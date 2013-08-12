From: Shaohua Li <shli@kernel.org>
Subject: [patch 0/3 v2] raid5: make stripe handling multi-threading
Date: Mon, 12 Aug 2013 10:18:03 +0800
Message-ID: <20130812021803.325887805@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com, tj@kernel.org
List-Id: linux-raid.ids

Neil,

This is another attempt to make raid5 stripe handling multi-threading.
Recent workqueue improvement for unbound workqueue looks very promising to the
raid5 usage. I had details in the first patch.

The patches are against your tree with patch 'raid5: make release_stripe
lockless' and 'raid5: fix stripe release order' but without 'raid5: create
multiple threads to handle stripes'

My test setup has 7 PCIe SSD, chunksize 8k, stripe_cache_size 2048. If enabling
multi-threading, group_thread_cnt is set to 8.

randwrite	throughput(ratio) unpatch/patch		requestsize(sectors) unpatch/patch
4k		1/5.9					8/8
8k		1/5.5					16/13
16k		1/4.8					16/13
32k		1/4.6					18/14
64k		1/4.7					17/13
128k		1/4.2					23/16
256k		1/3.5					41/21
512k		1/3					75/28
1M		1/2.6					134/34

For example, in 1M randwrite test, patched kernel is 2.6x faster, but average
request sending to each disk is drop to 34 sectors from 134 sectors long.

Currently the biggest problem is request size is dropped, because there are
multiple threads dispatching requests. This indicates multi-threading might not
be proper for all setup, so I disable it by default in this version. But since
throughput is largly improved, I thought this isn't a blocking issue. I'm still
working on improving this, maybe schedule stripes from one block plug as a
whole.

Thanks,
Shaohua
