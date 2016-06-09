From: Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Subject: Low RAID10 performance during resync
Date: Thu, 9 Jun 2016 15:45:55 +0200
Message-ID: <20160609134555.GA9104@proton.igk.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

A low performance of mkfs has been observed on RAID10 array during resync. It is not so significant for NVMe drives but for my setup of RAID10 consisting of 4 SATA drives format time has increased by 200%.

I have looked into the problem and I have found out it is caused by this changeset:

commit 09314799e4f0589e52bafcd0ca3556c60468bc0e
md: remove 'go_faster' option from ->sync_request()

It seemed the code had been redundant and could be safely removed due to barriers mechanism but it proved otherwise. The barriers don't provide enough throttle to resync IOs. They only assure non-resync IOs and resync IOs are not being executed at the same time. In result resync IOs take around 25% of CPU time, mostly because there are many of them but only one at a time so a lot of CPU time is simply wasted waiting for a single IO to complete.

The removed sleep call in resync IO had allowed a lot of non-resync activity to be scheduled (nobody waiting for a barrier). Once sleep call had ended, resync IO had to wait longer to raise a barrier as all non-resync activity had to be completed first. It had nicely throttled a number of resync IOs in favour of non-resync activity. Since we lack it now, the performance has dropped badly.

I would like to revert the changeset. We don't have to put a resync IO to sleep for a second though. I have done some testing and it seems even a delay of 100ms is sufficient. It slows down resync IOs to the same extent as sleep for a second - the sleep call ends sooner but the barrier cannot be raised until non-resync IOs complete.

Is this solution ok?

Regards,

Tomek

