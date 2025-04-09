use starknet::ContractAddress;
use command_nexus::models::banner::{Banner, BannerLevel};

#[derive(Copy, Drop, Serde)]
#[dojo::model]
pub struct Commander {
    #[key]
    pub address: ContractAddress,
    pub kills: u32,
    pub deaths: u32,
    pub score: u32,
    pub banner: Banner,
}


#[generate_trait]
pub impl CommanderImpl of CommanderTrait {

    fn new(caller: ContractAddress, banner: Banner) -> Commander{

       Commander { 
        address: caller, 
        kills: 0, 
        deaths: 0, 
        score: 0, 
        banner: banner
       }
    }

}