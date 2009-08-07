From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Fri, 7 Aug 2009 11:51:33 +0200
Message-ID: <20090807095133.GB28746@rap.rap.dk>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop> <4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop> <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop> <4A7B708F.4050406@uga.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4A7B708F.4050406@uga.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Harold Pritchett <harold@uga.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 06, 2009 at 08:08:47PM -0400, Harold Pritchett wrote:
> Following this note is a draft of a "Mirrored Linux Mini How-to" document.
> It's primarily for my own use, but I will make it available to anyone who
> would like a copy.
>
> Before I do this, I would like input from this group as to whether it:
> 1. is a good idea?

It is a good idea to have a how-to. But tehere are already a few around.
I wrote something like it for our wiki at
http://linux-raid.osdl.org/index.php/Preventing_against_a_failing_disk
but with some more advanced features, such as you do not crash if one
disk fails, and you can reboot the system without a rescue disk, and you
get faster mirrored raid, avoiding the slow raid 1. It does not do LVM,
however, and I think that how-to should be enhanced with LVM.

maybe we could work together on an enhanced wiki description


> 2. has no obvious errors or problems?

I think it could be improved to have additional features, using the same
equipment. And I think it can be simplified.

> 3. will reliably work?

Most likely. However I think it can be made more robust.

> 4. Should I provide more details?  Or at least pointers to using fdisk, etc.

I would recommend  that actual CLI commands be described.
I think that helps more novice users a lot.

>
> Thanks for the assistance
>
> Harold
>
> ==============================================================================
>
> Mirrored Linux Mini How-to
>
> Install linux on two identical disk drives in such a way that the failure
> of either of the drives will allow the system to be recovered without any
> loss of data
>
> Both of the drives are partitioned exactly the same:
>      1.  3 primary partitions
>      2.  Partition 1 - size - 1GB format as Linux Raid (fd)
>      3.  Partition 2 - size = real memory size, format as linux swap (82)
>      4.  Partition 3 = size = remainder of disk, format as linux raid (fd)
>
> To ensure that the partitions are correct, and in the correct order, boot from
> the install CD/DVD and run the rescue system.  Use fdisk from this system
> to partition the two drives.  (The GUI disk partitioner which runs in the
> anaconda installer has a tendency to move partitions around without asking.
> We don't want this to happen!)  After saving the partition information on
> both drives, you can Run the Linux installer.  Select "custom" installation.

why not use sfdisk to copy the layout of one disk to another.
using sfdisk you can actually script much of this. 
That makes the how-to more robust.

>
> Define a raid 1 mirror named fd0 using the first partition on both drives
> Define a raid 1 mirror named fd1 using the third partition of both drives
>
> Define a linux ext3 filesystem on fd0.  Mount on /boot
> Define a linux Logical Volume Group named vg0 on fd1.
> Within vg0, define the following Logical Volumes:
>      lv00 - /
>      lv01 - /tmp
>      lv02 - /var
>      lv03 - /usr
>      lv04 - /usr/local
>      lv05 - /home
>      lv06 - /opt
> I'm from the old school.  I believe in lots of partitions.  Create any
> additional partitions you may need.  If you really want to, you can
> just create a single partition and put "/" in it.  You still will
> need the "/boot" partition since you can't boot from an LVM partition.

I think it is good to have a / , a /home, and possibly a /boot partition, 
but having more partitions is probably just shooting yourself in the
foot, because you may create space problems. Those smaill partitions can
easily hit some roof, like /var (when logs run full)  and /tmp (doing temporary
work like editing in big files), /opt and /usr/local (installing big new packages)
and why should /usr and / be on different partition - that beats me.

I don't remember, but can you change LVM sizes on active LVMs?
Anyway you are likely to run into space constraints on such a
multipartiton system, and overrun of just one of the partitions will
create a severe operation problem. Better pool all the space together...

Having the system on one partition faclitates if you want to upgrade
your system, or shift to another distribution, then you can make another
partition with the new system, and have a quick fallback path, while
preserving your actual data on a /home partition.

>
> You can now continue to install linux normally.  I usually do it twice.
> the first time is to get an idea of how big each partition should be
> and the second time is to get it right.

That is cumbersome, and probably caused by your use of many partitions.
It will turn some novices off.

>  Remember to leave some extra
> unallocated space in the volume group to be allocated later if one of your
> file systems fills up.  Read the linux logical volume manager docs.

an URL to one would be fine.
>
>
> In the event of a disk failure, follow the below procedure.
>
> 1.  Shutdown the system and remove the failed drive.
>
> 2.  If the second (non boot) drive is the failing drive, skip to step 9 below.
>
> 3.  Move the second (non boot) drive to the boot drive position.

why can't you boot from the working drive?
The system should be configured to do this.

> 4.  Boot from the linux rescue CD/DVD and start the system, no network.

better avoid the rescue cd by making the system bootable from both drives.'

> 5.  Use the "chroot /mnt/sysimage" command to mount the system.
>
> 6.  Run the command "/sbin/grub-install /dev/sda" or whatever your drive is
>     to write a boot image into the MBR of the new boot drive.
>
> 7.  Remove the CD/DVD and re-boot.  The system should boot on a single drive
>     and both raid array's will show no spare available.
>
> 8.  Shutdown the system
>
> 9.  Install a new drive, identical to the existing drive if possible.
>
> 10. Bring up the system and use fdisk to partition the new drive EXACTLY
>     the same as the existing drive.
>
> 11. Format the swap partition with "mkswap /dev/sdb2"
>
> 12. Add the mirror for the /boot partition with "mdadm --add /dev/md0 /dev/sdb1"
>     or whatever is appropriate for your system...
>
> 13. Add the mirror for the LVM partition with "mdadm --add /dev/md1 /dev/sdb3"
>     or whatever is appropriate for your system...
>
> 14. Wait for the mirror to sync.  It may take several hours

you can begin using the system immediately, while the raids are syncing.

it would be nice if you could reference our wiki, wherever you put up
your howto.

best regards
keld
