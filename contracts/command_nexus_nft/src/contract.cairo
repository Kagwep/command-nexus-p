// SPDX-License-Identifier: MIT
// CommanderNFT - An NFT with different banner levels

use starknet::ContractAddress;

#[derive(Serde, Copy, Drop, PartialEq, Introspect)]
pub enum BannerLevel {
    Recruit,
    Soldier,
    Veteran,
    Elite,
    Commander,
    Legend,
    Mythic
}

#[starknet::interface]
trait ICommanderNFT<TState> {
    fn mint(ref self: TState, recipient: ContractAddress, token_id: u256, level: BannerLevel);
    fn upgrade_banner(ref self: TState, token_id: u256, new_level: BannerLevel);
    fn get_banner_level(self: @TState, token_id: u256) -> BannerLevel;
    fn attach_lords(ref self: TState, token_id: u256, amount: u256);
    fn detach_lords(ref self: TState, token_id: u256, amount: u256);
    fn lords_balance(self: @TState, token_id: u256) -> u256;
}

#[starknet::contract]
mod CommanderNFT {
    use command_nexus_nft::utils::make_commander_json_metadata;
    use openzeppelin::access::ownable::OwnableComponent;
    use openzeppelin::introspection::src5::SRC5Component;
    use openzeppelin::token::erc20::interface::{IERC20Dispatcher, IERC20DispatcherTrait};
    use openzeppelin::token::erc721::ERC721Component;
    use openzeppelin::token::erc721::ERC721HooksEmptyImpl;
    use openzeppelin::token::erc721::interface::{
        IERC721Metadata, IERC721MetadataDispatcher, IERC721MetadataDispatcherTrait, IERC721Dispatcher,
        IERC721DispatcherTrait, IERC721MetadataCamelOnly,
    };
    use openzeppelin::upgrades::UpgradeableComponent;
    use openzeppelin::upgrades::interface::IUpgradeable;
    use starknet::ClassHash;
    use starknet::ContractAddress;
    use super::BannerLevel;

    component!(path: ERC721Component, storage: erc721, event: ERC721Event);
    component!(path: SRC5Component, storage: src5, event: SRC5Event);
    component!(path: OwnableComponent, storage: ownable, event: OwnableEvent);
    component!(path: UpgradeableComponent, storage: upgradeable, event: UpgradeableEvent);
    
    #[abi(embed_v0)]
    impl ERC721Impl = ERC721Component::ERC721Impl<ContractState>;
    #[abi(embed_v0)]
    impl OwnableImpl = OwnableComponent::OwnableImpl<ContractState>;
    #[abi(embed_v0)]
    impl SRC5Impl = SRC5Component::SRC5Impl<ContractState>;
    impl ERC721InternalImpl = ERC721Component::InternalImpl<ContractState>;
    impl OwnableInternalImpl = OwnableComponent::InternalImpl<ContractState>;
    impl UpgradeableInternalImpl = UpgradeableComponent::InternalImpl<ContractState>;

    // Images for different banner levels
    fn get_banner_image(level: BannerLevel) -> ByteArray {
        match level {
            BannerLevel::Recruit => "QmXbhQRZMxod2USTMgargWt3sxPGBo4sQNiQEMkLq36qf1",
            BannerLevel::Soldier => "QmXbhQRZMxod2USTMgargWt3sxPGBo4sQNiQEMkLq36qf2",
            BannerLevel::Veteran => "QmXbhQRZMxod2USTMgargWt3sxPGBo4sQNiQEMkLq36qf3",
            BannerLevel::Elite => "QmXbhQRZMxod2USTMgargWt3sxPGBo4sQNiQEMkLq36qf4",
            BannerLevel::Commander => "QmXbhQRZMxod2USTMgargWt3sxPGBo4sQNiQEMkLq36qf5",
            BannerLevel::Legend => "QmXbhQRZMxod2USTMgargWt3sxPGBo4sQNiQEMkLq36qf6",
            BannerLevel::Mythic => "QmXbhQRZMxod2USTMgargWt3sxPGBo4sQNiQEMkLq36qf7",
        }
    }

    #[storage]
    struct Storage {
        lords: IERC20Dispatcher,
        lords_balance: LegacyMap<u256, u256>,
        banner_levels: LegacyMap<u256, BannerLevel>,
        encoded_metadata: LegacyMap<u256, felt252>,
        #[substorage(v0)]
        erc721: ERC721Component::Storage,
        #[substorage(v0)]
        src5: SRC5Component::Storage,
        #[substorage(v0)]
        ownable: OwnableComponent::Storage,
        #[substorage(v0)]
        upgradeable: UpgradeableComponent::Storage,
    }

    #[event]
    #[derive(Drop, starknet::Event)]
    enum Event {
        #[flat]
        ERC721Event: ERC721Component::Event,
        #[flat]
        SRC5Event: SRC5Component::Event,
        #[flat]
        OwnableEvent: OwnableComponent::Event,
        #[flat]
        UpgradeableEvent: UpgradeableComponent::Event,
        BannerUpgraded: BannerUpgraded,
    }

    #[derive(Drop, starknet::Event)]
    struct BannerUpgraded {
        token_id: u256,
        old_level: BannerLevel,
        new_level: BannerLevel
    }

