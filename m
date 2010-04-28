From: Jeremy Knickerbocker <jeremy.knickerbocker@gmail.com>
Subject: Failed Growing RAID 5 to RAID 6
Date: Wed, 28 Apr 2010 14:58:20 -0400
Message-ID: <m2h624e8eba1004281158jf7c8c943o90ad8f3ec3584d4c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have been running a 4 disk raid 5 array with mdadm just fine for the
last couple of months. =A0I went out and got 4 new drives (same model)
and added them on a PCI controller. =A0I was able to add the drives jus=
t
fine. =A0But now my problem is growing the array.

The drives are 8 Seagate 1.5TB drives (ST31500341AS).  All have been
tested working.

jaykae-serv:~# mdadm --detail /dev/md1
/dev/md1:
Version : 1.2
Creation Time : Sun Apr 25 17:41:27 2010
Raid Level : raid5
Array Size : 4395402240 (4191.78 GiB 4500.89 GB)
Used Dev Size : 1465134080 (1397.26 GiB 1500.30 GB)
Raid Devices : 4
Total Devices : 8
Persistence : Superblock is persistent

Update Time : Wed Apr 28 14:40:10 2010
State : clean
Active Devices : 4
Working Devices : 8
=46ailed Devices : 0
Spare Devices : 4

Layout : left-symmetric
Chunk Size : 1024K

Name : jaykae-serv:1  (local to host jaykae-serv)
UUID : 71e05a16:b7ef5a50:b2499057:0ff0f6e3
Events : 549

Number   Major   Minor   RaidDevice State
0       8       97        0      active sync   /dev/sdg1
1       8      113        1      active sync   /dev/sdh1
2       8      129        2      active sync   /dev/sdi1
4       8      145        3      active sync   /dev/sdj1

5       8       17        -      spare   /dev/sdb1
6       8       33        -      spare   /dev/sdc1
7       8       49        -      spare   /dev/sdd1
8       8       81        -      spare   /dev/sdf1

My original intention was to turn it into a raid 6 array.

jaykae-serv:~# mdadm --grow /dev/md1 --level=3D6 --raid-disk=3D8
mdadm level of /dev/md1 changed to raid6
mdadm: Need to backup 1501199875784021K of critical section..
mdadm: /dev/md1: Something wrong - reshape aborted
mdadm: aborting level change

I get the same error message with just growing it normally.

jaykae-serv:~# mdadm --grow /dev/md1 --raid-disk=3D8
mdadm: Need to backup 4503599627348992K of critical section..
mdadm: /dev/md1: Something wrong - reshape aborted

One thing I do have to mention is that I had sd[bcdf] in their own
raid 5 array as those were my original drives, but because of some
formatting issues I had to create a second raid 5 array and copy them
over.  I had originally partitioned the drives differently and I was
getting an error that my other drives were too small.  sd[bcdf] are
all partitioned, but are unformatted.

Any suggestions would be welcomed.

Thanks,
Jeremy
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
