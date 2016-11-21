From: Andy Smith <andy@strugglers.net>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname
 change?
Date: Mon, 21 Nov 2016 06:02:56 +0000
Message-ID: <20161121060256.GL1804@bitfolk.com>
References: <20161117035230.GG21587@bitfolk.com>
 <87lgwihc2v.fsf@notabene.neil.brown.name>
 <20161117150954.GH21587@bitfolk.com>
 <87d1hthgm7.fsf@notabene.neil.brown.name>
 <20161118023144.GC1804@bitfolk.com>
 <87poltfq2d.fsf@notabene.neil.brown.name>
 <20161118034716.GI21587@bitfolk.com>
 <87k2c1fn0o.fsf@notabene.neil.brown.name>
 <20161118041759.GE1804@bitfolk.com>
 <877f7xe9lh.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <877f7xe9lh.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Mon, Nov 21, 2016 at 03:32:42PM +1100, NeilBrown wrote:
> If you still want to get to the bottom of this, you might need to revert
> your work-around, the try the "udevadm monitor" and "udevadm info" and "udevadm
> trigger" while the array is not assembled.

I have reverted my addition of "mpt3sas" from
/etc/initramfs-tools/modules and rebooted, so that md5 is again not
assembled.

Result of

    udevadm info /dev/sdc

P: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc
N: sdc
S: disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633
S: disk/by-id/wwn-0x5002538c0007e7a8
S: disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: DEVLINKS=/dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633 /dev/disk/by-id/wwn-0x5002538c0007e7a8 /dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: DEVNAME=/dev/sdc
E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc 
E: DEVTYPE=disk
E: ID_ATA=1
E: ID_ATA_DOWNLOAD_MICROCODE=1
E: ID_ATA_FEATURE_SET_HPA=1
E: ID_ATA_FEATURE_SET_HPA_ENABLED=1
E: ID_ATA_FEATURE_SET_PM=1
E: ID_ATA_FEATURE_SET_PM_ENABLED=1
E: ID_ATA_FEATURE_SET_SECURITY=1
E: ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
E: ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=32
E: ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=32
E: ID_ATA_FEATURE_SET_SMART=1
E: ID_ATA_FEATURE_SET_SMART_ENABLED=1
E: ID_ATA_ROTATION_RATE_RPM=0
E: ID_ATA_SATA=1
E: ID_ATA_SATA_SIGNAL_RATE_GEN1=1
E: ID_ATA_SATA_SIGNAL_RATE_GEN2=1
E: ID_ATA_WRITE_CACHE=1
E: ID_ATA_WRITE_CACHE_ENABLED=1
E: ID_BUS=ata
E: ID_FS_LABEL=tbd:5
E: ID_FS_LABEL_ENC=tbd:5
E: ID_FS_TYPE=linux_raid_member
E: ID_FS_USAGE=raid
E: ID_FS_UUID=957030cf-c09f-023d-ceae-bb27e546f095
E: ID_FS_UUID_ENC=957030cf-c09f-023d-ceae-bb27e546f095
E: ID_FS_UUID_SUB=4ac82c29-2d10-9465-7fff-9b228c411c1e
E: ID_FS_VERSION=1.2
E: ID_MODEL=SAMSUNG_MZ7KM1T9HAJM-00005
E: ID_MODEL_ENC=SAMSUNG\x20MZ7KM1T9HAJM-00005\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
E: ID_PATH=pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: ID_PATH_TAG=pci-0000_01_00_0-sas-0x4433221100000000-lun-0
E: ID_REVISION=GXM1003Q
E: ID_SERIAL=SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633
E: ID_SERIAL_SHORT=S2HNNAAH200633
E: ID_TYPE=disk
E: ID_WWN=0x5002538c0007e7a8
E: ID_WWN_WITH_EXTENSION=0x5002538c0007e7a8
E: MAJOR=8
E: MINOR=32
E: SUBSYSTEM=block
E: TAGS=:systemd:
E: USEC_INITIALIZED=43226

I then issued

    echo change > /sys/block/sdc/uevent

and

    echo change > /sys/block/sdd/uevent

which resulted in the monitor showing:

KERNEL[572.956390] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc (block)
UDEV  [572.960256] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc (block)
KERNEL[593.140178] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:1/end_device-10:1/target10:0:1/10:0:1:0/block/sdd (block)
UDEV  [593.143824] change   /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:1/end_device-10:1/target10:0:1/10:0:1:0/block/sdd (block)

But no assembly of md5.

Afterwards,

    udevadm info /dev/sdc

showed:

P: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc
N: sdc
S: disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633
S: disk/by-id/wwn-0x5002538c0007e7a8
S: disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: DEVLINKS=/dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633 /dev/disk/by-id/wwn-0x5002538c0007e7a8 /dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: DEVNAME=/dev/sdc
E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc
E: DEVTYPE=disk
E: ID_ATA=1
E: ID_ATA_DOWNLOAD_MICROCODE=1
E: ID_ATA_FEATURE_SET_HPA=1
E: ID_ATA_FEATURE_SET_HPA_ENABLED=1
E: ID_ATA_FEATURE_SET_PM=1
E: ID_ATA_FEATURE_SET_PM_ENABLED=1
E: ID_ATA_FEATURE_SET_SECURITY=1
E: ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
E: ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=32
E: ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=32
E: ID_ATA_FEATURE_SET_SMART=1
E: ID_ATA_FEATURE_SET_SMART_ENABLED=1
E: ID_ATA_ROTATION_RATE_RPM=0
E: ID_ATA_SATA=1
E: ID_ATA_SATA_SIGNAL_RATE_GEN1=1
E: ID_ATA_SATA_SIGNAL_RATE_GEN2=1
E: ID_ATA_WRITE_CACHE=1
E: ID_ATA_WRITE_CACHE_ENABLED=1
E: ID_BUS=ata
E: ID_FS_LABEL=tbd:5
E: ID_FS_LABEL_ENC=tbd:5
E: ID_FS_TYPE=linux_raid_member
E: ID_FS_USAGE=raid
E: ID_FS_UUID=957030cf-c09f-023d-ceae-bb27e546f095
E: ID_FS_UUID_ENC=957030cf-c09f-023d-ceae-bb27e546f095
E: ID_FS_UUID_SUB=4ac82c29-2d10-9465-7fff-9b228c411c1e
E: ID_FS_UUID_SUB_ENC=4ac82c29-2d10-9465-7fff-9b228c411c1e
E: ID_FS_VERSION=1.2
E: ID_MODEL=SAMSUNG_MZ7KM1T9HAJM-00005
E: ID_MODEL_ENC=SAMSUNG\x20MZ7KM1T9HAJM-00005\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
E: ID_PATH=pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: ID_PATH_TAG=pci-0000_01_00_0-sas-0x4433221100000000-lun-0
E: ID_REVISION=GXM1003Q
E: ID_SERIAL=SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633
E: ID_SERIAL_SHORT=S2HNNAAH200633
E: ID_TYPE=disk
E: ID_WWN=0x5002538c0007e7a8
E: ID_WWN_WITH_EXTENSION=0x5002538c0007e7a8
E: MAJOR=8
E: MINOR=32
E: SUBSYSTEM=block
E: TAGS=:systemd:
E: USEC_INITIALIZED=43226

Thanks,
Andy
