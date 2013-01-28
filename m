From: Wolfgang Denk <wd@denx.de>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 07:27:46 +0100
Message-ID: <20130128062746.3123B2580EC@gemini.denx.de>
References: <20130127192656.634892005AD@gemini.denx.de> <5105D0EA.7080100@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <5105D0EA.7080100@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear Phil Turmel,

In message <5105D0EA.7080100@turmel.org> you wrote:
>
> >   Creation Time : Mon Jan 14 14:20:34 2013
> 
> Something is missing from this story.  Was the original system created
> this month, and immediately upgraded?  Or was there a "mdadm --create"
> in this story you haven't told us about?

On one of the systems where I observe these problems the array was
indeed recreated; this is running  set of old Maxtor MaXLine Plus II
7Y250M0 drives, and the rebuild was done to throw out some drives that
started growing number of reallocated sectors.

The two other systems have been running unmodified hardware-wise for
many months.

> Please share the output of "mdadm -E /dev/sd[defghijk]1".


/dev/sdd1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489968447 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 9d820d74:cd981ec5:b0d95ad6:37124d98

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : 9fe9401b - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 0
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sde1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489970560 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : d0494c53:30feb967:37f035e7:5665af56

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : f100de9d - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 6
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdf1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489970560 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 6d84b3ee:3789d762:1de41934:986e51c2

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : 400ba165 - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 1
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdg1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489970560 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 1605798c:a669952b:33d986ec:a25c7c1f

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : bc26e59d - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 2
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdh1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489970560 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 90bdf4cd:1e05fd37:bd4d27d5:666c9924

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : f7c7bdde - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 3
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdi1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489970560 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 2143a792:be518d02:b2ad54b6:fbf72cd7

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : 1acb7b9e - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 7
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdj1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489970560 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 8d76c4b7:819e678e:c9c66587:9eea674f

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : 150f0784 - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 4
   Array State : AAAAAAAA ('A' == active, '.' == missing)
/dev/sdk1:
          Magic : a92b4efc
        Version : 1.2
    Feature Map : 0x0
     Array UUID : da015f96:138b37bf:d5ef71dc:8970ab15
           Name : atlas.denx.de:0  (local to host atlas.denx.de)
  Creation Time : Mon Jan 14 14:20:34 2013
     Raid Level : raid6
   Raid Devices : 8

 Avail Dev Size : 489970560 (233.64 GiB 250.86 GB)
     Array Size : 1459617792 (1392.00 GiB 1494.65 GB)
  Used Dev Size : 486539264 (232.00 GiB 249.11 GB)
    Data Offset : 262144 sectors
   Super Offset : 8 sectors
          State : clean
    Device UUID : 5d9ef991:6162ced4:d50c17e8:882b4e68

    Update Time : Sun Jan 27 23:03:15 2013
       Checksum : af427a2b - correct
         Events : 8

         Layout : left-symmetric
     Chunk Size : 16K

   Device Role : Active device 5
   Array State : AAAAAAAA ('A' == active, '.' == missing)

> Please also explain/share what you've done to conclude the filesystem is
> error-free.

fsck shows no errors, a full backup shows no errors, and a number of
files I checked manually showed no corruption.  I'm aware that this is
not a very reliable test.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
At the source of every error which is blamed on the computer you will
find at least two human errors, including the error of blaming it  on
the computer.
