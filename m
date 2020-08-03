From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: Re: add file system helpers that take kernel pointers for the init
 code v4
Date: Mon, 3 Aug 2020 17:08:02 +0200
Message-ID: <20200803150802.GA19112@lst.de>
References: <20200728163416.556521-1-hch@lst.de> <20200803145622.GB4631@lca.pw>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20200803145622.GB4631-J5quhbR+WMc@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Qian Cai <cai-J5quhbR+WMc@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "Rafael J. Wysocki" <rafael-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org, linux-next-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

On Mon, Aug 03, 2020 at 10:56:23AM -0400, Qian Cai wrote:
> On Tue, Jul 28, 2020 at 06:33:53PM +0200, Christoph Hellwig wrote:
> > Hi Al and Linus,
> > 
> > currently a lot of the file system calls in the early in code (and the
> > devtmpfs kthread) rely on the implicit set_fs(KERNEL_DS) during boot.
> > This is one of the few last remaining places we need to deal with to kill
> > off set_fs entirely, so this series adds new helpers that take kernel
> > pointers.  These helpers are in init/ and marked __init and thus will
> > be discarded after bootup.  A few also need to be duplicated in devtmpfs,
> > though unfortunately.
> 
> Reverting this series from next-20200803 fixed the crash below on shutdown.

Please try this patch:

---
From 6448eebe2fe7189cedc5136ab3464517956922b7 Mon Sep 17 00:00:00 2001
From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Date: Mon, 3 Aug 2020 15:56:18 +0200
Subject: init: fix init_dup

Don't allocate an unused fd for each call.  Also drop the extra
reference from filp_open after the init_dup calls while we're at it.

Fixes: 36e96b411649 ("init: add an init_dup helper")
Reported-by Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 fs/init.c   | 2 +-
 init/main.c | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/fs/init.c b/fs/init.c
index 730e05acda2392..e9c320a48cf157 100644
--- a/fs/init.c
+++ b/fs/init.c
@@ -260,6 +260,6 @@ int __init init_dup(struct file *file)
 	fd = get_unused_fd_flags(0);
 	if (fd < 0)
 		return fd;
-	fd_install(get_unused_fd_flags(0), get_file(file));
+	fd_install(fd, get_file(file));
 	return 0;
 }
diff --git a/init/main.c b/init/main.c
index 089e21504b1fc1..9dae9c4f806bb9 100644
--- a/init/main.c
+++ b/init/main.c
@@ -1470,6 +1470,7 @@ void __init console_on_rootfs(void)
 	init_dup(file);
 	init_dup(file);
 	init_dup(file);
+	fput(file);
 }
 
 static noinline void __init kernel_init_freeable(void)
-- 
2.27.0
