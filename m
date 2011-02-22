From: hansbkk@gmail.com
Subject: Combining RAID6 and mdadm RAID10?
Date: Tue, 22 Feb 2011 22:43:28 +0700
Message-ID: <AANLkTi=xDHboFKj01RU9wM9k-UNhR+skf6jjdcGRM2Qc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is this a crazy idea?

In order to get the greater "top-level" fault-tolerance and expansion
flexibility of RAID6, run it over components made up of RAID10 arrays.

Yes, costly, but not so much more than straight RAID10 when you get
past say a dozen components.

And if you're able to replace drives relatively quickly, the RAID10
recovery completes quickly enough that the top RAID6 layer would
rarely get degraded at all, seems to me reducing the likelihood of
hitting the multiple-disks-failing-during-rebuild problem with today's
large drives.

I imagine running RAID10 above RAID6 would make less sense, right?

Say the RAID10 components were 6-10 drives each, would the performance
advantage over plain RAID1 pairs make the added complexity worthwhile?

Any and all feedback welcome. . .
