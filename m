From: NeilBrown <neilb@cse.unsw.edu.au>
Subject: [PATCH md 003 of 7] Fix minor error in raid10 read-balancing calculation.
Date: Tue, 02 Aug 2005 19:53:41 +1000
Message-ID: <E1DztSv-0004VT-HM@notabene.cse.unsw.edu.au>
References: <20050802193525.12307.patches@notabene>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


'this_sector' is a virtual (array) address while 'head_position' is
a physical (device) address, so substraction doesn't make any sense.
devs[slot].addr should be used instead of this_sector.

However, this patch doesn't make much practical different to the read
balancing due to the effects of later code.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid10.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletion(-)

diff ./drivers/md/raid10.c~current~ ./drivers/md/raid10.c
--- ./drivers/md/raid10.c~current~	2005-08-02 15:22:31.000000000 +1000
+++ ./drivers/md/raid10.c	2005-08-02 15:22:31.000000000 +1000
@@ -538,7 +538,8 @@ static int read_balance(conf_t *conf, r1
 	}
 
 
-	current_distance = abs(this_sector - conf->mirrors[disk].head_position);
+	current_distance = abs(r10_bio->devs[slot].addr -
+			       conf->mirrors[disk].head_position);
 
 	/* Find the disk whose head is closest */
 
