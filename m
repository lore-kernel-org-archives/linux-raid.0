From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 09/24] init: mark create_dev as __init
Date: Tue, 21 Jul 2020 18:28:03 +0200
Message-ID: <20200721162818.197315-10-hch@lst.de>
References: <20200721162818.197315-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200721162818.197315-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org
List-Id: linux-raid.ids

The helper is only used for the early init code.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/do_mounts.h b/init/do_mounts.h
index 853da3cc4a3586..15d256658a3093 100644
--- a/init/do_mounts.h
+++ b/init/do_mounts.h
@@ -14,7 +14,7 @@ void  mount_root(void);
 void prepare_namespace(void);
 extern int root_mountflags;
 
-static inline int create_dev(char *name, dev_t dev)
+static inline __init int create_dev(char *name, dev_t dev)
 {
 	ksys_unlink(name);
 	return ksys_mknod(name, S_IFBLK|0600, new_encode_dev(dev));
-- 
2.27.0
