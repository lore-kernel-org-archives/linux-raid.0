From: Eric Valette <eric.valette@free.fr>
Subject: Re: Problem with array raid10 array resync on 4.4.0 (keeps reyncing
 each reboot)
Date: Mon, 1 Feb 2016 00:00:36 +0100
Message-ID: <56AE9214.3030206@free.fr>
References: <56A78786.10103@Free.fr> <20160126233133.GB12721@kernel.org>
 <56A870AD.4070400@free.fr> <20160128182522.GB23378@kernel.org>
 <56AA7176.1020508@free.fr>
Reply-To: eric.valette@free.fr
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56AA7176.1020508@free.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/01/2016 20:52, Eric Valette wrote:
> On 28/01/2016 19:25, Shaohua Li wrote:
>
> If really needed can rebuild a 4.4 kernel and boot it. What do you mean
> by special config? I can send you my kernel .config once rebuild
> (oldconfig from 4.1.16)

Linux nas2 4.4.1 #1 SMP Sun Jan 31 23:46:26 CET 2016 x86_64 GNU/Linux


mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
   Creation Time : Wed Jun 20 23:56:59 2012
      Raid Level : raid10
      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
   Used Dev Size : 2930134016 (2794.39 GiB 3000.46 GB)
    Raid Devices : 4
   Total Devices : 5
     Persistence : Superblock is persistent

     Update Time : Sun Jan 31 23:51:44 2016
           State : active, resyncing
  Active Devices : 4
Working Devices : 5
  Failed Devices : 0
   Spare Devices : 1

          Layout : near=2
      Chunk Size : 512K

   Resync Status : 0% complete

            Name : nas2:0  (local to host nas2)
            UUID : 6abe1f20:90c629de:fadd8dc0:ca14c928
          Events : 488

     Number   Major   Minor   RaidDevice State
        0       8       17        0      active sync set-A   /dev/sdb1
        1       8       33        1      active sync set-B   /dev/sdc1
        2       8       49        2      active sync set-A   /dev/sdd1
        3       8       65        3      active sync set-B   /dev/sde1

        4       8       81        -      spare   /dev/sdf1

So it starts again rechecking the array

mdadm -E /dev/sd[b-f]1
/dev/sdb1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6abe1f20:90c629de:fadd8dc0:ca14c928
            Name : nas2:0  (local to host nas2)
   Creation Time : Wed Jun 20 23:56:59 2012
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=911 sectors
           State : active
     Device UUID : ce9d878a:37a4f3a3:936bd905:c4ed9970

     Update Time : Sun Jan 31 23:56:38 2016
        Checksum : c92206ec - correct
          Events : 489

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6abe1f20:90c629de:fadd8dc0:ca14c928
            Name : nas2:0  (local to host nas2)
   Creation Time : Wed Jun 20 23:56:59 2012
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=911 sectors
           State : active
     Device UUID : 8c89bdf8:4f3f8ace:c15b5634:7a874071

     Update Time : Sun Jan 31 23:56:38 2016
        Checksum : 911217a8 - correct
          Events : 489

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6abe1f20:90c629de:fadd8dc0:ca14c928
            Name : nas2:0  (local to host nas2)
   Creation Time : Wed Jun 20 23:56:59 2012
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=911 sectors
           State : active
     Device UUID : 9c0655c3:dca7722e:8ecc1a17:fb4d9089

     Update Time : Sun Jan 31 23:56:38 2016
        Checksum : b6a6bcd3 - correct
          Events : 489

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6abe1f20:90c629de:fadd8dc0:ca14c928
            Name : nas2:0  (local to host nas2)
   Creation Time : Wed Jun 20 23:56:59 2012
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=911 sectors
           State : active
     Device UUID : c97b767a:84d2e7e2:52557d30:51c39784

     Update Time : Sun Jan 31 23:56:38 2016
        Checksum : 36a6d284 - correct
          Events : 489

          Layout : near=2
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdf1:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 6abe1f20:90c629de:fadd8dc0:ca14c928
            Name : nas2:0  (local to host nas2)
   Creation Time : Wed Jun 20 23:56:59 2012
      Raid Level : raid10
    Raid Devices : 4

  Avail Dev Size : 5860268943 (2794.39 GiB 3000.46 GB)
      Array Size : 5860268032 (5588.79 GiB 6000.91 GB)
   Used Dev Size : 5860268032 (2794.39 GiB 3000.46 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=911 sectors
           State : active
     Device UUID : 82667e81:a6158319:85e0282e:845eec1c

     Update Time : Sun Jan 31 23:51:44 2016
        Checksum : a4a259e - correct
          Events : 488

          Layout : near=2
      Chunk Size : 512K

    Device Role : spare
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
root@nas2:~#

-- eric
