From: Andy Smith <andy@strugglers.net>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname
 change?
Date: Fri, 18 Nov 2016 04:17:59 +0000
Message-ID: <20161118041759.GE1804@bitfolk.com>
References: <20161117035230.GG21587@bitfolk.com>
 <87lgwihc2v.fsf@notabene.neil.brown.name>
 <20161117150954.GH21587@bitfolk.com>
 <87d1hthgm7.fsf@notabene.neil.brown.name>
 <20161118023144.GC1804@bitfolk.com>
 <87poltfq2d.fsf@notabene.neil.brown.name>
 <20161118034716.GI21587@bitfolk.com>
 <87k2c1fn0o.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87k2c1fn0o.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Fri, Nov 18, 2016 at 03:08:23PM +1100, NeilBrown wrote:
> Up to you, but I have an idea.
> The udev rules files depends on 'blkid' having been run.
>   /lib/udev/rules.d/60-persistent-storage.rules
> does this, but not for
>   KERNEL=="fd*|mtd*|nbd*|gnbd*|btibm*|dm-*|md*|zram*|mmcblk[0-9]*rpmb"
> 
> ... though that wouldn't apply to you.
> 
> what does
>   udevadm info /dev/sdc

(Since mpt3sas got loaded early the device identifiers have all
changed; what was sd{a,b} have now shifted to the end as sd{e,f}, so
the two members of md5 are now sd{a,b})

$ sudo udevadm info /dev/sda
P: /devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda
N: sda
S: disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633
S: disk/by-id/wwn-0x5002538c0007e7a8
S: disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: DEVLINKS=/dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633 /dev/disk/by-id/wwn-0x5002538c0007e7a8 /dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
E: DEVNAME=/dev/sda
E: DEVPATH=/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda
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
E: MINOR=0
E: SUBSYSTEM=block
E: TAGS=:systemd:
E: UDEV_LOG=7
E: USEC_INITIALIZED=38597

Cheers,
Andy
