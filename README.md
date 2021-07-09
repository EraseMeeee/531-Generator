# Disclaimer

This repo is in no way affiliated with Jim Wendler or his program. Just in case you thought that.

The templates contained in the templates directory are based on https://www.jimwendler.com/blogs/jimwendler-com/boring-but-big-beefcake-training and https://www.t-nation.com/workouts/5-3-1-how-to-build-pure-strength/. To learn more about 5/3/1 and its many templates, buy Jim Wendler's books.

# How to use

Make sure you have Powershell installed to use this script. I believe it is standard on Windows these days and there are instructions for installing on macos: https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-core-on-macos?view=powershell-7.1

1. Make a copy of config/training-maxes.json.example and name it training-maxes.json. Be sure to keep your new copy in the config folder.
2. Update the training-maxes.json file to reflect your training max for each of the lift. If you're not sure how to determine your training max, check out Jim's articles
3. Decide which template in the templates folder you want to use
4. The name of the template file (minus ".json") is what you will use to set the `TemplateName`
5. For macos, run:
  - `pwsh New-531Sheet.ps1 -TemplateName fsl` (or `bbb-beefcake`)
6. For Windows, I'm guessing:
  - `powershell New-531Sheet.ps1 -TemplateName fsl`
7. Open the file generated in the "output" folder
8. Either work from this view, or copy and paste the CSV contents into a Google Sheet
9. Get swole
10. (bonus) Buy Jim's books :D
