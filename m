From: Tomka Gergely <tomka@avaxio.net>
Subject: Re: spare group
Date: Tue, 12 Jun 2007 09:57:58 +0200
Message-ID: <466E5206.20200@avaxio.net>
References: <466D51EE.7030509@avaxio.net>	<18029.57132.285522.284156@notabene.brown>	<466E3E58.8050105@avaxio.net> <18030.17507.290572.911043@notabene.brown>
Reply-To: tomka@avaxio.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18030.17507.290572.911043@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown =EDrta:
> (reads code).
>=20
> Ahhh. You are using version-1 superblocks aren't you?  That code only
> works for version-0.90 superblocks.  That was careless of me.  It
> shouldn't be hard to make it work more generally, but it looks like i=
t
> will be slightly more than trivial.  I'll try to get you a patch in
> the next day or so (feel free to remind me if I seem to have
> forgotten).
>=20
> Thanks for testing and reporting this problem.
>=20
> NeilBrown

# mdadm26 --detail /dev/md0
/dev/md0:
         Version : 00.90.03
   Creation Time : Tue Jun 12 10:31:08 2007
      Raid Level : raid5
      Array Size : 19534848 (18.63 GiB 20.00 GB)
   Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
    Raid Devices : 3
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Tue Jun 12 10:33:35 2007
           State : clean
  Active Devices : 3
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 1

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 5fd83926:01739a55:36458d87:119f8994 (local to host=20
ursula)
          Events : 0.4

     Number   Major   Minor   RaidDevice State
        0       8        1        0      active sync   /dev/sda1
        1       8       17        1      active sync   /dev/sdb1
        2       8       33        2      active sync   /dev/sdc1

        3       8       49        -      spare   /dev/sdd1

/dev/md1:
         Version : 00.90.03
   Creation Time : Tue Jun 12 10:31:29 2007
      Raid Level : raid5
      Array Size : 19534848 (18.63 GiB 20.00 GB)
   Used Dev Size : 9767424 (9.31 GiB 10.00 GB)
    Raid Devices : 3
   Total Devices : 3
Preferred Minor : 1
     Persistence : Superblock is persistent

     Update Time : Tue Jun 12 10:36:18 2007
           State : clean, degraded
  Active Devices : 2
Working Devices : 2
  Failed Devices : 1
   Spare Devices : 0

          Layout : left-symmetric
      Chunk Size : 64K

            UUID : 815d6fc4:a55c2602:36458d87:119f8994 (local to host=20
ursula)
          Events : 0.6

     Number   Major   Minor   RaidDevice State
        0       8       65        0      active sync   /dev/sde1
        1       8       81        1      active sync   /dev/sdf1
        2       0        0        2      removed

        3       8       97        -      faulty spare   /dev/sdg1

ARRAY /dev/md1 level=3Draid5 num-devices=3D3 spare-group=3Dubul=20
UUID=3D815d6fc4:a55c2602:36458d87:119f8994
ARRAY /dev/md0 level=3Draid5 num-devices=3D3 spares=3D1 spare-group=3Du=
bul=20
UUID=3D5fd83926:01739a55:36458d87:119f8994

I am very sorry, but it wont works with .9 superblocks also :( We=20
missing something small, but important here. Before you start to code.=20
mdadm was running in monitor mode, and reported a Fail. mdadm is the=20
latest version, 2.6.2.

tg
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
