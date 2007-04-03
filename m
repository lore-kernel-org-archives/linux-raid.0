From: linux@horizon.com
Subject: Re: 2.6.20.3 AMD64 oops in CFQ code
Date: 3 Apr 2007 09:03:34 -0400
Message-ID: <20070403130334.14799.qmail@science.horizon.com>
References: <4611EADC.3000306@suse.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4611EADC.3000306@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux@horizon.com, teheo@suse.de
Cc: cebbert@redhat.com, dan.j.williams@intel.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-kernel@dale.us, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

linux@horizon.com wrote:
>> Anyway, what's annoying is that I can't figure out how to bring the
>> drive back on line without resetting the box.  It's in a hot-swap enclosure,
>> but power cycling the drive doesn't seem to help.  I thought libata hotplug
>> was working?  (SiI3132 card, using the sil24 driver.)

> Yeah, it's working but failing resets are considered highly dangerous
> (in that the controller status is unknown and may cause something
> dangerous like screaming interrupts) and port is muted after that.  The
> plan is to handle this with polling hotplug such that libata tries to
> revive the port if PHY status change is detected by polling.  Patches
> are available but they need other things to resolved to get integrated.
> I think it'll happen before the summer.

> Anyways, you can tell libata to retry the port by manually telling it to
> rescan the port (echo - - - > /sys/class/scsi_host/hostX/scan).

Ah, thank you!  I have to admit, that is at least as mysterious as any
Microsoft registry tweak.

>> (H'm... after rebooting, reallocated sectors jumped from 26 to 39.
>> Something is up with that drive.)

> Yeap, seems like a broken drive to me.

Actually, after a few rounds, the reallocated sectors stabilized at 56
and all is working well again.  It's like there was a major problem with
error handling.

The problem is that I don't know where the blame lies.

In case it helps, here is the syslog associated with the first failure:

