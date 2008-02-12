From: "George Spelvin" <linux@horizon.com>
Subject: Got raid10 assembled wrong - how to fix?
Date: Tue, 12 Feb 2008 11:59:00 -0500
Message-ID: <20080212165900.15511.qmail@science.horizon.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

I just discovered (the hard way, sigh, but not too much data loss) that a
4-drive RAID 10 array had the mirroring set up incorrectly.

Given 4 drvies A, B, C and D, I had intended to mirror A<->C and B<->D,
so that I could split the mirror and run on either (A,B) or (C,D).

However, it turns out that the mirror pairs are A<->B and C<->D.  So
pulling both A and B off-line results in a non-functional array.

So basically what I need to do is to decommission B and C, and rebuild
the array with them swapped: A, C, B, D.

Can someone tell me if the following incantation is correct?

mdadm /dev/mdX -f /dev/B -r /dev/B
mdadm /dev/mdX -f /dev/C -r /dev/C
mdadm --zero-superblock /dev/B
mdadm --zero-superblock /dev/C
mdadm /dev/mdX -a /dev/C
mdadm /dev/mdX -a /dev/B

I'm assuming that fresh spares will be assigned to the lowest available
slot.  I just get nervous about commands with names like --zero-superblock
when I have data I'd rather not lose.

Thanks!
