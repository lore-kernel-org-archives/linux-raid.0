From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 20:35:28 -0500
Message-ID: <4BB2A6E0.5010504@gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jim Duchek wrote:
> Hi all.  Regularly after a large write to the disk (untarring a very
> large file, etc), my RAID5 will 'freeze' for a period of time --
> perhaps around a minute.  My system is completely responsive otherwise
> during this time, with the exception of anything that is attempting to
> read or write from the array -- it's as if any file descriptors simply
> block.  Nothing disk/raid-related is written to the logs during this
> time.  The array is mounted as /home -- so an awful lot of things
> completely freeze during this time (web browser, any video that is
> running, etc).  The disks don't seem to be actually accessed during
> this time (I can't hear them, and the disk access light stays off),
> and it's not as if it's just reading slowly -- it's not reading at
> all.   Array performance is completely normal before and after the
> freeze and simply non-existent during it.  The root disk (which is on
> a seperate disk entirely from the RAID) runs fine during this time, as
> does everything else (network, video card, etc -- as long it doesn't
> touch the array) -- for example, a Terminal window open is still
> responsive during the freeze, and 'ls /' would work fine, while 'ls
> /home' would block until the 'freeze' is over.
> 
> Some more detailed information on my setup attached.  It's pretty
> vanilla.  Unfortunately this started around the time four things
> happened -- a kernel upgrade to 2.6.32, upgrading my filesystems to
> ext4, replacing a disk gone bad in the RAID, and a video card change.
> I would assume one of these is the culprit, but you know what they say
> about 'assume'.  I cannot reproduce the problem reliably, but it
> happens a couple times a day.  My questions are these:
> 
> 1. Is there any way to turn on more detailed logging for the RAID
> system in the kernel?  The wiki or a google search makes no mention I
> can find, and mdadm doesn't put anything out during this time.
> 2. Possibly a problem with the SATA system?  My root drive is PATA --
> my RAID disks are all SATA.
> 2. Uh, any other ideas? :)
> 
> 
> Thanks, all.
> 
> Jim Duchek
> 
> 
> 
> 
> 
> [jrduchek@jimbob ~]$ uname -a
> Linux jimbob 2.6.32-ARCH #1 SMP PREEMPT Mon Mar 15 20:44:03 CET 2010
> x86_64 Intel(R) Core(TM)2 Quad CPU Q8400 @ 2.66GHz GenuineIntel
> GNU/Linux
> 
> [jrduchek@jimbob ~]$ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdb1[0] sde1[3] sdd1[2] sdc1[1]
>       1465151808 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> unused devices: <none>
> 
> 
> [jrduchek@jimbob ~]$ mount
> /dev/sda3 on / type ext4 (rw,noatime,user_xattr)
> udev on /dev type tmpfs (rw,nosuid,relatime,size=10240k,mode=755)
> none on /proc type proc (rw,relatime)
> none on /sys type sysfs (rw,relatime)
> none on /dev/pts type devpts (rw)
> none on /dev/shm type tmpfs (rw)
> /dev/sda1 on /boot type ext2 (rw)
> /dev/md0 on /home type ext4 (rw,noatime,user_xattr)
> 
> [jrduchek@jimbob ~]$ more /etc/rc.local
> #!/bin/bash
> #
> # /etc/rc.local: Local multi-user startup script.
> #
> 
> echo 8192 > /sys/block/md0/md/stripe_cache_size
> blockdev --setra 32768 /dev/md0
> blockdev --setfra 32768 /dev/md0
> 
> 
> 
> dmesg (relevant):
> 
> 
> 
> 
> ata3: SATA max UDMA/133 cmd 0xc400 ctl 0xc080 bmdma 0xb880 irq 19
> ata4: SATA max UDMA/133 cmd 0xc000 ctl 0xbc00 bmdma 0xb888 irq 19
> ata3.00: ATA-7: WDC WD5000AAJS-22TKA0, 12.01C01, max UDMA/133
> ata3.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata3.01: ATA-8: WDC WD5002ABYS-02B1B0, 02.03B03, max UDMA/133
> ata3.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata3.00: configured for UDMA/133
> ata3.01: configured for UDMA/133
> ata4.00: ATA-7: WDC WD5000AAJS-22TKA0, 12.01C01, max UDMA/133
> ata4.00: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata4.01: ATA-7: WDC WD5000AAJS-22TKA0, 12.01C01, max UDMA/133
> ata4.01: 976773168 sectors, multi 16: LBA48 NCQ (depth 0/32)
> ata4.00: configured for UDMA/133
> ata4.01: configured for UDMA/133
> ata1.00: ATA-7: MAXTOR STM3160815A, 3.AAD, max UDMA/100
> ata1.00: 312581808 sectors, multi 16: LBA48
> ata1.01: ATAPI: LITE-ON DVDRW LH-20A1P, KL0G, max UDMA/66
> ata1.00: configured for UDMA/100
> ata1.01: configured for UDMA/66
> scsi 0:0:0:0: Direct-Access     ATA      MAXTOR STM316081 3.AA PQ: 0 ANSI: 5
> scsi 0:0:1:0: CD-ROM            LITE-ON  DVDRW LH-20A1P   KL0G PQ: 0 ANSI: 5
> scsi 2:0:0:0: Direct-Access     ATA      WDC WD5000AAJS-2 12.0 PQ: 0 ANSI: 5
> scsi 2:0:1:0: Direct-Access     ATA      WDC WD5002ABYS-0 02.0 PQ: 0 ANSI: 5
> scsi 3:0:0:0: Direct-Access     ATA      WDC WD5000AAJS-2 12.0 PQ: 0 ANSI: 5
> scsi 3:0:1:0: Direct-Access     ATA      WDC WD5000AAJS-2 12.0 PQ: 0 ANSI: 5
> sd 2:0:0:0: [sdb] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> sd 2:0:1:0: [sdc] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> sd 0:0:0:0: [sda] 312581808 512-byte logical blocks: (160 GB/149 GiB)
> sd 3:0:0:0: [sdd] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> sd 0:0:0:0: [sda] Write Protect is off
> sd 0:0:0:0: [sda] Mode Sense: 00 3a 00 00
> sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 3:0:0:0: [sdd] Write Protect is off
> sd 3:0:0:0: [sdd] Mode Sense: 00 3a 00 00
> sd 3:0:0:0: [sdd] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
> sd 2:0:0:0: [sdb] Write Protect is off
> sd 2:0:0:0: [sdb] Mode Sense: 00 3a 00 00
> sd 2:0:0:0: [sdb] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sdd:
>  sda:
>  sdb:
> sd 2:0:1:0: [sdc] Write Protect is off
> sd 2:0:1:0: [sdc] Mode Sense: 00 3a 00 00
> sd 2:0:1:0: [sdc] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sdc: sdb1
>  sdd1
> sd 3:0:0:0: [sdd] Attached SCSI disk
> sd 3:0:1:0: [sde] 976773168 512-byte logical blocks: (500 GB/465 GiB)
> sd 3:0:1:0: [sde] Write Protect is off
> sd 3:0:1:0: [sde] Mode Sense: 00 3a 00 00
> sd 3:0:1:0: [sde] Write cache: enabled, read cache: enabled, doesn't
> support DPO or FUA
>  sde: sde1
> sd 3:0:1:0: [sde] Attached SCSI disk
>  sda1 sda2 sda3
>  sdc1
> sd 0:0:0:0: [sda] Attached SCSI disk
> 
> sd 2:0:0:0: [sdb] Attached SCSI disk
> sd 2:0:1:0: [sdc] Attached SCSI disk
> 
> md: md0 stopped.
> md: bind<sdc1>
> md: bind<sdd1>
> md: bind<sde1>
> md: bind<sdb1>
> async_tx: api initialized (async)
> xor: automatically using best checksumming function: generic_sse
>    generic_sse:  7597.200 MB/sec
> xor: using function: generic_sse (7597.200 MB/sec)
> raid6: int64x1   1567 MB/s
> raid6: int64x2   1994 MB/s
> raid6: int64x4   1582 MB/s
> raid6: int64x8   1427 MB/s
> raid6: sse2x1    3698 MB/s
> raid6: sse2x2    4184 MB/s
> raid6: sse2x4    5888 MB/s
> raid6: using algorithm sse2x4 (5888 MB/s)
> md: raid6 personality registered for level 6
> md: raid5 personality registered for level 5
> md: raid4 personality registered for level 4
> raid5: device sdb1 operational as raid disk 0
> raid5: device sde1 operational as raid disk 3
> raid5: device sdd1 operational as raid disk 2
> raid5: device sdc1 operational as raid disk 1
> raid5: allocated 4272kB for md0
> 0: w=1 pa=0 pr=4 m=1 a=2 r=4 op1=0 op2=0
> 3: w=2 pa=0 pr=4 m=1 a=2 r=4 op1=0 op2=0
> 2: w=3 pa=0 pr=4 m=1 a=2 r=4 op1=0 op2=0
> 1: w=4 pa=0 pr=4 m=1 a=2 r=4 op1=0 op2=0
> raid5: raid level 5 set md0 active with 4 out of 4 devices, algorithm 2
> RAID5 conf printout:
>  --- rd:4 wd:4
>  disk 0, o:1, dev:sdb1
>  disk 1, o:1, dev:sdc1
>  disk 2, o:1, dev:sdd1
>  disk 3, o:1, dev:sde1
> md0: detected capacity change from 0 to 1500315451392
>  md0: unknown partition table
> EXT4-fs (md0): mounted filesystem with ordered data mode
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

In /etc/sysctl.conf or with "sysctl -a|grep vm.dirty" check these two 
settings:
vm.dirty_background_ratio 5
vm.dirty_ratio = 6

Default will be something like 40 for the second one and 10 for the 
first on.

40% is how much memory the kernel lets get dirty with write data, 10% 
or whatever the bottom number is, is once it starts cleaning it up how 
low it has to go before letting anyone else write again (ie freeze all 
writes and massively slow down reads)

I set the values to the above, in older kernels 5 is the min value, 
newer ones may allow lower, I don't believe it is well documented what 
the limits are, and if you set it lower the older kernels silently set 
the value to the min internally in the kernel, you won't see it on 
sysctl -a check.   So on my machine I could freeze for how long it 
takes to write 1% of memory out to disk, which with 8GB is 81MB which 
takes at most a second or 2 at 60mb/second or so.  If you have 8G and 
have the difference between the two set to 10% it can take 10+ 
seconds, I don't remember the default, but the large it is the bigger 
the freeze will be.

And these depends on the underlying disk speed, if the underlying disk 
is slower the time it takes to write out that amount of data is larger 
and things are uglier, and file copies do a good job of causing this.
