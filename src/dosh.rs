use gdnative::api::*;
use gdnative::prelude::*;

/// The Dosh "class"
#[derive(NativeClass)]
#[inherit(Node)]
#[register_with(Self::register_builder)]
pub struct Dosh {
    amount: i32,

    // References
    dosh_animator: Ref<AnimationPlayer>,
    dosh_label: Ref<Label>,
}

#[methods]
impl Dosh {
    // Register the builder for methods, properties and/or signals.
    fn register_builder(_builder: &ClassBuilder<Self>) {
        godot_print!("Dosh builder is registered!");
    }

    /// The "constructor" of the class.
    fn new(_owner: &Node) -> Self {
        godot_print!("Dosh is created!");
        Dosh {
            amount: 0,
            dosh_animator: AnimationPlayer::new(),
            dosh_label: Label::new(),
        }
    }

    // In order to make a method known to Godot, the #[export] attribute has to be used.
    // In Godot script-classes do not actually inherit the parent class.
    // Instead they are "attached" to the parent object, called the "owner".
    // The owner is passed to every single exposed method.
    #[export]
    unsafe fn _ready(&mut self, _owner: &Node) {
        // The `godot_print!` macro works like `println!` but prints to the Godot-editor
        // output tab as well.
        self.name = "Dosh".to_string();
        godot_print!("{} is ready!", self.name);
    }

    // This function will be called in every frame
    #[export]
    unsafe fn _process(&self, _owner: &Node, delta: f64) {
        godot_print!("Inside {} _process(), delta is {}", self.name, delta);
    }
}
