From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 5, 2 disk failed
Date: Tue, 25 Jan 2011 10:30:28 +1000
Message-ID: <20110125103028.2594095b@nbeee.brown>
References: <AANLkTi=17u_e24gJMQFQJiCYCUok7-fETW=__HGhJFXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=17u_e24gJMQFQJiCYCUok7-fETW=__HGhJFXg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Landstedt <daniel.landstedt@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 24 Jan 2011 22:31:34 +0100
Daniel Landstedt <daniel.landstedt@gmail.com> wrote:

> Hi, for starters, great work with the linux raid guys.
> 
> Now for the unpleasantness's
> 
> Please..
> ...help
> 
> 
> I have a raid 5 with 4 disks and 1 spare.
> 2 disks failed at the same time.
> 
> This i what happened:
> I ran mdadm --fail /dev/md0 /dev/dm-1
> 
> >From /var/log/messages:
> Jan 24 01:06:51 metafor kernel: [87838.338996] md/raid:md0: Disk
> failure on dm-1, disabling device.
> Jan 24 01:06:51 metafor kernel: [87838.338997] <1>md/raid:md0:
> Operation continuing on 3 devices.
> Jan 24 01:06:51 metafor kernel: [87838.408494] RAID conf printout:
> Jan 24 01:06:51 metafor kernel: [87838.408497]  --- level:5 rd:4 wd:3
> Jan 24 01:06:51 metafor kernel: [87838.408500]  disk 0, o:1, dev:dm-2
> Jan 24 01:06:51 metafor kernel: [87838.408503]  disk 1, o:1, dev:dm-3
> Jan 24 01:06:51 metafor kernel: [87838.408505]  disk 2, o:1, dev:sdb1
> Jan 24 01:06:51 metafor kernel: [87838.408507]  disk 3, o:0, dev:dm-1
> Jan 24 01:06:51 metafor kernel: [87838.412006] RAID conf printout:
> Jan 24 01:06:51 metafor kernel: [87838.412009]  --- level:5 rd:4 wd:3
> Jan 24 01:06:51 metafor kernel: [87838.412011]  disk 0, o:1, dev:dm-2
> Jan 24 01:06:51 metafor kernel: [87838.412013]  disk 1, o:1, dev:dm-3
> Jan 24 01:06:51 metafor kernel: [87838.412015]  disk 2, o:1, dev:sdb1
> Jan 24 01:06:51 metafor kernel: [87838.412022] RAID conf printout:
> Jan 24 01:06:51 metafor kernel: [87838.412024]  --- level:5 rd:4 wd:3
> Jan 24 01:06:51 metafor kernel: [87838.412026]  disk 0, o:1, dev:dm-2
> Jan 24 01:06:51 metafor kernel: [87838.412028]  disk 1, o:1, dev:dm-3
> Jan 24 01:06:51 metafor kernel: [87838.412030]  disk 2, o:1, dev:sdb1
> Jan 24 01:06:51 metafor kernel: [87838.412032]  disk 3, o:1, dev:sdf1
> Jan 24 01:06:51 metafor kernel: [87838.412071] md: recovery of RAID
> array md0 Jan 24 01:06:51 metafor kernel: [87838.412074] md: minimum
> _guaranteed_  speed: 1000 KB/sec/disk.
> Jan 24 01:06:51 metafor kernel: [87838.412076] md: using maximum
> available idle IO bandwidth (but not more than 200000 KB/sec) for
> recovery.
> Jan 24 01:06:51 metafor kernel: [87838.412081] md: using 128k window,
> over a total of 1953510272 blocks.
> Jan 24 01:06:52 metafor kernel: [87838.501501] ata2: EH in SWNCQ
> mode,QC:qc_active 0x21 sactive 0x21
> Jan 24 01:06:52 metafor kernel: [87838.501505] ata2: SWNCQ:qc_active
> 0x21 defer_bits 0x0 last_issue_tag 0x0
> Jan 24 01:06:52 metafor kernel: [87838.501507]   dhfis 0x20 dmafis
> 0x20 sdbfis 0x0
> Jan 24 01:06:52 metafor kernel: [87838.501510] ata2: ATA_REG 0x41
> ERR_REG 0x84 Jan 24 01:06:52 metafor kernel: [87838.501512] ata2:
> tag : dhfis dmafis sdbfis sacitve
> Jan 24 01:06:52 metafor kernel: [87838.501515] ata2: tag 0x0: 0 0 0 1
> Jan 24 01:06:52 metafor kernel: [87838.501518] ata2: tag 0x5: 1 1 0 1
> Jan 24 01:06:52 metafor kernel: [87838.501527] ata2.00: exception
> Emask 0x1 SAct 0x21 SErr 0x280000 action 0x6 frozen
> Jan 24 01:06:52 metafor kernel: [87838.501530] ata2.00: Ata error.
> fis:0x21 Jan 24 01:06:52 metafor kernel: [87838.501533] ata2: SError:
> { 10B8B BadCRC } Jan 24 01:06:52 metafor kernel: [87838.501537]
> ata2.00: failed command: READ FPDMA QUEUED
> Jan 24 01:06:52 metafor kernel: [87838.501543] ata2.00: cmd
> 60/10:00:80:24:00/00:00:00:00:00/40 tag 0 ncq 8192 in
> Jan 24 01:06:52 metafor kernel: [87838.501545]          res
> 41/84:00:80:24:00/84:00:00:00:00/40 Emask 0x10 (ATA bus error)
> Jan 24 01:06:52 metafor kernel: [87838.501548] ata2.00: status:
> { DRDY ERR } Jan 24 01:06:52 metafor kernel: [87838.501550] ata2.00:
> error: { ICRC ABRT }
> 
> The spare kicked in and started to sync, but almost at the same time
> /dev/sdb disconnected from the sata controller..
> And thus I lost 2 drives at once.
> 
> I ran mdadm -r /dev/md0 /dev/mapper/luks3
> Then i tried to readd the device with mdadm
> --add /dev/md0 /dev/mapper/luks3
> 
> After a shutdown, I disconnected and reconnected the sata cable, and
> haven't had any more problems with /dev/sdb since.
> 
> So, /dev/sdb1 and/or /dev/dm-1 _should_ have it's data intact? Right?
> 
> I Panicked and tried to assemble the device with mdadm --assemble
> --scan --force which didn't work.
> 
> Then I went to https://raid.wiki.kernel.org/index.php/RAID_Recovery
> and tried to collect my thoughts.
> 
> As suggested I ran: mdadm --examine /dev/mapper/luks[3,4,5] /dev/sdb1
> /dev/sdf1 > raid.status
> (/dev/mapper/luks[3,4,5] is the same device as /dev/dm-[1,2,3])
> 
> >From raid.status:
> /dev/mapper/luks3:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 264a224d:1e5acc54:25627026:3fb802f2
>            Name : metafor:0  (local to host metafor)
>   Creation Time : Thu Dec 30 21:06:02 2010
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3907020976 (1863.01 GiB 2000.39 GB)
>      Array Size : 11721061632 (5589.04 GiB 6001.18 GB)
>   Used Dev Size : 3907020544 (1863.01 GiB 2000.39 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : b96c7045:cedbbc01:2a1c6150:a3f59a88
> 
>     Update Time : Mon Jan 24 01:19:59 2011
>        Checksum : 45959b82 - correct
>          Events : 190990
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>    Device Role : spare
>    Array State : AA.A ('A' == active, '.' == missing)
> /dev/mapper/luks4:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 264a224d:1e5acc54:25627026:3fb802f2
>            Name : metafor:0  (local to host metafor)
>   Creation Time : Thu Dec 30 21:06:02 2010
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3907020976 (1863.01 GiB 2000.39 GB)
>      Array Size : 11721061632 (5589.04 GiB 6001.18 GB)
>   Used Dev Size : 3907020544 (1863.01 GiB 2000.39 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : b30343f4:542a2e59:b614ba85:934e31d5
> 
>     Update Time : Mon Jan 24 01:19:59 2011
>        Checksum : cdc8d27b - correct
>          Events : 190990
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>    Device Role : Active device 0
>    Array State : AA.A ('A' == active, '.' == missing)
> /dev/mapper/luks5:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 264a224d:1e5acc54:25627026:3fb802f2
>            Name : metafor:0  (local to host metafor)
>   Creation Time : Thu Dec 30 21:06:02 2010
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3907020976 (1863.01 GiB 2000.39 GB)
>      Array Size : 11721061632 (5589.04 GiB 6001.18 GB)
>   Used Dev Size : 3907020544 (1863.01 GiB 2000.39 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : active
>     Device UUID : 6e5af09b:b69ebb8c:f8725f20:cb53d033
> 
>     Update Time : Mon Jan 24 01:19:59 2011
>        Checksum : a2480112 - correct
>          Events : 190990
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>    Device Role : Active device 1
>    Array State : AA.A ('A' == active, '.' == missing)
> /dev/sdb1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x0
>      Array UUID : 264a224d:1e5acc54:25627026:3fb802f2
>            Name : metafor:0  (local to host metafor)
>   Creation Time : Thu Dec 30 21:06:02 2010
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 11721061632 (5589.04 GiB 6001.18 GB)
>   Used Dev Size : 3907020544 (1863.01 GiB 2000.39 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>           State : clean
>     Device UUID : 87288108:5cc4715a:7c50cedf:551fa3a9
> 
>     Update Time : Mon Jan 24 01:06:51 2011
>        Checksum : 11d4aacb - correct
>          Events : 190987
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>    Device Role : Active device 2
>    Array State : AAAA ('A' == active, '.' == missing)
> /dev/sdf1:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x2
>      Array UUID : 264a224d:1e5acc54:25627026:3fb802f2
>            Name : metafor:0  (local to host metafor)
>   Creation Time : Thu Dec 30 21:06:02 2010
>      Raid Level : raid5
>    Raid Devices : 4
> 
>  Avail Dev Size : 3907025072 (1863.01 GiB 2000.40 GB)
>      Array Size : 11721061632 (5589.04 GiB 6001.18 GB)
>   Used Dev Size : 3907020544 (1863.01 GiB 2000.39 GB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
> Recovery Offset : 2 sectors
>           State : active
>     Device UUID : f2e95701:07d717fb:7b57316c:92e01add
> 
>     Update Time : Mon Jan 24 01:19:59 2011
>        Checksum : 6b284a3b - correct
>          Events : 190990
> 
>          Layout : left-symmetric
>      Chunk Size : 128K
> 
>    Device Role : Active device 3
>    Array State : AA.A ('A' == active, '.' == missing)
> 
> 
> Then I tried a hole bunch of recreate commands..
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md1
> /dev/mapper/luks3 /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
> /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1 missing

When you are trying to recreate an array, you should give as many
detail to mdadm -C as you can to avoid any possible confusion.  This is
particularly import if you originally created the array with a
different version of mdadm (as defaults change) but a good idea in any
case. 
If you look at the "--examine" output that you included above you will
see all of the details you need.  You should at least specify --level,
--chunksize --metadata --layout --raid-disks.
In particular, chunksize should be 128, which has never been the
default.

The order of devices can be determined by looking at the "Device Role"
field, so it appears that it should be:
   luks4 luks5 sdb1 sdf1
unless you 'know' about a recent change, preferably verified in the
kernel logs.

If could be that simple running the same --create command, but with
--chunksize=128
will be enough to fix it for you.

NeilBrown



> lvm vgscan
> lvm vgchange -a y
> LVM reported that it found 1 new vg and 3 lvs.
> But, I couldn't mount the volumes..
> fsck.ext4 found nothing. Not with backup superblock either.
> I continued..:
> mdadm --assemble /dev/md0 /dev/mapper/luks3 /dev/mapper/luks4
> /dev/mapper/luks5 /dev/sdb1 /dev/sdf1
> mdadm
> --assemble /dev/md0 /dev/mapper/luks3 /dev/mapper/luks4 /dev/mapper/luks5
> mdadm
> --assemble /dev/md0 /dev/mapper/luks3 /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1
> mdadm
> --assemble /dev/md0 /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1
> missing Didn't work.. mdadm --create --level=5
> --raid-devices=4 /dev/md0 /dev/mapper/luks4 /dev/mapper/luks5
> missing /dev/mapper/luks3 mdadm --create --assume-clean --level=5
> --raid-devices=4 /dev/md0 /dev/mapper/luks4 /dev/mapper/luks5
> missing /dev/mapper/luks3 mdadm --create --assume-clean --level=5
> --raid-devices=4 /dev/md0 /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1
> missing Still no luck mdadm --create --assume-clean --level=5
> --raid-devices=4 /dev/md0 /dev/mapper/luks4 /dev/mapper/luks5
> missing /dev/mapper/luks3 mdadm --create --assume-clean --level=5
> --raid-devices=4 /dev/md0 /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1 /dev/mapper/luks3
> lvm vgscan
> lvm vgchange -a y
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
> missing /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
> /dev/mapper/luks3 /dev/mapper/luks4 /dev/mapper/luks5 missing
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
> /dev/sdb1 /dev/mapper/luks4 /dev/mapper/luks5 missing
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
> /dev/mapper/luks4 /dev/mapper/luks5 missing /dev/sdb1
> lvm vgscan
> lvm vgchange -a y
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
> /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1 missing
> lvm vgscan
> lvm vgchange -a y
> mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md0
> /dev/mapper/luks4 /dev/mapper/luks5 /dev/sdb1 /dev/mapper/luks3
> lvm vgscan
> lvm vgchange -a y
> 
> You get the point.
> 
> 
> So, did I screw it up when I went a bit crazy? Or do you think my raid
> can be saved?
> /dev/mapper/luks[4,5] (/dev/dm-2,3]) should be unharmed.
> Can /dev/mapper/luks3 (/dev/dm-1) or /dev/sdb1 be saved and help
> rebuild the array?
> 
> If its possible, do you have any pointers how I can go about?
> 
> 
> Thanks,
> Daniel
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

