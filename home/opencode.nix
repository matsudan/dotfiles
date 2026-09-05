{ ... }:
{
  # https://opencode.ai/docs/
  programs.opencode = {
    enable = true;

    settings = {
      autoupdate = false;
    };

    # 端末の背景色を継承し、Ghostty の透過を維持する
    tui.theme = "system";
  };
}
