From: =?ISO-8859-1?Q?Niccol=F2_Belli?= <darkbasic@linuxsystems.it>
Subject: Re: raid1 issue after disk failure: both disks of the array are still
 active
Date: Sat, 15 Sep 2012 21:05:25 +0200
Message-ID: <5054D175.5070303@linuxsystems.it>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com> <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se> <5052E096.5040509@linuxsystems.it> <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com> <20120914182755.GA2534@cthulhu.home.robinhill.me.uk> <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

CHECK didn't help me, so I did a echo "repair >=20
/sys/block/md0/md/sync_action". REPAIR didn't work too :(

Here is syslog of REPAIR:

Sep 15 19:34:10 asterisk mdadm[2117]: RebuildStarted event detected on=20
md device /dev/md/0
Sep 15 19:34:10 asterisk kernel: [258470.152296] md: requested-resync o=
f=20
RAID array md0
Sep 15 19:34:10 asterisk kernel: [258470.152301] md: minimum=20
_guaranteed_  speed: 1000 KB/sec/disk.
Sep 15 19:34:10 asterisk kernel: [258470.152304] md: using maximum=20
available idle IO bandwidth (but not more than 200000 KB/sec) for=20
requested-resync.
Sep 15 19:34:10 asterisk kernel: [258470.152310] md: using 128k window,=
=20
over a total of 311619448k.
Sep 15 19:34:11 asterisk kernel: [258471.165653] ata3.00: exception=20
Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 15 19:34:11 asterisk kernel: [258471.167468] ata3.00: BMDMA stat 0x=
44
Sep 15 19:34:11 asterisk kernel: [258471.169912] ata3.00: failed=20
command: READ DMA EXT
Sep 15 19:34:11 asterisk kernel: [258471.172769] ata3.00: cmd=20
25/00:00:00:15:00/00:04:00:00:00/e0 tag 0 dma 524288 in
Sep 15 19:34:11 asterisk kernel: [258471.172771]          res=20
51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 15 19:34:11 asterisk kernel: [258471.176753] ata3.00: status: { DRD=
Y=20
ERR }
Sep 15 19:34:11 asterisk kernel: [258471.178605] ata3.00: error: { UNC =
}
Sep 15 19:34:12 asterisk kernel: [258472.148217] ata3.00: configured fo=
r=20
UDMA/133
Sep 15 19:34:12 asterisk kernel: [258472.148232] ata3: EH complete
Sep 15 19:34:13 asterisk kernel: [258473.131054] ata3.00: exception=20
Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 15 19:34:13 asterisk kernel: [258473.132881] ata3.00: BMDMA stat 0x=
44
Sep 15 19:34:13 asterisk kernel: [258473.134639] ata3.00: failed=20
command: READ DMA EXT
Sep 15 19:34:13 asterisk kernel: [258473.136413] ata3.00: cmd=20
25/00:00:00:15:00/00:04:00:00:00/e0 tag 0 dma 524288 in
Sep 15 19:34:13 asterisk kernel: [258473.136415]          res=20
51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 15 19:34:13 asterisk kernel: [258473.141768] ata3.00: status: { DRD=
Y=20
ERR }
Sep 15 19:34:13 asterisk kernel: [258473.144049] ata3.00: error: { UNC =
}
Sep 15 19:34:14 asterisk kernel: [258474.112209] ata3.00: configured fo=
r=20
UDMA/133
Sep 15 19:34:14 asterisk kernel: [258474.112224] ata3: EH complete
Sep 15 19:34:15 asterisk kernel: [258475.071642] ata3.00: exception=20
Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
Sep 15 19:34:15 asterisk kernel: [258475.073476] ata3.00: BMDMA stat 0x=
44
Sep 15 19:34:15 asterisk kernel: [258475.075240] ata3.00: failed=20
command: READ DMA EXT
Sep 15 19:34:15 asterisk kernel: [258475.077027] ata3.00: cmd=20
25/00:00:00:15:00/00:04:00:00:00/e0 tag 0 dma 524288 in
Sep 15 19:34:15 asterisk kernel: [258475.077029]          res=20
51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
Sep 15 19:34:15 asterisk kernel: [258475.080720] ata3.00: status: { DRD=
Y=20
ERR }
Sep 15 19:34:15 asterisk kernel: [258475.083512] ata3.00: error: { UNC =
}
Sep 15 19:34:16 asterisk kernel: [258476.100935] ata3.00: configured fo=
r=20
UDMA/133
Sep 15 19:34:16 asterisk kernel: [258476.100960] ata3: EH complete
Sep 15 19:41:29 asterisk asterisk[3492]: rc_avpair_new: unknown=20
attribute 1490026597
Sep 15 19:41:46 asterisk asterisk[3492]: rc_avpair_new: unknown=20
attribute 1490026597
Sep 15 19:41:52 asterisk asterisk[3492]: rc_avpair_new: unknown=20
attribute 1490026597
Sep 15 19:42:52 asterisk asterisk[3492]: rc_avpair_new: unknown=20
attribute 1490026597
Sep 15 19:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 2=20
Currently unreadable (pending) sectors
Sep 15 19:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 1 Offlin=
e=20
uncorrectable sectors
Sep 15 19:50:51 asterisk mdadm[2117]: Rebuild26 event detected on md=20
device /dev/md/0
Sep 15 20:07:31 asterisk mdadm[2117]: Rebuild53 event detected on md=20
device /dev/md/0
Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 2=20
Currently unreadable (pending) sectors
Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 1 Offlin=
e=20
uncorrectable sectors
Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT],=20
Temperature changed +4 Celsius to 42 Celsius (Min/Max 30/46)
Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sda [SAT], SMART=20
Usage Attribute: 201 Soft_Read_Error_Rate changed from 99 to 100
Sep 15 20:16:34 asterisk smartd[2581]: Device: /dev/sdb [SAT], SMART=20
Usage Attribute: 190 Airflow_Temperature_Cel changed from 61 to 60
Sep 15 20:24:11 asterisk mdadm[2117]: Rebuild75 event detected on md=20
device /dev/md/0
Sep 15 20:40:51 asterisk mdadm[2117]: Rebuild93 event detected on md=20
device /dev/md/0
Sep 15 20:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 2=20
Currently unreadable (pending) sectors
Sep 15 20:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], 1 Offlin=
e=20
uncorrectable sectors
Sep 15 20:46:34 asterisk smartd[2581]: Device: /dev/sda [SAT], SMART=20
Usage Attribute: 190 Airflow_Temperature_Cel changed from 61 to 60
Sep 15 20:47:24 asterisk kernel: [262863.781068] md: md0:=20
requested-resync done.
Sep 15 20:47:24 asterisk mdadm[2117]: RebuildFinished event detected on=
=20
md device /dev/md/0