07:17:56: ata5.00: exception Emask 0x0 SAct 0x7fffff SErr 0x0 action 0x2 frozen
07:20:15: ata5.00: cmd 61/30:00:a2:d8:b9/00:00:1c:00:00/40 tag 0 cdb 0x0 data 24576 out
07:20:15:          res 40/00:01:00:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:15: ata5.00: cmd 60/08:08:9a:7c:b9/00:00:1c:00:00/40 tag 1 cdb 0x0 data 4096 in
07:20:15:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:15: ata5.00: cmd 60/08:10:ca:7c:b9/00:00:1c:00:00/40 tag 2 cdb 0x0 data 4096 in
07:20:15:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:15: ata5.00: cmd 60/20:18:b2:d6:b9/00:00:1c:00:00/40 tag 3 cdb 0x0 data 16384 in
07:20:15:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:15: ata5.00: cmd 61/08:20:fa:a2:b6/00:00:1c:00:00/40 tag 4 cdb 0x0 data 4096 out
07:20:15:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:15: ata5.00: cmd 60/40:28:1a:d7:b9/00:00:1c:00:00/40 tag 5 cdb 0x0 data 32768 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/00:30:d2:11:c0/01:00:24:00:00/40 tag 6 cdb 0x0 data 131072 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/28:38:2a:0b:b9/00:00:1c:00:00/40 tag 7 cdb 0x0 data 20480 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/08:40:82:7c:b9/00:00:1c:00:00/40 tag 8 cdb 0x0 data 4096 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 61/58:48:02:a3:b6/00:00:1c:00:00/40 tag 9 cdb 0x0 data 45056 out
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/10:50:52:49:ba/00:00:1c:00:00/40 tag 10 cdb 0x0 data 8192 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/08:58:6a:49:ba/00:00:1c:00:00/40 tag 11 cdb 0x0 data 4096 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/08:60:7a:49:ba/00:00:1c:00:00/40 tag 12 cdb 0x0 data 4096 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/10:68:8a:49:ba/00:00:1c:00:00/40 tag 13 cdb 0x0 data 8192 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/08:70:a2:49:ba/00:00:1c:00:00/40 tag 14 cdb 0x0 data 4096 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/08:78:ba:49:ba/00:00:1c:00:00/40 tag 15 cdb 0x0 data 4096 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/18:80:0a:b0:b8/00:00:1c:00:00/40 tag 16 cdb 0x0 data 12288 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/10:88:2a:b0:b8/00:00:1c:00:00/40 tag 17 cdb 0x0 data 8192 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/08:90:52:0a:b9/00:00:1c:00:00/40 tag 18 cdb 0x0 data 4096 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 61/40:98:d2:d6:b9/00:00:1c:00:00/40 tag 19 cdb 0x0 data 32768 out
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 61/40:a0:92:d7:b9/00:00:1c:00:00/40 tag 20 cdb 0x0 data 32768 out
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 61/50:a8:52:d8:b9/00:00:1c:00:00/40 tag 21 cdb 0x0 data 40960 out
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 61/78:b0:da:d7:b9/00:00:1c:00:00/40 tag 22 cdb 0x0 data 61440 out
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5: soft resetting port
07:20:16: ata5: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
07:20:16: ata5.00: configured for UDMA/100
07:20:16: ata5: EH complete
07:20:16: SCSI device sde: 781422768 512-byte hdwr sectors (400088 MB)
07:20:16: sde: Write Protect is off
07:20:16: sde: Mode Sense: 00 3a 00 00
07:20:16: SCSI device sde: write cache: enabled, read cache: enabled, doesn't support DPO or FUA
07:20:16: ata5.00: exception Emask 0x0 SAct 0xb0000 SErr 0x0 action 0x2 frozen
07:20:16: ata5.00: cmd 60/00:80:d2:11:c0/01:00:24:00:00/40 tag 16 cdb 0x0 data 131072 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/40:88:1a:d7:b9/00:00:1c:00:00/40 tag 17 cdb 0x0 data 32768 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5.00: cmd 60/20:98:b2:d6:b9/00:00:1c:00:00/40 tag 19 cdb 0x0 data 16384 in
07:20:16:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
07:20:16: ata5: soft resetting port
07:20:16: ata5: softreset failed (timeout)
07:20:16: ata5: softreset failed, retrying in 5 secs
07:20:16: ata5: hard resetting port
07:20:16: ata5: softreset failed (timeout)
07:20:16: ata5: follow-up softreset failed, retrying in 5 secs
07:20:16: ata5: hard resetting port
07:20:16: ata5: softreset failed (timeout)
07:20:16: ata5: reset failed, giving up
07:20:16: ata5.00: disabled
07:20:16: ata5: EH complete
07:20:16: sd 4:0:0:0: SCSI error: return code = 0x00040000
07:20:16: end_request: I/O error, dev sde, sector 481941170
07:20:16: sd 4:0:0:0: SCSI error: return code = 0x00040000
07:20:16: end_request: I/O error, dev sde, sector 481941274
07:20:16: sd 4:0:0:0: SCSI error: return code = 0x00040000
07:20:16: end_request: I/O error, dev sde, sector 616567250
07:20:16: sd 4:0:0:0: SCSI error: return code = 0x00040000
07:20:16: end_request: I/O error, dev sde, sector 779457538
07:20:16: md: super_written gets error=-5, uptodate=0
07:20:16: raid5: Disk failure on sde4, disabling device. Operation continuing on 5 devices
07:20:16: sd 4:0:0:0: SCSI error: return code = 0x00040000
07:20:16: end_request: I/O error, dev sde, sector 91795259
07:20:16: md: super_written gets error=-5, uptodate=0
07:20:16: raid10: Disk failure on sde3, disabling device.
07:20:16: ^IOperation continuing on 5 devices
07:20:16: RAID5 conf printout:
07:20:16:  --- rd:6 wd:5
07:20:16:  disk 0, o:1, dev:sda4
07:20:16:  disk 1, o:1, dev:sdb4
07:20:16:  disk 2, o:1, dev:sdc4
07:20:16:  disk 3, o:1, dev:sdd4
07:20:16:  disk 4, o:0, dev:sde4
07:20:16:  disk 5, o:1, dev:sdf4
07:20:16: RAID5 conf printout:
07:20:16:  --- rd:6 wd:5
07:20:16:  disk 0, o:1, dev:sda4
07:20:16:  disk 1, o:1, dev:sdb4
07:20:16:  disk 2, o:1, dev:sdc4
07:20:16:  disk 3, o:1, dev:sdd4
07:20:16:  disk 5, o:1, dev:sdf4
07:20:16: RAID10 conf printout:
07:20:16:  --- wd:5 rd:6
07:20:16:  disk 0, wo:0, o:1, dev:sdb3
07:20:16:  disk 1, wo:0, o:1, dev:sdc3
07:20:16:  disk 2, wo:0, o:1, dev:sdd3
07:20:16:  disk 3, wo:1, o:0, dev:sde3
07:20:16:  disk 4, wo:0, o:1, dev:sdf3
07:20:16:  disk 5, wo:0, o:1, dev:sda3
07:20:16: RAID10 conf printout:
07:20:16:  --- wd:5 rd:6
07:20:16:  disk 0, wo:0, o:1, dev:sdb3
07:20:16:  disk 1, wo:0, o:1, dev:sdc3
07:20:16:  disk 2, wo:0, o:1, dev:sdd3
07:20:16:  disk 4, wo:0, o:1, dev:sdf3
07:20:16:  disk 5, wo:0, o:1, dev:sda3

