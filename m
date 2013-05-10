From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: SOLVED Re: vess raid stripes disappear
Date: Fri, 10 May 2013 02:55:34 -0500
Message-ID: <518CA7F6.4000000@hardwarefreak.com>
References: <CANSWD74J9HZCbE4ba1Y5UMRQjjDDZiof21-tUJOKdJmHBvuyXw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANSWD74J9HZCbE4ba1Y5UMRQjjDDZiof21-tUJOKdJmHBvuyXw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mashtin.bakir@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/9/2013 6:29 AM, mashtin.bakir@gmail.com wrote:
> I have an interesting problem with a Vessraid 1830s.
> We have a few of these that work fine but one seems
> to lose its filesets. The only difference between the
> good ones and the bad one is that the bad one has firmware
> version 3.06 while the good ones are at 3.05 (This may
> not be relevant).

It's not a firmware problem Mashtin.  The problem here is incomplete
education.  More accurately, the problem is that you've confused
concepts of hardware RAID and Linux software RAID.  I will attempt to
help you separate these so you understand the line in the sand
separating the two.

> Here's what happens. If I plug the raid into a 32 bit
> RHEL5 box with large files enabled, syslog does pick
> it up:
> 
> kernel: Vendor: Promise  Model:VessRAID 1830s Rev: 0306
> Type: Direct-Access     ANSI SCSI revision: 05
> SCSI device sdc:2929686528 2048-byte hdwr sectors (5999998 MB)

The kernel sees a single 6TB SCSI device/LUN presented by the Promise
array..

> Using the web gui, I can carve out partitions,

The Promise web gui doesn't create partitions.  That's the job of the
operating system.  What it does allow you to do is carve out multiple
virtual drives from a single RAID set and export them as individual LUNs.

> I make three stripes across 4 disks of 2Terabytes each
> using RAID5.

This is not possible with the Promise firmware.  I think you're simply
using incorrect terminology here.  According to your dmesg output above
you have created a single hardware RAID5 array of 4 disks, one 6TB
virtual drive, and exported it as a single LUN.

...
> I then use gnu-parted (v3.1) to make the
> filesets:

parted doesn't create "filesets".  It creates partitions.  What are
"filesets"?

> mklabel gpt
> mkpart primray 0 0

Ok so you created a primary partition.

> set 1 raid on

^^^^^^^^^^^^^^^

THIS IS THE PROBLEM.  "set 1 raid on" is used exclusively with Linux
software RAID.  What this does is tell the Kernel to look for a software
RAID superblock on the partition and auto start the array.  You are not
using md/RAID, but hardware RAID, so the superblock doesn't exist.  This
is the source of your problem.  This is where you have confused hardware
and software RAID concepts.

> I create the fileset using

Ok so when you say "fileset" you actually mean "file system".

> mkfs.ext3 -m0 /dev/sdc1
> I can then mount the FS and write to it.
> 
> If I either reboot the RAID or the host, the FS disappears
> ie cat/proc/partitions   shows only sdc, not sdc1.
> If I go back into parted, the label is intact
> But I can't even mkfs without re-creating the label/partition,
> in wich case I get:

This is a direct result of "set 1 raid on" as explained above.  You
should see other error messages in dmesg about no superblock being found.

> ...Have been written, but we have been
> unable to
> inform the kernel of the change, probably because it/they are in use.  As a
> result, the old partition(s) will remain in use.  You should reboot now
> before
> making further changes.
> Ignore/Cancel? i

Clearing the parted RAID flag on the partition should fix your problem,
assuming you haven't done anything else wonky WRT software RAID and this
partition that hasn't been presented here.

Always remember this:  Any time your see "RAID" setup or configuration
referenced in Linux documentation or cheat sheets on the web, it is
invariably referring to a kernel software function, either md/RAID,
dm-raid, etc.  It is never referring to hardware RAID devices.  If you
have a hardware RAID device you will never configure anything RAID
related in Linux, whether it be parted, grub, md, dm, etc.

-- 
Stan


