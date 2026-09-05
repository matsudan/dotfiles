{ ... }:
{
  # https://opencode.ai/docs/
  programs.opencode = {
    enable = true;

    settings = {
      autoupdate = false;

      mcp.aws-documentation = {
        type = "local";
        command = [
          "uvx"
          "awslabs.aws-documentation-mcp-server@latest"
        ];
        enabled = true;
        timeout = 30000;
        environment = {
          FASTMCP_LOG_LEVEL = "ERROR";
          AWS_DOCUMENTATION_PARTITION = "aws";
        };
      };
    };

    # 端末の背景色を継承し、Ghostty の透過を維持する
    tui.theme = "system";
  };
}
