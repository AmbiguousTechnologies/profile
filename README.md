# Rapid Home Manager deployments with FlakeHub 🚀

This project demonstrates how to deploy [Home Manager](https://github.com/nix-community/home-manager) configurations across multiple platforms using [FlakeHub](https://flakehub.com) _in seconds_ ⏱️

- **Initial deployment completes in _less than 30 seconds_**
- **Subsequent deployments take _less than 5 seconds_**

The deployment process fetches pre-built Home Manager [closures](https://zero-to-nix.com/concepts/closures) from [FlakeHub](https://flakehub.com) and applies them to your systems, ensuring consistent environments across development machines and CI pipelines.

## ⚠️ Disclaimer

> **IMPORTANT**: This repository contains demo configurations intended for educational and testing purposes only.
>
> These configurations should **NOT** be applied to production systems without thorough review and adaptation.
> The flakes, configurations, and workflows demonstrated here are designed to showcase FlakeHub's capabilities.
>
> Before adapting these techniques for real-world use:
> - Thoroughly test in isolated environments
> - Review and customize configurations for your specific requirements

## ✨ Sign up for FlakeHub ✨

To experience this streamlined Home Manager deployment pipeline yourself, [**sign up for FlakeHub**](https://flakehub.com) at https://flakehub.com.

FlakeHub provides the enterprise-grade Nix infrastructure needed to use these advanced deployment techniques, ensuring secure and efficient environment management from development to production.

## Running the demo deployment

In this demo, you'll deploy a Home Manager configuration for two different machine types:
- A Linux robot system
- A macOS developer workstation

> [!TIP]
> For a full explanation of how everything works, see [What's in the demo](#whats-in-the-demo) below.

### Run it locally

To run the demo locally, you'll need:
- [Determinate Nix](https://determinate.systems/determinate-nix) installed
- FlakeHub authentication configured

```shell
# Clone the repo
git clone https://github.com/AmbiguousTechnologies/profile
cd profile

# Log in to FlakeHub (if not already logged in)
determinate-nixd login

# For Linux systems, apply the robot profile
fh apply home-manager "AmbiguousTechnologies/profile/0.1#homeConfigurations.user@robot"

# For macOS systems, apply the workstation profile
fh apply home-manager "AmbiguousTechnologies/profile/0.1#homeConfigurations.user@workstation"
```

## What's in the demo

This demonstration project consists of the following key components:

- **Nix [flake](https://zero-to-nix.com/concepts/flakes) configuration**: A Nix flake that defines Home Manager configurations for multiple systems.
- **Home Manager modules**: Configuration modules that set up development environments consistently across platforms.
- **GitHub Actions workflow**: A workflow that builds the Home Manager configurations and publishes them to FlakeHub.

### Nix flake ❄️

The [`flake.nix`](./flake.nix) sets up a Home Manager configuration with specific dependencies and system packages:

- **Inputs**: Specifies dependencies from FlakeHub:
  - `nixpkgs`: Nixpkgs flake from FlakeHub.
  - `home-manager`: Home Manager flake from FlakeHub.
- **Outputs**: Defines the Home Manager configurations:
  - `homeConfigurations.user@robot`: Configuration for Linux-based robot systems.
  - `homeConfigurations.user@workstation`: Configuration for macOS developer workstations.

### Home Manager configuration 🏠

The [`home-manager/default.nix`](./home-manager/default.nix) creates a consistent environment across platforms:

- Enables unfree packages from Nixpkgs
- Sets up the latest version of Nix with flakes enabled
- Configures Git
- Automatically adapts paths between Linux and macOS
- Ensures proper service reloading on Linux

### Deployment with `fh apply` 🚀

The `fh apply home-manager` command is central to this demo's efficiency:

1. **Zero evaluation overhead**: Unlike traditional `home-manager switch` commands, `fh apply` skips local Nix evaluation entirely.
2. **Pre-cached closures**: FlakeHub Cache stores pre-built closures of your Home Manager configurations.
3. **Cross-platform consistency**: The same command works on both Linux and macOS.
4. **Authentication integration**: Leverages your Determinate Nix authentication with FlakeHub.

```bash
# Apply a Home Manager configuration without local evaluation
fh apply home-manager "AmbiguousTechnologies/profile/0.1#homeConfigurations.user@workstation"
```

If you don't specify a flake output path, `fh apply home-manager` defaults to `homeConfigurations.$(whoami)`. These two commands are equivalent if your username is "user":

```bash
fh apply home-manager "AmbiguousTechnologies/profile/0.1#homeConfigurations.user"
fh apply home-manager "AmbiguousTechnologies/profile/0.1"
```

## Summary 🤔

Deploying Home Manager configurations via FlakeHub offers significant advantages over traditional methods:

### Security

- **FlakeHub deployment**: Configurations are built in controlled CI environments and cryptographically verified.
- **Traditional deployment**: Configurations are built locally, potentially introducing inconsistency and security risks.

### Deployment speed

- **FlakeHub deployment**: Configurations are pre-evaluated and pre-built. Deployment only requires downloading and applying the closure.
- **Traditional deployment**: Each deployment requires local evaluation and building, which can be time-consuming, especially on less powerful machines.

### Resource utilization

- **FlakeHub deployment**: Offloads resource-intensive evaluation and building to CI systems.
- **Traditional deployment**: Requires local resources for evaluation and building, which can be significant for complex configurations.

### Cross-device consistency

- **FlakeHub deployment**: The same evaluated closure is applied everywhere, guaranteeing identical environments.
- **Traditional deployment**: Small differences in local environments can lead to subtle inconsistencies.

In summary, using FlakeHub for Home Manager deployments ensures that your development environments are consistent, secure, and quick to deploy across all your systems. This approach is particularly valuable for teams that need to maintain consistent environments across multiple developers and platforms.