And another one while recovering.  I notice that the reset timeouts seem
to take much longer this time.  Or could the above have had similar
timeouts, but syslog was blocked by the error and didn't receive and
timestamp the messages until recovery was complete?

14:49:55: RAID5 conf printout:
14:49:55:  --- rd:6 wd:5
14:49:55:  disk 0, o:1, dev:sda4
14:49:55:  disk 1, o:1, dev:sdb4
14:49:55:  disk 2, o:1, dev:sdc4
14:49:55:  disk 3, o:1, dev:sdd4
14:49:55:  disk 4, o:1, dev:sde4
14:49:55:  disk 5, o:1, dev:sdf4
14:49:55: md: recovery of RAID array md5
14:49:55: md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
14:49:55: md: using maximum available idle IO bandwidth (but not more than 200000 KB/sec) for recovery.
14:49:55: md: using 128k window, over a total of 343831040 blocks.
14:56:13: ata5.00: exception Emask 0x0 SAct 0xff SErr 0x0 action 0x2 frozen
14:56:13: ata5.00: cmd 61/f8:00:da:d6:b9/00:00:1c:00:00/40 tag 0 cdb 0x0 data 126976 out
14:56:13:          res 40/00:01:09:4f:c2/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5.00: cmd 61/90:08:d2:2f:ba/00:00:1c:00:00/40 tag 1 cdb 0x0 data 73728 out
14:56:13:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5.00: cmd 61/70:10:62:30:ba/01:00:1c:00:00/40 tag 2 cdb 0x0 data 188416 out
14:56:13:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5.00: cmd 61/00:18:d2:31:ba/01:00:1c:00:00/40 tag 3 cdb 0x0 data 131072 out
14:56:13:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5.00: cmd 61/00:20:d2:32:ba/01:00:1c:00:00/40 tag 4 cdb 0x0 data 131072 out
14:56:13:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5.00: cmd 61/00:28:d2:33:ba/01:00:1c:00:00/40 tag 5 cdb 0x0 data 131072 out
14:56:13:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5.00: cmd 61/00:30:d2:34:ba/01:00:1c:00:00/40 tag 6 cdb 0x0 data 131072 out
14:56:13:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5.00: cmd 61/00:38:d2:35:ba/01:00:1c:00:00/40 tag 7 cdb 0x0 data 131072 out
14:56:13:          res 40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
14:56:13: ata5: soft resetting port
14:56:43: ata5: softreset failed (timeout)
14:56:43: ata5: softreset failed, retrying in 5 secs
14:56:48: ata5: hard resetting port
14:57:20: ata5: softreset failed (timeout)
14:57:20: ata5: follow-up softreset failed, retrying in 5 secs
14:57:25: ata5: hard resetting port
14:57:58: ata5: softreset failed (timeout)
14:57:58: ata5: reset failed, giving up
14:57:58: ata5.00: disabled
14:57:58: ata5: EH complete
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481965522
14:57:58: raid5: Disk failure on sde4, disabling device. Operation continuing on 5 devices
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481965266
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481965010
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481964754
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481964498
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481964130
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481963986
14:57:58: sd 4:0:0:0: SCSI error: return code = 0x00040000
14:57:58: end_request: I/O error, dev sde, sector 481941210
14:57:58: md: md5: recovery done.
14:57:58: RAID5 conf printout:
14:57:58:  --- rd:6 wd:5
14:57:58:  disk 0, o:1, dev:sda4
14:57:58:  disk 1, o:1, dev:sdb4
14:57:58:  disk 2, o:1, dev:sdc4
14:57:58:  disk 3, o:1, dev:sdd4
14:57:58:  disk 4, o:0, dev:sde4
14:57:58:  disk 5, o:1, dev:sdf4
14:57:58: RAID5 conf printout:
14:57:58:  --- rd:6 wd:5
14:57:58:  disk 0, o:1, dev:sda4
14:57:58:  disk 1, o:1, dev:sdb4
14:57:58:  disk 2, o:1, dev:sdc4
14:57:58:  disk 3, o:1, dev:sdd4
14:57:58:  disk 5, o:1, dev:sdf4
