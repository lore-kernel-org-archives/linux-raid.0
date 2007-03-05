From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Replace drive in RAID5 without losing redundancy?
Date: Mon, 5 Mar 2007 11:55:39 +0100
Message-ID: <37643E71-0FD9-4F8A-AE68-A8565FEB0247@bj-ig.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

The day before I grew a 4 times 300GB disk RAID5. I replaced the 300GB
drives by 750GB ones. As far as I can see the proposed way to do that
is to kick a drive from RAID and let a spare drive take over - for
sensible data this is scary - at least for me, because I lose
redundancy for the whole time of rebuild. Everything worked fine - so
no harm is done - but is there a way to replace a disk without losing
redundancy?

Is it possible to mark a disk as "to be replaced by an existing spare",
then migrate to the spare disk and kick the old disk _after_ migration
has been done? Or not even kick - but mark as new spare.

This feature would be even more interesting for partially degraded
arrays with read problems on different disks which do not apply to the
same RAID chunk (up to now I've seen one array in such a state and this
one was able to recover by automatically rewriting the unreadable
sectors). The point is - I would have felt better if I had been able to
mark the old disks read only and migrate disk by disk without losing
the partially damaged redundancy.

Best Regards
Ralf Mueller

-- 
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.


