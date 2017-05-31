From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 07/24] nfsd: namespace-prefix uuid_parse
Date: Wed, 31 May 2017 18:18:09 +0200
Message-ID: <20170531161826.23243-8-hch@lst.de>
References: <20170531161826.23243-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170531161826.23243-1-hch-jcswGhMUV9g@public.gmane.org>
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
Cc: linux-xfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvdimm-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, Shaohua Li <shli-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mimi Zohar <zohar-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, Steven Whitehouse <swhiteho-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/nfsd/export.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/nfsd/export.c b/fs/nfsd/export.c
index e71f11b1a180..3bc08c394a3f 100644
--- a/fs/nfsd/export.c
+++ b/fs/nfsd/export.c
@@ -486,7 +486,7 @@ secinfo_parse(char **mesg, char *buf, struct svc_export *exp) { return 0; }
 #endif
 
 static inline int
-uuid_parse(char **mesg, char *buf, unsigned char **puuid)
+nfsd_uuid_parse(char **mesg, char *buf, unsigned char **puuid)
 {
 	int len;
 
@@ -586,7 +586,7 @@ static int svc_export_parse(struct cache_detail *cd, char *mesg, int mlen)
 			if (strcmp(buf, "fsloc") == 0)
 				err = fsloc_parse(&mesg, buf, &exp.ex_fslocs);
 			else if (strcmp(buf, "uuid") == 0)
-				err = uuid_parse(&mesg, buf, &exp.ex_uuid);
+				err = nfsd_uuid_parse(&mesg, buf, &exp.ex_uuid);
 			else if (strcmp(buf, "secinfo") == 0)
 				err = secinfo_parse(&mesg, buf, &exp);
 			else
-- 
2.11.0
