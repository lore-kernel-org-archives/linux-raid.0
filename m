From: Asdo <asdo@shiftmail.org>
Subject: Re: Some md/mdadm bugs
Date: Mon, 06 Feb 2012 19:47:38 +0100
Message-ID: <4F30204A.1060206@shiftmail.org>
References: <4F2ADF45.4040103@shiftmail.org>
 <20120203081717.195bfec8@notabene.brown> <4F2B1519.5010500@shiftmail.org>
 <4F3008DA.8060402@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4F3008DA.8060402@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

One or two more bug(s) in 3.2.2
(note: my latest mail I am replying to is still valid)

AUTO line in mdadm.conf does not appear to work any longer in 3.2.2 
compared to mdadm 3.1.4
Now this line

"AUTO -all"

still autoassembles every array.
There are many arrays not declared in my mdadm.conf, and which are not 
for this host (hostname is different)
but mdadm still autoassembles everything, e.g.:

# mdadm -I /dev/sdr8
mdadm: /dev/sdr8 attached to /dev/md/perftest:r0d24, not enough to start 
(1).

(note: "perftest" is even not the hostname)

I have just regressed to mdadm 3.1.4 to confirm that it worked back 
then, and yes, I confirm that 3.1.4 was not doing any action upon:
# mdadm -I /dev/sdr8
--> nothing done
when the line in config was:
"AUTO -all"
or even
"AUTO +homehost -all"
which is the line I am normally using.


This is a problem in our fairly large system with 80+ HDDs and many 
partitions which I am testing now which is full of every kind of arrays....
I am normally using : "AUTO +homehost -all"  to prevent assembling a 
bagzillion of arrays at boot, also because doing that gives race 
conditions at boot and drops me to initramfs shell (see below next bug).





Another problem with 3.2.2:

At boot, this is from a serial dump:

udevd[218]: symlink '../../sdx13' 
'/dev/disk/by-partlabel/Linux\x20RAID.udev-tmp' failed: File exists
udevd[189]: symlink '../../sdb1' 
'/dev/disk/by-partlabel/Linux\x20RAID.udev-tmp' failed: File exists

And sdb1 is not correctly inserted into array /dev/md0 which hence 
starts degraded and so I am dropped into an initramfs shell.
This looks like a race condition... I don't know if this is fault of 
udev, udev rules or mdadm...
This is with mdadm 3.2.2 and kernel 3.0.13 (called 3.0.0-15-server by 
Ubuntu) on Ubuntu oneiric 11.10
Having also the above bug of nonworking AUTO line, this problem happens 
a lot with 80+ disks and lots of partitions. If the auto line worked, I 
would have postponed most of the assembly's at a very late stage in the 
boot process, maybe after a significant "sleep".


Actually this race condition could be an ubuntu udev script bug :

Here are the ubuntu udev rules files I could find, related to mdadm or 
containing "by-partlabel":
------------------------------------------------
65-mdadm-blkid.rules:

# This file causes Linux RAID (md) block devices to be checked for further
# filesystems if the array is active. See udev(8) for syntax.
#
# Based on Suse's udev rule file for md

SUBSYSTEM!="block", GOTO="mdadm_end"
KERNEL!="md[0-9]*", GOTO="mdadm_end"
ACTION!="add|change", GOTO="mdadm_end"

# container devices have a metadata version of e.g. 'external:ddf' and
# never leave state 'inactive'
ATTR{md/metadata_version}=="external:[A-Za-z]*", 
ATTR{md/array_state}=="inactive", GOTO="md_ignore_state"
ENV{DEVTYPE}=="partition", GOTO="md_ignore_state"
TEST!="md/array_state", GOTO="mdadm_end"
ATTR{md/array_state}=="|clear|inactive", GOTO="mdadm_end"
LABEL="md_ignore_state"

# Obtain array information
IMPORT{program}="/sbin/mdadm --detail --export $tempnode"
ENV{DEVTYPE}=="disk", ENV{MD_NAME}=="?*", 
SYMLINK+="disk/by-id/md-name-$env{MD_NAME}", 
OPTIONS+="string_escape=replace"
ENV{DEVTYPE}=="disk", ENV{MD_UUID}=="?*", 
SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}"
ENV{DEVTYPE}=="disk", ENV{MD_DEVNAME}=="?*", SYMLINK+="md/$env{MD_DEVNAME}"
ENV{DEVTYPE}=="partition", ENV{MD_NAME}=="?*", 
SYMLINK+="disk/by-id/md-name-$env{MD_NAME}-part%n", 
OPTIONS+="string_escape=replace"
ENV{DEVTYPE}=="partition", ENV{MD_UUID}=="?*", 
SYMLINK+="disk/by-id/md-uuid-$env{MD_UUID}-part%n"
ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[^0-9]", 
SYMLINK+="md/$env{MD_DEVNAME}%n"
ENV{DEVTYPE}=="partition", ENV{MD_DEVNAME}=="*[0-9]", 
SYMLINK+="md/$env{MD_DEVNAME}p%n"

