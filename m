From: =?ISO-8859-1?Q?R=E9mi_R=E9rolle?= <rrerolle@lacie.com>
Subject: mdadm: can't removed failed/detached drives when using metadata 1.x
Date: Thu, 10 Feb 2011 16:28:12 +0100
Message-ID: <4D54040C.4040201@lacie.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I recently came across what I believe is a regression in mdadm, which
has been introduced in version 3.1.3.

It seems that, when using metadata 1.x, the handling of failed/detached
drives isn't effective anymore.

Here's a quick example:

[root@GrosCinq ~]# mdadm -C /dev/md4 -l1 -n2 --metadata=3D1.0 /dev/sdc1=
=20
/dev/sdd1
mdadm: array /dev/md4 started.
[root@GrosCinq ~]#
[root@GrosCinq ~]# mdadm --wait /dev/md4
[root@GrosCinq ~]#
[root@GrosCinq ~]# mdadm -D /dev/md4
/dev/md4:
         Version : 1.0
   Creation Time : Thu Feb 10 13:56:31 2011
      Raid Level : raid1
      Array Size : 1953096 (1907.64 MiB 1999.97 MB)
   Used Dev Size : 1953096 (1907.64 MiB 1999.97 MB)
    Raid Devices : 2
   Total Devices : 2
     Persistence : Superblock is persistent

     Update Time : Thu Feb 10 13:56:46 2011
           State : clean
  Active Devices : 2
Working Devices : 2
  Failed Devices : 0
   Spare Devices : 0

            Name : GrosCinq:4  (local to host GrosCinq)
            UUID : bbfef508:252e7ce1:c95d4a03:8beb3cbd
          Events : 17

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sdc1
        1       8       49        1      active sync   /dev/sdd1

[root@GrosCinq ~]# mdadm --fail /dev/md4 /dev/sdc1
mdadm: set /dev/sdc1 faulty in /dev/md4
[root@GrosCinq ~]#
[root@GrosCinq ~]# mdadm -D /dev/md4 | tail -n 6

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       49        1      active sync   /dev/sdd1

        0       8        1        -      faulty spare   /dev/sdc1
[root@GrosCinq ~]#
[root@GrosCinq ~]# mdadm --remove /dev/md4 failed
[root@GrosCinq ~]#
[root@GrosCinq ~]# mdadm -D /dev/md4 | tail -n 6

     Number   Major   Minor   RaidDevice State
        0       0        0        0      removed
        1       8       49        1      active sync   /dev/sdd1

        0       8        1        -      faulty spare   /dev/sdc1
[root@GrosCinq ~]#

This is with mdadm 3.1.4, 3.1.3 or even 3.2, but not 3.1.2. I did a git=
=20
bisect to try and isolate the regression and it appears the guilty=20
commit is :

b3b4e8a : "Avoid skipping devices where removing all faulty/detached
            devices."

As stated in the commit, this is only true with metadata 1.x. With 0.9,=
=20
there is no problem. I also tested with detached drives as well as=20
raid5/6 and encountered the same issue. Actually, with detached drives,=
=20
it's even more annoying, since using --remove detached is the only way=20
to remove the device without restarting the array. For a failed drive,=20
there is still the possibility to use the device name.

Do you have any idea of the reason behind that regression ? Shall this=20
patch only apply in the case of 0.9 metadata ?

Regards,

--=20
R=E9mi
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
