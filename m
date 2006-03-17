From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 6] md: Introduction - patching those patches.
Date: Fri, 17 Mar 2006 18:21:21 +1100
Message-ID: <20060317181912.28543.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

This is the "Andrew Morton: Awesome code reviewer" patch series, that fixes
up issues identified in my recent series of md patches.

NeilBrown


 [PATCH 001 of 6] md: INIT_LIST_HEAD to LIST_HEAD conversions.
 [PATCH 002 of 6] md: Documentation and tidy up for resize_stripes
 [PATCH 003 of 6] md: Remove an unused variable.
 [PATCH 004 of 6] md: Improve comments about locking situation in raid5 make_request
 [PATCH 005 of 6] md: Remove some stray semi-colons after functions called in macro....
 [PATCH 006 of 6] md: Make new function stripe_to_pdidx static.
