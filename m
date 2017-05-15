From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/17] afs: switch to use uuid_t and uuid_gen
Date: Mon, 15 May 2017 17:43:01 +0200
Message-ID: <20170515154308.26739-11-hch@lst.de>
References: <20170515154308.26739-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170515154308.26739-1-hch-jcswGhMUV9g@public.gmane.org>
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
List-Help: <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org?subject=subscribe>
Errors-To: linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
To: Andy Shevchenko <andriy.shevchenko-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 fs/afs/cmservice.c | 46 +++++++++++++++++++++++-----------------------
 fs/afs/internal.h  |  2 +-
 fs/afs/main.c      |  4 ++--
 3 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/fs/afs/cmservice.c b/fs/afs/cmservice.c
index 3062cceb5c2a..d4e77d12570c 100644
--- a/fs/afs/cmservice.c
+++ b/fs/afs/cmservice.c
@@ -350,7 +350,7 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 {
 	struct sockaddr_rxrpc srx;
 	struct afs_server *server;
-	struct uuid_v1 *r;
+	uuid_t *r;
 	unsigned loop;
 	__be32 *b;
 	int ret;
@@ -380,20 +380,20 @@ static int afs_deliver_cb_init_call_back_state3(struct afs_call *call)
 		}
 
 		_debug("unmarshall UUID");
-		call->request = kmalloc(sizeof(struct uuid_v1), GFP_KERNEL);
+		call->request = kmalloc(sizeof(uuid_t), GFP_KERNEL);
 		if (!call->request)
 			return -ENOMEM;
 
 		b = call->buffer;
 		r = call->request;
-		r->time_low			= b[0];
-		r->time_mid			= htons(ntohl(b[1]));
-		r->time_hi_and_version		= htons(ntohl(b[2]));
-		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
-		r->clock_seq_low		= ntohl(b[4]);
+		r->v1.time_low			= b[0];
+		r->v1.time_mid			= htons(ntohl(b[1]));
+		r->v1.time_hi_and_version	= htons(ntohl(b[2]));
+		r->v1.clock_seq_hi_and_reserved = ntohl(b[3]);
+		r->v1.clock_seq_low		= ntohl(b[4]);
 
 		for (loop = 0; loop < 6; loop++)
-			r->node[loop] = ntohl(b[loop + 5]);
+			r->v1.node[loop] = ntohl(b[loop + 5]);
 
 		call->offset = 0;
 		call->unmarshall++;
@@ -453,7 +453,7 @@ static int afs_deliver_cb_probe(struct afs_call *call)
 static void SRXAFSCB_ProbeUuid(struct work_struct *work)
 {
 	struct afs_call *call = container_of(work, struct afs_call, work);
-	struct uuid_v1 *r = call->request;
+	uuid_t *r = call->request;
 
 	struct {
 		__be32	match;
@@ -476,7 +476,7 @@ static void SRXAFSCB_ProbeUuid(struct work_struct *work)
  */
 static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 {
-	struct uuid_v1 *r;
+	uuid_t *r;
 	unsigned loop;
 	__be32 *b;
 	int ret;
@@ -502,20 +502,20 @@ static int afs_deliver_cb_probe_uuid(struct afs_call *call)
 		}
 
 		_debug("unmarshall UUID");
-		call->request = kmalloc(sizeof(struct uuid_v1), GFP_KERNEL);
+		call->request = kmalloc(sizeof(uuid_t), GFP_KERNEL);
 		if (!call->request)
 			return -ENOMEM;
 
 		b = call->buffer;
 		r = call->request;
-		r->time_low			= b[0];
-		r->time_mid			= htons(ntohl(b[1]));
-		r->time_hi_and_version		= htons(ntohl(b[2]));
-		r->clock_seq_hi_and_reserved 	= ntohl(b[3]);
-		r->clock_seq_low		= ntohl(b[4]);
+		r->v1.time_low			= b[0];
+		r->v1.time_mid			= htons(ntohl(b[1]));
+		r->v1.time_hi_and_version	= htons(ntohl(b[2]));
+		r->v1.clock_seq_hi_and_reserved = ntohl(b[3]);
+		r->v1.clock_seq_low		= ntohl(b[4]);
 
 		for (loop = 0; loop < 6; loop++)
-			r->node[loop] = ntohl(b[loop + 5]);
+			r->v1.node[loop] = ntohl(b[loop + 5]);
 
 		call->offset = 0;
 		call->unmarshall++;
@@ -568,13 +568,13 @@ static void SRXAFSCB_TellMeAboutYourself(struct work_struct *work)
 	memset(&reply, 0, sizeof(reply));
 	reply.ia.nifs = htonl(nifs);
 
-	reply.ia.uuid[0] = afs_uuid.time_low;
-	reply.ia.uuid[1] = htonl(ntohs(afs_uuid.time_mid));
-	reply.ia.uuid[2] = htonl(ntohs(afs_uuid.time_hi_and_version));
-	reply.ia.uuid[3] = htonl((s8) afs_uuid.clock_seq_hi_and_reserved);
-	reply.ia.uuid[4] = htonl((s8) afs_uuid.clock_seq_low);
+	reply.ia.uuid[0] = afs_uuid.v1.time_low;
+	reply.ia.uuid[1] = htonl(ntohs(afs_uuid.v1.time_mid));
+	reply.ia.uuid[2] = htonl(ntohs(afs_uuid.v1.time_hi_and_version));
+	reply.ia.uuid[3] = htonl((s8) afs_uuid.v1.clock_seq_hi_and_reserved);
+	reply.ia.uuid[4] = htonl((s8) afs_uuid.v1.clock_seq_low);
 	for (loop = 0; loop < 6; loop++)
-		reply.ia.uuid[loop + 5] = htonl((s8) afs_uuid.node[loop]);
+		reply.ia.uuid[loop + 5] = htonl((s8) afs_uuid.v1.node[loop]);
 
 	if (ifs) {
 		for (loop = 0; loop < nifs; loop++) {
diff --git a/fs/afs/internal.h b/fs/afs/internal.h
index 393672997cc2..7de45c8686a2 100644
--- a/fs/afs/internal.h
+++ b/fs/afs/internal.h
@@ -544,7 +544,7 @@ extern int afs_drop_inode(struct inode *);
  * main.c
  */
 extern struct workqueue_struct *afs_wq;
-extern struct uuid_v1 afs_uuid;
+extern uuid_t afs_uuid;
 
 /*
  * misc.c
diff --git a/fs/afs/main.c b/fs/afs/main.c
index 51d7d17bca57..75b3d3a8b1ba 100644
--- a/fs/afs/main.c
+++ b/fs/afs/main.c
@@ -31,7 +31,7 @@ static char *rootcell;
 module_param(rootcell, charp, 0);
 MODULE_PARM_DESC(rootcell, "root AFS cell name and VL server IP addr list");
 
-struct uuid_v1 afs_uuid;
+uuid_t afs_uuid;
 struct workqueue_struct *afs_wq;
 
 /*
@@ -43,7 +43,7 @@ static int __init afs_init(void)
 
 	printk(KERN_INFO "kAFS: Red Hat AFS client v0.1 registering.\n");
 
-	generate_random_uuid((unsigned char *)&afs_uuid);
+	uuid_gen(&afs_uuid);
 
 	/* create workqueue */
 	ret = -ENOMEM;
-- 
2.11.0
