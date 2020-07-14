From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 13/23] initrd: mark init_linuxrc as __init
Date: Tue, 14 Jul 2020 21:04:17 +0200
Message-ID: <20200714190427.4332-14-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts_initrd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index e4f88e9e1c0839..57ad5b2da8f5f5 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -56,7 +56,7 @@ static int __init early_initrd(char *p)
 }
 early_param("initrd", early_initrd);
 
-static int init_linuxrc(struct subprocess_info *info, struct cred *new)
+static int __init init_linuxrc(struct subprocess_info *info, struct cred *new)
 {
 	ksys_unshare(CLONE_FS | CLONE_FILES);
 	console_on_rootfs();
-- 
2.27.0
