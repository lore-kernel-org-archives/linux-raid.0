From: Chris <email.bug@arcor.de>
Subject: Re: re-add POLICY
Date: Tue, 17 Feb 2015 15:09:54 +0000 (UTC)
Message-ID: <loom.20150217T152416-500@post.gmane.org>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown> <loom.20150216T124230-883@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> NeilBrown <neilb <at> suse.de> writes:
> 
> > If it doesn't, then maybe you need "POLICY action=spare".
> 
> OK, I will test this when the notebook is back in the house.


I could test it on another system.

Without adding a bitmap, it required configring
  POLICY domain=default action=spare
and calling
  mdadm --udev-rules

but then, after removing and inserting sdc again, only two out of six md
partitions got synced.

To see if there is something wrong, I then added the sdc1 md0 member
manually, and it synced without failure.

So I can't tell why the other partitions did not sync atomatically.
Some of the unsynced partition types are 83 (md0 member), but others
are FD (md7 member) like the automatically synced ones.

linux 3.2.0
mdadm v3.2.5

md7 : active raid1 sdc6[3] sda8[2]
      14327680 blocks super 1.2 [3/2] [UU_]
      bitmap: 1/1 pages [4KB], 65536KB chunk

md3 : active raid1 sdc8[4] sda10[3]
      307011392 blocks super 1.2 [3/2] [UU_]
      bitmap: 3/3 pages [12KB], 65536KB chunk

md6 : active raid1 sda7[2]
      8695680 blocks super 1.2 [3/1] [_U_]
      
md1 : active raid1 sda6[3](W) sdb2[1]
      19513216 blocks super 1.2 [4/2] [_UU_]
      
md2 : active raid1 sda9[3](W) sdb3[0]
      97590144 blocks super 1.2 [4/2] [U_U_]
      
md0 : active raid1 sdc1[4] sda5[2](W) sdb1[1]
      340672 blocks super 1.2 [4/3] [UUU_]




A partition that did not sync automatically:
/dev/sdc7:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7a5847cd:be0e8510:8e170bf5:5d40143f
           Name : name:2  (local to host name)
  Creation Time : Sun Dec  2 21:40:58 2012
     Raid Level : raid1
   Raid Devices : 4

 Avail Dev Size : 195187135 (93.07 GiB 99.94 GB)
     Array Size : 97590144 (93.07 GiB 99.93 GB)
  Used Dev Size : 195180288 (93.07 GiB 99.93 GB)
    Data Offset : 131072 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : b1a97d12:965e3d08:059acefb:6ac5b7e3

    Update Time : Wed Dec  3 11:23:26 2014
       Checksum : ac0ce511 - correct
         Events : 382479


   Device Role : Active device 1
   Array State : AAA. ('A' == active, '.' == missing)



And a corresponding partition that is part of the running array:
/dev/sda9:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : 7a5847cd:be0e8510:8e170bf5:5d40143f
           Name : name:2  (local to host name)
  Creation Time : Sun Dec  2 21:40:58 2012
     Raid Level : raid1
   Raid Devices : 4

 Avail Dev Size : 195182592 (93.07 GiB 99.93 GB)
     Array Size : 97590144 (93.07 GiB 99.93 GB)
  Used Dev Size : 195180288 (93.07 GiB 99.93 GB)
    Data Offset : 131072 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 4c191282:80769896:378abe34:aeb01b8d

          Flags : write-mostly
    Update Time : Mon Feb 16 17:41:54 2015
       Checksum : 8cb4794c - correct
         Events : 384989


   Device Role : Active device 2
   Array State : A.A. ('A' == active, '.' == missing)



BTW looking at this data now, it seems to me the superblocks almost support
the clean re-sync / conflict detection I was trying to explain.

a) The removed device 1 does not claim that a member
   in the running array (0 and 2) has failed (AAA.)

b) The Events count of device 1 is lower than in the running array.

c) The running array/superblock does not seem to keep
   a reference of the Event count when device 1 failed, for additional
   security that it has not ben started separately.

But b) and c) may not even be necessary, as starting device 1 separately
would make device 1 claim that 0 and 2 have failed, right?


Regards,
Chris





