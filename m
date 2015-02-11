From: Kyle Logue <teque5@gmail.com>
Subject: Re: Wierd: Degrading while recovering raid5
Date: Wed, 11 Feb 2015 01:23:58 -0500
Message-ID: <CAP7a4URzYsvw9aEd117FAs9_AE4fk1FuHQAmQQqreb3Y1yvOdg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil:

For a while I really thought that was going to work. I swapped out the
sata cable and set the timeout to 10 minutes. At about 70% rebuilt I
got the following dmesg which seems to indicate the death of my sdc
drive.

Here is my question: I still have this sde that I manually failed and
hasn't been touched. Can i force re-add it to the array and just take
the data corruption hit?

I'd rather have to revert part of my data than all of it. The drive
counts are significantly different now, but I haven't mounted the
drives since the beginning. I haven't tried it but I saw someone else
online get a message like 'raid has failed so using --add cannot work
and might destroy data'. Is there a force add? What are my chances?

The dmesg in question. I started rebuilding at 20:24.

[Tue Feb 10 20:23:59 2015] md: md0 stopped.
[Tue Feb 10 20:23:59 2015] md: unbind<sdf1>
[Tue Feb 10 20:23:59 2015] md: export_rdev(sdf1)
[Tue Feb 10 20:23:59 2015] md: unbind<sde1>
[Tue Feb 10 20:23:59 2015] md: export_rdev(sde1)
[Tue Feb 10 20:23:59 2015] md: unbind<sdd1>
[Tue Feb 10 20:23:59 2015] md: export_rdev(sdd1)
[Tue Feb 10 20:23:59 2015] md: unbind<sdc1>
[Tue Feb 10 20:23:59 2015] md: export_rdev(sdc1)
[Tue Feb 10 20:23:59 2015] md: unbind<sdb1>
[Tue Feb 10 20:23:59 2015] md: export_rdev(sdb1)
[Tue Feb 10 20:23:59 2015] md: unbind<sda1>
[Tue Feb 10 20:23:59 2015] md: export_rdev(sda1)
[Tue Feb 10 20:24:59 2015] md: md0 stopped.
[Tue Feb 10 20:24:59 2015] md: bind<sdd1>
[Tue Feb 10 20:24:59 2015] md: bind<sde1>
[Tue Feb 10 20:24:59 2015] md: bind<sdf1>
[Tue Feb 10 20:24:59 2015] md: bind<sdb1>
[Tue Feb 10 20:24:59 2015] md: bind<sda1>
[Tue Feb 10 20:24:59 2015] md: bind<sdc1>
[Tue Feb 10 20:24:59 2015] md: kicking non-fresh sde1 from array!
[Tue Feb 10 20:24:59 2015] md: unbind<sde1>
[Tue Feb 10 20:24:59 2015] md: export_rdev(sde1)
[Tue Feb 10 20:24:59 2015] md/raid:md0: device sdc1 operational as raid disk 0
[Tue Feb 10 20:24:59 2015] md/raid:md0: device sdb1 operational as raid disk 4
[Tue Feb 10 20:24:59 2015] md/raid:md0: device sdf1 operational as raid disk 3
[Tue Feb 10 20:24:59 2015] md/raid:md0: device sdd1 operational as raid disk 1
[Tue Feb 10 20:24:59 2015] md/raid:md0: allocated 0kB
[Tue Feb 10 20:24:59 2015] md/raid:md0: raid level 5 active with 4 out
of 5 devices, algorithm 2
[Tue Feb 10 20:24:59 2015] RAID conf printout:
[Tue Feb 10 20:24:59 2015]  --- level:5 rd:5 wd:4
[Tue Feb 10 20:24:59 2015]  disk 0, o:1, dev:sdc1
[Tue Feb 10 20:24:59 2015]  disk 1, o:1, dev:sdd1
[Tue Feb 10 20:24:59 2015]  disk 3, o:1, dev:sdf1
[Tue Feb 10 20:24:59 2015]  disk 4, o:1, dev:sdb1
[Tue Feb 10 20:24:59 2015] md0: Warning: Device sda1 is misaligned
[Tue Feb 10 20:24:59 2015] md0: Warning: Device sdb1 is misaligned
[Tue Feb 10 20:24:59 2015] md0: Warning: Device sdb1 is misaligned
[Tue Feb 10 20:24:59 2015] md0: detected capacity change from 0 to 8001584889856
[Tue Feb 10 20:24:59 2015] RAID conf printout:
[Tue Feb 10 20:24:59 2015]  --- level:5 rd:5 wd:4
[Tue Feb 10 20:24:59 2015]  disk 0, o:1, dev:sdc1
[Tue Feb 10 20:24:59 2015]  disk 1, o:1, dev:sdd1
[Tue Feb 10 20:24:59 2015]  disk 2, o:1, dev:sda1
[Tue Feb 10 20:24:59 2015]  disk 3, o:1, dev:sdf1
[Tue Feb 10 20:24:59 2015]  disk 4, o:1, dev:sdb1
[Tue Feb 10 20:24:59 2015] md: recovery of RAID array md0
[Tue Feb 10 20:24:59 2015] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
[Tue Feb 10 20:24:59 2015] md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for recovery.
[Tue Feb 10 20:24:59 2015] md: using 128k window, over a total of 1953511936k.
[Tue Feb 10 20:24:59 2015]  md0: unknown partition table
[Tue Feb 10 20:35:34 2015] perf samples too long (2505 > 2500),
lowering kernel.perf_event_max_sample_rate to 50000
[Wed Feb 11 01:02:15 2015] ata5.00: exception Emask 0x0 SAct 0x30 SErr
0x0 action 0x0
[Wed Feb 11 01:02:15 2015] ata5.00: irq_stat 0x40000008
[Wed Feb 11 01:02:15 2015] ata5.00: failed command: READ FPDMA QUEUED
[Wed Feb 11 01:02:15 2015] ata5.00: cmd
60/00:20:18:1d:1c/04:00:a4:00:00/40 tag 4 ncq 524288 in
[Wed Feb 11 01:02:15 2015]          res
41/40:00:e8:1d:1c/00:04:a4:00:00/00 Emask 0x409 (media error) <F>
[Wed Feb 11 01:02:15 2015] ata5.00: status: { DRDY ERR }
[Wed Feb 11 01:02:15 2015] ata5.00: error: { UNC }
[Wed Feb 11 01:02:15 2015] ata5.00: configured for UDMA/133
[Wed Feb 11 01:02:15 2015] sd 4:0:0:0: [sdc] Unhandled sense code
[Wed Feb 11 01:02:15 2015] sd 4:0:0:0: [sdc]
[Wed Feb 11 01:02:15 2015] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[Wed Feb 11 01:02:15 2015] sd 4:0:0:0: [sdc]
[Wed Feb 11 01:02:15 2015] Sense Key : Medium Error [current] [descriptor]
[Wed Feb 11 01:02:15 2015] Descriptor sense data with sense
descriptors (in hex):
[Wed Feb 11 01:02:15 2015]         72 03 11 04 00 00 00 0c 00 0a 80 00
00 00 00 00
[Wed Feb 11 01:02:15 2015]         a4 1c 1d e8
[Wed Feb 11 01:02:15 2015] sd 4:0:0:0: [sdc]
[Wed Feb 11 01:02:15 2015] Add. Sense: Unrecovered read error - auto
reallocate failed
[Wed Feb 11 01:02:15 2015] sd 4:0:0:0: [sdc] CDB:
[Wed Feb 11 01:02:15 2015] Read(10): 28 00 a4 1c 1d 18 00 04 00 00
[Wed Feb 11 01:02:15 2015] end_request: I/O error, dev sdc, sector 2753306088
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304040 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304048 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304056 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304064 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304072 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304080 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304088 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304096 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304104 on sdc1).
[Wed Feb 11 01:02:15 2015] md/raid:md0: read error not correctable
(sector 2753304112 on sdc1).
[Wed Feb 11 01:02:15 2015] ata5: EH complete
[Wed Feb 11 01:02:18 2015] ata5.00: exception Emask 0x0 SAct 0xff80
SErr 0x0 action 0x0
[Wed Feb 11 01:02:18 2015] ata5.00: irq_stat 0x40000008
[Wed Feb 11 01:02:18 2015] ata5.00: failed command: READ FPDMA QUEUED
[Wed Feb 11 01:02:18 2015] ata5.00: cmd
60/80:38:e8:1d:1c/00:00:a4:00:00/40 tag 7 ncq 65536 in
[Wed Feb 11 01:02:18 2015]          res
41/40:80:e8:1d:1c/00:00:a4:00:00/00 Emask 0x409 (media error) <F>
[Wed Feb 11 01:02:18 2015] ata5.00: status: { DRDY ERR }
[Wed Feb 11 01:02:18 2015] ata5.00: error: { UNC }
[Wed Feb 11 01:02:18 2015] ata5.00: configured for UDMA/133
[Wed Feb 11 01:02:18 2015] sd 4:0:0:0: [sdc] Unhandled sense code
[Wed Feb 11 01:02:18 2015] sd 4:0:0:0: [sdc]
[Wed Feb 11 01:02:18 2015] Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
[Wed Feb 11 01:02:18 2015] sd 4:0:0:0: [sdc]
[Wed Feb 11 01:02:18 2015] Sense Key : Medium Error [current] [descriptor]
[Wed Feb 11 01:02:18 2015] Descriptor sense data with sense
descriptors (in hex):
[Wed Feb 11 01:02:18 2015]         72 03 11 04 00 00 00 0c 00 0a 80 00
00 00 00 00
[Wed Feb 11 01:02:18 2015]         a4 1c 1d e8
[Wed Feb 11 01:02:18 2015] sd 4:0:0:0: [sdc]
[Wed Feb 11 01:02:18 2015] Add. Sense: Unrecovered read error - auto
reallocate failed
[Wed Feb 11 01:02:18 2015] sd 4:0:0:0: [sdc] CDB:
[Wed Feb 11 01:02:18 2015] Read(10): 28 00 a4 1c 1d e8 00 00 80 00
[Wed Feb 11 01:02:18 2015] end_request: I/O error, dev sdc, sector 2753306088
[Wed Feb 11 01:02:18 2015] md/raid:md0: Disk failure on sdc1, disabling device.
[Wed Feb 11 01:02:18 2015] md/raid:md0: Operation continuing on 3 devices.
[Wed Feb 11 01:02:18 2015] ata5: EH complete
[Wed Feb 11 01:02:18 2015] md: md0: recovery interrupted.
[Wed Feb 11 01:02:18 2015] RAID conf printout:
[Wed Feb 11 01:02:18 2015]  --- level:5 rd:5 wd:3
[Wed Feb 11 01:02:18 2015]  disk 0, o:0, dev:sdc1
[Wed Feb 11 01:02:18 2015]  disk 1, o:1, dev:sdd1
[Wed Feb 11 01:02:18 2015]  disk 2, o:1, dev:sda1
[Wed Feb 11 01:02:18 2015]  disk 3, o:1, dev:sdf1
[Wed Feb 11 01:02:18 2015]  disk 4, o:1, dev:sdb1
[Wed Feb 11 01:02:18 2015] RAID conf printout:
[Wed Feb 11 01:02:18 2015]  --- level:5 rd:5 wd:3
[Wed Feb 11 01:02:18 2015]  disk 1, o:1, dev:sdd1
[Wed Feb 11 01:02:18 2015]  disk 2, o:1, dev:sda1
[Wed Feb 11 01:02:18 2015]  disk 3, o:1, dev:sdf1
[Wed Feb 11 01:02:18 2015]  disk 4, o:1, dev:sdb1
[Wed Feb 11 01:02:18 2015] RAID conf printout:
[Wed Feb 11 01:02:18 2015]  --- level:5 rd:5 wd:3
[Wed Feb 11 01:02:18 2015]  disk 1, o:1, dev:sdd1
[Wed Feb 11 01:02:18 2015]  disk 2, o:1, dev:sda1
[Wed Feb 11 01:02:18 2015]  disk 3, o:1, dev:sdf1
[Wed Feb 11 01:02:18 2015]  disk 4, o:1, dev:sdb1
[Wed Feb 11 01:02:18 2015] RAID conf printout:
[Wed Feb 11 01:02:18 2015]  --- level:5 rd:5 wd:3
[Wed Feb 11 01:02:18 2015]  disk 1, o:1, dev:sdd1
[Wed Feb 11 01:02:18 2015]  disk 3, o:1, dev:sdf1
[Wed Feb 11 01:02:18 2015]  disk 4, o:1, dev:sdb1

