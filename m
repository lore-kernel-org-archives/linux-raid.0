From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 14/23] initrd: mark initrd support as deprecated
Date: Tue, 14 Jul 2020 21:04:18 +0200
Message-ID: <20200714190427.4332-15-hch@lst.de>
References: <20200714190427.4332-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200714190427.4332-1-hch@lst.de>
Sender: linux-raid-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Song Liu <song@kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

The classic initial ramdisk has been replaced by the much more
flexible and efficient initramfs a long time.  Warn about it being
removed soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 init/do_mounts_initrd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/init/do_mounts_initrd.c b/init/do_mounts_initrd.c
index 57ad5b2da8f5f5..e08669187d63be 100644
--- a/init/do_mounts_initrd.c
+++ b/init/do_mounts_initrd.c
@@ -75,6 +75,8 @@ static void __init handle_initrd(void)
 	extern char *envp_init[];
 	int error;
 
+	pr_warn("using deprecated initrd support, will be removed in 2021.\n");
+
 	real_root_dev = new_encode_dev(ROOT_DEV);
 	create_dev("/dev/root.old", Root_RAM0);
 	/* mount initrd on rootfs' /root */
-- 
2.27.0
