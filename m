From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: raidreconf: Successful RAID5 Reconstruction (re-size)
Date: Wed, 26 Jun 2002 14:40:07 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAIEOKDAAA.kc130iseo@coastalnet.com>
References: <20020626180640.GC4914@unthought.net>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20020626180640.GC4914@unthought.net>
To: Jakob Oestergaard <jakob@unthought.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Jakob Oestergaard
> Sent: Wednesday, June 26, 2002 12:07 PM
> To: cwebster@ec.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: raidreconf: Successful RAID5 Reconstruction (re-size)
>
[snip]
>
> Did you fsck -f the array before re-sizing the filesystem ?

No I didn't. I saw no need to since it has been working perfectly fine
following the conversion from 2.2 to 2.4 kernel.

> What does fsck -f show on (the unmounted) filesystem now ?

I can't unmount it right now. I went ahead and ran "mkraid" to re-create the
array. I'm now restoring from backups. I was going to do that anyway, as I
indicated in my first message. Sorry, I tried to get as much data for you as
possible. I did run the "lsraid" commands prior to re-making if you want the
output from them. Let me know.

> It is also possible that you have hardware errors, bad cabling, bad
> disk, etc.  Anything suspicious in dmesg ?

I doubt that there were any kind of hardware errors. I double-checked
everything and scanned the logs after installing the new drives. There were
no problems using the array in its original configuration after installing
the new drives, but before reconfiguring. I've included RAID-related entries
from "dmesg" at the bottom of this message. This is since the last reboot
after "mkraid".

> It is really important to run fsck -f on arrays after running raidreconf
> and before re-sizing the filesystem.  For this reason - tracking of
> when/where errors occurred.  Of course, it is a little late for you to
> be told this now - sorry.  I should add this note to the raidreconf
> output after successful reconfiguration.

Yes, that might have been helpful information. I had a backup plan anyway.
I'll take this extra step next time, but I don't envision it happening
anytime soon.

There is likely some information in /var/log/messages that may be useful to
you. Would you like me to attach a "gzipped" copy of it to a reply? I'm
sorry, but I don't have time to pick through it right now to extract the
RAID info.

Thanks! :-)

--Cal Webster

################################
## Begin "dmesg" RAID entries ##
################################
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: FUJITSU   Model: MAA3182S SUN18G   Rev: 2107
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: SEAGATE   Model: ST318438LW        Rev: 0003
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST318438LW        Rev: 0003
  Type:   Direct-Access                      ANSI SCSI revision: 03
  Vendor: SEAGATE   Model: ST318438LW        Rev: 0003
  Type:   Direct-Access                      ANSI SCSI revision: 03
Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
Attached scsi disk sdb at scsi0, channel 0, id 1, lun 0
Attached scsi disk sdc at scsi0, channel 0, id 2, lun 0
Attached scsi disk sdd at scsi0, channel 0, id 3, lun 0
Attached scsi disk sde at scsi0, channel 0, id 4, lun 0
Attached scsi disk sdf at scsi0, channel 0, id 5, lun 0
Attached scsi disk sdg at scsi0, channel 0, id 6, lun 0
Attached scsi disk sdh at scsi0, channel 0, id 8, lun 0
Attached scsi disk sdi at scsi0, channel 0, id 9, lun 0
sym53c875-0-<0,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sda: 35378533 512-byte hdwr sectors (18114 MB)
 sda: sda1 sda3
sym53c875-0-<1,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdb: 35378533 512-byte hdwr sectors (18114 MB)
 sdb: sdb1 sdb3
sym53c875-0-<2,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdc: 35378533 512-byte hdwr sectors (18114 MB)
 sdc: sdc1 sdc3
sym53c875-0-<3,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdd: 35378533 512-byte hdwr sectors (18114 MB)
 sdd: sdd1 sdd3
sym53c875-0-<4,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sde: 35378533 512-byte hdwr sectors (18114 MB)
 sde: sde1 sde3
sym53c875-0-<5,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdf: 35378533 512-byte hdwr sectors (18114 MB)
 sdf: sdf1 sdf3
sym53c875-0-<6,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdg: 38914049 512-byte hdwr sectors (19924 MB)
 sdg: sdg1 sdg3
sym53c875-0-<8,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdh: 38914049 512-byte hdwr sectors (19924 MB)
 sdh: sdh1 sdh3