Thanks again,

Kyle L

On Tue, Feb 10, 2015 at 9:14 PM, Phil Turmel <philip@turmel.org> wrote:
>
> Hi Kyle,
>
> { Convention on kernel.org lists is reply-to-all, trim replies, and
> either bottom post or interleave }
>
> On 02/10/2015 04:50 PM, Kyle Logue wrote:
> > Phil:
> >
> > Thanks for your detailed response. That link does seem to describe my
> > problem and I do understand that desktop grade drives are sub-optimal.
> > It was many years ago when I first set up this array on my home
> > theater pc.  Until now I had no idea about the cron job - I'll make
> > sure to implement that. I am preparing to move to 6 tb disks sometime
> > soon and i'll definitely go enterprise this time.
> >
> > Regarding the drive timeout: I understand that I need to increase it
> > from 30 seconds to something larger (2+ min) but am unaware how to do
> > this. Is it a kernel variable? I'll keep googling but this seems like
> > it's whats going to save me.
> >
> > tl;dr: How do I change the drive timeout?
>
> Put something like this in /etc/rc.local or wherever your distro suggests:
>
> for x in /sys/block/sd[a-f]/device/timeout ; do
>   echo 180 > $x
> done
>
> Where the [a-f] is adjusted to suit your needs, and only for non-raid
> non-scterc drives.
>
> Phil
