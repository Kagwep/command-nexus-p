import { Network } from './utils/nexus';
import { MANIFEST_DEV, MANIFEST_MAINNET, MANIFEST_SEPOLIA } from '../dojoConfig';


// Sepolia network constants
export const SEPOLIA = {
    TORII_RPC_URL: "https://api.cartridge.gg/x/starknet/sepolia",
    TORII_URL: "https://api.cartridge.gg/x/nexus-1/torii",
    NEXUS_ADDRESS: "0x208b1fe3c916660ee0047d40be697c218152c2a0b9ffbf231ddf787adeb2c9f",
    ARENA_ADDRESS: "0x214d02a2a3f292258e6dc938e034d8fd9241946fe470a1563d8a340da353953",
    WORLD_ADDRESS: MANIFEST_SEPOLIA.world.address,
    MANIFEST: MANIFEST_SEPOLIA, 
  };
  
  // Mainnet network constants
  export const MAINNET = {
    TORII_RPC_URL: "https://api.cartridge.gg/x/starknet/mainnet", 
    TORII_URL: "https://api.cartridge.gg/x/command-2/torii", 
    NEXUS_ADDRESS: "0x1213b6603b66f5e4c579a611f3087591e47c2e378e3b255c6f4237ac836368a", 
    ARENA_ADDRESS: "0x74475067fc9f4eabd14ef2523cae24d06988a1a8f6b32ada588f14b95df8b38", 
    WORLD_ADDRESS: MANIFEST_MAINNET.world.address,
    MANIFEST: MANIFEST_MAINNET, 
  };


  // Katana/local network constants
export const KATANA = {
    TORII_RPC_URL: "", // Default Katana RPC
    TORII_URL: "http://localhost:8080",
    NEXUS_ADDRESS: "0x0", 
    ARENA_ADDRESS: "0x0", 
    WORLD_ADDRESS: MANIFEST_DEV.world.address,
    MANIFEST: MANIFEST_DEV,  
  };
  
  // Helper function to get constants based on network
export const getNetworkConstants = (network: Network) => {
    switch (network) {
      case 'sepolia':
        return SEPOLIA;
      case 'mainnet':
        return MAINNET;
      case 'katana':
      default:
        return KATANA;
    }
  };