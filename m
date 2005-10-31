From: NeilBrown <neilb@suse.de>
Subject: [PATCH md 000 of 2] Introduction
Date: Mon, 31 Oct 2005 16:58:50 +1100
Message-ID: <20051031165552.8151.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Two patches for md in 2.6.14-rc5-mm1 (First one depends on -mm stuff,
second should apply to most recent 2.6 kernels).

I'd like to review the sysfs a bit more before it goes to Linus, but
the rest can go anytime.
Thanks,
NeilBrown


 [PATCH md 001 of 2] Remove attempt to use dynamic names in sysfs for component devices on an MD array.
 [PATCH md 002 of 2] Allow md arrays to be started read-only (module parameter).
