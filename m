From: "Don Dupuis" <dondster@gmail.com>
Subject: Md corruption using RAID10 on linux-2.6.21
Date: Wed, 16 May 2007 13:38:33 -0500
Message-ID: <632b79000705161138h359f71egdf4ad5d483731dbe@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a system with 4 disks in a raid10 configuration. Here is the
output of mdadm:

bash-3.1# mdadm -D /dev/md_d0
/dev/md_d0:
        Version : 00.90.03
  Creation Time : Wed May 16 10:28:44 2007
     Raid Level : raid10
     Array Size : 3646464 (3.48 GiB 3.73 GB)
  Used Dev Size : 2734848 (2.61 GiB 2.80 GB)
   Raid Devices : 4
  Total Devices : 4
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : Internal

    Update Time : Wed May 16 12:20:29 2007
          State : active, resyncing
 Active Devices : 4
Working Devices : 4
 Failed Devices : 0
  Spare Devices : 0

         Layout : near=3, far=1
     Chunk Size : 256K

 Rebuild Status : 37% complete

           UUID : fe3cad98:406511ae:3df46086:0a218818
         Events : 0.1066

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/sda2
       1       8       18        1      active sync   /dev/sdb2
       2       8       34        2      active sync   /dev/sdc2
       3       8       50        3      active sync   /dev/sdd2

The problem arises when I do a drive removal such as sda and then I
remove power from the system. Most of the time I will have a corrupted
partition on the md device. Other corruption will be my root partition
which is an ext3 filesystem. I seem to have a better chance of booting
a least 1 time with no errors with bitmap turned on, but If I repeat
the process, I will have corruption as well. Also with bitmap turned
on, adding the new drive into the md device will take way to too long.
I only get about 3MB per second on the resync. With bitmap turned off,
I will get between 10MB to 15MB resync rate. Has anyone else seen this
behavior, or is this situation is no tested very often? I would think
that I shouldn't get corruption with this raid  setup and jornaling of
my filesytems? Any help would be appreciated.

Don
