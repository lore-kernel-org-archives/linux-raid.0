From: andy liebman <andyliebman@aol.com>
Subject: Recipe for Mirrored OS Drives
Date: Sun, 01 Oct 2006 19:45:46 -0400
Message-ID: <4520532A.3090204@aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A few weeks ago, I promised that I would put my "recipe" here  for 
creating "mirrored OS drives from an existing OS Drive". This "recipe" 
combines what I learned from MANY OTHER sometimes conflicting documents 
on the same subject -- documents that were probably developed for 
earlier kernels and distributions.

I tried to follow the other instructions and always found that some 
steps didn't work for me or weren't necessary, or that some important 
steps were missing. I hope my recipe helps others who are trying to 
create mirrored drives with their recent Linux distributions.  

Please keep in mind the following:

1)  This recipe works with recent 2.6.x kernels and recent Linux 
distributions that use UDEV. Older distributions that rely on DEVFS and 
that include older versions of mdadm probably will require some 
variations in the steps. I tested this with Mandriva 2006 and a 2.6.16 
kernel.

2)  This recipe is designed for SATA drives and a motherboard with SATA 
controllers that are supported by the current Linux kernels. It might 
not work with all motherboards.

3)  If you have IDE drives instead of SATA drives, you should substitute 
"/dev/hdX" where I have "/dev/sdX"

4)   Many other instructions that I read claimed that it was necessary 
to create a separate boot partition in order to boot with mirrored 
drives. I found that I was able to create mirrored OS drives WITHOUT a 
separate boot partition. FYI -- My installation has three partitions -- 
the "root" partition "/" as well as a partition for "swap" and "home". 
You may have a different layout. Just go with the layout to which you 
are accustomed.

5)   This recipe does NOT require compiling RAID drivers or other 
drivers into the kernel. It uses an "initial ramdisk" (initrd) to load 
the required drivers during the early stages of booting up.

6)   The distribution YOU use may have some important differences from 
Mandriva 2006. For instance, Mandriva puts the mdadm.conf in /etc/ and 
some other distributions put it in /etc/mdadm/.  In addition, Mandriva 
doesn't require editing any sort of "initrd.conf" file in order to build 
a proper initrd so that it includes the required drivers. Your 
distribution may require you to specify what you want to put in the initrd.


Recipe for Creating Mirrored OS Drives from Exiting OS Drive


REQUIREMENTS:

-- One or Two NEW SATA drives of the same size. If only ONE, you must 
have an existing SATA drive of the SAME size that you can use as part of 
your mirrored pairs.
-- A Live CD/DVD Linux Distribution such as Mandriva One or Knoppix

CAUTION:

-- It is probably best to have two NEW SATA drives in addition to an 
existing SATA OS drive. However, if you decide to use your existing SATA 
drive as one of your RAID drives,  you should back up your existing OS 
drive. That way, if you make a mistake, you can always put the current 
SATA OS drive back in your system.

For Backup, I highly recommend using Acronis True Image. It's a great, 
fast, and relatively inexpensive imaging product that allows you to copy 
your existing OS image from one disk and restore it to another.


IF YOU WANT TO SWITCH FROM IDE TO SATA:

If you normally boot off of an IDE drive but want to switch to SATA, you 
can use Acronis True Image make an image from your IDE drive and then 
restore it to a SATA drive. Then, you only need to edit your /etc/fstab 
and boot loader configuration file (i.e., /etc/lilo.conf)  so that they 
refer to /dev/sdX instead of /dev/hdX.


THE PROCEDURE

-- Assuming you already boot from a SATA drive, install a second SATA 
drive. If you are going to use both drives as members of your mirrored 
pairs, the NEW drive should be the same size or larger than the first 
drive.

-- Boot your computer as you normally do from the SATA drive.

-- Assuming that your existing OS drive comes up as /dev/sda and that 
the new drive comes up as /dev/sdb, copy the partition layout from 
/dev/sda to /dev/sdb so that you have identical partition layouts on 
each disk:
    
            sfdisk -d /dev/sda | sfdisk /dev/sdb

