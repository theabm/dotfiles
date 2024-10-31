use rand::seq::SliceRandom;
use rand::thread_rng;
use std::fs;
use std::io;
use std::path::PathBuf;
use std::process::Command;

struct WallpaperManager {
    wallpaper_dir: PathBuf,
    supported_extension: Vec<&'static str>,
    entries: Option<Vec<PathBuf>>,
}

impl WallpaperManager {
    fn new(wallpaper_dir: PathBuf) -> Self {
        WallpaperManager {
            wallpaper_dir,
            supported_extension: vec!["jpg", "pdf", "png"],
            entries: None,
        }
    }

    fn collect_wallpapers(&mut self) -> Result<(), io::Error> {
        let entries: Vec<PathBuf> = fs::read_dir(self.wallpaper_dir.as_path())?
            .map(|res| res.unwrap().path())
            .filter(|p| p.extension().is_some())
            .filter(|p| {
                self.supported_extension
                    .contains(&p.extension().unwrap().to_str().unwrap())
            })
            .collect();
        self.entries = Some(entries);
        Ok(())
    }

    fn set_random_wallpaper(&self) {
        let mut rng = thread_rng();
        let new_wallpaper_dir = self
            .entries
            .as_ref()
            .expect("Error reading wallpapers dir.")
            .choose(&mut rng)
            .expect("Error reading wallpaper.");

        let _output = Command::new("swww")
            .arg("img")
            .arg(new_wallpaper_dir)
            .output()
            .expect("failed to execute swww");

        let _output2 = Command::new("wallust")
            .arg("run")
            .arg(new_wallpaper_dir)
            .output()
            .expect("failed to execute wallust");
    }
}

fn main() {
    let w_d = PathBuf::from("/home/andres/wallpapers/");
    let mut manager = WallpaperManager::new(w_d);
    let _ = manager
        .collect_wallpapers()
        .expect("Error retrieving entries.");
    manager.set_random_wallpaper();
}
