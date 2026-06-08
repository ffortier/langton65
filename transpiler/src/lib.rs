mod parser;

use wasm_bindgen::prelude::*;

pub fn transpile(code: JsValue) -> JsValue {
    let Some(code) = code.as_string() else {
        panic!("Expected string");
    };

    let js = parser::transpile(&code).expect("Failed to transpile");

    JsValue::from_str(&js)
}
