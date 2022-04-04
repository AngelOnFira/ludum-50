use gdnative::api::*;
use gdnative::prelude::*;

#[derive(NativeClass)]
#[inherit(Node)]
#[register_with(Self::register_builder)]
pub struct Menu {}

#[methods]
impl Menu {
    fn register_builder(_builder: &ClassBuilder<Self>) {}

    fn new(_owner: &Node) -> Self {
        Menu {}
    }

    #[export]
    unsafe fn _on_start_pressed(&self, owner: &Node) {
        owner
            .get_tree()
            .expect("Could not get tree")
            .assume_safe()
            .change_scene("res://Scenes/Main.tscn".to_string())
            .unwrap();
    }
}
