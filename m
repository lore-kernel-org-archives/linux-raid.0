From: whollygoat@letterboxes.org
Subject: --examine contradicts --create and --detail, again
Date: Wed, 11 Feb 2009 02:48:09 -0800
Message-ID: <1234349289.21577.1299744243@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am on my 4th or 5th try at getting a raid5 array 
set up.  I did have one working quite nicely with 6 
(5 active, 1 spare) 40GB drives but have had a 
succession of failures since trying to grow the array
after putting bigger drives in the box.

Either I am misunderstanding something, or I have
a hardware issue I don't know how to diagnose.  Any 
suggestions on things to read or to try are welcome.

I've been told that zeroing the superblock is sufficient
but having had so many failures I wanted to be thourough


# dd if=/dev/zero of=/dev/hd{egikmo} (for brevity, each was
run separately)

# rm -R /dev/md0 /dev/md

# fdisk /dev/hd{egikmo}
 - creating a new, primary, partition starting cylinder 1, 80G
 - type da (non-fs data)
 
#mdadm -C /dev/md/0 -e 1.0 -v -l 5 -b internal -a yes\
  -n 5 /dev/hde1 /dev/hdg1 /dev/hdi1 /dev/hdk1 /dev/hdm1\
  -x 1 /dev/hdo1  --name=FlyFileServ_md

After waiting for the initial syncing of the array to complete

# mdadm -D /dev/md/0
/dev/md/0:
        Version : 01.00.03
  Creation Time : Tue Feb 10 14:45:39 2009
     Raid Level : raid5
     Array Size : 312501760 (298.02 GiB 320.00 GB)
    Device Size : 156250880 (74.51 GiB 80.00 GB)
   Raid Devices : 5
  Total Devices : 6
Preferred Minor : 0
    Persistence : Superblock is persistent

  Intent Bitmap : Internal
   
    Update Time : Tue Feb 10 16:41:48 2009
          State : active
 Active Devices : 5
Working Devices : 6
 Failed Devices : 0
  Spare Devices : 1
           
         Layout : left-symmetric
     Chunk Size : 64K
           
           Name : fly:FlyFileServ_md  (local to host fly)
           UUID : 684bf5f1:de2c0d2a:5a5ac88f:de7cf2d3
         Events : 2
    
    Number   Major   Minor   RaidDevice State
       0      33        1        0      active sync   /dev/hde1
       1      34        1        1      active sync   /dev/hdg1
       2      56        1        2      active sync   /dev/hdi1
       3      57        1        3      active sync   /dev/hdk1
       6      88        1        4      active sync   /dev/hdm1
         
       5      89        1        -      spare   /dev/hdo1

So, then, why oh why oh why does --examine, on any of the 
component devices, show slots for  7 devices, one failed, 
one empty?  I have recently changed RAM, mobo, system disk
and some IDE cables thinking each time that I had finally
come to the end of this.



# mdadm -E /dev/hde1
/dev/hde1:
          Magic : a92b4efc
        Version : 01
    Feature Map : 0x1
     Array UUID : 684bf5f1:de2c0d2a:5a5ac88f:de7cf2d3
           Name : fly:FlyFileServ_md  (local to host fly)
  Creation Time : Tue Feb 10 14:45:39 2009
     Raid Level : raid5
   Raid Devices : 5
     
    Device Size : 156250880 (74.51 GiB 80.00 GB)
     Array Size : 625003520 (298.02 GiB 320.00 GB)
   Super Offset : 156251008 sectors
          State : clean
    Device UUID : 88b0d67e:3e2cf8ee:83f58286:4040c5da

Internal Bitmap : 2 sectors from superblock
    Update Time : Tue Feb 10 16:41:48 2009
       Checksum : dae7896e - correct
         Events : 2

         Layout : left-symmetric
     Chunk Size : 64K

    Array Slot : 0 (0, 1, 2, 3, failed, empty, 4)
   Array State : Uuuuu 1 failed

Sorry for bringing up this new instance of the same old 
problem yet one more time.
-- 
  
  whollygoat@letterboxes.org

-- 
http://www.fastmail.fm - A no graphics, no pop-ups email service

