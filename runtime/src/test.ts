import { ldx, lda, dex, adc, bne, newVirtualMachine } from "./index.ts";
import { describe, it } from "node:test";
import * as assert from "node:assert/strict";

describe("adding and branching", () => {
    it("should do something", () => {
        let label = "_start";
        let vm = newVirtualMachine();

        program: while (true) {
            switch (label) {
                case "_start":
                    lda(vm, { addressingMode: "immediate", value: 34 });
                    ldx(vm, { addressingMode: "immediate", value: 35 });
                case "loop":
                    adc(vm, { addressingMode: "immediate", value: 1 });
                    dex(vm);
                    if (bne(vm)) {
                        label = "loop";
                        break;
                    }
                case "end":
                    break program;
            }
        }

        assert.strictEqual(69, vm.a);
    });
});
