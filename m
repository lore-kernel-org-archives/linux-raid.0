From: Robin Whittle <rw@firstpr.com.au>
Subject: Re: [RAID] Creating mirror from existing data disk
Date: Mon, 19 Aug 2002 13:33:55 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D606723.C78789F@firstpr.com.au>
References: <20020819020928.4550.qmail@web20416.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

fred pasteck wrote:
 
> Hi all. Is it possible to take a disk with existing
> data on it and mirror it to an identical disk?

Here is what I do to create rotating off-site bootable hard-drive
backups.  I do this every month or two, along with nightly rotating
backups of all the main data to another machine via the LAN.  Its not
necessarily the best approach - I would be interested in how other
people achieve similar goals.

For instance, is it possible to temporarily synch the file system and
halt all activity on the RAID 1 partitions in question, and then do a
raw read of each partition on hda, gzipping it on the fly, to another
partition on the same or another drive, or via the LAN to another
computer?   If so, then this would be a way of creating files which
could be subsequently used on another machine to create a bootable clone
of the main system's RAID 1 drives, without having to turn off the main
machine, swap drives etc.   To be able to automatically save .gzips of
the RAID partitions to another machine, which could have a script to
write them to a drive to make it a bootable clone, would be a marvelous
thing! 

My permanently connected Linux machine is a Celeron 800 with Red Hat 7.2
software RAID 1 installed from the graphic installer on the CD-ROM. 
(Maybe RH7.3 has the graphic installer, and so the RAID installation
options, available via a Network install.  For RH7.2 I temporarily put a
CD-ROM as a slave on one IDE cable.  Normally I don't have a CD-ROM in
the machine at present, because I think its presence would stop that IDE
cable from running at full -100 or -66 speed.)

The hard drives are 20 gig IBM DTLA 60GXP units - after my three 75GXPs
and one earlier IBM drive all died and were replaced with 60GXPs.

Both 20 gig drives are in removable caddies.  (The bottom and top is
removed and there is a 120 mm, slowed (with a resistor) ball-bearing fan
between them blowing air onto one and sucking it from the other, so they
both run very cool indeed.)

Each drive is the sole device on its cable - the standard primary and
secondary IDE cables on the motherboard.  If I want to plug a CD-ROM
drive in, I have a special adaptor and cable so it goes into a third
caddy slot, on the secondary cable, with the CD-ROM drive mounted
outside the caddy.

In addition to the two drives A and B which are in constant use in the
system, I have another two identical drives C and D - the same model and
capacity.  These too are mounted in caddies.

The server connects to the Net via a 56k modem, and to the rest of the
system via Ethernet.   My aim is to make regular offsite backups on hard
drives so I can plug the drive into any Celeron/PIII machine (it won't
boot on a K6 or ordinary 100 MHz Pentium) with a modem connected to a
phone line, and that system will become my new server.   It is my mail
server, name server and a small web server.   This is intended to make
my setup robust against hard drive failure, my own misoperation,
hacking, fire and burglary.


Here's my procedure:

 1 - Give the "reboot" command.  Actually, it would be better to use
     "poweroff".

 2 - When the machine gets to the BIOS reboot stage again (this would
     not happen with "poweroff"), turn the power off.

 3 - Remove drive B (hdc = master on the secondary cable) in its caddy 
     from its slot.

 4 - Install backup drive-to-be-cloned drive C (or D) in its caddy in 
     that slot.  Now this is hdc.
   
 5 - Power up the machine.

 6 - When it gets to the Red Hat graphic screen, press Cntrl X to get
     the text-mode lilo prompt.  (This may be different for you 
     depending on your Linux distribution and if you are using GRUB 
     rather than LILO.)

 7 - Type "linux single".   The machine boots up in single-user mode,
     without requiring a password.  There is no attempt to start 
     the PPP daemon to connect to the Net with the modem, or to start
     the Ethernet driver etc.   The machine is not running any 
     background processes, as far as I know - or at least it is not 
     running any programs which can write to the hard drive.
 
 8 - Type "cat /proc/mdstat".  This should show each md running only
     from hda: "(U_)".   (See notes below about why this is the case.)

 9 - Give the command:

        cat /def/hda > /dev/hdc

     This copies every byte to the backup drive - the entire boot 
     sector, partition tables, data, RAID superblocks etc.   This 
     makes C a clone of drive A.

     With ATA-100 cables (I assume it is running ATA-100 or ATA-66),
     this takes about 20 minutes - 100 Megabytes a minute.

10 - When this is done, give the "reboot" command.  Again, I probably 
     should give the "poweroff" command instead.

11 - Turn off the power when the BIOS reboots.

12 - Take out C and re-install B.

13 - Turn on the machine and wait for it to boot Linux.  The machine
     will operate in degraded mode, running only on drive A, because
     some or all of the RAID superblock counters on A will be higher
     than on B.  At this point, I am running fully on the Net with
     no RAID redundancy.  

14 - Give the command to resynchronise the partitions on drive B to 
     match those of drive A.  I do this with a script:

       raidhotadd /dev/md4 /dev/hdc1
       raidhotadd /dev/md1 /dev/hdc5
       raidhotadd /dev/md0 /dev/hdc6
       raidhotadd /dev/md3 /dev/hdc7
       raidhotadd /dev/md2 /dev/hdc8
       raidhotadd /dev/md5 /dev/hdc9

     This produces no results on the command line.  It takes about 
     11 minutes to complete - with the drives in constant activity.

15 - Then I do:

       cat /proc/mdstat

     and expect to see all partitions part of their RAID device, 
     such as:

       md5 : active raid1 hda9[0] hdc9[1]
             10080384 blocks [2/2] [UU]

       md2 : active raid1 hda8[0] hdc8[1]
             1048704 blocks [2/2] [UU]

       md3 : active raid1 hda7[0] hdc7[1]
             524544 blocks [2/2] [UU]

       md0 : active raid1 hda6[0] hdc6[1]
             4194688 blocks [2/2] [UU]

       md1 : active raid1 hda5[0] hdc5[1]
             4194688 blocks [2/2] [UU]

       md4 : active raid1 hda1[0] hdc1[1]
             20544 blocks [2/2] [UU]

    (I have partitions for /, /boot (probably unnecessary now modern
    BIOSes can go over the old 1024 track boundary), /var/log, /home 
    and another big directory for backup data.)
    

I can prove that the cloned drive is bootable by plugging it into the 
first slot.  It will boot normally, in degraded mode because it finds no
hdc to run as RAID 1 with it.   I do this without the modem plugged into
the phone line, because I don't want it connecting to the Net, receiving
emails etc.


I have some concerns about the stage where I plug the backup drive into
the second slot and boot into single-user mode.   If the RAID system
decided to synchronise drive A from the second drive, then this would be
bad (though not distrous, since drive B has the same data and is not in
the machine).

This clearly can't happen when the backup drive has never been formatted
for Linux RAID.  But if I have already made it a clone of the system at
an earlier date, then it will be formatted for RAID.  Typically, its
counters would be lower than those of drive A, so if there was any
resynching, then it would be writing data from A to B.   But if, after I
cloned to drive B, I had installed a new Linux system on the machine,
then the superblock counters on A could be lower than on drive B, so the
RAID system might be tempted to synchronise A to B's data.

However, as far as I know, the RAID system will never automatically
resynch any partitions.  So I should be safe with this arrangement.  At
least, if I do something wrong, I still have drive B to go back to.

 - Robin


http://www.firstpr.com.au
