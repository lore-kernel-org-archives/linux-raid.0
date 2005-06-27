From: David Wuertele <dave-gnus@bfnet.com>
Subject: Repost --- please help, did "mdadm --create" make my data unrecoverable?
Date: 27 Jun 2005 11:13:19 -0700
Message-ID: <m3irzzbrcw.fsf@bfnet.com>
References: <m364w22e80.fsf@bfnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I recently had a raid server hang, and after a reset the 1.5TB raid 5
array no longer mounted.  Being hasty, I messed around with mdadm
commands trying to find out what was going wrong, and in the process I
ran "mdadm -C" thinking that it was one of the steps for mounting an
existing array.  I suspect that this was a fatal error, because now
fsck.reiserfs can't find the superblock on the array!

I know how to create a new superblock for reiserfs, and rebuild the
tree, but that will only work if the data is still readable.  Should I
go ahead and try this, or should I first try to reassemble my raid to
find the correct configuration?

I had an /etc/mdadm.conf file lying around, and I happened to compare
the uuid in the /etc/mdadm.conf file and on one of the partitions.
They did not match!!!

Did I forever ruin my raid array?  Is there a way to recover my
reiserfs superblock and the original array data?

Thanks,
Dave

