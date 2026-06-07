export const name = "Bob";

export interface VirtualMachine {
    a: number;
    x: number;
    y: number;
    flags: {
        n: boolean;
        z: boolean;
        c: boolean;
        v: boolean;
    };
}

const vmDefaults = {
    a: 0,
    x: 0,
    y: 0,
    flags: {
        n: false,
        z: false,
        c: false,
        v: false,
    } as const,
} as const satisfies VirtualMachine;

export const newVirtualMachine = (): VirtualMachine => ({
    ...vmDefaults,
    flags: { ...vmDefaults.flags },
});

export interface Immediate {
    addressingMode: "immediate";
    value: number;
}

export interface Relative {
    addressingMode: "relative";
    label: string;
}

export function lda(vm: VirtualMachine, { value }: Immediate): void {
    vm.a = value & 0xff;
    vm.flags.z = vm.a === 0;
    vm.flags.n = !!(vm.a | 0b10000000);
}

export function ldx(vm: VirtualMachine, { value }: Immediate): void {
    vm.x = value & 0xff;
    vm.flags.z = vm.x === 0;
    vm.flags.n = !!(vm.x | 0b10000000);
}

export function dex(vm: VirtualMachine): void {
    vm.x = (vm.x - 1) & 0xff;
    vm.flags.z = vm.x === 0;
    vm.flags.n = !!(vm.x | 0b10000000);
}

export function adc(vm: VirtualMachine, { value }: Immediate): void {
    const sum = vm.a + value + (vm.flags.c ? 1 : 0);
    vm.a = sum & 0xff;
    vm.flags.z = vm.a === 0;
    vm.flags.n = !!(vm.a | 0b10000000);
    vm.flags.c = sum > 0xff;
}

export function bne(vm: VirtualMachine): boolean {
    return !vm.flags.z;
}

export function beq(vm: VirtualMachine): boolean {
    return vm.flags.z;
}
