From: Daniel Sievers <Daniel.Sievers@post.rwth-aachen.de>
Subject: raid5 and bad blocks
Date: Sat, 17 Jan 2004 10:48:29 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <400904ED.8030303@post.rwth-aachen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

recently i have been running in a lot of trouble with harddisks, that
are developing bad blocks over time.

example scenario:
1 disk fails (for whatever reason) and gets kicked out of the array.
then a resync fails because one of the other disk has developed bad
blocks. the raid volume is not operational or resyncable anymore now.

here are some naive thoughts i had:

1) an option to disable degraded mode (or turn array read-only when
switching to degraded mode). i had disks fail once but (at least  for a
while) work fine later again. i would like the opportunity to try assure
data reconstruction before the kicked-out disk gets completely out-of-date.

without really having studied the code, would some simple change like
this work to disable degraded mode on disk fail?
if (!rdev->faulty) {
    stop(mddev);
    printk(KERN_ALERT, "raid5: Disk failure on %s, stopping raid."
    , bdevname(rdev->bdev,b));
  }

2) would it make sense to let resync finish even when encountering bad
blocks? could the filesystem be reported bad blocks on the affected
areas instead?

3) even better... actually in most cases bad blocks on several disks but
in different areas should still allow a complete reconstruction. correct?
the driver being able to compute the correct sectors across different
disks would be kick-ass :))
but of course then some reserved space would be needed as a prerequisite.

i would be glad to hear some opinions about this.

thanks!
Daniel Sievers


