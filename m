From: Alberto Morell <amp4tj@gmail.com>
Subject: Fwd: Unable to re-assemble a raid 10 after it has FAILED.
Date: Tue, 10 Jun 2014 13:04:28 +0200
Message-ID: <CAEp9EKg462T+7E35RnarP6y41wGgNv3R_jAXEhxiLBg_vukW3g@mail.gmail.com>
References: <CAEp9EKjgt1RTkYzhSX-UQN2-WhV3iCKPr_DTnHN_KmorvFNsvg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEp9EKjgt1RTkYzhSX-UQN2-WhV3iCKPr_DTnHN_KmorvFNsvg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have a raid 10 devices with 4 components. I make the raid fails, by
making two components fail (using "mdadm --set-faulty <device>"). When
I add the two devices back, they are added as spare devices. Then, I
can get the raid active again only creating the raid again using
"mdadm --create --assume-clean...". Re-assembling the device does not
work with error message:

mdadm: failed to RUN_ARRAY /dev/md/hdd: Input/output error
mdadm: Not enough devices to start the array.

I am trying to automate the raid configuration and the "mdadm --create
..." option is not convenient as I would have to know all the creation
parameters.

Below is the command sequence.

Thanks is advance,

Alberto Morell.


[root@os2 raid_tools]# mdadm --version
mdadm - v3.2.6 - 25th October 2012

[root@os2 ~]# mdadm --create /dev/md/hdd --metadata=1.0 --auto=md --name=hdd \
--chunk=256 --bitmap=internal --bitmap-chunk=65536 --level=raid10 --run \
--raid-devices=4 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1

[root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sde1
mdadm: set /dev/sde1 faulty in /dev/md/hdd
[root@os2 ~]# mdadm --set-faulty /dev/md/hdd /dev/sdf1
mdadm: set /dev/sdf1 faulty in /dev/md/hdd

[root@os2 ~]# mdadm --remove /dev/md/hdd /dev/sde1
mdadm: hot removed /dev/sde1 from /dev/md/hdd
[root@os2 ~]# mdadm --remove /dev/md/hdd /dev/sdf1
mdadm: hot removed /dev/sdf1 from /dev/md/hdd
[root@os2 ~]# mdadm --add /dev/md/hdd /dev/sde1
mdadm: re-added /dev/sde1
[root@os2 ~]# mdadm --add /dev/md/hdd /dev/sdf1
mdadm: re-added /dev/sdf1

[root@os2 raid_tools]# mdadm --detail /dev/md/hdd /dev/md/hdd:
        Version : 1.0
  Creation Time : Tue Jun 10 10:57:23 2014
     Raid Level : raid10
  Used Dev Size : 4193280 (4.00 GiB 4.29 GB)
   Raid Devices : 4
  Total Devices : 4
    Persistence : Superblock is persistent

    Update Time : Tue Jun 10 10:59:25 2014
          State : active, FAILED, Not Started
 Active Devices : 2
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 2

         Layout : near=2
     Chunk Size : 256K

           Name : hdd
           UUID : 3398fe2d:48bfbff8:6ff2acaf:7cd020c5
         Events : 60

    Number   Major   Minor   RaidDevice State
       0       8       33        0      active sync   /dev/sdc1
       1       8       49        1      active sync   /dev/sdd1
       2       0        0        2      removed
       3       0        0        3      removed

       2       8       65        -      spare   /dev/sde1
       3       8       81        -      spare   /dev/sdf1

[root@os2 raid_tools]# mdadm --assemble /dev/md/hdd --force --run
--uuid=3398fe2d:48bfbff8:6ff2acaf:7cd020c5 --verbose /dev/sdc1
/dev/sdd1 /dev/sde1 /dev/sdf1
mdadm: looking for devices for /dev/md/hdd
mdadm: /dev/sdc1 is identified as a member of /dev/md/hdd, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md/hdd, slot 1.
mdadm: /dev/sde1 is identified as a member of /dev/md/hdd, slot -1.
mdadm: /dev/sdf1 is identified as a member of /dev/md/hdd, slot -1.
mdadm: added /dev/sdd1 to /dev/md/hdd as 1
mdadm: no uptodate device for slot 2 of /dev/md/hdd
mdadm: no uptodate device for slot 3 of /dev/md/hdd
mdadm: added /dev/sde1 to /dev/md/hdd as -1
mdadm: added /dev/sdf1 to /dev/md/hdd as -1
mdadm: added /dev/sdc1 to /dev/md/hdd as 0
mdadm: failed to RUN_ARRAY /dev/md/hdd: Input/output error
mdadm: Not enough devices to start the array.
