From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 4] Introduction
Date: Tue, 08 Mar 2005 16:50:59 +1100
Message-ID: <20050308165021.3745.patches@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


4 patches for md/raid in 2.6.11-mm1

The first two are trivial and should apply equally to 2.6.11

The second two fix bugs that were introduced by the recent 
bitmap-based-intent-logging patches and so are not relevant
to 2.6.11 yet. 

[PATCH md 1 of 4] Fix typo in super_1_sync
[PATCH md 2 of 4] Erroneous sizeof use in raid1
[PATCH md 3 of 4] Initialise sync_blocks in raid1 resync
[PATCH md 4 of 4] Fix md deadlock due to md thread processing delayed requests.
