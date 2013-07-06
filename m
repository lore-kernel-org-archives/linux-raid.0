From: "Marek Jaros" <mjaros1@nbox.cz>
Subject: mdadm ignoring X as it reports Y as failed
Date: Sat, 06 Jul 2013 21:06:14 +0200
Message-ID: <20130706210614.180228gmgmc172qu@mail.netbox.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
	DelSp=Yes	format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey everybody.

To keep it short, I have a RAID-5 mdraid, just today 2 out of the 5  
drives dropped out. It was a cable issue and has since been fixed. The  
array was not being written to or utilized in other way so no data has  
been lost.

However when I attempted to reassemble the array with

mdadm --assemble --force --verbose /dev/md0 /dev/sdc /dev/sdd /dev/sde  
/dev/sdf /dev/sdg


I got the folowing errors

mdadm: looking for devices for /dev/md0
mdadm: /dev/sdc is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
mdadm: /dev/sde is identified as a member of /dev/md0, slot 2.
mdadm: /dev/sdf is identified as a member of /dev/md0, slot 3.
mdadm: /dev/sdg is identified as a member of /dev/md0, slot 4.
mdadm: ignoring /dev/sde as it reports /dev/sdc as failed
mdadm: ignoring /dev/sdf as it reports /dev/sdc as failed
mdadm: ignoring /dev/sdg as it reports /dev/sdc as failed
mdadm: added /dev/sdd to /dev/md0 as 1
mdadm: no uptodate device for slot 2 of /dev/md0
mdadm: no uptodate device for slot 3 of /dev/md0
mdadm: no uptodate device for slot 4 of /dev/md0
mdadm: added /dev/sdc to /dev/md0 as 0
mdadm: /dev/md0 assembled from 2 drives - not enough to start the array.


After doing --examine* I indeed found out that the StateArray info  
inside the superblock has marked the first two drives as missing. That  
is however not true anymore but I can't force it to assemble the array  
or update the superblock info.

So is there anyway to force mdadm to assemble the array? Or perhaps  
edit the superblock info manually? I'd rather avoid having to recreate  
the array from scratch.

Any help or pointers with more info are highly appreciated. Thank you.


Regards,

Marek Jaros


*--examine output here:

/dev/sdc:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
            Name : YSGARD:0
   Creation Time : Thu Apr 25 12:38:17 2013
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : d2a4d8ed:b2c2bf12:6d553d16:7aabe804

     Update Time : Sat Jul  6 14:43:14 2013
        Checksum : 1b569235 - correct
          Events : 2742

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 0
    Array State : AAAAA ('A' == active, '.' == missing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
            Name : YSGARD:0
   Creation Time : Thu Apr 25 12:38:17 2013
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : f729ddca:adb2eaec:748ad0b6:0e321903

     Update Time : Sat Jul  6 14:29:42 2013
        Checksum : 7149bfc6 - correct
          Events : 2742

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 1
    Array State : AAAAA ('A' == active, '.' == missing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
            Name : YSGARD:0
   Creation Time : Thu Apr 25 12:38:17 2013
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : 83aea2f7:dc6a7d68:0d875248:c54d2bc9

     Update Time : Sat Jul  6 14:46:15 2013
        Checksum : 713418b2 - correct
          Events : 2742

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 2
    Array State : ..AAA ('A' == active, '.' == missing)
/dev/sdg:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x0
      Array UUID : 43222604:a15a957d:313d7b6c:d087ba6a
            Name : YSGARD:0
   Creation Time : Thu Apr 25 12:38:17 2013
      Raid Level : raid5
    Raid Devices : 5

  Avail Dev Size : 1953263024 (931.39 GiB 1000.07 GB)
      Array Size : 3906525184 (3725.55 GiB 4000.28 GB)
   Used Dev Size : 1953262592 (931.39 GiB 1000.07 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
           State : clean
     Device UUID : b8295773:a4a73e18:6a097100:15ecc829

     Update Time : Sat Jul  6 14:46:15 2013
        Checksum : b565f15d - correct
          Events : 2742

          Layout : left-symmetric
      Chunk Size : 512K

    Device Role : Active device 4
    Array State : ..AAA ('A' == active, '.' == missing)

----------------------------------------------------------------
This message was sent using IMP, the Internet Messaging Program.
