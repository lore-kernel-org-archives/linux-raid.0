From: NeilBrown <neilb@suse.de>
Subject: [PATCH 00/18] Assorted md patches headed for 2.6.30
Date: Thu, 12 Feb 2009 14:10:10 +1100
Message-ID: <20090212031009.23983.14496.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
 following is my current patch queue for 2.6.30, in case anyone would
like to review or otherwise comment.
They should show up in -next shortly.

Probably the most interesting are the last few which provide support
for converting a raid1 into a raid5, and a raid5 into a raid6.
I plan to do some more work here so the code might change a bit before
final submission, as I work out how best ot factor the code.

mdadm doesn't current support these conversions, but you can
simply
   echo raid5 > /sys/block/md0/md/level
to change a 2-drive raid1 into a raid5.  Similarly for 5->6

The raid6 array created will have a somewhat unusual layout in that
all the Q blocks will be on the last drive.  Later I'll create
functionality to restripe the array so that the Q block is rotated
around all the drives as you would expect.

Comments and testing very welcome.

Thanks,
NeilBrown



