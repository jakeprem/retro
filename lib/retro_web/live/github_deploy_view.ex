defmodule RetroWeb.GithubDeployView do
  use Phoenix.LiveView

  def render(assigns) do
    ~L"""
    <div class="">
      <div>
        <div>
          <button phx-click="github_deploy">Deploy to Github</button>
        </div>
        <%= @deploy_step %>
      </div>
    </div>
    """
  end

  def mount(_session, socket) do
    IO.inspect(socket, label: "MOUNT")
    {:ok, assign(socket, deploy_step: "Ready!")}
  end

  def handle_event("github_deploy", _value, socket) do
    IO.inspect(socket, label: "HANDLE_EVENT")
    Process.send_after(self(), :create_org, 1000)
    {:noreply, assign(socket, deploy_step: "Starting deploy...")}
  end

  def handle_info(:create_org, socket) do
    IO.inspect(socket, label: "HANDLE_INFO")
    Process.send_after(self(), :create_repo, 1000)
    {:noreply, assign(socket, deploy_step: "Creating Org...")}
  end

  def handle_info(:create_repo, socket) do
    Process.send_after(self(), :push_contents, 1000)
    {:noreply, assign(socket, deploy_step: "Creating Repo...")}
  end

  def handle_info(:push_contents, socket) do
    Process.send_after(self(), :done, 1000)
    {:noreply, assign(socket, deploy_step: "Pushing contents...")}
  end

  def handle_info(:done, socket) do
    {:noreply, assign(socket, deploy_step: "Done!")}
  end
end
