From: Shaohua Li <shli@kernel.org>
Subject: [patch 0/3] raid5: relieve lock contention of get_active_stripe()
Date: Mon, 12 Aug 2013 10:24:34 +0800
Message-ID: <20130812022434.507702228@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, djbw@fb.com
List-Id: linux-raid.ids

Neil,

This is to relieve lock contention of get_active_stripe(), which is the last
place we have lock contention in stripe handling. For small size random write,
we have no lock contention now. For big size write, lock contention is still
there. Please check the third patch for detail.

Thanks,
Shaohua
