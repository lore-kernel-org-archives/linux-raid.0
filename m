From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 05/16] uuid: add the v1 layout to uuid_t
Date: Wed, 10 May 2017 20:02:03 +0200
Message-ID: <20170510180214.16852-6-hch@lst.de>
References: <20170510180214.16852-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nvdimm-bounces-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org>
In-Reply-To: <20170510180214.16852-1-hch-jcswGhMUV9g@public.gmane.org>
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
---
 include/uapi/linux/uuid.h | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/uuid.h b/include/uapi/linux/uuid.h
index 1a2914d8b225..1039d2f3e114 100644
--- a/include/uapi/linux/uuid.h
+++ b/include/uapi/linux/uuid.h
@@ -25,7 +25,34 @@ typedef struct {
 } guid_t;
 
 typedef struct {
-	__u8 b[16];
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
+		struct {
+			__be32		time_low;
+			__be16		time_mid;
+			__be16		time_hi_and_version;
+#define UUID_TO_UNIX_TIME	0x01b21dd213814000ULL
+#define UUID_TIMEHI_MASK	0x0fff
+#define UUID_VERSION_TIME	0x1000	/* time-based UUID */
+#define UUID_VERSION_NAME	0x3000	/* name-based UUID */
+#define UUID_VERSION_RANDOM	0x4000	/* (pseudo-)random generated UUID */
+			u8		clock_seq_hi_and_reserved;
+#define UUID_CLOCKHI_MASK	0x3f
+#define UUID_VARIANT_STD	0x80
+			u8		clock_seq_low;
+			u8		node[6];
+		} v1;
+	};
 } uuid_t;
 
 #define GUID(a, b, c, d0, d1, d2, d3, d4, d5, d6, d7)			\
-- 
2.11.0
