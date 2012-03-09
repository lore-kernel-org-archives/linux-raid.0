From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: re-adding a disk to a raid1 array with bitmap
Date: Fri, 09 Mar 2012 17:07:42 +0100
Message-ID: <4F5A2ACE.4090003@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "Brown, Neil" <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,

I have been spinning my head over this for a bit trying to figure out
what is the right solution to this problem.

In bedd86b7773fd97f0d708cc0c371c8963ba7ba9a you added a test to reject
re-adding a drive to an array in some cases.

The problem I have been looking at is if one has a raid1 with a bitmap.
Basically in the situation where we have one of the drives pulled from
the array, then if I try to add it back, it fails like this:

[root@monkeybay ~]#  mdadm -I --run /dev/sdf5
mdadm: failed to add /dev/sdf5 to /dev/md32: Invalid argument.

However this works:

[root@monkeybay ~]# mdadm -a /dev/md32 /dev/sdf5
mdadm: re-added /dev/sdf5

I dug through the kernel and it shows up that the failure is due to this
test in the above mentioned commit:

+                    rdev->raid_disk != info->raid_disk)) {

So basically when doing -I it seems the disk itself expects to be
raid_disk = 0, whereas the kernel expects it should be raid_disk = 1.

I agree with the previous discussion that it makes sense to reject a
drive in the normal case without a bitmap. However it seems illogical to
me that -a works but -I should fail in this case.

What would be the right fix here? Relaxing the test in the kernel to not
require the raid_disk numbers match up for a bitmap raid, or should
mdadm be taught to examine the raids and set the expected disk number
before submitting the add_new_disk ioctl?

Cheers,
Jes
