From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 06/23] uuid: add the v1 layout to uuid_t
Date: Thu, 18 May 2017 08:26:48 +0200
Message-ID: <20170518062705.25902-7-hch@lst.de>
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

Turn the content of uuid_t into a union and add the fields for the v1
interpretation to it.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: David Howells <dhowells-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/uuid.h | 59 ++++++++++++++++++++++++++++------------------------
 1 file changed, 32 insertions(+), 27 deletions(-)

diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 0410cd002282..8bd1da4ec95d 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -18,40 +18,45 @@
 
 #include <uapi/linux/uuid.h>
 
-typedef struct {
-	__u8 b[16];
-} uuid_t;
-
-#define UUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
-((uuid_t)								\
-{{ ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
-   ((b) >> 8) & 0xff, (b) & 0xff,					\
-   ((c) >> 8) & 0xff, (c) & 0xff,					\
-   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }})
-
-/*
- * V1 (time-based) UUID definition [RFC 4122].
- * - the timestamp is a 60-bit value, split 32/16/12, and goes in 100ns
- *   increments since midnight 15th October 1582
- *   - add AFS_UUID_TO_UNIX_TIME to convert unix time in 100ns units to UUID
- *     time
- * - the clock sequence is a 14-bit counter to avoid duplicate times
- */
-struct uuid_v1 {
-	__be32		time_low;			/* low part of timestamp */
-	__be16		time_mid;			/* mid part of timestamp */
-	__be16		time_hi_and_version;		/* high part of timestamp and version  */
+/* v1 UUID defintions: */
 #define UUID_TO_UNIX_TIME	0x01b21dd213814000ULL
 #define UUID_TIMEHI_MASK	0x0fff
 #define UUID_VERSION_TIME	0x1000	/* time-based UUID */
 #define UUID_VERSION_NAME	0x3000	/* name-based UUID */
 #define UUID_VERSION_RANDOM	0x4000	/* (pseudo-)random generated UUID */
-	u8		clock_seq_hi_and_reserved;	/* clock seq hi and variant */
 #define UUID_CLOCKHI_MASK	0x3f
 #define UUID_VARIANT_STD	0x80
-	u8		clock_seq_low;			/* clock seq low */
-	u8		node[6];			/* spatially unique node ID (MAC addr) */
-};
+
+typedef struct {
+	union {
+		__u8			b[16];
+
+		/*
+		 * V1 (time-based) UUID definition [RFC 4122]:
+		 * - the timestamp is a 60-bit value, split 32/16/12, and goes
+		 *   in 100ns increments since midnight 15th October 1582
+		 *   - add UUID_TO_UNIX_TIME to convert unix time in 100ns
+		 *     units to UUID time
+		 * - the clock sequence is a 14-bit counter to avoid duplicate
+		 *   times
+		 */
+		struct uuid_v1 {
+			__be32		time_low;
+			__be16		time_mid;
+			__be16		time_hi_and_version;
+			u8		clock_seq_hi_and_reserved;
+			u8		clock_seq_low;
+			u8		node[6];
+		} v1;
+	};
+} uuid_t;
+
+#define UUID(a, _b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
+{.b = {									\
+   ((a) >> 24) & 0xff, ((a) >> 16) & 0xff, ((a) >> 8) & 0xff, (a) & 0xff, \
+   ((_b) >> 8) & 0xff, (_b) & 0xff,					\
+   ((c) >> 8) & 0xff, (c) & 0xff,					\
+   (d0), (d1), (d2), (d3), (d4), (d5), (d6), (d7) }}
 
 /*
  * The length of a UUID string ("aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee")
-- 
2.11.0
