From: Andreas Kahnt <aka@aka.coware.de>
Subject: Reduce Timeout on Disk Failure
Date: Tue, 29 Apr 2003 13:04:11 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0304291208100.31701-100000@aka.coware.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

we've raid5 configured and removed one disk. The system hangs over one =
minute
on io (try to copy a big file, cp is in 'uninterruptible sleep') before
continuing in degraded mode. Lots of scsi errors occurred while pending
(kernel 2.4.19). Is it possible to reduce this dead time? Where is it
controlled that md recognizes disk failure at 17:37:09 but remove sde1 =
at
17:38:23, over one minute later?

I did a look into the md.c and other sources/includes, found the printk=
()
messages but I'm not familiar with the conzept... please help.

Excerpt of /var/log/messages:
Apr 25 17:37:09 r16 kernel: SCSI disk error : host 1 channel 0 id 2 lun=
 0 return code =3D 10000
Apr 25 17:37:09 r16 kernel:  I/O error: dev 08:41, sector 5396720
Apr 25 17:37:09 r16 kernel: raid5: Disk failure on sde1, disabling devi=
ce. Operation continuing on 3 devices
Apr 25 17:37:09 r16 kernel: md: recovery thread got woken up ...
Apr 25 17:37:09 r16 kernel: md: updating md5 RAID superblock on device
Apr 25 17:37:09 r16 kernel: md: sdh1 [events: 00000003]<6>(write) sdh1'=
s sb offset: 5124608
Apr 25 17:37:09 r16 kernel: SCSI disk error : host 1 channel 0 id 2 lun=
 0 return code =3D 10000
Apr 25 17:37:09 r16 kernel:  I/O error: dev 08:41, sector 5396728
Apr 25 17:37:10 r16 kernel: md: sdg1 [events: 00000003]<6>(write) sdg1'=
s sb offset: 5124608
Apr 25 17:37:10 r16 kernel: SCSI disk error : host 1 channel 0 id 2 lun=
 0 return code =3D 10000
Apr 25 17:37:10 r16 kernel:  I/O error: dev 08:41, sector 5396992
=2E.. SCSI disk error... + I/O error...
Apr 25 17:37:14 r16 kernel: md: sdf1 [events: 00000003]<6>(write) sdf1'=
s sb offset: 5124608
=2E.. SCSI disk error... + I/O error...
Apr 25 17:37:15 r16 kernel: md: (skipping faulty sde1 )
Apr 25 17:37:15 r16 kernel: md5: no spare disk to reconstruct array! --=
 continuing in degraded mode
Apr 25 17:37:15 r16 kernel: md: recovery thread finished ...
=2E.. SCSI disk error... + I/O error...
Apr 25 17:38:09 r16 kernel: scsi1:0:2:0: Attempting to queue an ABORT m=
essage
Apr 25 17:38:09 r16 kernel: scsi1: Dumping Card State while idle, at SE=
QADDR 0x8
=2E.. driver messages ...
Apr 25 17:38:09 r16 kernel: (scsi1:A:2:0): Queuing a recovery SCB
Apr 25 17:38:09 r16 kernel: scsi1:0:2:0: Device is disconnected, re-que=
uing SCB
Apr 25 17:38:09 r16 kernel: Recovery code sleeping
Apr 25 17:38:09 r16 kernel: Recovery SCB completes
Apr 25 17:38:09 r16 kernel: Recovery code awake
Apr 25 17:38:09 r16 kernel: aic7xxx_abort returns 0x2002
Apr 25 17:38:09 r16 kernel: scsi1:0:2:0: Attempting to queue a TARGET R=
ESET message
Apr 25 17:38:09 r16 kernel: scsi1:0:2:0: Command not found
Apr 25 17:38:09 r16 kernel: aic7xxx_dev_reset returns 0x2002
Apr 25 17:38:15 r16 kernel: scsi: device set offline - not ready or com=
mand retry failed after bus reset: host 1 channel 0 id 2 lun 0
Apr 25 17:38:15 r16 kernel: SCSI disk error : host 1 channel 0 id 2 lun=
 0 return code =3D 10000
Apr 25 17:38:15 r16 kernel:  I/O error: dev 08:41, sector 5396760
Apr 25 17:38:15 r16 kernel:  I/O error: dev 08:41, sector 5396768
Apr 25 17:38:23 r16 kernel: md: trying to remove sde1 from md5 ...
Apr 25 17:38:23 r16 kernel: RAID5 conf printout:
Apr 25 17:38:23 r16 kernel:  --- rd:4 wd:3 fd:1
Apr 25 17:38:23 r16 kernel:  disk 0, s:0, o:0, n:0 rd:0 us:1 dev:sde1
Apr 25 17:38:23 r16 kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdf1
Apr 25 17:38:23 r16 kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdg1
Apr 25 17:38:23 r16 kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdh1
Apr 25 17:38:23 r16 kernel: RAID5 conf printout:
Apr 25 17:38:23 r16 kernel:  --- rd:4 wd:3 fd:1
Apr 25 17:38:23 r16 kernel:  disk 0, s:0, o:0, n:0 rd:0 us:0 dev:[dev 0=
0:00]
Apr 25 17:38:23 r16 kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdf1
Apr 25 17:38:23 r16 kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdg1
Apr 25 17:38:23 r16 kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdh1
Apr 25 17:38:23 r16 kernel: md: unbind<sde1,3>
Apr 25 17:38:23 r16 kernel: md: export_rdev(sde1)
Apr 25 17:38:23 r16 kernel: md: updating md5 RAID superblock on device
Apr 25 17:38:23 r16 kernel: md: sdh1 [events: 00000004]<6>(write) sdh1'=
s sb offset: 5124608
Apr 25 17:38:23 r16 kernel: md: sdg1 [events: 00000004]<6>(write) sdg1'=
s sb offset: 5124608
Apr 25 17:38:23 r16 kernel: md: sdf1 [events: 00000004]<6>(write) sdf1'=
s sb offset: 5124608

Thanx,

Andreas.Kahnt@coware.de                         Coware AG
---------------------------------------------------------
Landsberger Str. 402                      D-81241 M=FCnchen
Telefon +49 (0)89 568 236 - 22, Fax -70     www.coware.de

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
