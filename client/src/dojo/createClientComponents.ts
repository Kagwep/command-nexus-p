import { overridableComponent } from "@dojoengine/recs";
import { ContractComponents } from './contractComponents';

export type ClientComponents = ReturnType<typeof createClientComponents>;

export function createClientComponents({
    contractComponents,
}: {
    contractComponents: ContractComponents;
}) {
    return {
        ...contractComponents,
        Game: overridableComponent(contractComponents.Game),
        Player: overridableComponent(contractComponents.Player),
        
    };
}