From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: raid5+ lvm2 disaster
Date: Fri, 9 Jul 2004 23:38:54 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407092338.54366.maarten@ultratux.net>
References: <40EEFD38.8080805@dobbels.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40EEFD38.8080805@dobbels.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday 09 July 2004 22:16, Bernhard Dobbels wrote:
> Hi,

> I had problems with DMA timeout and with the patch mentioned in
> http://kerneltrap.org/node/view/3040 for pDC20268, which had the same
> erors in messages.
> I've checked the raid with lsraid and two disks seemed ok, although, one
> was mentioned as spare.
> I did a mkraid --really-force /dev/md0 to remake the raid, but after
> this, I cannot start it anymore.
>
> Any help or tips to recover all or part of data would be welcome
> (ofcourse no backup ;-), as data was not that important), but the wife
> still wants to see a Friends a day, which she can't do now ;(.

They say that nine months after a big power outage there invariably is a 
marked increase in births.  Maybe this would work with TV shows and / or Raid 
sets, too ?   Use this knowledge to your advantage !   ;-)

But joking aside, I'm afraid I don't know what to do at this point.  Did you 
have the DMA problems already before things broke down ?
Stating the obvious probably, I'd have tried to find out if one of the drives 
had read errors by 'cat'ting to /dev/null, so as to omit that one when 
reassembling.  But now that you've reassembled there may be little point in 
that, and besides- from the logs it seems fair to say that it was disk hde.

But since we are where we are; you could try to set faulty hdc and reassemble 
a degraded array with hde and hdg. See if that looks anything like a valid 
array, if not, repeat that with only hdc and hde (and hdg set faulty).
Don't know if this will lead to anything but it may be worth a try. 
It may be possible that not hde is really bad, but one of the others. And when 
hde went flaky due to DMA errors, it led to a two-disk failure and thus 
killed your array. If this is the case, the above scenario could work.

Good luck anyway !
Maarten

