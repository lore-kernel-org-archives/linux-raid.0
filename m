From: shli@kernel.org
Subject: [patch 0/3] raid5: make stripe handling multi-threading
Date: Tue, 30 Jul 2013 13:52:07 +0800
Message-ID: <20130730055207.698660010@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, djbw@fb.com
List-Id: linux-raid.ids

Neil,

This is another attempt to make raid5 stripe handling multi-threading.
Recent workqueue improvement for unbound workqueue looks very promising to the
raid5 usage. I had details in the first patch.

The patches are against your tree with patch 'raid5: make release_stripe
lockless' and 'raid5: fix stripe release order' but without 'raid5: create
multiple threads to handle stripes'

Thanks,
Shaohua