-- Set the partition type on all /dev/sdb partitions to "raid autodetect 
-- type fd", except on any EXTENDED PARTITION. For example, assuming 
your root (/) partition is currently on /dev/sda1, and you have an 
extended partition on 2, and two logical partitions (swap and home) on 5 
and 6:  

            fdisk /dev/sdb
            ENTER "t"
            SELECT "1" for partition 1
            ENTER "fd" for partition type
            Repeat for partitions 5 and 6

-- Shutdown your computer

-- Reboot using a Live CD/DVD distribution (i.e., Mandriva One, or Knoppix)

-- Open a terminal (i.e., KDE's Konsole) and become root.
 
-- Create "degraded mirrored RAIDS" on /dev/sdb1, /dev/sdb5, /dev/sdb6 
(or on ALL partitions that are part of your OS drive and that you want 
to mirror). The basic idea is that your motherboard probably only has 
built-in support for two SATA drives. In order to copy your existing OS 
from the current standalone SATA drive to the mirrored drives, you have 
to create the mirrors such that they are initially MISSING their second 
parts. You will add the second parts latter after you copy everything 
from the standalone SATA OS drive.

        mdadm -Cv -ayes /dev/md0 -n2 -l1 missing /dev/sdb1
        mdadm -Cv -ayes /dev/md1 -n2 -l1 missing /dev/sdb5
        mdadm -Cv -ayes /dev/md2 -n2 -l1 missing /dev/sdb6

-- Confirm that the RAIDS are running:

        cat /proc/mdstat

    You should see that each RAID is listed as "_U"

-- Format the md devices. For example:
 
        mkfs.ext3 /dev/md0
        mkswap /dev/md1
        mkfs.ext3 /dev/md2

-- Make mountpoints for old and new partitions. This assumes your "Live 
Distro" allows you to create new mountpoints inside /mnt.

         mkdir /mnt/oldroot
         mkdir /mnt/oldhome
         mkdir /mnt/newroot
         mkdir /mnt/newhome

-- Mount partitions from /dev/sdaX (the original OS drive) and from the 
NEW /md devices (the "degraded" md devices you just created above).      

         mount -t ext3 /dev/sda1 /mnt/oldroot
         mount -t ext3 /dev/sda5 /mnt/oldhome
         mount -t ext3 /dev/md0 /mnt/newroot
         mount -t ext3 /dev/md2 /mnt/newhome

-- Run rsync to copy contents from your existing OS drive

         rsync -av /mnt/oldroot /mnt/newroot
         rsync -av /mnt/oldhome /mnt/newhome

NOTE: Running rsync from your Live Distro will avoid copying over any 
unwanted files from /proc or any "lock files" or "PID" files that SHOULD 
NOT be copied.


-- edit fstab on /mnt/newroot/etc/fstab so that you will be mounting mdX 
devices and not sdX devices. You can use an editor such as "vim" or 
"emacs". For example:

    vim /mnt/newroot/etc/fstab

    Makes sure the "/", "swap" and "home" partitions refer to     
    "/dev/mdX" instead of "/dev/sdX"

        /dev/md0 /
        /dev/md2  /home
        cdrom
        proc
        /dev/md1 swap
 
-- edit lilo.conf (if you use the LILO bootloader). If you use GRUB, 
you'll have to figure out what to do in YOUR case.

        vim /mnt/newroot/etc/lilo.conf

        Set "boot=/dev/md0"  (no quotes)
        Add line to lilo.conf main section that says:
              "raid-extra-boot=/dev/sda,/dev/sdb"  (no quotes)
        change root=/dev/md0 on all kernels
        change resume=/dev/md1 on all kernels  (assuming your swap
        partition is /dev/md1

-- If you were planning to remove your existing OS drive and replace it 
with a new drive, SHUTDOWN NOW. Remove the original SATA OS drive. 
Replace it with a NEW SATA drive (same size as the other one you 
installed at the beginning). Then reboot again with your LIVE Distro and 
skip down TWO steps to where it says "copy partition layout from 
/dev/sdb to /dev/sda"

OR

If you plan on using your existing OS drive as part of your mirrored OS 
drive, follow the next two instructions

 
-- Unmount /dev/sda partitions. You may need to close your Terminal 
window and open it again so that it doesn't tell you the partitions are 
"busy"

        umount /mnt/oldroot
        umount /mnt/oldhome



Delete partitions on /dev/sda

        fdisk /dev/sda
        SELECT "d" for "delete"
        SELECT "6" for "partition 6"
        SELECT "d" for "delete"
        SELECT "5" for "partition 5"
        SELECT "d" for "delete"
        SELECT "2" for "partition 2"
        SELECT "d" for "delete"
        SELECT "1" for "partition 1"


-- copy partition layout from /dev/sdb to /dev/sda
     
        sfdisk -d /dev/sdb | sfdisk /dev/sda

    
-- add partitions from /dev/sda to each "degraded" md device (which 
currently only consist of partitions from /dev/sdb.

        mdadm /dev/md0 -a /dev/sda1
        mdadm /dev/md1 -a /dev/sda5
        mdadm /dev/md2 -a /dev/sda6

-- Check resyncing progress with

        cat /proc/mdstat

-- WHEN resyncing is done, copy your running RAID configuration to 
mdadm.conf.  To do that,
as root type:

        mdadm --detail --scan >> /mnt/newroot/etc/mdadm.conf

-- Edit your new /mnt/newroot/etc/mdadm.conf file.   This file will need 
TWO extra instructions in order to start the RAIDS automatically on 
booting. Open the file with a text editor. For example:

        vim /mnt/newroot/etc.mdadm.conf

        At at top of mdadm.conf, add:

        DEVICE /dev/sda1 /dev/sda5 /dev/sda6 /dev/sdb1 /dev/sdb5 /dev/sdb6

    (Note: be sure to include any other partitions that are part of your 
RAID 1 mirrored pairs. For example, if you have a separate partition for 
/usr you might need to add another listing. If your drives are NOT sda 
and sdb, use the correct device letters

        Next, at the end of each ARRAY statement add:
    
        auto=yes

    The above option, "auto=yes" is required if you are running under 
UDEV so that mdadm will recreate the device nodes /dev/md1 and /dev/md2 
EACH time you boot. Leave a space before "auto" and the UUID number.

-- chroot to /mnt/newroot

        chroot /mnt/newroot

-- run mkinitrd. For example:

        /sbin/mkinitrd -v /boot/initrd-2.6.16.20.img 2.6.16.20

Substitute YOUR EXACT KERNEL for 2.6.16.20 (which is the kernel I am 
running)

In MY case I also had to tell mkinitrd NOT to worry about a 3ware driver 
(3w_9xxx) that I use for my storage arrays because it wasn't finding it. 
I think that's because there's an inconsistency between the name of the 
3ware driver (with an underscore "_") and the name of the driver file 
3w-9xxx.ko (with a dash "-"). Having a "--builtin" statement (see below) 
tells mkinitrd that the driver is built into the kernel so not to worry 
about putting the module into the initrd. In my case, the driver is NOT 
built into the kernel, but I don't need the driver to be present early 
in the boot process so it's okay to load it later.

    /sbin/mkinitrd -v --builtin=3w_9xxx /boot/initrd-2.6.16.20-es1.img 
2.6.16.20-es1


-- run lilo

       /sbin/lilo
        
-- exit chroot environment

       exit

-- unmount RAIDS

        umount /dev/md0
        umount /dev/md1
        umount /dev/md2

-- stop RAIDS

        mdadm --stop /dev/md2
        mdadm --stop /dev/md1
        mdadm --stop /dev/md0

NOTE:  I perform the above two steps because I have seen various Live 
CDs crash or freeze on exit and I want to be sure I have cleanly 
unmounted and stopped my RAIDs before rebooting.

-- reboot without Live CD to be sure everything is working. Your 
MIRRORED OS DRIVE should now boot.


I hope that works for you. Please feel free to pass these instructions 
along to other.

Andy Liebman