> most commands + output:
>
> tail /var/log/messages:
>
> Jul  9 14:00:43 localhost kernel: hde: dma_timer_expiry: dma status == 0x61
> Jul  9 14:00:53 localhost kernel: hde: DMA timeout error
> Jul  9 14:00:53 localhost kernel: hde: dma timeout error: status=0x51 {
> DriveReady SeekComplete Error }
> Jul  9 14:00:53 localhost kernel: hde: dma timeout error: error=0x40 {
> UncorrectableError }, LBAsect=118747579, high=7, low=1307067,
> sector=118747455
> Jul  9 14:00:53 localhost kernel: end_request: I/O error, dev hde,
> sector 118747455
> Jul  9 14:00:53 localhost kernel: md: md0: sync done.
> Jul  9 14:00:53 localhost kernel: RAID5 conf printout:
> Jul  9 14:00:53 localhost kernel:  --- rd:3 wd:1 fd:2
> Jul  9 14:00:53 localhost kernel:  disk 0, o:1, dev:hdc1
> Jul  9 14:00:53 localhost kernel:  disk 1, o:0, dev:hde1
> Jul  9 14:00:53 localhost kernel:  disk 2, o:1, dev:hdg1
> Jul  9 14:00:53 localhost kernel: RAID5 conf printout:
> Jul  9 14:00:53 localhost kernel:  --- rd:3 wd:1 fd:2
> Jul  9 14:00:53 localhost kernel:  disk 0, o:1, dev:hdc1
> Jul  9 14:00:53 localhost kernel:  disk 2, o:1, dev:hdg1
> Jul  9 14:00:53 localhost kernel: md: syncing RAID array md0
> Jul  9 14:00:53 localhost kernel: md: minimum _guaranteed_
> reconstruction speed: 1000 KB/sec/disc.
> Jul  9 14:00:53 localhost kernel: md: using maximum available idle IO
> bandwith (but not more than 200000 KB/sec) for reconstruction.
> Jul  9 14:00:53 localhost kernel: md: using 128k window, over a total of
> 195358336 blocks.
> Jul  9 14:00:53 localhost kernel: md: md0: sync done.
> Jul  9 14:00:53 localhost kernel: md: syncing RAID array md0
> Jul  9 14:00:53 localhost kernel: md: minimum _guaranteed_
> reconstruction speed: 1000 KB/sec/disc.
> Jul  9 14:00:53 localhost kernel: md: using maximum available idle IO
> bandwith (but not more than 200000 KB/sec) for reconstruction.
> Jul  9 14:00:53 localhost kernel: md: using 128k window, over a total of
> 195358336 blocks.
> Jul  9 14:00:53 localhost kernel: md: md0: sync done.
>
> + many times (per second) the same repeated.
>
>
>
> viking:/home/bernhard# lsraid -a /dev/md0 -d /dev/hdc1 -d /dev/hde1 -d
> /dev/hdg1
> [dev   9,   0] /dev/md0         829542B9.3737417C.D102FD21.18FFE273 offline
> [dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
> [dev   ?,   ?] (unknown)        00000000.00000000.00000000.00000000 missing
> [dev  34,   1] /dev/hdg1        829542B9.3737417C.D102FD21.18FFE273 good
> [dev  33,   1] /dev/hde1        829542B9.3737417C.D102FD21.18FFE273 failed
> [dev  22,   1] /dev/hdc1        829542B9.3737417C.D102FD21.18FFE273 spare
>
>
> viking:/home/bernhard# lsraid -a /dev/md0 -d /dev/hdc1 -d /dev/hde1 -d
> /dev/hdg1 -D
> [dev 22, 1] /dev/hdc1:
>          md device       = [dev 9, 0] /dev/md0
>          md uuid         = 829542B9.3737417C.D102FD21.18FFE273
>          state           = spare
>
> [dev 34, 1] /dev/hdg1:
>          md device       = [dev 9, 0] /dev/md0
>          md uuid         = 829542B9.3737417C.D102FD21.18FFE273
>          state           = good
>
> [dev 33, 1] /dev/hde1:
>          md device       = [dev 9, 0] /dev/md0
>          md uuid         = 829542B9.3737417C.D102FD21.18FFE273
>          state           = failed
>
> viking:/home/bernhard# lsraid -R -a /dev/md0 -d /dev/hdc1 -d /dev/hde1
> -d /dev/hdg1
> # This raidtab was generated by lsraid version 0.7.0.
> # It was created from a query on the following devices:
> #       /dev/md0
> #       /dev/hdc1
> #       /dev/hde1
> #       /dev/hdg1
>
> # md device [dev 9, 0] /dev/md0 queried offline
> # Authoritative device is [dev 22, 1] /dev/hdc1
> raiddev /dev/md0
>          raid-level              5
>          nr-raid-disks           3
>          nr-spare-disks          1
>          persistent-superblock   1
>          chunk-size              32
>
>          device          /dev/hdg1
>          raid-disk               2
>          device          /dev/hdc1
>          spare-disk              0
>          device          /dev/null
>          failed-disk             0
>          device          /dev/null
>          failed-disk             1
>
>
>
>
> viking:/home/bernhard# lsraid -R -p
> # This raidtab was generated by lsraid version 0.7.0.
> # It was created from a query on the following devices:
> #       /dev/hda
> #       /dev/hda1
> #       /dev/hda2
> #       /dev/hda5
> #       /dev/hdb
> #       /dev/hdb1
> #       /dev/hdc
> #       /dev/hdc1
> #       /dev/hdd
> #       /dev/hdd1
> #       /dev/hde
> #       /dev/hde1
> #       /dev/hdf
> #       /dev/hdf1
> #       /dev/hdg
> #       /dev/hdg1
> #       /dev/hdh
> #       /dev/hdh1
>
> # md device [dev 9, 0] /dev/md0 queried offline
> # Authoritative device is [dev 22, 1] /dev/hdc1
> raiddev /dev/md0
>          raid-level              5
>          nr-raid-disks           3
>          nr-spare-disks          1
>          persistent-superblock   1
>          chunk-size              32
>
>          device          /dev/hdg1
>          raid-disk               2
>          device          /dev/hdc1
>          spare-disk              0
>          device          /dev/null
>          failed-disk             0
>          device          /dev/null
>          failed-disk             1
>
> viking:/home/bernhard# cat /etc/raidtab
> raiddev /dev/md0
>          raid-level      5
>          nr-raid-disks   3
>          nr-spare-disks  0
>          persistent-superblock   1
>          parity-algorithm        left-symmetric
>
>          device  /dev/hdc1
>          raid-disk 0
>          device  /dev/hde1
>          failed-disk 1
>          device  /dev/hdg1
>          raid-disk 2
>
>
> viking:/home/bernhard# mkraid --really-force /dev/md0
> DESTROYING the contents of /dev/md0 in 5 seconds, Ctrl-C if unsure!
> handling MD device /dev/md0
> analyzing super-block
> disk 0: /dev/hdc1, 195358401kB, raid superblock at 195358336kB
> disk 1: /dev/hde1, failed
> disk 2: /dev/hdg1, 195358401kB, raid superblock at 195358336kB
> /dev/md0: Invalid argument
>
> viking:/home/bernhard# raidstart /dev/md0
> /dev/md0: Invalid argument
>
>
> viking:/home/bernhard# cat /proc/mdstat
> Personalities : [raid1] [raid5]
> md0 : inactive hdg1[2] hdc1[0]
>        390716672 blocks
> unused devices: <none>
> viking:/home/bernhard# pvscan -v
>      Wiping cache of LVM-capable devices
>      Wiping internal cache
>      Walking through all physical volumes
>    Incorrect metadata area header checksum
>    Found duplicate PV uywoDlobnH0pbnr09dYuUWqB3A5kkh8M: using /dev/hdg1
> not /dev/hdc1
>    Incorrect metadata area header checksum
>    Incorrect metadata area header checksum
>    Incorrect metadata area header checksum
>    Found duplicate PV uywoDlobnH0pbnr09dYuUWqB3A5kkh8M: using /dev/hdg1
> not /dev/hdc1
>    PV /dev/hdc1   VG data_vg   lvm2 [372,61 GB / 1,61 GB free]
>    PV /dev/hda1                lvm2 [4,01 GB]
>    Total: 2 [376,63 GB] / in use: 1 [372,61 GB] / in no VG: 1 [4,01 GB]
>
> viking:/home/bernhard# lvscan -v
>      Finding all logical volumes
>    Incorrect metadata area header checksum
>    Found duplicate PV uywoDlobnH0pbnr09dYuUWqB3A5kkh8M: using /dev/hdg1
> not /dev/hdc1
>    ACTIVE            '/dev/data_vg/movies_lv' [200,00 GB] inherit
>    ACTIVE            '/dev/data_vg/music_lv' [80,00 GB] inherit
>    ACTIVE            '/dev/data_vg/backup_lv' [50,00 GB] inherit
>    ACTIVE            '/dev/data_vg/ftp_lv' [40,00 GB] inherit
>    ACTIVE            '/dev/data_vg/www_lv' [1,00 GB] inherit
> viking:/home/bernhard# mount /dev/mapper/data_vg-ftp_lv /tmp
>
>
> Jul  9 15:54:36 localhost kernel: md: bind<hdc1>
> Jul  9 15:54:36 localhost kernel: md: bind<hdg1>
> Jul  9 15:54:36 localhost kernel: raid5: device hdg1 operational as raid
> disk 2
> Jul  9 15:54:36 localhost kernel: raid5: device hdc1 operational as raid
> disk 0
> Jul  9 15:54:36 localhost kernel: RAID5 conf printout:
> Jul  9 15:54:36 localhost kernel:  --- rd:3 wd:2 fd:1
> Jul  9 15:54:36 localhost kernel:  disk 0, o:1, dev:hdc1
> Jul  9 15:54:36 localhost kernel:  disk 2, o:1, dev:hdg1
> Jul  9 15:54:53 localhost kernel: md: raidstart(pid 1950) used
> deprecated START_ARRAY ioctl. This will not be supported beyond 2.6
> Jul  9 15:54:53 localhost kernel: md: could not import hdc1!
> Jul  9 15:54:53 localhost kernel: md: autostart unknown-block(0,5633)
> failed!
> Jul  9 15:54:53 localhost kernel: md: raidstart(pid 1950) used
> deprecated START_ARRAY ioctl. This will not be supported beyond 2.6
> Jul  9 15:54:53 localhost kernel: md: could not import hdg1, trying to
> run array nevertheless.
> Jul  9 15:54:53 localhost kernel: md: could not import hdc1, trying to
> run array nevertheless.
> Jul  9 15:54:53 localhost kernel: md: autorun ...
> Jul  9 15:54:53 localhost kernel: md: considering hde1 ...
> Jul  9 15:54:53 localhost kernel: md:  adding hde1 ...
> Jul  9 15:54:53 localhost kernel: md: md0 already running, cannot run hde1
> Jul  9 15:54:53 localhost kernel: md: export_rdev(hde1)
> Jul  9 15:54:53 localhost kernel: md: ... autorun DONE.
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

