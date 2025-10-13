runner "mechamachine", "ubuntu-latest"
env "BUILDCONFIGURATION", "Debug"
transform "DotNetCoreCLI@2" do |item|
  projects = item["projects"]
  command = item["command"]
  run_command = []

  if projects.include?("$")
    command = "build" if command.nil?
    run_command << "shopt -s globstar; for f in ./**/*.csproj; do dotnet #{command} $f #{item['arguments']} ; done"
  else
    run_command << "dotnet #{command} #{item['projects']} #{item['arguments']}"
  end

  {
    run:   run_command.join("\n"),
    shell: "bash",
  }
end