# by-uuid and by-label symlinks
IMPORT{program}="/sbin/blkid -o udev -p $tempnode"
OPTIONS+="link_priority=100"
OPTIONS+="watch"
ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", \
                        SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", \
                        SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"

LABEL="mdadm_end"


------------------------------------------------
85-mdadm.rules:

# This file causes block devices with Linux RAID (mdadm) signatures to
# automatically cause mdadm to be run.
# See udev(8) for syntax

SUBSYSTEM=="block", ACTION=="add|change", ENV{ID_FS_TYPE}=="linux_raid*", \
         RUN+="/sbin/mdadm --incremental $env{DEVNAME}"


------------------------------------------------
part of 60-persistent-storage.rules:

# do not edit this file, it will be overwritten on update

# persistent storage links: /dev/disk/{by-id,by-uuid,by-label,by-path}
# scheme based on "Linux persistent device names", 2004, Hannes Reinecke 
<hare@suse.de>

# forward scsi device event to corresponding block device
ACTION=="change", SUBSYSTEM=="scsi", ENV{DEVTYPE}=="scsi_device", 
TEST=="block", ATTR{block/*/uevent}="change"

ACTION=="remove", GOTO="persistent_storage_end"

# enable in-kernel media-presence polling
ACTION=="add", SUBSYSTEM=="module", KERNEL=="block", 
ATTR{parameters/events_dfl_poll_msecs}=="0", 
ATTR{parameters/events_dfl_poll_msecs}="2000"

SUBSYSTEM!="block", GOTO="persistent_storage_end"

# skip rules for inappropriate block devices
KERNEL=="fd*|mtd*|nbd*|gnbd*|btibm*|dm-*|md*", GOTO="persistent_storage_end"

# ignore partitions that span the entire disk
TEST=="whole_disk", GOTO="persistent_storage_end"

# for partitions import parent information
ENV{DEVTYPE}=="partition", IMPORT{parent}="ID_*"

# virtio-blk
KERNEL=="vd*[!0-9]", ATTRS{serial}=="?*", 
ENV{ID_SERIAL}="$attr{serial}", SYMLINK+="disk/by-id/virtio-$env{ID_SERIAL}"
KERNEL=="vd*[0-9]", ATTRS{serial}=="?*", ENV{ID_SERIAL}="$attr{serial}", 
SYMLINK+="disk/by-id/virtio-$env{ID_SERIAL}-part%n"

# ATA devices with their own "ata" kernel subsystem
KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", SUBSYSTEMS=="ata", 
IMPORT{program}="ata_id --export $tempnode"
# ATA devices using the "scsi" subsystem
KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", SUBSYSTEMS=="scsi", 
ATTRS{vendor}=="ATA", IMPORT{program}="ata_id --export $tempnode"
# ATA/ATAPI devices (SPC-3 or later) using the "scsi" subsystem
KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", SUBSYSTEMS=="scsi", 
ATTRS{type}=="5", ATTRS{scsi_level}=="[6-9]*", IMPORT{program}="ata_id 
--export $tempnode"

# Run ata_id on non-removable USB Mass Storage (SATA/PATA disks in 
enclosures)
KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", ATTR{removable}=="0", 
SUBSYSTEMS=="usb", IMPORT{program}="ata_id --export $tempnode"
# Otherwise fall back to using usb_id for USB devices
KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", SUBSYSTEMS=="usb", 
IMPORT{program}="usb_id --export %p"

# scsi devices
KERNEL=="sd*[!0-9]|sr*", ENV{ID_SERIAL}!="?*", IMPORT{program}="scsi_id 
--export --whitelisted -d $tempnode", ENV{ID_BUS}="scsi"
KERNEL=="cciss*", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}!="?*", 
IMPORT{program}="scsi_id --export --whitelisted -d $tempnode", 
ENV{ID_BUS}="cciss"
KERNEL=="sd*|sr*|cciss*", ENV{DEVTYPE}=="disk", ENV{ID_SERIAL}=="?*", 
SYMLINK+="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}"
KERNEL=="sd*|cciss*", ENV{DEVTYPE}=="partition", ENV{ID_SERIAL}=="?*", 
SYMLINK+="disk/by-id/$env{ID_BUS}-$env{ID_SERIAL}-part%n"

# firewire
KERNEL=="sd*[!0-9]|sr*", ATTRS{ieee1394_id}=="?*", 
SYMLINK+="disk/by-id/ieee1394-$attr{ieee1394_id}"
KERNEL=="sd*[0-9]", ATTRS{ieee1394_id}=="?*", 
SYMLINK+="disk/by-id/ieee1394-$attr{ieee1394_id}-part%n"

# scsi compat links for ATA devices
KERNEL=="sd*[!0-9]", ENV{ID_BUS}=="ata", PROGRAM="scsi_id --whitelisted 
--replace-whitespace -p0x80 -d$tempnode", RESULT=="?*", 
ENV{ID_SCSI_COMPAT}="$result", 
SYMLINK+="disk/by-id/scsi-$env{ID_SCSI_COMPAT}"
KERNEL=="sd*[0-9]", ENV{ID_SCSI_COMPAT}=="?*", 
SYMLINK+="disk/by-id/scsi-$env{ID_SCSI_COMPAT}-part%n"

KERNEL=="mmcblk[0-9]", SUBSYSTEMS=="mmc", ATTRS{name}=="?*", 
ATTRS{serial}=="?*", ENV{ID_NAME}="$attr{name}", 
ENV{ID_SERIAL}="$attr{serial}", 
SYMLINK+="disk/by-id/mmc-$env{ID_NAME}_$env{ID_SERIAL}"
KERNEL=="mmcblk[0-9]p[0-9]", ENV{ID_NAME}=="?*", ENV{ID_SERIAL}=="?*", 
SYMLINK+="disk/by-id/mmc-$env{ID_NAME}_$env{ID_SERIAL}-part%n"
KERNEL=="mspblk[0-9]", SUBSYSTEMS=="memstick", ATTRS{name}=="?*", 
ATTRS{serial}=="?*", ENV{ID_NAME}="$attr{name}", 
ENV{ID_SERIAL}="$attr{serial}", 
SYMLINK+="disk/by-id/memstick-$env{ID_NAME}_$env{ID_SERIAL}"
KERNEL=="mspblk[0-9]p[0-9]", ENV{ID_NAME}=="?*", ENV{ID_SERIAL}=="?*", 
SYMLINK+="disk/by-id/memstick-$env{ID_NAME}_$env{ID_SERIAL}-part%n"

# by-path (parent device path)
ENV{DEVTYPE}=="disk", ENV{ID_PATH}=="", DEVPATH!="*/virtual/*", 
IMPORT{program}="path_id %p"
ENV{DEVTYPE}=="disk", ENV{ID_PATH}=="?*", 
SYMLINK+="disk/by-path/$env{ID_PATH}"
ENV{DEVTYPE}=="partition", ENV{ID_PATH}=="?*", 
SYMLINK+="disk/by-path/$env{ID_PATH}-part%n"

# skip unpartitioned removable media devices from drivers which do not 
send "change" events
ENV{DEVTYPE}=="disk", KERNEL!="sd*|sr*", ATTR{removable}=="1", 
GOTO="persistent_storage_end"

# probe filesystem metadata of optical drives which have a media inserted
KERNEL=="sr*", ENV{DISK_EJECT_REQUEST}!="?*", 
ENV{ID_CDROM_MEDIA_TRACK_COUNT_DATA}=="?*", 
ENV{ID_CDROM_MEDIA_SESSION_LAST_OFFSET}=="?*", 
IMPORT{program}="/sbin/blkid -o udev -p -u noraid -O 
$env{ID_CDROM_MEDIA_SESSION_LAST_OFFSET} $tempnode"
# single-session CDs do not have ID_CDROM_MEDIA_SESSION_LAST_OFFSET
KERNEL=="sr*", ENV{DISK_EJECT_REQUEST}!="?*", 
ENV{ID_CDROM_MEDIA_TRACK_COUNT_DATA}=="?*", 
ENV{ID_CDROM_MEDIA_SESSION_LAST_OFFSET}=="", 
IMPORT{program}="/sbin/blkid -o udev -p -u noraid $tempnode"

# probe filesystem metadata of disks
KERNEL!="sr*", IMPORT{program}="/sbin/blkid -o udev -p $tempnode"

# watch metadata changes by tools closing the device after writing
KERNEL!="sr*", OPTIONS+="watch"

# by-label/by-uuid links (filesystem metadata)
ENV{ID_FS_USAGE}=="filesystem|other|crypto", ENV{ID_FS_UUID_ENC}=="?*", 
SYMLINK+="disk/by-uuid/$env{ID_FS_UUID_ENC}"
ENV{ID_FS_USAGE}=="filesystem|other", ENV{ID_FS_LABEL_ENC}=="?*", 
SYMLINK+="disk/by-label/$env{ID_FS_LABEL_ENC}"

# by-id (World Wide Name)
ENV{DEVTYPE}=="disk", ENV{ID_WWN_WITH_EXTENSION}=="?*", 
SYMLINK+="disk/by-id/wwn-$env{ID_WWN_WITH_EXTENSION}"
ENV{DEVTYPE}=="partition", ENV{ID_WWN_WITH_EXTENSION}=="?*", 
SYMLINK+="disk/by-id/wwn-$env{ID_WWN_WITH_EXTENSION}-part%n"

# by-partlabel/by-partuuid links (partition metadata)
ENV{ID_PART_ENTRY_SCHEME}=="gpt", ENV{ID_PART_ENTRY_UUID}=="?*", 
SYMLINK+="disk/by-partuuid/$env{ID_PART_ENTRY_UUID}"
ENV{ID_PART_ENTRY_SCHEME}=="gpt", ENV{ID_PART_ENTRY_NAME}=="?*", 
SYMLINK+="disk/by-partlabel/$env{ID_PART_ENTRY_NAME}"

LABEL="persistent_storage_end"
------------------------------------------------


Do you think this is an ubuntu udev rule bug or a mdadm bug?

Thank you
A.
