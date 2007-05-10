From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 2] md: Two more bugfixes.
Date: Thu, 10 May 2007 16:22:19 +1000
Message-ID: <20070510161940.20204.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Neil Brown <neilb@suse.de>, stable@kernel.org
List-Id: linux-raid.ids

Following are two bugfixes for md in current kernels.
The first is suitable for -stable is it can allow drive errors
through to the filesystem wrongly.
Both are suitable for 2.6.22.

Thanks,
NeilBrown


 [PATCH 001 of 2] md: Avoid a possibility that a read error can wrongly propagate through md/raid1 to a filesystem.
 [PATCH 002 of 2] md: Improve the is_mddev_idle test
