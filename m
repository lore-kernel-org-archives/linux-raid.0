From: "Rob Bray" <raid@bymeinc.com>
Subject: Move superblock on partition resize?
Date: Wed, 7 Feb 2007 12:57:42 -0500 (EST)
Message-ID: <44918.192.168.0.1.1170871062.squirrel@bymeinc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I am trying to grow a raid5 volume in-place. I would like to expand the
partition boundaries, then grow raid5 into the newly-expanded partitions.
I was wondering if there is a way to move the superblock from the end of
the "old" partition to the end of the "new" partition. I've tried dd
if=/dev/sdX1 of=/dev/sdX1 bs=512 count=256
skip=(sizeOfOldPartitionInBlocks - 256) seek=(sizeOfNewPartitionInBlocks -
256) unsuccessfully. Also, copying the last 128KB (256 blocks) of the old
partition before the table modification to a file, and placing that data
at the tail of the new partition also yields no beans. I can drop one
drive at a time from the group, change the partition table, then hot-add
it, but a resync times 7 drives is a lot of juggling. Any ideas?

Thanks,
Rob

