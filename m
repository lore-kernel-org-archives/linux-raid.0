From: Marco Schindler <marco.schindler@gmail.com>
Subject: Re: frequent disk activity with mdadm-3.3
Date: Thu, 18 Sep 2014 12:38:55 +0200
Message-ID: <D28F9C01-C75C-4B69-932F-FA2425DEDDB4@gmail.com>
References: <AB305DF4-9DCC-47E1-9B29-130E211D4B4E@gmail.com> <20140912082403.549fc298@notabene.brown> <164CD08B-99CA-4007-855A-7B0561B4EC76@gmail.com> <BDDC2624-8578-4720-A526-56EFDFBE26C4@gmail.com> <20140915101830.3c85d423@notabene.brown> <DDAF4EEF-EFA9-4B0E-BB97-E5D8B9788A70@gmail.com> <20140918200347.762845bb@notabene.brown>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140918200347.762845bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On 18.09.2014, at 12:03, NeilBrown <neilb@suse.de> wrote:

> Getting a "change" even on spindown is causing the problem I suspect.
> A change in 3.3.1 causes "mdadm -I" to be run on a device when it 'changes'.
> That will read from the device which will wake it up.
> (commit 25392f5fc59f96fb76 - revert it and the symptom will probably go away).
> 
> I really think the "bug" here is that the change event is emitted on
> 'spindown', but maybe the bug is that the exact meaning of 'change' isn't
> well documented.
> 
> I can probably get "mdadm -I" to use O_EXCL which will fail on devices
> already in an array, but I'm not sure that is a complete solution.  You could
> still get wakeups on other devices.
> 
> Can you rung the 'udevadm monitor' again, but this time with '--property'.
> Maybe there is some property associated with spindown events which we can use
> to ignore them.
> 
> NeilBrown

sure. I also took separate logs for standby and wakeup.

change events only occur when the drive goes standby (see below).
strangely enough, there are no events when the drive wakes up.

monitor will print the received events for:
UDEV - the event which udev sends out after rule processing
KERNEL - the kernel uevent

KERNEL[558130.868218] change   /devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (block)
ACTION=change
DEVNAME=/dev/sda
DEVPATH=/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda
DEVTYPE=disk
MAJOR=8
MINOR=0
SEQNUM=3239
SUBSYSTEM=block

KERNEL[558132.028485] change   /devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
ACTION=change
DEVNAME=/dev/sdb
DEVPATH=/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb
DEVTYPE=disk
MAJOR=8
MINOR=16
SEQNUM=3240
SUBSYSTEM=block

UDEV  [558139.263973] change   /devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda (block)
ACTION=change
DEVLINKS=/dev/disk/by-id/ata-WDC_WD20EARS-00S8B1_WD-WCAVY1872131 /dev/disk/by-id/wwn-0x50014ee203dca984 /dev/disk/by-path/pci-0000:09:00.0-sas-0x4433221103000000-lun-0
DEVNAME=/dev/sda
DEVPATH=/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:0/end_device-0:0/target0:0:0/0:0:0:0/block/sda
DEVTYPE=disk
ID_ATA=1
ID_ATA_DOWNLOAD_MICROCODE=1
ID_ATA_FEATURE_SET_AAM=1
ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=254
ID_ATA_FEATURE_SET_AAM_ENABLED=0
ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=128
ID_ATA_FEATURE_SET_HPA=1
ID_ATA_FEATURE_SET_HPA_ENABLED=1
ID_ATA_FEATURE_SET_PM=1
ID_ATA_FEATURE_SET_PM_ENABLED=1
ID_ATA_FEATURE_SET_PUIS=1
ID_ATA_FEATURE_SET_PUIS_ENABLED=0
ID_ATA_FEATURE_SET_SECURITY=1
ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=408
ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=408
ID_ATA_FEATURE_SET_SMART=1
ID_ATA_FEATURE_SET_SMART_ENABLED=1
ID_ATA_SATA=1
ID_ATA_SATA_SIGNAL_RATE_GEN1=1
ID_ATA_SATA_SIGNAL_RATE_GEN2=1
ID_ATA_WRITE_CACHE=1
ID_ATA_WRITE_CACHE_ENABLED=1
ID_BUS=ata
ID_FS_LABEL=alina.o81.5:media3
ID_FS_LABEL_ENC=alina.o81.5:media3
ID_FS_TYPE=linux_raid_member
ID_FS_USAGE=raid
ID_FS_UUID=058bd7b0-455c-0d7e-6de0-a845ea05ee38
ID_FS_UUID_ENC=058bd7b0-455c-0d7e-6de0-a845ea05ee38
ID_FS_UUID_SUB=da1c1cad-6661-174c-b0b9-4bc1a712902d
ID_FS_UUID_SUB_ENC=da1c1cad-6661-174c-b0b9-4bc1a712902d
ID_FS_VERSION=1.2
ID_MODEL=WDC_WD20EARS-00S8B1
ID_MODEL_ENC=WDC\x20WD20EARS-00S8B1\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
ID_PATH=pci-0000:09:00.0-sas-0x4433221103000000-lun-0
ID_PATH_TAG=pci-0000_09_00_0-sas-0x4433221103000000-lun-0
ID_REVISION=80.00A80
ID_SERIAL=WDC_WD20EARS-00S8B1_WD-WCAVY1872131
ID_SERIAL_SHORT=WD-WCAVY1872131
ID_TYPE=disk
ID_WWN=0x50014ee203dca984
ID_WWN_WITH_EXTENSION=0x50014ee203dca984
MAJOR=8
MINOR=0
SEQNUM=3239
SUBSYSTEM=block
USEC_INITIALIZED=2003

