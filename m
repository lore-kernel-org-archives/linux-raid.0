From: "Gordon Mohr (@ Bitzi)" <gojomo@bitzi.com>
Subject: Shrinking on-disk size of RAID1 array?
Date: Thu, 29 Sep 2005 23:02:34 -0700
Message-ID: <433CD4FA.6010603@bitzi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I'm hoping to shrink the per-component size of an active RAID1
array, so that I can transition the array to a smaller, faster
set of drives.

It appears I could do this by first shrinking the filesystem
(ext3) with 'parted' as described here...

http://www.gnu.org/software/parted/manual/html_mono/parted.html#SEC68

...and then use 'mdadm' with the '--grow' and '--size' options
to shrink my RAID1 array's extent on disks.

But, I can't find a reference to doing exactly this online,
the 'mdadm' man page is a little thin on 'grow' details, and
there's at least one suggestion that the 'mdadm' man page is
wrong about the units to use in the '--size' parameter. (See

http://www.issociate.de/board/post/250478/error_in_mdadm_man_page.html
)

So, could someone "in the know" give a sanity check to my
plan?

I've got a 2.6.12 kernel and I've got the following RAID1
arrays...

# cat /proc/mdstat
Personalities : [raid1]
md1 : active raid1 sdc3[2] sdb3[1] sda3[0]
       154087360 blocks [3/3] [UUU]

md0 : active raid1 sdc1[1] sdb1[2] sda1[0]
       104320 blocks [3/3] [UUU]

unused devices: <none>

I want to shrink /dev/md1 to about 70GB. The constituent
physical partitions look like this...

# fdisk /dev/sda

Command (m for help): p

Disk /dev/sda: 160.0 GB, 160041885696 bytes
255 heads, 63 sectors/track, 19457 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

    Device Boot      Start         End      Blocks   Id  System
/dev/sda1               1          13      104391   fd  Linux raid autodetect
/dev/sda2              14         274     2096482+  82  Linux swap
/dev/sda3             275       19457   154087447+  fd  Linux raid autodetect

I presume I should boot from a CD, then without /dev/md1
mounted, follow the instructions from the 'parted' docs to
resize filesystem to 70000 megabytes (or is it mebibytes?
the 'parted' doc isn't clear):

# parted /dev/md1
(parted) resize 1 0 70000
(parted) quit

Then, use 'mdadm' to shrink the array to the right size (which
I'm assuming is 70000MiB*1024KiB/MiB == 71680000 kebibytes):

# mdadm --grow /dev/md1 --size 71680000

Then reboot, and all should be well at the smaller size.

My main concerns:
(1) Are these the right steps? (Missing anything?)
(2) Are the 'parted' units truly meGAbytes?
(3) How should the 'mdadm' '--size' parameter be related
to the 'parted' parameter? (Is the man bug report suggesting
the '--size' must be specified in bytes, not kebibytes,
accurate? Do I have to deduct the 128K superblock space, or
is that done automatically?)

Thanks for any guidance!

- Gordon @ Bitzi


