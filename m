From: NeilBrown <neilb@suse.de>
Subject: [PATCH 000 of 3] md: Introduction
Date: Thu, 2 Feb 2006 17:02:01 +1100
Message-ID: <20060202165638.15890.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids


Three patches for 2.6.lastest. All should go in 2.6.16.
One won't apply against -rc1-git5 as it fixes a bug in a patch
in -mm that hasn't quite got to -linus yes.

They are mostly little fixes.  I've been doing some more testing,
particularly creating a raid1 over 2 6TB arrays.  This requires
version-1 superblocks, so they have had a bit more testing too.

(No, I didn't try to resync the 6TB raid1.  I created it 
--assume-clean and gave it a write-intent bitmap so a full resync
would never be needed.  If one side died, a recovery would take
ages!!!! but for me it was only an experiment, not a serious configuration).
(You will need mdadm-2.3 if you too want a 6TB raid1).


 [PATCH 001 of 3] md: Handle overflow of mdu_array_info_t->size better.
 [PATCH 002 of 3] md: Assorted little md fixes:
 [PATCH 003 of 3] md: Make sure rdev->size gets set for version-1 superblocks.
