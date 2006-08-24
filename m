From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 2] md: Fix a bug with backward event updates.
Date: Thu, 24 Aug 2006 17:20:13 +1000
Message-ID: <20060824171215.14077.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi Andrew,

There is a bug in 2.6.18-rc which needs to be fixed before -final,
but there is a patch in -mm which is not scheduled for 2.6.18 which
touches the same code - so that patch has to change.

So:
 wind back to 
    md-replace-magic-numbers-in-sb_dirty-with-well-defined-bit-flags.patch
 discard that patch.
 Apply 1 of 2 following - that needs to go to Linux (or Greg)
 Then apply 2 of 2 to replace the one that was removed.
 Then you should be able to wind forwards again and everything will apply.

(If there is some other way you would like me to deal with this
 situation - just say so).

Thanks,
NeilBrown


 [PATCH 001 of 2] md: Avoid backward event updates in md superblock when degraded.
 [PATCH 002 of 2] md: replace magic numbers in sb_dirty with well defined bit flags
