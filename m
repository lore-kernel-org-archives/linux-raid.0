From: mwilck@arcor.de
Subject: [PATCH 07/12] DDF: container_content_ddf: check for secondary RAID
Date: Fri,  1 Mar 2013 23:28:28 +0100
Message-ID: <1362176913-6804-8-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

Check for supportable secondary RAID configurations.
There is currently only one: RAID 10, if the stripe
sizes and Basic volume sizes are all equal.

With this patch, mdadm will not try to start unsupported
secondary RAID level configurations any more.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   73 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 73 insertions(+), 0 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index a5080dd..4186038 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3051,6 +3051,74 @@ static int load_container_ddf(struct supertype *st, int fd,
 
 #endif /* MDASSEMBLE */
 
+static int check_secondary(const struct vcl *vc)
+{
+	const struct vd_config *conf = &vc->conf;
+	int i;
+
+	/* The only DDF secondary RAID level md can support is
+	 * RAID 10, if the stripe sizes and Basic volume sizes
+	 * are all equal.
+	 * Other configurations could in theory be supported by exposing
+	 * the BVDs to user space and using device mapper for the secondary
+	 * mapping. So far we don't support that.
+	 */
+
+	__u64 sec_elements[4] = {0, 0, 0, 0};
+#define __set_sec_seen(n) (sec_elements[(n)>>6] |= (1<<((n)&63)))
+#define __was_sec_seen(n) ((sec_elements[(n)>>6] & (1<<((n)&63))) != 0)
+
+	if (vc->other_bvds == NULL) {
+		pr_err("No BVDs for secondary RAID found\n");
+		return -1;
+	}
+	if (conf->prl != DDF_RAID1) {
+		pr_err("Secondary RAID level only supported for mirrored BVD\n");
+		return -1;
+	}
+	if (conf->srl != DDF_2STRIPED && conf->srl != DDF_2SPANNED) {
+		pr_err("Secondary RAID level %d is unsupported\n",
+		       conf->srl);
+		return -1;
+	}
+	__set_sec_seen(conf->sec_elmnt_seq);
+	for (i = 0; i < conf->sec_elmnt_count-1; i++) {
+		const struct vd_config *bvd = vc->other_bvds[i];
+		if (bvd == NULL) {
+			pr_err("BVD %d is missing", i+1);
+			return -1;
+		}
+		if (bvd->srl != conf->srl) {
+			pr_err("Inconsistent secondary RAID level across BVDs\n");
+			return -1;
+		}
+		if (bvd->prl != conf->prl) {
+			pr_err("Different RAID levels for BVDs are unsupported\n");
+			return -1;
+		}
+		if (bvd->prim_elmnt_count != conf->prim_elmnt_count) {
+			pr_err("All BVDs must have the same number of primary elements\n");
+			return -1;
+		}
+		if (bvd->chunk_shift != conf->chunk_shift) {
+			pr_err("Different strip sizes for BVDs are unsupported\n");
+			return -1;
+		}
+		if (bvd->array_blocks != conf->array_blocks) {
+			pr_err("Different BVD sizes are unsupported\n");
+			return -1;
+		}
+		__set_sec_seen(bvd->sec_elmnt_seq);
+	}
+	for (i = 0; i < conf->sec_elmnt_count; i++) {
+		if (!__was_sec_seen(i)) {
+			pr_err("BVD %d is missing\n", i);
+			return -1;
+		}
+	}
+	return 0;
+}
+
 #define NO_SUCH_REFNUM (0xFFFFFFFF)
 static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
 					     __u32 refnum, unsigned int nmax)
@@ -3090,6 +3158,11 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		     *ep != '\0'))
 			continue;
 
+		if (vc->conf.sec_elmnt_count > 1) {
+			if (check_secondary(vc) != 0)
+				continue;
+		}
+
 		this = xcalloc(1, sizeof(*this));
 		this->next = rest;
 		rest = this;
-- 
1.7.3.4
