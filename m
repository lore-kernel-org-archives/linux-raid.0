From: Shaohua Li <shli@kernel.org>
Subject: [patch 0/4] MD: improve raid1/10 write performance for fast storage
Date: Wed, 23 May 2012 15:26:19 +0800
Message-ID: <20120523072619.670179001@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, axboe@kernel.dk, shli@fusionio.com
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
