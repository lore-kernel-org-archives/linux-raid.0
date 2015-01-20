From: "Graham Mitchell" <gmitch@woodlea.com>
Subject: RE: RAID 6 recovery issue
Date: Tue, 20 Jan 2015 13:32:46 -0500
Message-ID: <010101d034df$7de0a4d0$79a1ee70$@woodlea.com>
References: <00b101d034d0$ad7dd050$087970f0$@woodlea.com> <20150120215202.27bf1c8f@natsu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150120215202.27bf1c8f@natsu>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'Roman Mamedov' <rm@romanrm.net>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> 	to add some mystery and suspense to the situation? :)

Sorry, didn't want to make it too easy... :) It's been a long couple of
days...

Dmesg says nothing of interest at all

[root@file00bert log]# dmesg | grep sde
 sde: sde1
md: bind<sde1>


/var/log/messages says something more, but not too much

[root@file00bert log]# cat messages-20150118 | grep sde
Jan 17 20:29:19 file00bert kernel: md: export_rdev(sde1)
Jan 17 20:29:19 file00bert kernel: md: bind<sde1>
Jan 17 22:35:24 file00bert kernel: md: unbind<sde1>
Jan 17 22:35:24 file00bert kernel: md: export_rdev(sde1)
Jan 17 23:03:05 file00bert kernel: sde: sde1
Jan 17 23:03:05 file00bert kernel: md: bind<sde1>


Not quite sure why md decided to unbind sde1...


Around that point in the messages file, I see this...

Jan 17 20:24:42 file00bert kernel: sdp:
Jan 17 20:27:57 file00bert kernel: sds:
Jan 17 20:29:19 file00bert kernel: md: export_rdev(sde1)
Jan 17 20:29:19 file00bert kernel: md: bind<sde1>
Jan 17 20:29:19 file00bert kernel: md: recovery of RAID array md0
Jan 17 20:29:19 file00bert kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Jan 17 20:29:19 file00bert kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for recovery.
Jan 17 20:29:19 file00bert kernel: md: using 128k window, over a total of
488383488k.
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Synchronizing SCSI
cache
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Unhandled error code
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] CDB: Read(10): 28 00
00 5f 42 3f 00 00 e8 00
Jan 17 20:30:34 file00bert kernel: __ratelimit: 182 callbacks suppressed
Jan 17 20:30:34 file00bert kernel: md/raid:md0: Disk failure on sdo1,
disabling device.
Jan 17 20:30:34 file00bert kernel: md/raid:md0: Operation continuing on 14
devices.
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242896 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242904 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242912 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242920 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242928 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242936 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242944 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242952 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242960 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242968 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242976 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242984 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242992 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243000 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243008 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243016 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243024 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243032 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243040 on sdo1).
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Unhandled error code
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] CDB: Read(10): 28 00
00 5f 43 27 00 00 18 00
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243048 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243056 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243064 on sdo1).
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Unhandled error code
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] CDB: Read(10): 28 00
00 5f 43 3f 00 01 00 00
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243072 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243080 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243088 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243096 on sdo1).
Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6243104 on sdo1).

It goes on for a bit, then I get this...

