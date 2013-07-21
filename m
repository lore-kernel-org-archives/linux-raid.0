From: mwilck@arcor.de
Subject: [PATCH 5/6] DDF: add_other_bvd: fix endianness bug
Date: Sun, 21 Jul 2013 19:28:23 +0200
Message-ID: <1374427704-7903-6-git-send-email-mwilck@arcor.de>
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
index bd42194..ff71be2 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -949,7 +949,8 @@ static void add_other_bvd(struct vcl *vcl, struct vd_config *vd,
 			break;
 
 	if (i < vcl->conf.sec_elmnt_count-1) {
-		if (vd->seqnum <= vcl->other_bvds[i]->seqnum)
+		if (be32_to_cpu(vd->seqnum) <=
+		    be32_to_cpu(vcl->other_bvds[i]->seqnum))
 			return;
 	} else {
 		for (i = 0; i < vcl->conf.sec_elmnt_count-1; i++)
-- 
1.7.1
