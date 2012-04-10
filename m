From: jahammonds prost <gmitch64@yahoo.com>
Subject: Failed Array Rebuild advice Please
Date: Tue, 10 Apr 2012 15:32:44 -0700 (PDT)
Message-ID: <1334097164.41181.YahooMailNeo@web125506.mail.ne1.yahoo.com>
Reply-To: jahammonds prost <gmitch64@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

=46or various reasons, the email notifications on my RAID6 array wasn't=
 working, and 2 of the 15 drives failed out. I noticed this last week a=
s I was about to move the server into a new case. As part of the move, =
I upgraded the OS to the latest CentOS, as I was having issues with the=
 existing install and the new HBA card (a SASLP-MV8).
=A0
When the server came back up, for some reason it decided to fire up the=
 md array with only 1 drive - and it incremented the Event count on tha=
t 1 drive (and since I'm running with 2 failed drives on a RAID6, I cou=
ldn't kick the drive out and let it rebuild).
=A0
The array shows this...
=A0
=A0mdadm --detail /dev/md0
/dev/md0:
=A0=A0=A0=A0=A0=A0=A0 Version : 1.2
=A0 Creation Time : Sat Jun=A0 5 10:38:11 2010
=A0=A0=A0=A0 Raid Level : raid6
=A0 Used Dev Size : 488383488 (465.76 GiB 500.10 GB)
=A0=A0 Raid Devices : 15
=A0 Total Devices : 12
=A0=A0=A0 Persistence : Superblock is persistent
=A0=A0=A0 Update Time : Mon Apr=A0 9 13:05:31 2012
=A0=A0=A0=A0=A0=A0=A0=A0=A0 State : active, FAILED, Not Started
=A0Active Devices : 12
Working Devices : 12
=A0Failed Devices : 0
=A0 Spare Devices : 0
=A0=A0=A0=A0=A0=A0=A0=A0 Layout : left-symmetric
=A0=A0=A0=A0 Chunk Size : 512K
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 Name : file00bert.woodlea.org.uk:0=A0 (l=
ocal to host file00bert.woodlea.org.uk)
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 UUID : 1470c671:4236b155:67287625:899db1=
53
=A0=A0=A0=A0=A0=A0=A0=A0 Events : 1378022
=A0=A0=A0 Number=A0=A0 Major=A0=A0 Minor=A0=A0 RaidDevice State
=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 113=A0=A0=A0=A0=
=A0=A0=A0 0=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdh1
=A0=A0=A0=A0=A0=A0 1=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 209=A0=A0=A0=A0=
=A0=A0=A0 1=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdn1
=A0=A0=A0=A0=A0=A0 2=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 225=A0=A0=A0=A0=
=A0=A0=A0 2=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdo1
=A0=A0=A0=A0=A0 15=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 17=A0=A0=A0=A0=
=A0=A0=A0 3=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdb1
=A0=A0=A0=A0=A0=A0 4=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 145=A0=A0=A0=A0=
=A0=A0=A0 4=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdj1
=A0=A0=A0=A0=A0=A0 5=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 161=A0=A0=A0=A0=
=A0=A0=A0 5=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdk1
=A0=A0=A0=A0=A0=A0 6=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=
=A0=A0=A0=A0 6=A0=A0=A0=A0=A0 removed
=A0=A0=A0=A0=A0=A0 7=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 81=A0=A0=A0=A0=
=A0=A0=A0 7=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdf1
=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 97=A0=A0=A0=A0=
=A0=A0=A0 8=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdg1
=A0=A0=A0=A0=A0 16=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 65=A0=A0=A0=A0=
=A0=A0=A0 9=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sde1
=A0=A0=A0=A0=A0 10=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0=A0 33=A0=A0=A0=A0=
=A0=A0 10=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdc1
=A0=A0=A0=A0=A0 11=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=
=A0=A0 11=A0=A0=A0=A0=A0 removed
=A0=A0=A0=A0=A0 12=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 177=A0=A0=A0=A0=A0=
=A0 12=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdl1
=A0=A0=A0=A0=A0 13=A0=A0=A0=A0=A0=A0 8=A0=A0=A0=A0=A0 241=A0=A0=A0=A0=A0=
=A0 13=A0=A0=A0=A0=A0 active sync=A0=A0 /dev/sdp1
=A0=A0=A0=A0=A0 14=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=A0=A0=A0 0=A0=A0=A0=A0=
=A0=A0 14=A0=A0=A0=A0=A0 removed

=A0
Looking at the Event count on all the drives as they currently are, the=
y show this
=A0
sda1=A01378024
sdb1=A01378022
sdc1=A01378022
sdd1=A01362956
sde1=A01378022
sdf1=A01378022
sdg1=A01378022
sdh1=A01378022
sdj1=A01378022
sdk1=A01378022
sdl1=A01378022
sdm1=A0 616796
sdn1=A01378022
sdo1=A01378022
sdp1=A01378022
=A0
So, /dev/sdd1 and /dev/sdm1 are the 2 failed drives. The Event count on=
 all the other drives agree with each other, and with that of the array=
, except for /dev/sda1, which is a couple of events higher than everyth=
ing else - and with that I can't start the array.
=A0
=A0
Since I know I did nothing with the temp one drive array when the serve=
r was booted (and I don't think that the md code did anything either??)=
 would it be safe to=20
=A0
mdadm --assemble /dev/md0 /dev/sd[a-c]1 /dev/sd[e-h]1 /dev/sd[j-l]1 /de=
v/sd[n-p]1 --force
=A0
to let the array come back up and get it running?
=A0
What would then be the correct sequence to replace the 2 failed drives =
(sdd1 and sdm1) and get the array running fully again?
=A0
=A0
Thanks for your help.
=A0
=A0
YP.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
