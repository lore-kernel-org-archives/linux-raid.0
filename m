From: David Rientjes <rientjes@google.com>
Subject: [patch 1/6] md: remove dependency on __GFP_NOFAIL
Date: Mon, 16 Aug 2010 19:57:51 -0700 (PDT)
Message-ID: <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
caller.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/md/dm-region-hash.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -289,8 +289,12 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
 	struct dm_region *reg, *nreg;
 
 	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
-	if (unlikely(!nreg))
-		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
+	if (unlikely(!nreg)) {
+		/* FIXME: this may potentially loop forever */
+		do {
+			nreg = kmalloc(sizeof(*nreg), GFP_NOIO);
+		} while (!nreg);
+	}
 
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		      DM_RH_CLEAN : DM_RH_NOSYNC;
