From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Impending failure?
Date: Fri, 04 Nov 2011 18:05:53 +0000
Message-ID: <4EB42981.5080708@anonymous.org.uk>
References: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB1R3sh8=9imi41OTXRjf2ScoB=9WLZLHqL-WECOSyDuixVzrg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alex <mysqlstudent@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/11/2011 13:53, Alex wrote:
> Hi,
> I have a fedora15 system with two 80GB SATA disks using RAID1
[...]
> I believe the boot sector is installed on sda, which is also the bad
> disk. If I remove the disk to replace it, I'm concerned the system
> will no longer boot.
>
> Can you point me to instructions on the best way to replace a disk?

If you used Fedora's installer to set up the md RAIDs in the first 
place, you will be able to boot off the second drive, as the Fedora 
installer will have installed grub on it as well. You would have to tell 
your BIOS to boot from it though.

If you've room in the case and spare SATA ports for a third drive (with 
which to replace the failing drive), put it in and assuming it appears 
as sdc I'd do the switcheroo by growing the array to three drives then 
shrinking it again, something like this (all off the top of my head, so 
check it first by looking at the man page, which will help you 
understand what's going on anyway):

# sfdisk -d /dev/sda
Note down where sda1 starts. It will likely be either 63 or 2048.
# dd if=/dev/sda of=/dev/sdc bs=512 count=<howevermanyitwas>
This will copy the partition table and boot code.
# blockdev --rereadpt /dev/sdc
# mdadm /dev/md0 --add /dev/sdc1
# mdadm /dev/md1 --add /dev/sdc2
# mdadm --grow /dev/md0 -n3
# mdadm --grow /dev/md1 -n3
Wait for this to finish, either by looking at /proc/mdstat from time to 
time, or using mdadm --wait /dev/md1. This gives you a three-way mirror. 
It's possible this process will cause sda to fail, but that's OK. Next 
we want to remove the duff drive:
# mdadm /dev/md0 --fail /dev/sda1 --remove /dev/sda1
# mdadm /dev/md1 --fail /dev/sda2 --remove /dev/sda2
# mdadm --grow /dev/md0 -n2
# mdadm --grow /dev/md1 -n2

Now you can shut down again, and install the new drive in the place of 
the original failing drive.

Cheers,

John.

