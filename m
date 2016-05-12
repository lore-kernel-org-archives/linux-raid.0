From: Claudiu Rad-Lohanel <jazzman@misalpina.net>
Subject: Re: recovering failed and unrecognizable RAID5 during mdadm --grow
 without backup
Date: Thu, 12 May 2016 23:09:30 +0300
Message-ID: <f06998d6-8e1e-c8ea-a22c-1307935092c3@misalpina.net>
References: <1b26650f-0b2c-2485-f781-e3fd26340741@misalpina.net>
 <5734D23D.6030400@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5734D23D.6030400@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 5/12/2016 9:58 PM, Phil Turmel wrote:
> Please show the examine for the individual partitions of the raid5:
>
> mdadm --examine /dev/sd[a-d]3
>

root@rescue ~ # mdadm --examine /dev/sd[a-d]3
/dev/sda3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : a935894f:be435fc0:589c1c7f:d5454b43
            Name : rescue:2  (local to host rescue)
   Creation Time : Mon Apr 14 15:22:47 2014
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7779167887 (3709.40 GiB 3982.93 GB)
      Array Size : 11668750848 (11128.19 GiB 11948.80 GB)
   Used Dev Size : 7779167232 (3709.40 GiB 3982.93 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=655 sectors
           State : active
     Device UUID : 9bd5271f:9cb24f1f:f27b2d29:71320066

   Reshape pos'n : 49152 (48.01 MiB 50.33 MB)
   New Chunksize : 64K

     Update Time : Wed May 11 16:19:38 2016
        Checksum : 286cd938 - correct
          Events : 11526

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdb3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : a935894f:be435fc0:589c1c7f:d5454b43
            Name : rescue:2  (local to host rescue)
   Creation Time : Mon Apr 14 15:22:47 2014
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7779167887 (3709.40 GiB 3982.93 GB)
      Array Size : 11668750848 (11128.19 GiB 11948.80 GB)
   Used Dev Size : 7779167232 (3709.40 GiB 3982.93 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=655 sectors
           State : active
     Device UUID : fe992c5f:cf125d01:9bb8e3f7:572aef37

   Reshape pos'n : 49152 (48.01 MiB 50.33 MB)
   New Chunksize : 64K

     Update Time : Wed May 11 16:19:38 2016
        Checksum : eb24325e - correct
          Events : 11526

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdc3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : a935894f:be435fc0:589c1c7f:d5454b43
            Name : rescue:2  (local to host rescue)
   Creation Time : Mon Apr 14 15:22:47 2014
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7779167887 (3709.40 GiB 3982.93 GB)
      Array Size : 11668750848 (11128.19 GiB 11948.80 GB)
   Used Dev Size : 7779167232 (3709.40 GiB 3982.93 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=655 sectors
           State : active
     Device UUID : 0eb93951:876cbbad:46c6004c:0101f3ca

   Reshape pos'n : 49152 (48.01 MiB 50.33 MB)
   New Chunksize : 64K

     Update Time : Wed May 11 16:19:38 2016
        Checksum : 70b08f7d - correct
          Events : 11526

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd3:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x4
      Array UUID : a935894f:be435fc0:589c1c7f:d5454b43
            Name : rescue:2  (local to host rescue)
   Creation Time : Mon Apr 14 15:22:47 2014
      Raid Level : raid5
    Raid Devices : 4

  Avail Dev Size : 7779167887 (3709.40 GiB 3982.93 GB)
      Array Size : 11668750848 (11128.19 GiB 11948.80 GB)
   Used Dev Size : 7779167232 (3709.40 GiB 3982.93 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=655 sectors
           State : active
     Device UUID : 957d7ddb:dc6de4e7:feb6fb1f:7776adcc

   Reshape pos'n : 49152 (48.01 MiB 50.33 MB)
   New Chunksize : 64K

     Update Time : Wed May 11 16:19:38 2016
        Checksum : ad2bb8a - correct
          Events : 11526

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 3
    Array State : AAAA ('A' == active, '.' == missing, 'R' == replacing)

> You will need to manually assemble (not create !) your array with a
> backup file outside the raid5, and the --invalid-backup option to
> abandon the backup file you can't get to.  You will likely have some
> unavoidable corruption at the reshape position due to this.

i am waiting for your input on this and how to continue. it seems that i 
actually set new chunk size to 64K not 128K as i was remembering. 
clearly i wasn't with a clear mind when i did all this..
should i be worried that reshape position is so at the beginning of the 
volume? maybe LVM vg0 metadata lost? (i am just assuming, don't know 
much about how and where LVM stores info about its volumes).
the backup file is there, inside the array, if i could reach it somehow 
i could feed it to mdadm and would probably go well afterwards.

anyway, if just data is lost, i don't care, what are really important 
are some LVM volumes probably placed much further inside the array.

thank you phil!

-- 
jazzman

