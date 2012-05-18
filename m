From: wilsonjonathan <piercing_male@hotmail.com>
Subject: resizing array to use spare space on disks.
Date: Fri, 18 May 2012 18:39:19 +0100
Message-ID: <BLU0-SMTP324B803A06987797A4C86FD981E0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have recently finished upgrading my workstation to include an existing
file server systems disks, 6 sata drives-1TB each, in addition to two
new disks on a sata card, 500GB each.

I have managed to get the raid6 partition, approx 3.8GB working size,
from the file server to be recognised and mounted ok.

I have also deleted the original raid setup partitions from the file
server that held the boot, root, *swap, home, and tempdata, so I now
have approx 100GB free at the beginning of each hard disk, so 400GB
workable storage if its added into the last remaining raid 6.

I have superblock/metadata 1.2 and the drives are all GPT partitioned.

Now my questions are...

1, Is it better/preferable to unmount the file system on the RAID?

2, Am I right in thinking that the the RAID must be running while I do
work on it, I cant just tear down the array, delete and recreate the
partition table entry to include the unused space on the 6 disks and
then restart the array?

3, Assuming 2 is "it must be running" then is the following the best way
to resize the array?

3a, mdadm /dev/md6 --fail /dev/sdX6 --remove /dev/sdX6

3b, delete and recreate the partition on /dev/sdX to use all the space

3c, mdadm --add /dev/md6 /dev/sdX 

3d, let it resync then repeat for the other 5 drives.

3e, mdadm --grow /dev/md6 --size=max

3f, e2fsck -f /dev/md6

3g, resize2fs /dev/md6

3h, e2fsck -f /dev/md6

And hopefully the jobs done!

4, Are there any other things I should specify or do such as using an
internal bitmap, or stopping it; or using a backupfile for 3e?

5, As the data on the partition does not get changed, only the partition
start sector, is there a way to tell mdadm not to resync as in theory
there has been no change to the contents of the drive after it was
removed and added back, especially as the file system was unmounted at
the time?

Thanks in advance.


