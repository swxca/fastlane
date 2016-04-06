module Fastlane
  # Enable tab auto completion
  class AutoComplete
    def self.execute
      path = File.join(Fastlane::Helper.gem_path('fastlane'), 'lib', 'assets', 'completions')

      fastlane_conf_dir = "~/.fastlane"
      `mkdir -p #{fastlane_conf_dir} && cp -r #{path} #{fastlane_conf_dir}`

      UI.success "To use auto complete for fastlane"
      UI.success "add the following line to your favorite rc file (e.g. ~/.bashrc)"
      UI.important "  . ~/.fastlane/completions/completion.sh"
      UI.success "Don't forget to source that file in your current shell! 🐚"
    end
  end
end
