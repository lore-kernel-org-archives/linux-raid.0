From: Shaohua Li <shli@kernel.org>
Subject: [patch v3 0/5] raid5: make stripe handling multi-threading
Date: Tue, 27 Aug 2013 17:50:38 +0800
Message-ID: <20130827095038.303090029@kernel.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de, tj@kernel.org, dan.j.williams@gmail.com
List-Id: linux-raid.ids

Neil,

This set basically is the same as my previous post
http://marc.info/?l=linux-raid&m=137627404708265&w=2 except fixed two issues
you pointed out today. The first two patches are in your tree before, since you
rebased your for-next tree, I included here. Should apply to your for-next
cleanly.

Thanks,
Shaohua