Jan 17 20:30:34 file00bert kernel: md/raid:md0: read error not correctable
(sector 6242808 on sdo1).
Jan 17 20:30:34 file00bert kernel: sd 0:0:14:0: [sdo] Result:
hostbyte=DID_NO_CONNECT driverbyte=DRIVER_OK
Jan 17 20:30:34 file00bert kernel: mpt2sas0: removing handle(0x0018),
sas_addr(0x5001517e3b0af0ae)
Jan 17 20:30:34 file00bert kernel: md: md0: recovery done.
Jan 17 20:30:34 file00bert kernel: md: unbind<sdo1>
Jan 17 20:30:34 file00bert kernel: md: export_rdev(sdo1)
Jan 17 20:30:36 file00bert kernel: scsi 0:0:178:0: Direct-Access     ATA
ST3500630AS      K    PQ: 0 ANSI: 6
Jan 17 20:30:36 file00bert kernel: scsi 0:0:178:0: SATA: handle(0x0018),
sas_addr(0x5001517e3b0af0ae), phy(14), device_name(0x0000000000000000)
Jan 17 20:30:36 file00bert kernel: scsi 0:0:178:0: SATA:
enclosure_logical_id(0x5001517e3b0af0bf), slot(14)
Jan 17 20:30:36 file00bert kernel: scsi 0:0:178:0: atapi(n), ncq(y),
asyn_notify(n), smart(y), fua(y), sw_preserve(y)
Jan 17 20:30:36 file00bert kernel: scsi 0:0:178:0: qdepth(32), tagged(1),
simple(1), ordered(0), scsi_level(7), cmd_que(1)
Jan 17 20:30:36 file00bert kernel: sd 0:0:178:0: Attached scsi generic sg14
type 0
Jan 17 20:30:36 file00bert kernel: sd 0:0:178:0: [sdo] 976773168 512-byte
logical blocks: (500 GB/465 GiB)
Jan 17 20:30:36 file00bert kernel: sd 0:0:178:0: [sdo] Write Protect is off
Jan 17 20:30:36 file00bert kernel: sd 0:0:178:0: [sdo] Write cache: enabled,
read cache: enabled, supports DPO and FUA
Jan 17 20:30:36 file00bert kernel: sdo: sdo1
Jan 17 20:30:36 file00bert kernel: sd 0:0:178:0: [sdo] Attached SCSI disk
Jan 17 20:32:13 file00bert kernel: md: requested-resync of RAID array md0
Jan 17 20:32:13 file00bert kernel: md: minimum _guaranteed_  speed: 1000
KB/sec/disk.
Jan 17 20:32:13 file00bert kernel: md: using maximum available idle IO
bandwidth (but not more than 200000 KB/sec) for requested-resync.
Jan 17 20:32:13 file00bert kernel: md: using 128k window, over a total of
488383488k.
Jan 17 20:32:13 file00bert kernel: md: md0: requested-resync done.
Jan 17 20:38:27 file00bert kernel: [drm] nouveau 0000:05:03.0: Load detected
on output A
Jan 17 21:13:33 file00bert kernel: [drm] nouveau 0000:05:03.0: Setting dpms
mode 3 on vga encoder (output 0)
Jan 17 21:24:43 file00bert kernel: [drm] nouveau 0000:05:03.0: Setting dpms
mode 0 on vga encoder (output 0)
Jan 17 21:54:49 file00bert kernel: [drm] nouveau 0000:05:03.0: Setting dpms
mode 3 on vga encoder (output 0)
Jan 17 22:24:43 file00bert kernel: [drm] nouveau 0000:05:03.0: Setting dpms
mode 0 on vga encoder (output 0)
Jan 17 22:35:24 file00bert kernel: md: unbind<sde1>
Jan 17 22:35:24 file00bert kernel: md: export_rdev(sde1)
Jan 17 22:40:00 file00bert kernel: EXT4-fs error (device md0):
__ext4_get_inode_loc: unable to read inode block - inode=1041409,
block=1066401824
Jan 17 22:40:01 file00bert kernel: Buffer I/O error on device md0, logical
block 0
Jan 17 22:40:01 file00bert kernel: lost page write due to I/O error on md0
Jan 17 22:40:05 file00bert kernel: Aborting journal on device md0-8.
Jan 17 22:40:05 file00bert kernel: Buffer I/O error on device md0, logical
block 793280512
Jan 17 22:40:05 file00bert kernel: lost page write due to I/O error on md0
Jan 17 22:40:05 file00bert kernel: JBD2: I/O error detected when updating
journal superblock for md0-8.
Jan 17 22:40:17 file00bert kernel: EXT4-fs error (device md0):
ext4_journal_start_sb: Detected aborted journal
Jan 17 22:40:17 file00bert kernel: EXT4-fs (md0): Remounting filesystem
read-only
Jan 17 22:40:17 file00bert kernel: EXT4-fs error (device md0):
__ext4_get_inode_loc: unable to read inode block - inode=384003,
block=393216032


-----Original Message-----
From: Roman Mamedov [mailto:rm@romanrm.net] 
Sent: Tuesday, January 20, 2015 11:52 AM
To: Graham Mitchell
Cc: linux-raid
Subject: Re: RAID 6 recovery issue

On Tue, 20 Jan 2015 11:46:45 -0500
"Graham Mitchell" <gmitch@woodlea.com> wrote:

> but for some reason it is now marked as a spare.
      ^^^^^^^^^^^^^^^

And you are not looking into 'dmesg' to find out why on purpose, to add some
mystery and suspense to the situation? :)

--
With respect,
Roman

