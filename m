From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Fw: sdc1 does not have a valid v0.90 superblock, not importing!
Date: Tue, 10 Aug 2010 14:35:33 -0700 (PDT)
Message-ID: <275171.86984.qm@web51303.mail.re2.yahoo.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Help!

Long story short - I was watching a movie off my RAID6 array. Got a sma=
rt error warning=20

'Device: /dev/sdc [SAT], ATA error count increased from 30 to 31'

I went to investigate and found:

Error 31 occurred at disk power-on lifetime: 8461 hours (352 days + 13=20
hours)

 =A0When the command that caused the error occurred, the device was act=
ive
 or idle.



 =A0After command completion occurred, registers were:

 =A0ER ST SC SN CL CH DH

 =A0-- -- -- -- -- -- --

 =A084 51 28 50 bd 49 47



 =A0Commands leading to the command that caused the error were:

 =A0CR FR SC SN CL CH DH DC =A0 Powered_Up_Time =A0Command/Feature_Name

 =A0-- -- -- -- -- -- -- -- =A0---------------- =A0--------------------

 =A061 38 08 3f bd 49 40 08 =A0 =A0 =A000:38:33.100 =A0WRITE FPDMA QUEU=
ED

 =A061 08 00 7f bd 49 40 08 =A0 =A0 =A000:38:33.100 =A0WRITE FPDMA QUEU=
ED

 =A061 08 00 97 bd 49 40 08 =A0 =A0 =A000:38:33.000 =A0WRITE FPDMA QUEU=
ED

 =A0ea 00 00 00 00 00 a0 08 =A0 =A0 =A000:38:33.000 =A0FLUSH CACHE EXT

 =A061 08 00 bf 4b 38 40 08 =A0 =A0 =A000:38:33.000 =A0WRITE FPDMA QUEU=
ED

I then emailed myself some error logs and shut the machine down. This d=
rive has caused me problems before - the last time when the cat knocked=
 the computer over and dislodged the controller card. But several echo =
"check" sync_action later and several weeks I have not had a peep out o=
f it.

ANYWAYS. after the reboot the array wont assemble (is that normal?)

Aug 10 22:00:07 mangalore kernel: md: running:=20
<sdg1><sdf1><sde1><sdd1><sdb1> <sda1>

Aug 10 22:00:07 mangalore kernel: raid5: md4 is not clean -- starting=20
background reconstruction

Aug 10 22:00:07 mangalore kernel: raid5: device sdg1 operational as rai=
d
 disk 0

Aug 10 22:00:07 mangalore kernel: raid5: device sdf1 operational as rai=
d
 disk 6

Aug 10 22:00:07 mangalore kernel: raid5: device sde1 operational as rai=
d
 disk 2

Aug 10 22:00:07 mangalore kernel: raid5: device sdd1 operational as rai=
d
 disk 4

Aug 10 22:00:07 mangalore kernel: raid5: device sdb1 operational as rai=
d
 disk 5

Aug 10 22:00:07 mangalore kernel: raid5: device sda1 operational as rai=
d
 disk 1

Aug 10 22:00:07 mangalore kernel: raid5: allocated 7343kB for md4

Aug 10 22:00:07 mangalore kernel: 0: w=3D1 pa=3D0 pr=3D7 m=3D2 a=3D2 r=3D=
7 op1=3D0=20
op2=3D0

Aug 10 22:00:07 mangalore kernel: 6: w=3D2 pa=3D0 pr=3D7 m=3D2 a=3D2 r=3D=
7 op1=3D0=20
op2=3D0

Aug 10 22:00:07 mangalore kernel: 2: w=3D3 pa=3D0 pr=3D7 m=3D2 a=3D2 r=3D=
7 op1=3D0=20
op2=3D0

Aug 10 22:00:07 mangalore kernel: 4: w=3D4 pa=3D0 pr=3D7 m=3D2 a=3D2 r=3D=
7 op1=3D0=20
op2=3D0

Aug 10 22:00:07 mangalore kernel: 5: w=3D5 pa=3D0 pr=3D7 m=3D2 a=3D2 r=3D=
7 op1=3D0=20
op2=3D0

Aug 10 22:00:07 mangalore kernel: 1: w=3D6 pa=3D0 pr=3D7 m=3D2 a=3D2 r=3D=
7 op1=3D0=20
op2=3D0

Aug 10 22:00:07 mangalore kernel: raid5: cannot start dirty degraded=20
array for md4

Aug 10 22:00:07 mangalore kernel: RAID5 conf printout:

