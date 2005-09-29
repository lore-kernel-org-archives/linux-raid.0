From: Tyler <pml@dtbb.net>
Subject: Wierd issue with hard-drive, unable to write to/change it
Date: Thu, 29 Sep 2005 00:15:06 -0700
Message-ID: <433B947A.3040606@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Linux IDE Mailing List <linux-ide@vger.kernel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've got a hard-drive that is connected to a Promise IDE Controller 
(20268 chipset) as a primary (cable select) drive, and with a second 
drive on the cable as slave (cable select).  Currently, fdisk claims it 
as having an invalid partition table.  Mdadm examine shows it as being 
part of an old array (the array is long since history and 
disassembled).  If I try to write a partition table to it, using fdisk, 
cfdisk, parted, and a few other utililities available in the debian 
repository, it claims success upon writing the changed partition table 
to the drive, no sync problem, but for posterity, I reboot the machine 
after the fdisk changes anyways.  However, the problem is that no 
changes I make to the drives partition table (or even dd if=/dev/zero 
of=/dev/hdi bs=4096, or mdadm --zero-superblock (v1.9, 2.1)) are saved...

If you try a 'dd if=/dev/hdi of=testing bs=4096 count=1' , the testing 
file shows what seems to be an XFS filesystem identifier (this is all 
after trying to dd the drive with zero's, and trying remove any 
superblocks at the end and beginning of the drive).  Its as if the drive 
is in some wierd, read-only mode... (hdparm reports readonly: no), and 
there are no error messages when trying to write partition info, or 
dd'ing the drive with zero's.. it just happily accepts the commands, but 
seemingly drops them in the garbage.

I've wasted several hours troubleshooting this... I've run Maxtors 
advanced diagnostics on the drive, and even it reports no problems.

I am stumped... any suggestions?

Notes: the slave drive on the same cable as this "bad drive", is the 
exact same model drive, and accepts changes with no problems (for 
example, creating a new raid 5 array with it, and then examining with 
mdadm -E, shows the new raid information).  I've tried both a 2.6.13.1 
kernel, and 2.4.31, and an older debian kernel as well.  I've tried an 
xfs_repair on the drive, hoping to fix *something* that may be amiss, 
and this seems to go into a loop of searching for different superblocks, 
it seems to start the search over continually (I'm assuming it checks 
where it thinks the backup superblocks should be, not finding any across 
the whole drive, then starting the search over again.. I left this for 
half an hour, with the same "messages" reporting over and over, in 
between the "........" status dots.)  I also tryed running smartctl -t 
long on the drive, and it says that the test is started, but looking at 
smartctl -a, there are no tests showing as active, and the drive is 
reported as healthy.

Notes2: The only ideas I have, is A) a fubar ide controller B) fubar 
drive without any useful diagnostic recognizing it C) something set as 
readonly... somewhere... only things I can think of are 1) jumper 2) 
bios 3) linux .... but shouldn't I get some kind of error if its 
readonly? .. not a "success" for dd'ing zero's to the drive, "success" 
for writing and syncing the partition table, "success" (no error 
message) doing an mdadm --zero-superblock

# fdisk -l /dev/hdi
Disk /dev/hdi: 251.0 GB, 251000193024 bytes
255 heads, 63 sectors/track, 30515 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

Disk /dev/hdi doesn't contain a valid partition table

# mdadm -E /dev/hdi
/dev/hdi:
          Magic : a92b4efc
        Version : 00.90.01
           UUID : 04037f85:22382a10:9b872a89:afbf8390
  Creation Time : Sun Apr 24 22:55:33 2005
     Raid Level : raid5
   Raid Devices : 6
  Total Devices : 6
Preferred Minor : 0

    Update Time : Mon Apr 25 09:09:12 2005
          State : clean
 Active Devices : 4
Working Devices : 5
 Failed Devices : 3
  Spare Devices : 1
       Checksum : abaa5d59 - correct
         Events : 0.4099634

         Layout : left-symmetric
     Chunk Size : 128K

      Number   Major   Minor   RaidDevice State
this     0      22        0        0      active sync   /dev/hdc

   0     0      22        0        0      active sync   /dev/hdc
   1     1      22       64        1      active sync   /dev/hdd
   2     2       0        0        2      faulty removed
   3     3      33       64        3      active sync   /dev/hdf
   4     4      34        0        4      active sync   /dev/hdg
   5     5       0        0        5      faulty removed
   6     6      34       64        5      spare   /dev/hdh

Thanks,
Tyler.


-- 
No virus found in this outgoing message.
Checked by AVG Anti-Virus.
Version: 7.0.344 / Virus Database: 267.11.7/112 - Release Date: 9/26/2005

