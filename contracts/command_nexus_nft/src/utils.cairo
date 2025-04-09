use alexandria_math::{BitShift, pow};
use core::byte_array::ByteArrayTrait;
use graffiti::json::Builder;
use graffiti::json::JsonImpl;
use super::BannerLevel;

const BYTE_LEN: u256 = 8; // a byte is 8 bits
const MASK_1_BYTE: u256 = 0xff;
const MASK_2_BYTES: u256 = 0xffff;

/// Convert a u256 to an array of bytes
fn encoded_attributes_to_array(mut value: u256) -> Span<u8> {
    let mut res: Array<u8> = array![];
    while (value > 0) {
        let byte: u8 = (value & MASK_1_BYTE).try_into().unwrap();
        res.append(byte);

        value = BitShift::shr(value, 8);
    };

    return res.span();
}

/// Encodes commander metadata into a compact form
/// 
/// # Arguments
/// * `name` - Commander name
/// * `attributes` - Additional attributes to store
/// 
/// # Returns
/// * `felt252` - Encoded metadata as a felt252
pub fn encode_commander_metadata(name: ByteArray, attributes: Span<u8>) -> felt252 {
    let mut result: u256 = 0;
    let attrs_len: u256 = attributes.len().into();
    let name_len: u256 = name.len().into();
    
    // Store attributes length in the first byte
    result = attrs_len;
    
    // Store name length in the second byte
    result = result | (name_len << BYTE_LEN);
    
    // Store attributes - we pack them one byte at a time
    let mut attr_value: u256 = 0;
    let mut i: u256 = 0;
    loop {
        match attributes.get(i.try_into().unwrap()) {
            Option::Some(attr) => {
                // Add attribute at the appropriate position
                attr_value = attr_value | ((*attr).into() << (i * BYTE_LEN));
                i += 1;
            },
            Option::None => { break; }
        }
    };
    
    // Add attributes to result after the length bytes
    result = result | (attr_value << (2 * BYTE_LEN));
    
    // Store name - convert from ByteArray to u256
    let mut name_value: u256 = 0;
    if name_len > 0 {
        // This is a simplified approach - in practice you'd need
        // a more robust conversion from ByteArray to u256
        let mut i: u32 = 0;
        loop {
            if i >= name_len.try_into().unwrap() {
                break;
            }
            
            // Get character and add it to the appropriate position
            let char: u8 = name.at(i).unwrap();
            name_value = name_value | ((char.into()) << (i * 8));
            i += 1;
        };
    }
    
    // Add name after attributes
    result = result | (name_value << ((2 + attrs_len) * BYTE_LEN));
    
    // Return as felt252
    result.try_into().unwrap()
}

/// Convert banner level to string
fn banner_level_to_string(level: BannerLevel) -> ByteArray {
    match level {
        BannerLevel::Recruit => "Recruit",
        BannerLevel::Soldier => "Soldier",
        BannerLevel::Veteran => "Veteran",
        BannerLevel::Elite => "Elite",
        BannerLevel::Commander => "Commander",
        BannerLevel::Legend => "Legend",
        BannerLevel::Mythic => "Mythic",
    }
}

/// Get attributes for a banner level
fn get_banner_attributes(level: BannerLevel) -> Array<ByteArray> {
    let mut attrs: Array<ByteArray> = array![];
    
    // Add banner level trait
    attrs.append(
        JsonImpl::new()
            .add("trait_type", "Banner Level")
            .add("value", banner_level_to_string(level))
            .build()
    );
    
    // Add banner-specific traits
    match level {
        BannerLevel::Recruit => {
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Experience")
                    .add("value", "Novice")
                    .build()
            );
        },
        BannerLevel::Soldier => {
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Experience")
                    .add("value", "Trained")
                    .build()
            );
        },
        BannerLevel::Veteran => {
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Experience")
                    .add("value", "Seasoned")
                    .build()
            );
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Battles")
                    .add("value", "Many")
                    .build()
            );
        },
        BannerLevel::Elite => {
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Experience")
                    .add("value", "Expert")
                    .build()
            );
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Battles")
                    .add("value", "Numerous")
                    .build()
            );
        },
        BannerLevel::Commander => {
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Experience")
                    .add("value", "Master")
                    .build()
            );
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Leadership")
                    .add("value", "Respected")
                    .build()
            );
        },
        BannerLevel::Legend => {
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Experience")
                    .add("value", "Legendary")
                    .build()
            );
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Leadership")
                    .add("value", "Revered")
                    .build()
            );
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Status")
                    .add("value", "Hero")
                    .build()
            );
        },
        BannerLevel::Mythic => {
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Experience")
                    .add("value", "Mythical")
                    .build()
            );
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Leadership")
                    .add("value", "Legendary")
                    .build()
            );
            attrs.append(
                JsonImpl::new()
                    .add("trait_type", "Status")
                    .add("value", "Immortal")
                    .build()
            );
        },
    };
    
    attrs
}

