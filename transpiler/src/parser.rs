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

pub trait IntoJsString {
    fn to_js_string(&self, vm_name: &str) -> String;
}

impl IntoJsString for AddressingMode {
    fn to_js_string(&self, _: &str) -> String {
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

pub struct Label(String);

impl IntoJsString for Label {
    fn to_js_string(&self, _: &str) -> String {
        format!("case '{}':", &self.0)
    }
}

pub enum Instruction {
    LDA(AddressingMode),
    LDX(AddressingMode),
    BNE(AddressingMode),
    DEX(AddressingMode),
    CLC(AddressingMode),
    ADC(AddressingMode),
}

impl Instruction {
    pub fn from_parser(opcode: &str, param: AddressingMode) -> Self {
        match opcode {
            "lda" => Instruction::LDA(param),
            "ldx" => Instruction::LDA(param),
            "bne" => Instruction::LDA(param),
            "dex" => Instruction::LDA(param),
            "clc" => Instruction::CLC(param),
            "adc" => Instruction::ADC(param),
            _ => unreachable!(
                "The parser is suppose to pre-filter the values, but got {}",
                opcode
            ),
        }
    }
}

impl IntoJsString for Instruction {
    fn to_js_string(&self, vm_name: &str) -> String {
        match self {
            Instruction::LDA(param) => {
                format!("lda({}, {});", vm_name, param.to_js_string(vm_name))
            }
            Instruction::LDX(param) => {
                format!("ldx({}, {});", vm_name, param.to_js_string(vm_name))
            }
            Instruction::DEX(param) => {
                format!("dex({}, {});", vm_name, param.to_js_string(vm_name))
            }
            Instruction::BNE(param) => {
                format!(
                    "if (bne({}) {{ label = ({}).label; break; }}",
                    vm_name,
                    param.to_js_string(vm_name)
                )
            }
            Instruction::CLC(param) => {
                format!("clc({}, {});", vm_name, param.to_js_string(vm_name))
            }
            Instruction::ADC(param) => {
                format!("adc({}, {});", vm_name, param.to_js_string(vm_name))
            }
        }
    }
}

pub enum Node {
    Instruction(Instruction),
    Label(Label),
}

impl IntoJsString for Node {
    fn to_js_string(&self, vm_name: &str) -> String {
        match self {
            Node::Instruction(instruction) => instruction.to_js_string(vm_name),
            Node::Label(label) => label.to_js_string(vm_name),
        }
    }
}

peg::parser! {
    grammar ca65() for str {
        pub rule program() -> Program
            = _? nodes:(node() ++ _) _? { Program{ nodes } }

        pub rule node() -> Node
            = label:label() { Node::Label(label) }
            / instruction:instruction() { Node::Instruction(instruction) }

        pub rule label() -> Label
            = name:$(['a'..='z' | '@' | '_']+) ":" { Label(name.to_string()) }

        pub rule instruction() -> Instruction
            = opcode:opcode() param:(_ param:addressingMode() { param })? { Instruction::from_parser(opcode, param.unwrap_or(AddressingMode::Implicit)) }

        pub rule opcode() -> &'input str
            = $("lda")
            / $("clc")
            / $("adc")
            / $("ldx")
            / $("bne")
            / $("dex")

        pub rule addressingMode() -> AddressingMode
            = "#" num:num() { AddressingMode::Immediate(num) }
            / label:$(['a'..='z' | '@' | '_']+) { AddressingMode::Direct(label.to_string()) }

        pub rule num() -> u8
            = s:$(['0'..='9']+) { u8::from_str(s).expect("expected u8") }

        rule _ = quiet!{[' ' | '\n' | '\t']+}
    }
}

pub struct Program {
    nodes: Vec<Node>,
}

impl IntoJsString for Program {
    fn to_js_string(&self, vm_name: &str) -> String {
        self.nodes
            .iter()
            .map(|n| n.to_js_string(vm_name))
            .collect::<Vec<_>>()
            .join("\n")
    }
}

pub fn transpile(code: &str) -> Result<String, peg::error::ParseError<peg::str::LineCol>> {
    match ca65::program(code) {
        Ok(program) => Ok(program.to_js_string("vm")),
        Err(e) => Err(e),
    }
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_basic_instructions() {
        let code = include_str!("../samples/basic_instructions.s");

        transpile(code).expect("Failed to transpile code");
    }

    #[test]
    fn test_labels() {
        let code = include_str!("../samples/labels.s");

        transpile(code).expect("Failed to transpile code");
    }
}
