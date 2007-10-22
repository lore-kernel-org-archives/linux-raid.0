From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 2] md: Fixes for md in 2.6.23
Date: Mon, 22 Oct 2007 17:15:27 +1000
Message-ID: <20071022171426.31103.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, Stable <stable@kernel.org>, M@suse.de
List-Id: linux-raid.ids


It appears that a couple of bugs slipped in to md for 2.6.23.
These two patches fix them and are appropriate for 2.6.23.y as well
as 2.6.24-rcX

Thanks,
NeilBrown

 [PATCH 001 of 2] md: Fix an unsigned compare to allow creation of bitmaps with v1.0 metadata.
 [PATCH 002 of 2] md: raid5: fix clearing of biofill operations
