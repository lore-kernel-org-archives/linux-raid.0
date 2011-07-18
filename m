From: Lutz Vieweg <lvml@5t9.de>
Subject: SSDs vs. md/sync_speed_(min|max)
Date: Mon, 18 Jul 2011 20:42:04 +0200
Message-ID: <j01ups$vbc$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

just wanted to report some unexpected effects of the md/sync_speed_(min|max)
parameters when using MD RAID1 on SSDs:

While syncing from one SSD to another in a MD RAID1 (that was in use at that
time, but still had plenty of spare I/O bandwidth to spend),  I wanted to
increase the speed of that process. But md/sync_speed_max was already much
higher (200 MB/s) than the actual sync speed that MD reported (~ 30MB/s).
At the same time, the utilization of the SSD to read from was only at ~5 %.

So I wondered what was keeping MD from just reading faster.

I can only assume that MD is tuned for magnetic disks in that it assumes any
additional "reads" to some location on the source device will be pretty expensive,
so it is cautious about causing them.
But for SSDs, there's no extra cost for "seeking", so it would be perfectly fine
if the utilization of the source-device was e.g. 95% while synchronizing.

And with SSDs, reading tends to incur less "utilization" (as reported
by e.g. "iostat -dx 3") than writing - even if sequential reads/writes
appear to reach similar speeds.

I could help myself by setting md/sync_speed_min to 200 MB/s. That accelerated
the sync a lot while the source device still remained usable by others (~30%
utilization).


I would like to propose that if my assumption about the tuning for the penalty
of seeking on magnetic disks is right, implementation of some "SSD"-flag could
be a good idea to tune the algorithm otherwise.

Regards,

Lutz Vieweg


