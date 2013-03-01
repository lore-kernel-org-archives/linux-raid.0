From: mwilck@arcor.de
Subject: [PATCH 06/12] DDF: container_content_ddf: change array disk search loop
Date: Fri,  1 Mar 2013 23:28:27 +0100
Message-ID: <1362176913-6804-7-git-send-email-mwilck@arcor.de>
References: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1362176913-6804-1-git-send-email-mwilck@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: neilb@suse.de, linux-raid@vger.kernel.org
Cc: mwilck@arcor.de
List-Id: linux-raid.ids

When searching for container elements, loop over the known phys
disks rather than the elements of the current configuration.

This patch changes nothing in the logic or return value of the code.
It just prepares extended logic for handling RAID10.

Signed-off-by: Martin Wilck <mwilck@arcor.de>
---
 super-ddf.c |   33 +++++++++++++++++++++------------
 1 files changed, 21 insertions(+), 12 deletions(-)

diff --git a/super-ddf.c b/super-ddf.c
index 5426d29..a5080dd 100644
--- a/super-ddf.c
+++ b/super-ddf.c
@@ -3051,6 +3051,17 @@ static int load_container_ddf(struct supertype *st, int fd,
 
 #endif /* MDASSEMBLE */
 
+#define NO_SUCH_REFNUM (0xFFFFFFFF)
+static unsigned int get_pd_index_from_refnum(const struct vcl *vc,
+					     __u32 refnum, unsigned int nmax)
+{
+	unsigned int i;
+	for (i = 0 ; i < nmax ; i++)
+		if (vc->conf.phys_refnum[i] == refnum)
+			return i;
+	return NO_SUCH_REFNUM;
+}
+
 static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray)
 {
 	/* Given a container loaded by load_super_ddf_all,
@@ -3072,6 +3083,7 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 		struct mdinfo *this;
 		char *ep;
 		__u32 *cptr;
+		unsigned int pd;
 
 		if (subarray &&
 		    (strtoul(subarray, &ep, 10) != vc->vcnum ||
@@ -3125,21 +3137,12 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			devnum2devname(st->container_dev),
 			this->container_member);
 
-		for (i = 0 ; i < ddf->mppe ; i++) {
+		for (pd = 0; pd < __be16_to_cpu(ddf->phys->used_pdes); pd++) {
 			struct mdinfo *dev;
 			struct dl *d;
 			int stt;
-			int pd;
 
-			if (vc->conf.phys_refnum[i] == 0xFFFFFFFF)
-				continue;
-
-			for (pd = __be16_to_cpu(ddf->phys->used_pdes);
-			     pd--;)
-				if (ddf->phys->entries[pd].refnum
-				    == vc->conf.phys_refnum[i])
-					break;
-			if (pd < 0)
+			if (ddf->phys->entries[pd].refnum == 0xFFFFFFFF)
 				continue;
 
 			stt = __be16_to_cpu(ddf->phys->entries[pd].state);
@@ -3147,10 +3150,16 @@ static struct mdinfo *container_content_ddf(struct supertype *st, char *subarray
 			    != DDF_Online)
 				continue;
 
+			i = get_pd_index_from_refnum(
+				vc, ddf->phys->entries[pd].refnum, ddf->mppe);
+			if (i == NO_SUCH_REFNUM)
+				continue;
+
 			this->array.working_disks++;
 
 			for (d = ddf->dlist; d ; d=d->next)
-				if (d->disk.refnum == vc->conf.phys_refnum[i])
+				if (d->disk.refnum ==
+				    ddf->phys->entries[pd].refnum)
 					break;
 			if (d == NULL)
 				/* Haven't found that one yet, maybe there are others */
-- 
1.7.3.4
