From: shamim <shamim_99@yahoo.com>
Subject: grow MULTIPATH RAID
Date: Fri, 25 Mar 2011 03:13:41 +0000 (UTC)
Message-ID: <loom.20110325T041239-956@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Experts,

Please help me to grow MULTIPATH RAID. =20
My problem:
I've Linux box which have MULTIPATH RAID created on them. Now we need t=
o remove
those old LUN and move data onto new LUN presented to those boxes.

My initially thought was to grow the  current MULTIPATH RAID (/dev/md0)=
 and=20
make old LUN as spare and then  failed and then remove(Is this a right
approach?).  When I=E2=80=99m try adding new LUNs to it, they are getti=
ng added as spare
( as shown below).  And when I try to grow , it refuse to do so.  Below=
 are the
steps that I performed and error message.(Cannot reshaped!!)=20
( I read somehwere  that we can=E2=80=99t grow MULTIPATH RAID, if it is=
 TRUE, then what
would be suggested solution to move data from old LUNs to new LUNs)
Please help
--------------------------------------------------
=20
# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Thu Mar 24 13:54:41 2011
     Raid Level : multipath
     Array Size : 10486016 (10.00 GiB 10.74 GB)
   Raid Devices : 2
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Mar 24 13:54:41 2011
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

           UUID : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
         Events : 0.3

    Number   Major   Minor   RaidDevice State
       0      65        0        0      active sync   /dev/sdq
       1       8       96        1      active sync   /dev/sdg
--------------------------------------------------------------------
# mdadm /dev/md0 --add /dev/sdr /dev/sdh
mdadm: added /dev/sdr
mdadm: re-added /dev/sdh

--------------------------------------------------------------------
# mdadm --detail /dev/md0
/dev/md0:
        Version : 0.90
  Creation Time : Thu Mar 24 13:54:41 2011
     Raid Level : multipath
     Array Size : 10486016 (10.00 GiB 10.74 GB)
   Raid Devices : 2
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

    Update Time : Thu Mar 24 13:54:41 2011
          State : clean
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

           UUID : xxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
         Events : 0.3

    Number   Major   Minor   RaidDevice State
       0      65        0        0      active sync   /dev/sdq
       1       8       96        1      active sync   /dev/sdg

       2      65       16        -      spare   /dev/sdr
       3       8      112        -      spare   /dev/sdh

--------------------------------------------------------------------
# mdadm --grow /dev/md0 --raid-disks=3D4
mdadm: multipath array /dev/md0 cannot be reshaped.



--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
