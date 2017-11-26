From: Duane <duane@evenson.tk>
Subject: RAID5 devices assemble into RAID0 array
Date: Sat, 25 Nov 2017 18:50:54 -0700
Message-ID: <c1ae7110-8f62-9afd-2e4c-092256212153@evenson.tk>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------5174FD866447625F9A17D60E"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------5174FD866447625F9A17D60E
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

I have 3 RAID5 devices. When I assemble them, I end up with a RAID0 device.

What is the cause? What is the solution?

All I can think of is the fact that there is only 1 active device. I had 
2 but then manually failed it. I want to reassemble a RAID5 array and 
then re-add the second device.


mdadm -E /dev/sdc2 /dev/sdd /dev/sde

/dev/sdc2:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8c0d29d:9b5986a4:050ca914:3a2fb8c8
            Name : dave:0  (local to host dave)
   Creation Time : Fri Oct  6 10:46:50 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 7813726208 (3725.88 GiB 4000.63 GB)
      Array Size : 7630592 (7.28 GiB 7.81 GB)
   Used Dev Size : 7630592 (3.64 GiB 3.91 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=7806142351 sectors
           State : clean
     Device UUID : 0fe7e674:e1149499:7acb8853:c71fed62

Internal Bitmap : 8 sectors from superblock
     Update Time : Sun Nov 19 13:53:23 2017
   Bad Block Log : 512 entries available at offset 24 sectors
        Checksum : 79ee1226 - correct
          Events : 51526

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : Active device 0
    Array State : A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sdd:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8c0d29d:9b5986a4:050ca914:3a2fb8c8
            Name : dave:0  (local to host dave)
   Creation Time : Fri Oct  6 10:46:50 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 7813709489 (3725.87 GiB 4000.62 GB)
      Array Size : 7630592 (7.28 GiB 7.81 GB)
   Used Dev Size : 7630592 (3.64 GiB 3.91 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=7806078897 sectors
           State : clean
     Device UUID : ce2c8c03:f47f505b:c9a34e9a:668b70f5

Internal Bitmap : 8 sectors from superblock
     Update Time : Sun Nov 19 13:53:23 2017
   Bad Block Log : 512 entries available at offset 16 sectors
        Checksum : a398c591 - correct
          Events : 51526

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : spare
    Array State : A.. ('A' == active, '.' == missing, 'R' == replacing)
/dev/sde:
           Magic : a92b4efc
         Version : 1.2
     Feature Map : 0x1
      Array UUID : f8c0d29d:9b5986a4:050ca914:3a2fb8c8
            Name : dave:0  (local to host dave)
   Creation Time : Fri Oct  6 10:46:50 2017
      Raid Level : raid5
    Raid Devices : 3

  Avail Dev Size : 7813709489 (3725.87 GiB 4000.62 GB)
      Array Size : 7630592 (7.28 GiB 7.81 GB)
   Used Dev Size : 7630592 (3.64 GiB 3.91 GB)
     Data Offset : 262144 sectors
    Super Offset : 8 sectors
    Unused Space : before=262064 sectors, after=7806078897 sectors
           State : clean
     Device UUID : aecb9ce3:e7bc161f:9b8d1764:db815dde

Internal Bitmap : 8 sectors from superblock
     Update Time : Sun Nov 19 13:53:23 2017
   Bad Block Log : 512 entries available at offset 16 sectors
        Checksum : fa2581ac - correct
          Events : 51526

          Layout : left-symmetric
      Chunk Size : 64K

    Device Role : spare
    Array State : A.. ('A' == active, '.' == missing, 'R' == replacing)


mdadm -D /dev/md0
/dev/md0:
         Version : 1.2
      Raid Level : raid0
   Total Devices : 3
     Persistence : Superblock is persistent

           State : inactive

            Name : dave:0  (local to host dave)
            UUID : f8c0d29d:9b5986a4:050ca914:3a2fb8c8
          Events : 51526

     Number   Major   Minor   RaidDevice

        -       8       64        -        /dev/sde
        -       8       34        -        /dev/sdc2
        -       8       48        -        /dev/sdd



--------------5174FD866447625F9A17D60E
Content-Type: text/x-vcard;
 name="duane.vcf"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="duane.vcf"

bnVsbA==
--------------5174FD866447625F9A17D60E--
