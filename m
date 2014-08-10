From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: RAID10-shrink does not work
Date: Sun, 10 Aug 2014 18:46:57 +0200
Message-ID: <201408101646.s7AGkvDm009836@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear readers,

As you might have read in my former postings, I grew
a 13 disk raid10-array with near-2 layout into a 16 disk
array. The data is mirrored between all disks with even
numbers and all disks with odd numbers.

Now I learned that my disks have both a number and an id.
When you add a disk it will get the next number and it
does not matter wether you add one or more disks.

But when you grow an array by more then one disk, then
linux md will use the disks in an unpredictable way.

In my case I added three disks, they got id 13, 14 and 15
and when I grew my array from 13 to 16 disks these disk where
used in sequence: 14, 13, 15 

Since I have not grown the filsystem on my raid10-array I
can shrink the array back to 13 disks and then add each disk
one by one. Of course this will last three times longer than
adding all 3 disks in one operation. But I see no other
possibility to get a ono-to-one corresponding between ids
and numbers.

Unfortunately shrinking the raid10-array back to 13 devices
does not work:

# mdadm --grow /dev/md5 --array-size 12696988928
# mdadm --grow /dev/md5 --raid-devices=13
mdadm: Cannot set array shape for /dev/md5

I'm using mdadm 3.3 with linux 3.14.16

The mdadm-3.3 source code has only one line that prints
"Cannot set array shape". It's in Grow.c, function raid10_reshape()
and I added the following printf-statements:

printf("err=%d\n", err);
if (!err && sysfs_set_num(sra, NULL, "chunk_size", info->new_chunk) < 0)
        err = errno;
if(err) printf("chunk_size %d failed, err=%d, %s\n", info->new_chunk, err, strerror(errno));

mdadm will then output:

# ./mdadm --grow /dev/md5 --raid-devices=13
err=0
chunk_size 524288 failed, err=22, Invalid argument
mdadm: Cannot set array shape for /dev/md5

So the problem is caused by writing 512K to some sysfs-location
for a raid10-array that has already a chunk size of 512K !!

Strange - And why does this problem only occur on shrinking?

I cannot reproduce this problem with test-data. Adding 3 loop-devices
to a raid10-array consisting of 13 loop devices and then shrinking
it back to 13 devices worked with no problems.

Kind regards

Peter Koch