UDEV  [558139.293742] change   /devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb (block)
ACTION=change
DEVLINKS=/dev/disk/by-id/ata-WDC_WD20EARS-00S8B1_WD-WCAVY1879365 /dev/disk/by-id/wwn-0x50014ee25931e63a /dev/disk/by-path/pci-0000:09:00.0-sas-0x4433221102000000-lun-0
DEVNAME=/dev/sdb
DEVPATH=/devices/pci0000:00/0000:00:06.0/0000:09:00.0/host0/port-0:1/end_device-0:1/target0:0:1/0:0:1:0/block/sdb
DEVTYPE=disk
ID_ATA=1
ID_ATA_DOWNLOAD_MICROCODE=1
ID_ATA_FEATURE_SET_AAM=1
ID_ATA_FEATURE_SET_AAM_CURRENT_VALUE=254
ID_ATA_FEATURE_SET_AAM_ENABLED=0
ID_ATA_FEATURE_SET_AAM_VENDOR_RECOMMENDED_VALUE=128
ID_ATA_FEATURE_SET_HPA=1
ID_ATA_FEATURE_SET_HPA_ENABLED=1
ID_ATA_FEATURE_SET_PM=1
ID_ATA_FEATURE_SET_PM_ENABLED=1
ID_ATA_FEATURE_SET_PUIS=1
ID_ATA_FEATURE_SET_PUIS_ENABLED=0
ID_ATA_FEATURE_SET_SECURITY=1
ID_ATA_FEATURE_SET_SECURITY_ENABLED=0
ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=408
ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=408
ID_ATA_FEATURE_SET_SMART=1
ID_ATA_FEATURE_SET_SMART_ENABLED=1
ID_ATA_SATA=1
ID_ATA_SATA_SIGNAL_RATE_GEN1=1
ID_ATA_SATA_SIGNAL_RATE_GEN2=1
ID_ATA_WRITE_CACHE=1
ID_ATA_WRITE_CACHE_ENABLED=1
ID_BUS=ata
ID_FS_LABEL=alina.o81.5:media3
ID_FS_LABEL_ENC=alina.o81.5:media3
ID_FS_TYPE=linux_raid_member
ID_FS_USAGE=raid
ID_FS_UUID=058bd7b0-455c-0d7e-6de0-a845ea05ee38
ID_FS_UUID_ENC=058bd7b0-455c-0d7e-6de0-a845ea05ee38
ID_FS_UUID_SUB=ade4cbb9-501c-cd2c-00b2-607f1699133b
ID_FS_UUID_SUB_ENC=ade4cbb9-501c-cd2c-00b2-607f1699133b
ID_FS_VERSION=1.2
ID_MODEL=WDC_WD20EARS-00S8B1
ID_MODEL_ENC=WDC\x20WD20EARS-00S8B1\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20
ID_PATH=pci-0000:09:00.0-sas-0x4433221102000000-lun-0
ID_PATH_TAG=pci-0000_09_00_0-sas-0x4433221102000000-lun-0
ID_REVISION=80.00A80
ID_SERIAL=WDC_WD20EARS-00S8B1_WD-WCAVY1879365
ID_SERIAL_SHORT=WD-WCAVY1879365
ID_TYPE=disk
ID_WWN=0x50014ee25931e63a
ID_WWN_WITH_EXTENSION=0x50014ee25931e63a
MAJOR=8
MINOR=16
SEQNUM=3240
SUBSYSTEM=block
USEC_INITIALIZED=2361