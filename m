From: Andy Smith <andy@strugglers.net>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname
 change?
Date: Tue, 22 Nov 2016 06:01:05 +0000
Message-ID: <20161122060105.GS1804@bitfolk.com>
References: <20161117150954.GH21587@bitfolk.com>
 <87d1hthgm7.fsf@notabene.neil.brown.name>
 <20161118023144.GC1804@bitfolk.com>
 <87poltfq2d.fsf@notabene.neil.brown.name>
 <20161118034716.GI21587@bitfolk.com>
 <87k2c1fn0o.fsf@notabene.neil.brown.name>
 <20161118041759.GE1804@bitfolk.com>
 <877f7xe9lh.fsf@notabene.neil.brown.name>
 <20161121060256.GL1804@bitfolk.com>
 <87shqkcuhv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <87shqkcuhv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

On Tue, Nov 22, 2016 at 09:56:28AM +1100, NeilBrown wrote:
> Thanks.  Sorry this is taking a lot of back-and-forth...

No worries. This is very interesting to me and I'd also like to know
what is going wrong even if I have a work-around.

> I would:
>  - check that md5 definitely isn't running (mdadm -S /dev/md5)
>  - run mdadm -I just like udev does.
> 
>    /sbin/mdadm --incremental --export /dev/sdc --offroot /dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633 /dev/disk/by-id/wwn-0x5002538c0007e7a8 /dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
> 
> (the string of paths is from the "DEVLINKS" field).
> 
> That *should* produce several lines like "MD_NAME=tbd:5" etc.

I got:

$ sudo /sbin/mdadm --incremental --export /dev/sdc --offroot /dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633 /dev/disk/by-id/wwn-0x5002538c0007e7a8 /dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0
MD_DEVICE=md5
MD_DEVNAME=5
MD_FOREIGN=no
MD_STARTED=unsafe

Over in the "udevadm monitor" window I see:

KERNEL[86682.101420] add      /devices/virtual/bdi/9:5 (bdi)
KERNEL[86682.101866] add      /devices/virtual/block/md5 (block)
UDEV  [86682.102211] add      /devices/virtual/bdi/9:5 (bdi)
UDEV  [86682.103376] add      /devices/virtual/block/md5 (block)

and cat /proc/mdstat:

Personalities : [raid1] [raid10]
md5 : inactive sdc[1](S)
      1875243352 blocks super 1.2
…etc…

> If it doesn't produce an error, but does produce some MD_* lines, then
> the problem must be that udev isn't doing quite the same thing.
> So stop md5 again (mdadm -S /dev/md5), enable udev debugging
>   udevadm control -l debug
> 
> and re-issue the 'change'
>      echo change > /sys/block/sdc/uevent
> 
> That should puts lots of stuff in the journal.  If you could extract
> that and post it I might be able to find something of interest.

