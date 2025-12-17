# Setup Vagrant + VMware Fusion on macOS Apple Silicon (M4)

This guide provides a professional walkthrough for setting up a virtualization environment specifically for Apple Silicon (M1/M2/M3/M4) architectures using Vagrant and VMware Fusion.

## 📋 System Requirements

* **Hardware**: MacBook Pro/Air with M4 chip (or M1/M2/M3).
* **OS**: macOS 14 (Sonoma) or 15 (Sequoia).
* **Hypervisor**: VMware Fusion 13.5+ (Pro version is free for personal use).

---

## 1. Installation Steps

### 1.1. VMware Fusion

Download and install **VMware Fusion Pro**.

* Ensure you grant the necessary permissions in **System Settings > Privacy & Security** after installation.
* [Official Broadcom/VMware Download Portal](https://www.google.com/search?q=https://www.broadcom.com/products/cloud-infrastructure/vmware-fusion).

### 1.2. Install Vagrant via Homebrew

Use the official Hashicorp tap to ensure you have the latest version compatible with ARM64:

```bash
brew tap hashicorp/tap
brew install hashicorp/tap/hashicorp-vagrant

```

### 1.3. Vagrant VMware Utility

This system service is required for Vagrant to manage networking devices on VMware Fusion.

1. Download the **arm64** version: [Vagrant VMware Utility 1.0.24](https://releases.hashicorp.com/vagrant-vmware-utility/1.0.24/vagrant-vmware-utility_1.0.24_darwin_arm64.dmg).
2. Open the `.dmg` and run the `.pkg` installer.

### 1.4. Install the Vagrant Plugin

Install the provider plugin that bridges Vagrant and VMware Fusion:

```bash
vagrant plugin install vagrant-vmware-desktop

```

---

## 2. Verification

Confirm that all components are correctly installed and the background service is running:

```bash
# Check Vagrant version
vagrant --version

# Verify the plugin is installed
vagrant plugin list

# Ensure the utility service is active
sudo launchctl list | grep vagrant

```

---

## 3. Launching a Test Virtual Machine

On Apple Silicon, you **must** use native **ARM64** boxes. Using x86_64 boxes will result in architecture mismatch errors.

### 3.1. Create a Configuration File

Create a new directory for your project and generate the `Vagrantfile`:

```bash
mkdir vagrant-test && cd vagrant-test

cat <<EOF > Vagrantfile
Vagrant.configure("2") do |config|
  # Official Bento Box supporting vmware_desktop on arm64
  config.vm.box = "bento/ubuntu-22.04"
  
  config.vm.provider "vmware_desktop" do |v|
    v.gui = false
    v.allowlist_verified = true
    v.cpus = 2
    v.memory = 2048
  end
end
EOF

```

### 3.2. Spin Up the VM

```bash
# Start the virtual machine
vagrant up

# Connect to the machine via SSH
vagrant ssh

```

---

## 🛠 Troubleshooting

### Error: `Failed to enable device`

This usually indicates a conflict in VMware's virtual network configuration.

1. Run `vagrant destroy -f` to clean up.
2. Open **VMware Fusion** -> **Settings** -> **Network**.
3. Click **Restore Defaults** (requires admin password).
4. Restart the utility service:
```bash
sudo launchctl stop com.vagrant.vagrant-vmware-utility
sudo launchctl start com.vagrant.vagrant-vmware-utility

```



### Error: `msg.guestos.badArch`

This occurs if you try to run an Intel (x86_64) box on your M4 Mac.

* **Solution**: Ensure your `Vagrantfile` specifies an `arm64` box (e.g., `bento/ubuntu-22.04` or `almalinux/9`).
