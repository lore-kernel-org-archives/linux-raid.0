From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 3] md: a few little patches
Date: Fri, 7 Dec 2007 16:41:36 +1100
Message-ID: <20071207163806.7539.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

Following 3 patches for md provide some code tidyup and a small
functionality improvement.
They do not need to go into 2.6.24 but are definitely appropriate 25-rc1.

(Patches made against 2.6.24-rc3-mm2)

Thanks,
NeilBrown


 [PATCH 001 of 3] md: raid6: Fix mktable.c
 [PATCH 002 of 3] md: raid6: clean up the style of raid6test/test.c
 [PATCH 003 of 3] md: Update md bitmap during resync.
