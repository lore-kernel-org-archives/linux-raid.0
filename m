From: mwilck@arcor.de
Subject: [PATCH 6/6] DDF: ddf_set_disk: fix minor endianness bug
Date: Sun, 21 Jul 2013 19:28:24 +0200
Message-ID: <1374427704-7903-7-git-send-email-mwilck@arcor.de>
References: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1374427704-7903-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

---
 super-ddf.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index ff71be2..5a0c998 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -4170,7 +4170,8 @@ static void ddf_set_disk(struct active_array *a, int n, int state)
 			__func__, dl->pdnum, dl->major, dl->minor,
 			be32_to_cpu(dl->disk.refnum));
 		dprintf("%s: array %u disk %u ref %08x pd %d\n",
-			__func__, inst, n_bvd, vc->phys_refnum[n_bvd], pd);
+			__func__, inst, n_bvd,
+			be32_to_cpu(vc->phys_refnum[n_bvd]), pd);
 		if ((state & DS_INSYNC) && ! (state & DS_FAULTY)) {
 			pd = dl->pdnum; /* FIXME: is this really correct ? */
 			vc->phys_refnum[n_bvd] = dl->disk.refnum;
-- 
1.7.1