sym53c875-0-<9,*>: FAST-10 WIDE SCSI 20.0 MB/s (100.0 ns, offset 16)
SCSI device sdi: 38914049 512-byte hdwr sectors (19924 MB)
 sdi: sdi1 sdi3
raid5: measuring checksumming speed
   VIS       :   113.600 MB/sec
raid5: using function: VIS (113.600 MB/sec)
md: md driver 0.90.0 MAX_MD_DEVS=256, MD_SB_DISKS=27
 [events: 00000004]
 [events: 00000004]
 [events: 00000004]
 [events: 00000004]
 [events: 00000004]
 [events: 00000004]
 [events: 00000004]
 [events: 00000004]
 [events: 00000004]
md: autorun ...
md: considering sdi1 ...
md:  adding sdi1 ...
md:  adding sdh1 ...
md:  adding sdg1 ...
md:  adding sdf1 ...
md:  adding sde1 ...
md:  adding sdd1 ...
md:  adding sdc1 ...
md:  adding sdb1 ...
md:  adding sda1 ...
md: created md0
md: bind<sda1,1>
md: bind<sdb1,2>
md: bind<sdc1,3>
md: bind<sdd1,4>
md: bind<sde1,5>
md: bind<sdf1,6>
md: bind<sdg1,7>
md: bind<sdh1,8>
md: bind<sdi1,9>
md: running: <sdi1><sdh1><sdg1><sdf1><sde1><sdd1><sdc1><sdb1><sda1>
md: sdi1's event counter: 00000004
md: sdh1's event counter: 00000004
md: sdg1's event counter: 00000004
md: sdf1's event counter: 00000004
md: sde1's event counter: 00000004
md: sdd1's event counter: 00000004
md: sdc1's event counter: 00000004
md: sdb1's event counter: 00000004
md: sda1's event counter: 00000004
md: md0: raid array is not clean -- starting background reconstruction
md: raid5 personality registered as nr 4
md0: max total readahead window set to 3584k
md0: 7 data-disks, max readahead per data-disk: 512k
raid5: spare disk sdi1
raid5: device sdh1 operational as raid disk 7
raid5: device sdg1 operational as raid disk 6
raid5: device sdf1 operational as raid disk 5
raid5: device sde1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdc1 operational as raid disk 2
raid5: device sdb1 operational as raid disk 1
raid5: device sda1 operational as raid disk 0
raid5: allocated 17026kB for md0
raid5: raid level 5 set md0 active with 8 out of 8 devices, algorithm 0
raid5: raid set md0 not clean; reconstructing parity
RAID5 conf printout:
 --- rd:8 wd:8 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdh1
RAID5 conf printout:
 --- rd:8 wd:8 fd:0
 disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
 disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdc1
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
 disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
 disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdh1
md: updating md0 RAID superblock on device
md: sdi1 [events: 00000005]<6>(write) sdi1's sb offset: 17681664
md: syncing RAID array md0
md: minimum _guaranteed_ reconstruction speed: 100 KB/sec/disc.
md: using maximum available idle IO bandwith (but not more than 100000
KB/sec) f
or reconstruction.
md: using 248k window, over a total of 17681664 blocks.
md: sdh1 [events: 00000005]<6>(write) sdh1's sb offset: 17681664
md: sdg1 [events: 00000005]<6>(write) sdg1's sb offset: 17681664
md: sdf1 [events: 00000005]<6>(write) sdf1's sb offset: 17681664
md: sde1 [events: 00000005]<6>(write) sde1's sb offset: 17681664
md: sdd1 [events: 00000005]<6>(write) sdd1's sb offset: 17681664
md: sdc1 [events: 00000005]<6>(write) sdc1's sb offset: 17681664
md: sdb1 [events: 00000005]<6>(write) sdb1's sb offset: 17681664
md: sda1 [events: 00000005]<6>(write) sda1's sb offset: 17681664
md: ... autorun DONE.
raid5: switching cache buffer size, 8192 --> 1024
Journalled Block Device driver loaded
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,2), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on ide0(3,4), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
raid5: switching cache buffer size, 1024 --> 4096
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.17, 10 Jan 2002 on md(9,0), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
##############################
## End "dmesg" RAID entries ##
##############################

