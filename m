From: "George Spelvin" <linux@horizon.com>
Subject: 3-way mirrors
Date: 7 Sep 2010 10:19:04 -0400
Message-ID: <20100907141904.3696.qmail@science.horizon.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux@horizon.com
List-Id: linux-raid.ids

After some frustration with RAID-5 finding mismatches and not being
able to figure out which drive has the problem, I'm setting up a rather
intricate 5-way mirrored (x 2-way striped) system.

The intention is that 3 copies will be on line at any time (dropping to
2 in case of disk failure), while copies 4 and 5 will be kept off-site.
Occasionally one will come in, be re-synced, and then removed again.
(The file system can be quiesced briefly to permit a clean split.)

Anyway, one nice property of a 2-drive redundancy (3+-way mirror or
RAID-6) is error detection: in case of a mismatch, it's possible to
finger the offending drive.

My understanding of the current code is that it just copies one mirror
(the first readable?) to the others.  Does someone have a patch to vote
on the data?  If not, can someone point me at the relevant bit of code
and orient me enough that I can create it?

(The other thing I'd love is a more advanced sync_action that can accept a
block number found by "check" as a parameter to "repair" so I don't have
to wait while the array is re-scanned.  Um... I suppose this depends on
a local patch I have that logs the sector numbers of mismatches.)


Another thing I'm a bit worried about is the kernel's tendency to
add drives in the lowest-numbered open slot in a RAID.  When used in
multiply-mirrored RAID-10, this tends to fill up the first stripe hallf
before starting on the second.

I'm worried that someone not paying attention will --add rather than
--re-add the off-site backup drives and create mirrors 4 and 5 of
the first stripe half, thus producing an incomplete backup.

Any suggestions on how to mitigate this risk?  And if it happens,
how do I recover?  Is there a way to force a drive to be added
as 9/10, even if 5/10 is currently empty?


Thank you very much!
