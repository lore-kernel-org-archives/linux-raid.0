From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 3] md: Introduction - 3 bugfixs for -mm
Date: Tue, 16 May 2006 11:12:56 +1000
Message-ID: <20060516111036.2649.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Reuben Farrelly <reuben-lkml@reub.net>
List-Id: linux-raid.ids

The first of these fixes issues with the new bmap based bitmap file
access code, and possibly should be an -mm hotfix, and without it,
'internal' bitmaps don't work any more :-(

Others are minor and unrelated.

Thanks,
NeilBrown


 [PATCH 001 of 3] md: Change md/bitmap file handling to use bmap to file blocks-fix
 [PATCH 002 of 3] md: Fix inverted test for 'repair' directive.
 [PATCH 003 of 3] md: Calculate correct array size for raid10 in new offset mode.