/// Create JSON metadata for the commander NFT
///
/// # Arguments
/// * `metadata_felt` - Encoded metadata
/// * `image_url` - IPFS hash of the image
/// * `level` - Banner level
///
/// # Returns
/// * `ByteArray` - Base64 encoded JSON metadata
pub fn make_commander_json_metadata(metadata_felt: felt252, image_url: ByteArray, level: BannerLevel) -> ByteArray {
    let original_value: u256 = metadata_felt.into();
    
    // Extract metadata components based on our encoding scheme
    // The first byte contains attributes length
    let attrs_len: u256 = original_value & MASK_1_BYTE;
    
    // The second byte contains name length
    let name_len: u256 = BitShift::shr(original_value, BYTE_LEN) & MASK_1_BYTE;
    
    // Remove lengths from the value to get just name and attributes
    let name_and_attrs_only: u256 = BitShift::shr(original_value, 2 * BYTE_LEN);
    
    // Extract attributes
    let attrs_mask: u256 = pow(2, BYTE_LEN * attrs_len) - 1;
    let attributes_value: u256 = name_and_attrs_only & attrs_mask;
    
    // Extract encoded attributes - this would be custom per application -> MODIFY LATER
    let mut attrs_arr: Span<u8> = encoded_attributes_to_array(attributes_value);
    
    // Get banner level attributes and combine with custom attributes
    let mut attrs = get_banner_attributes(level);
    
    // Add any custom attributes from the encoded data
    loop {
        match attrs_arr.pop_front() {
            Option::Some(attr_value) => {
                if (*attr_value).into() > 0 {
                    attrs.append(
                        JsonImpl::new()
                            .add("trait_type", "Custom Attribute")
                            .add("value", format!("{}", (*attr_value).into()))
                            .build()
                    );
                }
            },
            Option::None => { break; }
        }
    };
    
    // Extract name
    let name: u256 = BitShift::shr(name_and_attrs_only, BYTE_LEN * attrs_len);
    let mut name_str: ByteArray = "";
    
    // Convert name from u256 to ByteArray
    if name_len > 0 {
        name_str.append_word(name.try_into().unwrap(), name_len.try_into().unwrap());
    } else {
        // Default name if none is stored
        name_str = format!("Commander #{}", original_value.try_into().unwrap());
    }
    
    // Construct full metadata
    let metadata = JsonImpl::new()
        .add("name", name_str)
        .add("image", format!("https://gateway.pinata.cloud/ipfs/{}", image_url))
        .add_array("attributes", attrs.span());
    
    // Base64 encode the metadata
    format!("data:application/json;base64,{}", bytes_base64_encode(metadata.build()))
}

/// Base64 encoding functions (reusing from the provided code)
fn bytes_base64_encode(bytes: ByteArray) -> ByteArray {
    let mut char_set = get_base64_char_set();
    char_set.append('+');
    char_set.append('/');
    encode_bytes(bytes, char_set.span())
}

fn encode_bytes(mut bytes: ByteArray, base64_chars: Span<u8>) -> ByteArray {
    let mut result: ByteArray = "";
    if bytes.len() == 0 {
        return result;
    }
    let mut p: u8 = 0;
    let c = bytes.len() % 3;
    if c == 1 {
        p = 2;
        bytes.append_byte(0_u8);
        bytes.append_byte(0_u8);
    } else if c == 2 {
        p = 1;
        bytes.append_byte(0_u8);
    }

    let mut i = 0;
    let bytes_len = bytes.len();
    let last_iteration = bytes_len - 3;
    loop {
        if i == bytes_len {
            break;
        }
        let n: u32 = (bytes.at(i).unwrap()).into()
            * 65536 | (bytes.at(i + 1).unwrap()).into()
            * 256 | (bytes.at(i + 2).unwrap()).into();
        let e1 = (n / 262144) & 63;
        let e2 = (n / 4096) & 63;
        let e3 = (n / 64) & 63;
        let e4 = n & 63;

        if i == last_iteration {
            if p == 2 {
                result.append_byte(*base64_chars[e1]);
                result.append_byte(*base64_chars[e2]);
                result.append_byte('=');
                result.append_byte('=');
            } else if p == 1 {
                result.append_byte(*base64_chars[e1]);
                result.append_byte(*base64_chars[e2]);
                result.append_byte(*base64_chars[e3]);
                result.append_byte('=');
            } else {
                result.append_byte(*base64_chars[e1]);
                result.append_byte(*base64_chars[e2]);
                result.append_byte(*base64_chars[e3]);
                result.append_byte(*base64_chars[e4]);
            }
        } else {
            result.append_byte(*base64_chars[e1]);
            result.append_byte(*base64_chars[e2]);
            result.append_byte(*base64_chars[e3]);
            result.append_byte(*base64_chars[e4]);
        }

        i += 3;
    };
    result
}

fn get_base64_char_set() -> Array<u8> {
    let mut result = array![
        'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
        'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z',
        'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
        'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z',
        '0', '1', '2', '3', '4', '5', '6', '7', '8', '9'
    ];
    result
}