Aug 10 22:00:07 mangalore kernel: --- rd:7 wd:6

Aug 10 22:00:07 mangalore kernel: disk 0, o:1, dev:sdg1

Aug 10 22:00:07 mangalore kernel: disk 1, o:1, dev:sda1

Aug 10 22:00:07 mangalore kernel: disk 2, o:1, dev:sde1

Aug 10 22:00:07 mangalore kernel: disk 4, o:1, dev:sdd1

Aug 10 22:00:07 mangalore kernel: disk 5, o:1, dev:sdb1

Aug 10 22:00:07 mangalore kernel: disk 6, o:1, dev:sdf1

Aug 10 22:00:07 mangalore kernel: raid5: failed to run raid set md4

Aug 10 22:00:07 mangalore kernel: md: pers->run() failed ...

Aug 10 22:00:07 mangalore kernel: md: do_md_run() returned -5

Aug 10 22:00:07 mangalore kernel: md: md4 stopped.

It appears sdc has an invalid superblock?=20

This is the 'examine' from sdc1 (note the checksum)

/dev/sdc1:

 =A0 =A0 =A0 =A0 =A0Magic : a92b4efc

 =A0 =A0 =A0 =A0Version : 0.90.00

 =A0 =A0 =A0 =A0 =A0 UUID : 7438efd1:9e6ca2b5:d6b88274: 7003b1d3

 =A0Creation Time : Thu Oct 11 00:01:49 2007

 =A0 =A0 Raid Level : raid6

 =A0Used Dev Size : 488383936 (465.76 GiB 500.11 GB)

 =A0 =A0 Array Size : 2441919680 (2328.80 GiB 2500.53 GB)

 =A0 Raid Devices : 7

 =A0Total Devices : 7

Preferred Minor : 4



 =A0 =A0Update Time : Tue Aug 10 21:39:49 2010

 =A0 =A0 =A0 =A0 =A0State : active

=A0Active Devices : 7

Working Devices : 7

=A0Failed Devices : 0

 =A0Spare Devices : 0

 =A0 =A0 =A0 Checksum : b335b4e3 - expected b735b4e3

 =A0 =A0 =A0 =A0 Events : 1860555



 =A0 =A0 =A0 =A0 Layout : left-symmetric

 =A0 =A0 Chunk Size : 64K



 =A0 =A0 =A0Number =A0 Major =A0 Minor =A0 RaidDevice State

this =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0 =A0 =A0=
active sync =A0 /dev/sdc1



 =A0 0 =A0 =A0 0 =A0 =A0 =A0 8 =A0 =A0 =A0 97 =A0 =A0 =A0 =A00 =A0 =A0 =
=A0active sync =A0 /dev/sdg1

 =A0 1 =A0 =A0 1 =A0 =A0 =A0 8 =A0 =A0 =A0 =A01 =A0 =A0 =A0 =A01 =A0 =A0=
 =A0active sync =A0 /dev/sda1

 =A0 2 =A0 =A0 2 =A0 =A0 =A0 8 =A0 =A0 =A0 65 =A0 =A0 =A0 =A02 =A0 =A0 =
=A0active sync =A0 /dev/sde1

 =A0 3 =A0 =A0 3 =A0 =A0 =A0 8 =A0 =A0 =A0 33 =A0 =A0 =A0 =A03 =A0 =A0 =
=A0active sync =A0 /dev/sdc1

 =A0 4 =A0 =A0 4 =A0 =A0 =A0 8 =A0 =A0 =A0 49 =A0 =A0 =A0 =A04 =A0 =A0 =
=A0active sync =A0 /dev/sdd1

 =A0 5 =A0 =A0 5 =A0 =A0 =A0 8 =A0 =A0 =A0 17 =A0 =A0 =A0 =A05 =A0 =A0 =
=A0active sync =A0 /dev/sdb1

 =A0 6 =A0 =A0 6 =A0 =A0 =A0 8 =A0 =A0 =A0 81 =A0 =A0 =A0 =A06 =A0 =A0 =
=A0active sync =A0 /dev/sdf1
Anyways... I am ASSUMING mdadm has not assembled the array to be on the=
 safe side? i have not done anything.. no force... no assume clean.. I =
wanted to be sure?

Should i remove sdc1 from the array? It should then assemble? I have 2 =
spare drives that I am getting around to using to replace this drive an=
d the other 500GB.. so should I remove sdc1... and try and re-add or ju=
st put the new drive in?

atm I have 'stop'ped the array and got badblocks running....


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