    #[constructor]
    fn constructor(
        ref self: ContractState,
        owner: ContractAddress,
        lords_contract_address: ContractAddress
    ) {
        self.erc721.initializer("Commander NFT", "CMDR", "");
        self.ownable.initializer(owner);
        self.lords.write(IERC20Dispatcher { contract_address: lords_contract_address });
    }

    #[abi(embed_v0)]
    impl UpgradeableImpl of IUpgradeable<ContractState> {
        fn upgrade(ref self: ContractState, new_class_hash: ClassHash) {
            self.ownable.assert_only_owner();
            self.upgradeable.upgrade(new_class_hash);
        }
    }

    #[abi(embed_v0)]
    impl ERC721Metadata of IERC721Metadata<ContractState> {
        fn name(self: @ContractState) -> ByteArray {
            self.erc721.ERC721_name.read()
        }

        fn symbol(self: @ContractState) -> ByteArray {
            self.erc721.ERC721_symbol.read()
        }

        fn token_uri(self: @ContractState, token_id: u256) -> ByteArray {
            self.erc721._require_owned(token_id);
            let level = self.banner_levels.read(token_id);
            let metadata_felt = self.encoded_metadata.read(token_id);
            make_commander_json_metadata(metadata_felt, get_banner_image(level), level)
        }
    }

    #[abi(embed_v0)]
    impl ERC721MetadataCamelOnly of IERC721MetadataCamelOnly<ContractState> {
        fn tokenURI(self: @ContractState, tokenId: u256) -> ByteArray {
            ERC721Metadata::token_uri(self, tokenId)
        }
    }

    #[abi(embed_v0)]
    impl CommanderNFTImpl of super::ICommanderNFT<ContractState> {
        fn mint(ref self: ContractState, recipient: ContractAddress, token_id: u256, level: BannerLevel) {
            // Only owner can mint
            self.ownable.assert_only_owner();
            
            // Mint the NFT
            self.erc721.mint(recipient, token_id);
            
            // Set the banner level
            self.banner_levels.write(token_id, level);
            
            // Create metadata for the token
            // Generate name based on token ID
            let name = format!("Commander #{}", token_id);
            
            // Create basic attributes based on level
            let mut attributes: Array<u8> = array![];
            
            // Add region attribute (example custom attribute)
            let region: u8 = 1;
            attributes.append(region);
            
            // Add battles attribute (random value between 1-100 based on token_id)
            let battles: u8 = (token_id % 100 + 1).try_into().unwrap();
            attributes.append(battles);
            
            // Add victories attribute (random value based on token_id)
            let victories: u8 = ((token_id % 50) + 5).try_into().unwrap();
            attributes.append(victories);
            
            // Add rank attribute based on banner level (1-7)
            attributes.append((level as u8) + 1);
            
            // Encode the metadata
            let encoded_metadata = commander::utils::encode_commander_metadata(name, attributes.span());
            
            // Store the encoded metadata
            self.encoded_metadata.write(token_id, encoded_metadata);
        }
        
        fn upgrade_banner(ref self: ContractState, token_id: u256, new_level: BannerLevel) {
            // Only owner can upgrade for now
            self.ownable.assert_only_owner();
            
            // Ensure NFT exists
            self.erc721._require_owned(token_id);
            
            // Get current level
            let old_level = self.banner_levels.read(token_id);
            
            // Ensure new level is higher than old level
            assert(new_level as u8 > old_level as u8, 'New level must be higher');
            
            // Update banner level
            self.banner_levels.write(token_id, new_level);
            
            // Emit event
            self.emit(BannerUpgraded { token_id, old_level, new_level });
        }
        
        fn get_banner_level(self: @ContractState, token_id: u256) -> BannerLevel {
            // Ensure NFT exists
            self.erc721._require_owned(token_id);
            
            self.banner_levels.read(token_id)
        }

        fn attach_lords(ref self: ContractState, token_id: u256, amount: u256) {
            // Ensure NFT exists
            self.erc721._require_owned(token_id);
            
            // Transfer LORDS tokens from caller to contract
            let caller = starknet::get_caller_address();
            let this = starknet::get_contract_address();
            assert(
                self.lords.read().transfer_from(caller, this, amount), 
                'CMDR: Failed to transfer LORDS'
            );
            
            // Update LORDS balance
            let lords_balance = self.lords_balance.read(token_id);
            self.lords_balance.write(token_id, lords_balance + amount);
        }
        
        fn detach_lords(ref self: ContractState, token_id: u256, amount: u256) {
            // Ensure caller is NFT owner
            let caller = starknet::get_caller_address();
            assert(
                self.erc721.owner_of(token_id) == caller,
                'CMDR: Only NFT owner can detach'
            );
            
            // Ensure enough LORDS balance
            let lords_balance = self.lords_balance.read(token_id);
            assert(lords_balance >= amount, 'CMDR: Insufficient LORDS');
            
            // Transfer LORDS to caller
            assert(
                self.lords.read().transfer(caller, amount),
                'CMDR: Failed to transfer LORDS'
            );
            
            // Update LORDS balance
            self.lords_balance.write(token_id, lords_balance - amount);
        }
        
        fn lords_balance(self: @ContractState, token_id: u256) -> u256 {
            self.lords_balance.read(token_id)
        }
    }
}