I still get:

Num  Test_Description    Status                  Remaining=20
LifeTime(hours)  LBA_of_first_error
# 1  Offline             Completed: read failure       90%      8985=20
      3912

and

197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Alway=
s=20
       -       2
198 Offline_Uncorrectable   0x0030   100   100   000    Old_age=20
Offline      -       1


How is it possible? Next thing I will try is manually failing /dev/sda=20
and filling it with zeros. I would like to do a *low level format* but =
I=20
didn't find the utility for my disk :(

Disk is:

=3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
Model Family:     SAMSUNG SpinPoint F1 DT
Device Model:     SAMSUNG HD322HJ
Serial Number:    S17AJDWQ402689
LU WWN Device Id: 5 0000f0 003046298
=46irmware Version: 1AC01110
User Capacity:    320,072,933,376 bytes [320 GB]
Sector Size:      512 bytes logical/physical
Device is:        In smartctl database [for details use: -P show]
ATA Version is:   8
ATA Standard is:  ATA-8-ACS revision 3b
Local Time is:    Sat Sep 15 21:02:36 2012 CEST
SMART support is: Available - device has SMART capability.
SMART support is: Enabled

=3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D



root@asterisk:~# smartctl -a /dev/sda -P show
smartctl 5.41 2011-06-09 r3365 [x86_64-linux-3.2.0-2-amd64] (local buil=
d)
Copyright (C) 2002-11 by Bruce Allen, http://smartmontools.sourceforge.=
net

Drive found in smartmontools Database.  Drive identity strings:
MODEL:              SAMSUNG HD322HJ
=46IRMWARE:           1AC01110
match smartmontools Drive Database entry:
MODEL REGEXP:       SAMSUNG=20
HD(083G|16[12]G|25[12]H|32[12]H|50[12]I|642J|75[23]L|10[23]U)J
=46IRMWARE REGEXP:    .*
MODEL FAMILY:       SAMSUNG SpinPoint F1 DT
ATTRIBUTE OPTIONS:  None preset; no -v options are required.


Thanks,
Niccol=F2
--=20
http://www.linuxsystems.it
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
