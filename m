From: Tyler <pml@dtbb.net>
Subject: BUGREPORT: mdadm v2.0-devel - Examine and zero-superblock misbehaving
Date: Tue, 03 May 2005 04:02:57 -0700
Message-ID: <42775A61.6020708@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, neilb@cse.unsw.edu.au
List-Id: linux-raid.ids

On a site note, mdadm --zero-superblock doesn't seem to work correctly 
with mdadm v2.0-devel, it reports no error when you use it, but you can 
mdadm -E /dev/hdX after using it, and there is still a superblock, if 
you use mdadm v1.9.0-2, it works correctly, and the examine shows 
nothing afterwards.  Examples follow after the first problem.  Mdadm 
v2.0 also seems to misreport the findings using the examine function.. 
"381 spares."  Using kernel 2.6.12-rc3-mm2.

First i run zero superblock with mdadm v2.0-devel from current dir:

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm --zero-superblock /dev/hdc

Then examine the superblock using mdadm v2.0-devel from current dir:

root@localhost:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
/dev/hdc:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : f4b2dc026e:a3cc3e95:de0563f5:199250
           Name :
  Creation Time : Tue May  3 11:16:22 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 390721952 (186.31 GiB 200.05 GB)
   Super Offset : 390721952 sectors
          State : active
    Device UUID : f4b2dc026e:a3cc3e95:de0563f5:199250
    Update Time : Tue May  3 11:16:22 2005
       Checksum : d4cd5d80 - correct
         Events : 0

         Layout : -unknown-
     Chunk Size : 64K

   Array State : Uuu 381 spares

Then i try using mdadm v1.9.0 (from system path):

root@localhost:~/dev/mdadm-2.0-devel-1# mdadm --version
mdadm - v1.9.0 - 04 February 2005
root@localhost:~/dev/mdadm-2.0-devel-1# mdadm -E /dev/hdc
mdadm: No super block found on /dev/hdc (Expected magic a92b4efc, got 
00000000)

Then i try erasing the superblock again with mdadm v1.9.0 from system path:

root@pink:~/dev/mdadm-2.0-devel-1# mdadm --version
mdadm - v1.9.0 - 04 February 2005
root@pink:~/dev/mdadm-2.0-devel-1# mdadm --zero-superblock /dev/hdc
mdadm: /dev/hdc does not appear to have an MD superblock.

Then examine it again with mdadm v2.0-devel from current dir:

root@pink:~/dev/mdadm-2.0-devel-1# ./mdadm -E /dev/hdc
/dev/hdc:
          Magic : a92b4efc
        Version : 01.00
     Array UUID : f4b2dc026e:a3cc3e95:de0563f5:199250
           Name :
  Creation Time : Tue May  3 11:16:22 2005
     Raid Level : raid5
   Raid Devices : 3

    Device Size : 390721952 (186.31 GiB 200.05 GB)
   Super Offset : 390721952 sectors
          State : active
    Device UUID : f4b2dc026e:a3cc3e95:de0563f5:199250
    Update Time : Tue May  3 11:16:22 2005
       Checksum : d4cd5d80 - correct
         Events : 0

         Layout : -unknown-
     Chunk Size : 64K

   Array State : Uuu 381 spares
