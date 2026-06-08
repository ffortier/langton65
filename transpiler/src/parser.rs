use std::str::FromStr;

pub enum AddressingMode {
    Implicit,
    Accumulator,
    Immediate(u8),
    // Combines relative, zero page and absolute
    Direct(String),
    DirectX(String),
    DirectY(String),
    // (ptr)
    Indirect(String),
    // (ptr, X)
    IndexedIndirect(String),
    // (ptr), Y
    IndirectIndexed(String),
}

impl AddressingMode {
    pub fn to_js_string(&self) -> String {
        use AddressingMode::*;

        match self {
            Implicit => format!("{{ type: 'implicit' }}"),
            Accumulator => format!("{{ type: 'accumulator' }}"),
            Immediate(value) => format!("{{ type: 'immediate', value: {value} }}"),
            Direct(label) => format!("{{ type: 'direct', label: '{label}' }}"),
            DirectX(label) => format!("{{ type: 'directX', label: '{label}' }}"),
            DirectY(label) => format!("{{ type: 'directY', label: '{label}' }}"),
            Indirect(label) => format!("{{ type: 'indirect', label: '{label}' }}"),
            IndexedIndirect(label) => format!("{{ type: 'indexedIndirect', label: '{label}' }}"),
            IndirectIndexed(label) => format!("{{ type: 'indirectIndexed', label: '{label}' }}"),
        }
    }
}

pub enum Instruction {
    LDA(AddressingMode),
    CLC(AddressingMode),
    ADC(AddressingMode),
}

impl Instruction {
    pub fn from_parser(opcode: &str, param: AddressingMode) -> Self {
        match opcode {
            "lda" => Instruction::LDA(param),
            "clc" => Instruction::CLC(param),
            "adc" => Instruction::ADC(param),
            _ => unreachable!(
                "The parser is suppose to pre-filter the values, but got {}",
                opcode
            ),
        }
    }

    pub fn to_js_string(&self, vm_name: &str) -> String {
        match self {
            Instruction::LDA(param) => format!("lda({}, {});", vm_name, param.to_js_string()),
            Instruction::CLC(param) => format!("clc({}, {});", vm_name, param.to_js_string()),
            Instruction::ADC(param) => format!("adc({}, {});", vm_name, param.to_js_string()),
        }
    }
}

peg::parser! {
    grammar ca65() for str {
        pub rule program() -> Program
            = _? instructions:(instruction() ++ _) _? { Program{ instructions } }

        pub rule instruction() -> Instruction
            = opcode:opcode() param:(_ param:addressingMode() { param })? { Instruction::from_parser(opcode, param.unwrap_or(AddressingMode::Implicit)) }

        pub rule opcode() -> &'input str
            = $("lda")
            / $("clc")
            / $("adc")

        pub rule addressingMode() -> AddressingMode
            = "#" num:num() { AddressingMode::Immediate(num) }

        pub rule num() -> u8
            = s:$(['0'..='9']+) { u8::from_str(s).expect("expected u8") }

        rule _ = quiet!{[' ' | '\n' | '\t']+}
    }
}

pub struct Program {
    instructions: Vec<Instruction>,
}

impl Program {
    pub fn to_js_string(&self) -> String {
        self.instructions
            .iter()
            .map(|instruction| instruction.to_js_string("vm"))
            .collect::<Vec<_>>()
            .join("\n")
    }
}

pub fn transpile(code: &str) -> Result<String, ()> {
    match ca65::program(code) {
        Ok(program) => Ok(program.to_js_string()),
        Err(_) => Err(()),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_instructions() {
        let code = include_str!("../samples/basic_instructions.s");

        transpile(code);
    }
}
