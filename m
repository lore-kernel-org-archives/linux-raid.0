From: mashtin.bakir@gmail.com
Subject: vess raid stripes disappear
Date: Thu, 9 May 2013 07:29:41 -0400
Message-ID: <CANSWD74J9HZCbE4ba1Y5UMRQjjDDZiof21-tUJOKdJmHBvuyXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have an interesting problem with a Vessraid 1830s.
We have a few of these that work fine but one seems
to lose its filesets. The only difference between the
good ones and the bad one is that the bad one has firmware
version 3.06 while the good ones are at 3.05 (This may
not be relevant).

Here's what happens. If I plug the raid into a 32 bit
RHEL5 box with large files enabled, syslog does pick
it up:

kernel: Vendor: Promise  Model:VessRAID 1830s Rev: 0306
Type: Direct-Access     ANSI SCSI revision: 05
SCSI device sdc:2929686528 2048-byte hdwr sectors (5999998 MB)


Using the web gui, I can carve out partitions,
I make three stripes across 4 disks of 2Terabytes each
using RAID5.
cat /proc/partitions   shows the raw devices as well as
the correct sizes. I then use gnu-parted (v3.1) to make the
filesets:

mklabel gpt
mkpart primray 0 0
set 1 raid on


I create the fileset using

mkfs.ext3 -m0 /dev/sdc1
I can then mount the FS and write to it.

If I either reboot the RAID or the host, the FS disappears
ie cat/proc/partitions   shows only sdc, not sdc1.
If I go back into parted, the label is intact
But I can't even mkfs without re-creating the label/partition,
in wich case I get:


...Have been written, but we have been
unable to
inform the kernel of the change, probably because it/they are in use.  As a
result, the old partition(s) will remain in use.  You should reboot now
before
making further changes.
Ignore/Cancel? i


Any ideas?

Thanks
