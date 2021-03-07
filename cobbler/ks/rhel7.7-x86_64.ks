# This kickstart file should only be used with EL > 5 and/or Fedora > 7.
# For older versions please use the sample.ks kickstart file.

#platform=x86, AMD64, or Intel EM64T
# System authorization information
auth  --useshadow  --enablemd5
# System bootloader configuration
bootloader --location=mbr
# Partition clearing information
clearpart --all --initlabel
# Use text mode install
text
# Firewall configuration
firewall --disable
# Run the Setup Agent on first boot
firstboot --disable
# System keyboard
keyboard --vckeymap=us --xlayouts='us'
# System language
lang en_US.UTF-8 --addsupport=zh_CN.UTF-8,zh_HK.UTF-8,zh_SG.UTF-8,zh_TW.UTF-8
# Use network installation
url --url=$tree
# If any cobbler repo definitions were referenced in the kickstart profile, include them here.
$yum_repo_stanza
# Network information
$SNIPPET('network_config')
# Reboot after installation
reboot

#Root password
rootpw --iscrypted $default_password_crypted
# SELinux configuration
selinux --disabled
# Do not configure the X Window System
#skipx
# System timezone
timezone Asia/Shanghai --isUtc --nontp
# Install OS instead of upgrade
install
# Clear the Master Boot Record
zerombr
# Allow anaconda to partition the system as needed
#autopart
ignoredisk --only-use=sda
part swap --fstype="swap" --recommended
part /boot --fstype="xfs" --size=200
part / --fstype="xfs" --grow --size=200



xconfig  --startxonboot


%pre
$SNIPPET('log_ks_pre')
$SNIPPET('kickstart_start')
$SNIPPET('pre_install_network_config')
# Enable installation monitoring
$SNIPPET('pre_anamon')
%end

%packages
#$SNIPPET('func_install_if_enabled')
@^graphical-server-environment
@backup-server
@base
@compat-libraries
@core
@desktop-debugging
@development
@dial-up
@dns-server
@file-server
@fonts
@ftp-server
@gnome-desktop
@guest-agents
@guest-desktop-agents
@hardware-monitoring
@identity-management-server
@infiniband
@input-methods
@internet-browser
@java-platform
@kde-desktop
@large-systems
@load-balancer
@mail-server
@mainframe-access
@mariadb
@multimedia
@network-file-system-client
@performance
@postgresql
@print-client
@print-server
@remote-system-management
@security-tools
@smart-card
@system-admin-tools
@x11
kexec-tools
ksh
%end

%post --nochroot
$SNIPPET('log_ks_post_nochroot')
%end

%post
$SNIPPET('log_ks_post')
# Start yum configuration
$yum_config_stanza
# End yum configuration
$SNIPPET('post_install_kernel_options')
$SNIPPET('post_install_network_config')
$SNIPPET('func_register_if_enabled')
$SNIPPET('download_config_files')
$SNIPPET('koan_environment')
$SNIPPET('redhat_register')
$SNIPPET('cobbler_register')
# Enable post-install boot notification
$SNIPPET('post_anamon')
# Start final steps
$SNIPPET('kickstart_done')
# End final steps
%end
