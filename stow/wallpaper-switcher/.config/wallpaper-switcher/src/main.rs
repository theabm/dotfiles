use rand::seq::SliceRandom;
use rand::thread_rng;
use std::env;
use std::fs;
use std::io;
use std::path::PathBuf;
use std::process::Command;

// to run: cargo run -- monitor1 monitor2 ...
// ex:   cargo run -- eDP-1 [HDMI-A-1] 
// to install: (this puts it in $HOME/.cargo/bin/ which is in my path)
// cargo install --path . 

struct WallpaperManager {
    wallpaper_dir: PathBuf,
    supported_extension: Vec<&'static str>,
    entries: Option<Vec<PathBuf>>,
    outputs: Vec<String>,
}

impl WallpaperManager {
    fn new(wallpaper_dir: PathBuf, outputs: Vec<String>) -> Self {
        WallpaperManager {
            wallpaper_dir,
            supported_extension: vec!["jpg", "jpeg", "png", "pdf"],
            entries: None,
            outputs,
        }
    }

    fn collect_wallpapers(&mut self) -> Result<(), io::Error> {
        let entries: Vec<PathBuf> = fs::read_dir(&self.wallpaper_dir)?
            .filter_map(|res| res.ok().map(|e| e.path()))
            .filter(|p| p.extension().and_then(|s| s.to_str()).is_some())
            .filter(|p| {
                let ext = p.extension().unwrap().to_str().unwrap().to_ascii_lowercase();
                self.supported_extension.contains(&ext.as_str())
            })
            .collect();
        self.entries = Some(entries);
        Ok(())
    }

    fn set_random_wallpaper(&self) {
        let mut rng = thread_rng();
        let chosen = self
            .entries
            .as_ref()
            .expect("Error reading wallpapers dir.")
            .choose(&mut rng)
            .expect("No wallpapers found in directory.");

        // Call swww for each output with the SAME chosen wallpaper
        for out in &self.outputs {

            // FIX Not sure why, but if eDP-1 and HDMI-A-1 are connected, and I only call
            // this for eDP-1, it will also change the wallpaper for HDMI-A-1
            let _ = Command::new("swww")
                .arg("img")
                .arg(chosen)
                .arg("--outputs")
                .arg(out)
                .status()
                .expect("failed to execute swww");
        }

        // Update colors once (no need per-output)
        let _ = Command::new("wallust")
            .arg("run")
            .arg(chosen)
            .status()
            .expect("failed to execute wallust");
    }
}

fn main() {
    // Args: <program> <output1> <output2> ...
    let mut args = env::args().skip(1).collect::<Vec<String>>();
    if args.is_empty() {
        eprintln!("Usage: wallpaper-switcher <OUTPUT> [OUTPUT2 OUTPUT3 ...]");
        std::process::exit(2);
    }

    // Adjust this path if your wallpapers live elsewhere
    let w_d = PathBuf::from("/home/andres/wallpapers/");

    let mut manager = WallpaperManager::new(w_d, args.drain(..).collect());
    manager
        .collect_wallpapers()
        .expect("Error retrieving entries.");
    manager.set_random_wallpaper();
}

