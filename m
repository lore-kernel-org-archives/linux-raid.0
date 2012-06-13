From: Shaohua Li <shli@kernel.org>
Subject: [patch 0/3 v3] MD: improve raid1/10 write performance for fast storage
Date: Wed, 13 Jun 2012 17:11:43 +0800
Message-ID: <20120613091143.508417333@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk
List-Id: linux-raid.ids

In raid1/10, all write requests are dispatched in a single thread. In fast
storage, the thread is a bottleneck, because it dispatches request too slow.
Also the thread migrates freely, which makes request completion cpu not match
with submission cpu even driver/block layer has such capability. This will
cause bad cache issue. Both these are not a big deal for slow storage.

Switching the dispatching to percpu/perthread based dramatically increases
performance.  The more raid disk number is, the more performance boosts. In a
4-disk raid10 setup, this can double the throughput.

percpu/perthread based dispatch doesn't harm slow storage. This is the way how
raw device is accessed, and there is correct block plug set which can help do
request merge and reduce lock contention.

V2->V3:
rebase to latest tree and fix cpuhotplug issue

V1->V2:
1. droped direct dispatch patches. That has better performance imporvement, but
is hopelessly made correct.
2. Add a MD specific workqueue to do percpu dispatch.
