From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 0 of 2] Introduction
Date: Tue, 16 Nov 2004 15:45:49 +1100
Message-ID: <20041116153856.18330.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Following are two patches for md/linear.c in 2.6.10-rc1-mm5

The first fixes a bug that was recently introduced, that affects linear arrays
where the components aren't all the same size (I didn't test that case :-( ).
I would be good if this was in 2.6.10.

The second is a code cleanup and minor reduction in memory usage.
There is no particular hurry for this patch to go in.

NeilBrown

