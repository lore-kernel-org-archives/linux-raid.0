From: "Cal Webster" <kc130iseo@coastalnet.com>
Subject: RE: RAID5: Fixing or Recovering Faulty Disk
Date: Thu, 27 Jun 2002 13:45:00 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBIAKEEKGGEIKCBKNAKEPFDAAA.kc130iseo@coastalnet.com>
References: <NDBBIAKEEKGGEIKCBKNACEPFDAAA.kc130iseo@coastalnet.com>
Reply-To: <cwebster@ec.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <NDBBIAKEEKGGEIKCBKNACEPFDAAA.kc130iseo@coastalnet.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Inserted below are relevant entries from /var/log/messages. I forgot to
place them in the original message.

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org]On Behalf Of Cal Webster
> Sent: Thursday, June 27, 2002 1:41 PM
> To: linux-raid@vger.kernel.org
> Subject: RAID5: Fixing or Recovering Faulty Disk
>

                   -----------------------------------
                   RAID entries from /var/log/messages
                   -----------------------------------
Jun 26 16:48:25 winggear kernel: SCSI disk error : host 0 channel 0 id 2 lun
0  return code = 2
Jun 26 16:48:25 winggear kernel:  I/O error: dev 08:21, sector 32772704
Jun 26 16:48:25 winggear kernel: raid5: Disk failure on sdc1, disabling
device.
Operation continuing on 7 devices
Jun 26 16:48:25 winggear kernel: raid5: parity resync was not fully
finished,  restarting next time.
Jun 26 16:48:25 winggear kernel: md: recovery thread got woken up ...
Jun 26 16:48:25 winggear kernel: sym53c875-0-<2,*>: FAST-10 WIDE SCSI 20.0
MB/s
(100.0 ns, offset 16)
Jun 26 16:48:25 winggear kernel: md: updating md0 RAID superblock on device
Jun 26 16:48:25 winggear kernel: md: sdi1 [events: 00000006]<6>(write)
sdi1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: sdh1 [events: 00000006]<6>(write)
sdh1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: sdg1 [events: 00000006]<6>(write)
sdg1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: sdf1 [events: 00000006]<6>(write)
sdf1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: sde1 [events: 00000006]<6>(write)
sde1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: sdd1 [events: 00000006]<6>(write)
sdd1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: (skipping faulty sdc1 )
Jun 26 16:48:25 winggear kernel: md: sdb1 [events: 00000006]<6>(write)
sdb1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: sda1 [events: 00000006]<6>(write)
sda1's sb
 offset: 17681664
Jun 26 16:48:25 winggear kernel: md: md_do_sync() got signal ... exiting
Jun 26 16:48:25 winggear kernel: md0: resyncing spare disk sdi1 to replace
failed  disk
Jun 26 16:48:25 winggear kernel: RAID5 conf printout:
Jun 26 16:48:25 winggear kernel:  --- rd:8 wd:7 fd:1
Jun 26 16:48:25 winggear kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Jun 26 16:48:25 winggear kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Jun 26 16:48:25 winggear kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
Jun 26 16:48:25 winggear kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Jun 26 16:48:25 winggear kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
Jun 26 16:48:25 winggear kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
Jun 26 16:48:25 winggear kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
Jun 26 16:48:25 winggear kernel:  disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdh1
Jun 26 16:48:25 winggear kernel: RAID5 conf printout:
Jun 26 16:48:25 winggear kernel:  --- rd:8 wd:7 fd:1
Jun 26 16:48:25 winggear kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Jun 26 16:48:25 winggear kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Jun 26 16:48:25 winggear kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
Jun 26 16:48:25 winggear kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Jun 26 16:48:25 winggear kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
Jun 26 16:48:25 winggear kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
Jun 26 16:48:25 winggear kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
Jun 26 16:48:25 winggear kernel:  disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdh1
Jun 26 16:48:25 winggear kernel: raid5: resync aborted!
Jun 26 16:48:25 winggear kernel: md: syncing RAID array md0
Jun 26 16:48:25 winggear kernel: md: minimum _guaranteed_ reconstruction
speed:
100 KB/sec/disc.
Jun 26 16:48:25 winggear kernel: md: using maximum available idle IO
bandwith (but  not more than 100000 KB/sec) for reconstruction.
Jun 26 16:48:25 winggear kernel: md: using 248k window, over a total of
17681664
 blocks.
Jun 26 19:09:32 winggear kernel: md: md0: sync done.
Jun 26 19:09:32 winggear kernel: RAID5 conf printout:
Jun 26 19:09:32 winggear kernel:  --- rd:8 wd:7 fd:1
Jun 26 19:09:32 winggear kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Jun 26 19:09:32 winggear kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Jun 26 19:09:32 winggear kernel:  disk 2, s:0, o:0, n:2 rd:2 us:1 dev:sdc1
Jun 26 19:09:32 winggear kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Jun 26 19:09:32 winggear kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
Jun 26 19:09:32 winggear kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
Jun 26 19:09:32 winggear kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
Jun 26 19:09:32 winggear kernel:  disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdh1
Jun 26 19:09:32 winggear kernel: RAID5 conf printout:
Jun 26 19:09:32 winggear kernel:  --- rd:8 wd:8 fd:0
Jun 26 19:09:32 winggear kernel:  disk 0, s:0, o:1, n:0 rd:0 us:1 dev:sda1
Jun 26 19:09:32 winggear kernel:  disk 1, s:0, o:1, n:1 rd:1 us:1 dev:sdb1
Jun 26 19:09:32 winggear kernel:  disk 2, s:0, o:1, n:2 rd:2 us:1 dev:sdi1
Jun 26 19:09:32 winggear kernel:  disk 3, s:0, o:1, n:3 rd:3 us:1 dev:sdd1
Jun 26 19:09:32 winggear kernel:  disk 4, s:0, o:1, n:4 rd:4 us:1 dev:sde1
Jun 26 19:09:32 winggear kernel:  disk 5, s:0, o:1, n:5 rd:5 us:1 dev:sdf1
Jun 26 19:09:32 winggear kernel:  disk 6, s:0, o:1, n:6 rd:6 us:1 dev:sdg1
Jun 26 19:09:32 winggear kernel:  disk 7, s:0, o:1, n:7 rd:7 us:1 dev:sdh1
Jun 26 19:09:32 winggear kernel: md: updating md0 RAID superblock on device
Jun 26 19:09:32 winggear kernel: md: sdi1 [events: 00000007]<6>(write)
sdi1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: sdh1 [events: 00000007]<6>(write)
sdh1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: sdg1 [events: 00000007]<6>(write)
sdg1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: sdf1 [events: 00000007]<6>(write)
sdf1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: sde1 [events: 00000007]<6>(write)
sde1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: sdd1 [events: 00000007]<6>(write)
sdd1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: (skipping faulty sdc1 )
Jun 26 19:09:32 winggear kernel: md: sdb1 [events: 00000007]<6>(write)
sdb1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: sda1 [events: 00000007]<6>(write)
sda1's sb
 offset: 17681664
Jun 26 19:09:32 winggear kernel: md: recovery thread finished ...
---------------------------------------------------

