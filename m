From: "Mark Hilbush" <mark@hilbush.com>
Subject: Procedure for growing RAID1 array
Date: Sun, 12 Feb 2006 12:14:27 -0500 (EST)
Message-ID: <2030.69.143.89.15.1139764467.squirrel@hilbush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's still a little bit off in the distance, but I'll need to grow the
size of one of my RAID1 arrays.  I'm running mdadm 2.2 on an FC4 system,
and would appreciate some feedback on whether the following procedure
makes sense, or if there is something more efficient.  The idea is to
increase the size of one drive now, then do the other one some time later
(probably a few months), at which time I can then grow the size of the
array and the ext3 filesystem that sits on the array.

Here's the procedure.  Any and all comments are welcome.

- First, make sure I have a good backup

- Set drive 2 as faulty (e.g. mdadm --manage /dev/md0 --fail /dev/sdb1)

- Remove drive 2 (e.g. mdadm --manage /dev/md0 --remove /dev/sdb1)

- Add new drive and partition to be size of new drive (size of new drive
>> size of old drive)

- Add /dev/sdb1 back into the array (e.g. mdadm --manage /dev/md0 --add
/dev/sdb1)

...
Some months later
...

- Make sure I have a good backup

- Set drive 1 as faulty (e.g. mdadm --manage /dev/md0 --fail /dev/sda1)

- Remove drive 1 (e.g. mdadm --manage /dev/md0 --remove /dev/sda1)

- Add new drive and partition to be same size as drive 2 above

- Add /dev/sda1 back into the array & wait for resync to finish (e.g.
mdadm --manage /dev/md0 --add /dev/sda1)

- Grow array to be the full size of the new partitions (e.g. mdadm --grow
--size=max /dev/md0)

- Unmount the ext3 filesystem

- Resize the ext3 filesystem (e.g. resize2fs -p /dev/md0)

- Do a check of the filesystem

- Mount ext3 filesystem and I'm good to go


Thanks again for the feedback.

Mark Hilbush


