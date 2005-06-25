From: David Wuertele <dave-gnus@bfnet.com>
Subject: OOPS!  Did I screw myself with mdadm --create?
Date: 25 Jun 2005 16:45:03 -0700
Message-ID: <m364w22e80.fsf@bfnet.com>
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

I had an /etc/mdadm.conf file lying around, and I happened to compare
the uuid in the /etc/mdadm.conf file and on one of the partitions.
They did not match!!!

Did I forever ruin my raid array?  Is there a way to recover my
reiserfs superblock and the original array data?

Thanks,
Dave

