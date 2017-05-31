From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 08/24] uuid: rename uuid_to_bin to uuid_parse
Date: Wed, 31 May 2017 18:18:10 +0200
Message-ID: <20170531161826.23243-9-hch@lst.de>
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

This matches the userspace version of it, and describes the functionality
much better.  Also do the same for the guid version.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/uuid.h |  8 ++++----
 lib/test_uuid.c      |  8 ++++----
 lib/uuid.c           | 14 +++++++-------
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index a9d0fdba5404..82b165b579f5 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -45,8 +45,8 @@ bool __must_check uuid_is_valid(const char *uuid);
 extern const u8 guid_index[16];
 extern const u8 uuid_index[16];
 
-int guid_to_bin(const char *uuid, guid_t *u);
-int uuid_to_bin(const char *uuid, uuid_t *u);
+int guid_parse(const char *uuid, guid_t *u);
+int uuid_parse(const char *uuid, uuid_t *u);
 
 /* backwards compatibility, don't use in new code */
 typedef uuid_t uuid_be;
@@ -58,8 +58,8 @@ typedef uuid_t uuid_be;
 
 #define uuid_le_gen(u)		guid_gen(u)
 #define uuid_be_gen(u)		uuid_gen(u)
-#define uuid_le_to_bin(guid, u)	guid_to_bin(guid, u)
-#define uuid_be_to_bin(uuid, u)	uuid_to_bin(uuid, u)
+#define uuid_le_to_bin(guid, u)	guid_parse(guid, u)
+#define uuid_be_to_bin(uuid, u)	uuid_parse(uuid, u)
 
 static inline int uuid_le_cmp(const guid_t u1, const guid_t u2)
 {
diff --git a/lib/test_uuid.c b/lib/test_uuid.c
index 9cad846fd805..edda536a7b45 100644
--- a/lib/test_uuid.c
+++ b/lib/test_uuid.c
@@ -67,7 +67,7 @@ static void __init test_uuid_test(const struct test_uuid_data *data)
 
 	/* LE */
 	total_tests++;
-	if (guid_to_bin(data->uuid, &le))
+	if (guid_parse(data->uuid, &le))
 		test_uuid_failed("conversion", false, false, data->uuid, NULL);
 
 	total_tests++;
@@ -78,7 +78,7 @@ static void __init test_uuid_test(const struct test_uuid_data *data)
 
 	/* BE */
 	total_tests++;
-	if (uuid_to_bin(data->uuid, &be))
+	if (uuid_parse(data->uuid, &be))
 		test_uuid_failed("conversion", false, true, data->uuid, NULL);
 
 	total_tests++;
@@ -95,12 +95,12 @@ static void __init test_uuid_wrong(const char *data)
 
 	/* LE */
 	total_tests++;
-	if (!guid_to_bin(data, &le))
+	if (!guid_parse(data, &le))
 		test_uuid_failed("negative", true, false, data, NULL);
 
 	/* BE */
 	total_tests++;
-	if (!uuid_to_bin(data, &be))
+	if (!uuid_parse(data, &be))
 		test_uuid_failed("negative", true, true, data, NULL);
 }
 
diff --git a/lib/uuid.c b/lib/uuid.c
index f80dc63f6ca8..90bee73f7bd7 100644
--- a/lib/uuid.c
+++ b/lib/uuid.c
@@ -97,7 +97,7 @@ bool uuid_is_valid(const char *uuid)
 }
 EXPORT_SYMBOL(uuid_is_valid);
 
-static int __uuid_to_bin(const char *uuid, __u8 b[16], const u8 ei[16])
+static int __uuid_parse(const char *uuid, __u8 b[16], const u8 ei[16])
 {
 	static const u8 si[16] = {0,2,4,6,9,11,14,16,19,21,24,26,28,30,32,34};
 	unsigned int i;
@@ -115,14 +115,14 @@ static int __uuid_to_bin(const char *uuid, __u8 b[16], const u8 ei[16])
 	return 0;
 }
 
-int guid_to_bin(const char *uuid, guid_t *u)
+int guid_parse(const char *uuid, guid_t *u)
 {
-	return __uuid_to_bin(uuid, u->b, guid_index);
+	return __uuid_parse(uuid, u->b, guid_index);
 }
-EXPORT_SYMBOL(guid_to_bin);
+EXPORT_SYMBOL(guid_parse);
 
-int uuid_to_bin(const char *uuid, uuid_t *u)
+int uuid_parse(const char *uuid, uuid_t *u)
 {
-	return __uuid_to_bin(uuid, u->b, uuid_index);
+	return __uuid_parse(uuid, u->b, uuid_index);
 }
-EXPORT_SYMBOL(uuid_to_bin);
+EXPORT_SYMBOL(uuid_parse);
-- 
2.11.0
