mod dosh;
mod game;
mod menu;

use gdnative::prelude::{godot_init, InitHandle};

// Function that registers all exposed classes to Godot
fn init(handle: InitHandle) {
    handle.add_class::<game::Game>();
    handle.add_class::<menu::Menu>();
    handle.add_class::<dosh::Dosh>();
}

// macros that create the entry-points of the dynamic library.
godot_init!(init);
