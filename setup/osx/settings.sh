# -- SYSTEM --------------------------------------------------------------------

# menubar: no siri
defaults write com.apple.systemuiserver "NSStatusItem Visible Siri" -bool false

# menubar: smaller spacing between items
defaults -currentHost read -globalDomain NSStatusItemSpacing 8

# menubar: Disable spotlight search icon (use cmd+space)
defaults write com.apple.controlcenter "NSStatusItem Visible Item-0" -int 0

# menubar: show battery percentage
defaults write com.apple.controlcenter BatteryShowPercentage -bool true

# menubar: Disable language / flag input menu
defaults write com.apple.TextInputMenu visible -bool false

# always show all extensions
defaults write -g AppleShowAllExtensions -bool true

# Use list view in all Finder windows by default
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
defaults write com.apple.finder SearchRecentsSavedViewStyle -string "clmv"

defaults write com.apple.finder EmptyTrashSecurely -bool true # Empty Trash securely by default

# Expand save panel by default
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true

# Expand print panel by default
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true

# Change Terminal settings
defaults write com.apple.Terminal "Default Window Settings" -string "Pro"
defaults write com.apple.Terminal "Startup Window Settings" -string "Pro"

# -- INPUT, KEYBOARD, TRACKPAD & MOUSE -----------------------------------------

# Disable press-and-hold for keys in favor of key repeat
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

# Disable auto-correct
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

defaults write -g InitialKeyRepeat -int 30
defaults write -g KeyRepeat -int 2

# Trackpad: enable tap to click for this user and for the login screen
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1
defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

# Mouse speed
defaults write -g com.apple.mouse.scaling 1.5

# -- FINDER --------------------------------------------------------------------

# Set Desktop as the default location for new Finder windows
# For other paths, use `PfLo` and `file:///full/path/here/`
defaults write com.apple.finder NewWindowTarget -string "PfHm"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/"

# Finder: show status bar
defaults write com.apple.finder ShowStatusBar -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Finder: allow text selection in Quick Look
defaults write com.apple.finder QLEnableTextSelection -bool true

# Keep folders on top when sorting by name
defaults write com.apple.finder _FXSortFoldersFirst -bool true

# When performing a search, search the current folder by default
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"

# Always open everything in Finder's list view.
# Use list view in all Finder windows by default
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"

# -- DOCK --------------------------------------------------

# Dock Size
defaults write com.apple.dock tilesize -int 70

# hot corner bottom right opens screensaver
defaults write com.apple.dock wvous-br-corner -int 5

# Don't show recently used applications in the Dock
defaults write com.Apple.Dock show-recents -bool false

# Remove the auto-hiding Dock delay
defaults write com.apple.dock autohide-delay -float 0

# Remove the animation when hiding/showing the Dock (use "-float 0.2" to enable)
defaults write com.apple.dock autohide-time-modifier -float 0

# Automatically hide and show the Dock
defaults write com.apple.dock autohide -bool true

# -- CALENDAR ------------------------------------------------------------------

# Show week numbers (10.8 only)
defaults write com.apple.iCal "Show Week Numbers" -bool true

# Week starts on monday
defaults write com.apple.iCal "first day of week" -int 1

# -- SAFARI & WEBKIT -----------------------------------------------------------

# Privacy: don't send search queries to Apple
# defaults write com.apple.Safari UniversalSearchEnabled -bool false
# defaults write com.apple.Safari SuppressSearchSuggestions -bool true

# # Show the full URL in the address bar (note: this still hides the scheme)
#defaults write com.apple.Safari ShowFullURLInSmartSearchField -bool true

# Enable the Develop menu and the Web Inspector in Safari
#defaults write com.apple.Safari.SandboxBroker ShowDevelopMenu -bool true
#defaults write com.apple.Safari IncludeDevelopMenu -bool true

# defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true

# Add a context menu item for showing the Web Inspector in web views
# defaults write NSGlobalDomain WebKitDeveloperExtras -bool true

# Prevent Safari from opening ‘safe’ files automatically after downloading
# defaults write com.apple.Safari AutoOpenSafeDownloads -bool false

# -- TIME MACHINE --------------------------------------------------------------

#  do NOT prompt to use new hard drives as backup volume
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

# -- APP STORE -----------------------------------------------------------------

# Enable the WebKit Developer Tools in the Mac App Store
# defaults write com.apple.appstore WebKitDeveloperExtras -bool true

# Enable Debug Menu in the Mac App Store
# defaults write com.apple.appstore ShowDebugMenu -bool true

# Enable the automatic update check
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

# Check for software updates daily, not just once per week
# defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

# Download newly available updates in background
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

# Automatically download apps purchased on other Macs
# defaults write com.apple.SoftwareUpdate ConfigDataInstall -int 1

# Turn on app auto-update
defaults write com.apple.commerce AutoUpdate -bool true

# Allow the App Store to reboot machine on macOS updates
# defaults write com.apple.commerce AutoUpdateRestartRequired -bool true
