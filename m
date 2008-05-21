From: Cry <cry_regarder@yahoo.com>
Subject: RAID-6, dmcrypt, lvm, ext3
Date: Wed, 21 May 2008 23:18:07 +0000 (UTC)
Message-ID: <loom.20080521T231352-378@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sentient beings,

I am going to be building a 5 disk (1TB seagate) raid-6 array.  To avoid having
to spend massive amounts of time wiping the disks when I'm done, I'd like to
keep the data encrypted on them.  

What is the best layer order?  I am thinking the best stack is

raid-6 to make /dev/md0

cryptsetup on /dev/md0 to make /dev/mapper/cryptpv0

lvm on /dev/mapper/cryptpv0

and then 

ext3 on a partition of the lvm volume.

Does that make sense?  Or should I just cryptsetup the particular partions on
the lvm?

Thanks for any advice/sanity checks.

Cry