Nov 22 05:50:15 jfd systemd-udevd[218]: validate module index
Nov 22 05:50:15 jfd systemd-udevd[218]: Check if link configuration needs reloading.
Nov 22 05:50:15 jfd systemd-udevd[218]: seq 5382 queued, 'change' 'block'
Nov 22 05:50:15 jfd systemd-udevd[218]: seq 5382 forked new worker [29004]
Nov 22 05:50:15 jfd systemd-udevd[29004]: seq 5382 running
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1cf950 filled with db file data
Nov 22 05:50:15 jfd systemd-udevd[29004]: removing watch on '/dev/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1d1a50 has devpath '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: IMPORT 'ata_id --export /dev/sdc' /lib/udev/rules.d/60-persistent-storage.rules:31
Nov 22 05:50:15 jfd systemd-udevd[29005]: starting 'ata_id --export /dev/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_TYPE=disk'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_BUS=ata'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_MODEL=SAMSUNG_MZ7KM1T9HAJM-00005'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_MODEL_ENC=SAMSUNG\x20MZ7KM1T9HAJM-00005\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20\x20'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_REVISION=GXM1003Q'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_SERIAL=SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_SERIAL_SHORT=S2HNNAAH200633'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_WRITE_CACHE=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_WRITE_CACHE_ENABLED=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_HPA=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_HPA_ENABLED=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_PM=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_PM_ENABLED=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_SECURITY=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_SECURITY_ENABLED=0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_SECURITY_ERASE_UNIT_MIN=32'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_SECURITY_ENHANCED_ERASE_UNIT_MIN=32'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_SMART=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_FEATURE_SET_SMART_ENABLED=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_DOWNLOAD_MICROCODE=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_SATA=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_SATA_SIGNAL_RATE_GEN2=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_SATA_SIGNAL_RATE_GEN1=1'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_ATA_ROTATION_RATE_RPM=0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_WWN=0x5002538c0007e7a8'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc'(out) 'ID_WWN_WITH_EXTENSION=0x5002538c0007e7a8'
Nov 22 05:50:15 jfd systemd-udevd[29004]: 'ata_id --export /dev/sdc' [29005] exit with return code 0
Nov 22 05:50:15 jfd systemd-udevd[29004]: LINK 'disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633' /lib/udev/rules.d/60-persistent-storage.rules:43
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1dde20 has devpath '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1de650 has devpath '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1dee60 has devpath '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1df650 has devpath '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10'
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1dfe30 has devpath '/devices/pci0000:00/0000:00:01.0/0000:01:00.0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1e0600 has devpath '/devices/pci0000:00/0000:00:01.0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1e0db0 has devpath '/devices/pci0000:00'
Nov 22 05:50:15 jfd systemd-udevd[29004]: IMPORT builtin 'path_id' /lib/udev/rules.d/60-persistent-storage.rules:56
Nov 22 05:50:15 jfd systemd-udevd[29004]: device 0x7f26dc1e17c0 has devpath '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/sas_device/end_device-10:0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: LINK 'disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0' /lib/udev/rules.d/60-persistent-storage.rules:57
Nov 22 05:50:15 jfd systemd-udevd[29004]: IMPORT builtin 'blkid' /lib/udev/rules.d/60-persistent-storage.rules:71
Nov 22 05:50:15 jfd systemd-udevd[29004]: probe /dev/sdc raid offset=0
Nov 22 05:50:15 jfd systemd-udevd[29004]: LINK 'disk/by-id/wwn-0x5002538c0007e7a8' /lib/udev/rules.d/60-persistent-storage.rules:81
Nov 22 05:50:15 jfd systemd-udevd[29004]: no db file to read /run/udev/data/+scsi:10:0:0:0: No such file or directory
Nov 22 05:50:15 jfd systemd-udevd[29004]: handling device node '/dev/sdc', devnum=b8:32, mode=0600, uid=0, gid=0
Nov 22 05:50:15 jfd systemd-udevd[29004]: preserve already existing symlink '/dev/block/8:32' to '../sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: found 'b8:32' claiming '/run/udev/links/\x2fdisk\x2fby-id\x2fata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633'
Nov 22 05:50:15 jfd systemd-udevd[29004]: creating link '/dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633' to '/dev/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: preserve already existing symlink '/dev/disk/by-id/ata-SAMSUNG_MZ7KM1T9HAJM-00005_S2HNNAAH200633' to '../../sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: found 'b8:32' claiming '/run/udev/links/\x2fdisk\x2fby-id\x2fwwn-0x5002538c0007e7a8'
Nov 22 05:50:15 jfd systemd-udevd[29004]: creating link '/dev/disk/by-id/wwn-0x5002538c0007e7a8' to '/dev/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: preserve already existing symlink '/dev/disk/by-id/wwn-0x5002538c0007e7a8' to '../../sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: found 'b8:32' claiming '/run/udev/links/\x2fdisk\x2fby-path\x2fpci-0000:01:00.0-sas-0x4433221100000000-lun-0'
Nov 22 05:50:15 jfd systemd-udevd[29004]: creating link '/dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0' to '/dev/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: preserve already existing symlink '/dev/disk/by-path/pci-0000:01:00.0-sas-0x4433221100000000-lun-0' to '../../sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: created db file '/run/udev/data/b8:32' for '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: adding watch on '/dev/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: created db file '/run/udev/data/b8:32' for '/devices/pci0000:00/0000:00:01.0/0000:01:00.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc'
Nov 22 05:50:15 jfd systemd-udevd[29004]: passed -1 bytes to netlink monitor 0x7f26dc1d2470
Nov 22 05:50:15 jfd systemd-udevd[29004]: seq 5382 processed with 0
Nov 22 05:50:15 jfd ata_id[29005]: custom logging function 0x7fc30e86abd0 registered
Nov 22 05:50:18 jfd systemd-udevd[218]: cleanup idle workers
Nov 22 05:50:18 jfd systemd-udevd[218]: validate module index
Nov 22 05:50:18 jfd systemd-udevd[218]: Check if link configuration needs reloading.
Nov 22 05:50:18 jfd systemd-udevd[29004]: unload module index
Nov 22 05:50:18 jfd systemd-udevd[29004]: Unloaded link configuration context.
Nov 22 05:50:18 jfd systemd-udevd[218]: worker [29004] exit
Nov 22 05:50:18 jfd systemd-udevd[218]: worker [29004] cleaned up

Cheers,
Andy
