From: "John Hendrikx" <hjohn@xs4all.nl>
Subject: Degraded array on every reboot
Date: Fri, 22 Jun 2007 14:51:03 +0200 (CEST)
Message-ID: <4755.10.3.3.3.1182516663.squirrel@swilver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I currently have a little problem where one my drives is kicked from
the raid array on every reboot.  dmesg claims the following:

md: md1 stoppped.
md: bind<sda1>
md: bind<sdc1>
md: could not open unknown-block(33,1).
md: md_import_device returned -6
md: bind<hdg1>
md: bind<hde>
md: bind<sdb1>
md: kicking non-fresh hde from array!
md: unbind<hde>
md: export_rdev(hde)
raid5: allocated 6284kB for md1
raid5: raid level 5 set md1 active with 5 out of 6 device, algorithm 2

I'm not sure why this keeps going wrong, but I do know I made a mistake
when initially reconstructing the array.  What I did was the following:

# mdadm /dev/md1 --add /dev/hde

Releazing that I didn't want to add the complete drive (/dev/hde) but only
one of its partitions (/dev/hde1) I then did (while it was still
rebuilding):

# mdadm /dev/md1 --fail /dev/hde
# mdadm /dev/md1 --remove /dev/hde

Then I recreated the partition /dev/hde1 because of course the partition
table was destroyed during the partial rebuild:

# fdisk /dev/hde
# fdisk -l /dev/hde

Disk /dev/hde: 300.0 GB, 300001443840 bytes
255 heads, 63 sectors/track, 36473 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot         Start        End    Blocks   Id   System
/dev/hde1                  1      36473 292969341   83   Linux

I then did:

# mdadm /dev/md1 --add /dev/hde1

I let it rebuild, and the system is working fine.  However, after a reboot
I get the above text in dmesg, and I have to re-add /dev/hde1 to the array
again.  Why it is trying to add /dev/hde I donot understand.  Another
funny thing is that when I try to re-add /dev/hde1 again, it won't work
immediately:

# mdadm /dev/md1 --add /dev/hde1
mdadm: cannot find /dev/hde1: No such file or directory

Which is odd, because fdisk still claims the partition is there:

# fdisk -l /dev/hde

Disk /dev/hde: 300.0 GB, 300001443840 bytes
255 heads, 63 sectors/track, 36473 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes

   Device Boot         Start        End    Blocks   Id   System
/dev/hde1                  1      36473 292969341   83   Linux

This clearly shows there is a /dev/hde1, no idea why mdadm doesn't see it.
 So I just run fdisk again, drop the partition, add a new one, and write
the table again.  Then mdadm sees it without problem.

# mdadm /dev/md1 --add /dev/hde1
mdadm: re-added /dev/hde1

One thing I noticed which may shed some light on this problem is the
following.  When I use mdadm --examine and examine when of the correctly
working drives, then I see a superblock on /dev/sda1 for example, but no
superblock when I use /dev/sda (which seems correct).

However, when I do this with /dev/hde1 and /dev/hde, both have a md
superblock, which may the cause of the confusion.  I'm not sure how to fix
this exactly (or why it happened in the first place) but I'm assuming that
if I can remove the md superblock from /dev/hde that the problem will be
gone.

I'm considering simply wiping /dev/hde completely so there's no trace of
the superblock and then re-adding it correctly, but perhaps there's a less
drastic way to do it.

Any insights would be appreciated :)

--John


