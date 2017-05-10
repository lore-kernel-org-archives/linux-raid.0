From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 10/16] uuid: hoist helpers uuid_equal() and uuid_copy() from
 xfs
Date: Wed, 10 May 2017 20:02:08 +0200
Message-ID: <20170510180214.16852-11-hch@lst.de>
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

From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

These helper are used to compare and copy two uuid_t type objects.

Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
[hch: also provide the respective guid_ versions]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/xfs/uuid.c        |  6 ------
 fs/xfs/uuid.h        |  7 -------
 include/linux/uuid.h | 20 ++++++++++++++++++++
 3 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/fs/xfs/uuid.c b/fs/xfs/uuid.c
index 937deaf2128d..737c186ea98b 100644
--- a/fs/xfs/uuid.c
+++ b/fs/xfs/uuid.c
@@ -30,9 +30,3 @@ uuid_is_nil(uuid_t *uuid)
 		if (*cp++) return 0;	/* not nil */
 	return 1;	/* is nil */
 }
-
-int
-uuid_equal(uuid_t *uuid1, uuid_t *uuid2)
-{
-	return memcmp(uuid1, uuid2, sizeof(uuid_t)) ? 0 : 1;
-}
diff --git a/fs/xfs/uuid.h b/fs/xfs/uuid.h
index 65b5cebf2f99..5aea49bf0963 100644
--- a/fs/xfs/uuid.h
+++ b/fs/xfs/uuid.h
@@ -19,12 +19,5 @@
 #define __XFS_SUPPORT_UUID_H__
 
 extern int uuid_is_nil(uuid_t *uuid);
-extern int uuid_equal(uuid_t *uuid1, uuid_t *uuid2);
-
-static inline void
-uuid_copy(uuid_t *dst, uuid_t *src)
-{
-	memcpy(dst, src, sizeof(uuid_t));
-}
 
 #endif	/* __XFS_SUPPORT_UUID_H__ */
diff --git a/include/linux/uuid.h b/include/linux/uuid.h
index 28a5a894b926..b7fec8b266eb 100644
--- a/include/linux/uuid.h
+++ b/include/linux/uuid.h
@@ -29,11 +29,31 @@ static inline int guid_cmp(const guid_t u1, const guid_t u2)
 	return memcmp(&u1, &u2, sizeof(guid_t));
 }
 
+static inline bool guid_equal(const guid_t *u1, const guid_t *u2)
+{
+	return memcmp(u1, u2, sizeof(guid_t)) == 0;
+}
+
+static inline void guid_copy(guid_t *dst, const guid_t *src)
+{
+	memcpy(dst, src, sizeof(guid_t));
+}
+
 static inline int uuid_cmp(const uuid_t u1, const uuid_t u2)
 {
 	return memcmp(&u1, &u2, sizeof(uuid_t));
 }
 
+static inline bool uuid_equal(const uuid_t *u1, const uuid_t *u2)
+{
+	return memcmp(u1, u2, sizeof(uuid_t)) == 0;
+}
+
+static inline void uuid_copy(uuid_t *dst, const uuid_t *src)
+{
+	memcpy(dst, src, sizeof(uuid_t));
+}
+
 void generate_random_uuid(unsigned char uuid[16]);
 
 extern void guid_gen(guid_t *u);
-- 
2.11.0
