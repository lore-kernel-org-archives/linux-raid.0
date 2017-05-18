From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 22/23] scsi_debug: switch to uuid_t
Date: Thu, 18 May 2017 08:27:04 +0200
Message-ID: <20170518062705.25902-23-hch@lst.de>
References: <20170518062705.25902-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170518062705.25902-1-hch-jcswGhMUV9g@public.gmane.org>
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
---
 drivers/scsi/scsi_debug.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 17249c3650fe..35ee09644cfb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -245,7 +245,7 @@ struct sdebug_dev_info {
 	unsigned int channel;
 	unsigned int target;
 	u64 lun;
-	uuid_be lu_name;
+	uuid_t lu_name;
 	struct sdebug_host_info *sdbg_host;
 	unsigned long uas_bm[1];
 	atomic_t num_in_q;
@@ -965,7 +965,7 @@ static const u64 naa3_comp_c = 0x3111111000000000ULL;
 static int inquiry_vpd_83(unsigned char *arr, int port_group_id,
 			  int target_dev_id, int dev_id_num,
 			  const char *dev_id_str, int dev_id_str_len,
-			  const uuid_be *lu_name)
+			  const uuid_t *lu_name)
 {
 	int num, port_a;
 	char b[32];
@@ -3568,7 +3568,7 @@ static void sdebug_q_cmd_wq_complete(struct work_struct *work)
 }
 
 static bool got_shared_uuid;
-static uuid_be shared_uuid;
+static uuid_t shared_uuid;
 
 static struct sdebug_dev_info *sdebug_device_create(
 			struct sdebug_host_info *sdbg_host, gfp_t flags)
@@ -3578,12 +3578,12 @@ static struct sdebug_dev_info *sdebug_device_create(
 	devip = kzalloc(sizeof(*devip), flags);
 	if (devip) {
 		if (sdebug_uuid_ctl == 1)
-			uuid_be_gen(&devip->lu_name);
+			uuid_gen(&devip->lu_name);
 		else if (sdebug_uuid_ctl == 2) {
 			if (got_shared_uuid)
 				devip->lu_name = shared_uuid;
 			else {
-				uuid_be_gen(&shared_uuid);
+				uuid_gen(&shared_uuid);
 				got_shared_uuid = true;
 				devip->lu_name = shared_uuid;
 			}
-- 
2.11.0
