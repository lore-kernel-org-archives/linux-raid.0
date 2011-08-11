From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] pnfs: Automatically select blocks & objects layouts
Date: Thu, 11 Aug 2011 14:10:42 -0700
Message-ID: <4E444552.9030105@panasas.com>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com> <20110810122304.96b8be67.rdunlap@xenotime.net> <CA+a=Yy5izxiyvW5eYiWuute9E1vXwNTj4frdzNeEwsLDrszesg@mail.gmail.com> <20110810175829.a834d80f.rdunlap@xenotime.net> <CA+55aFzcSLrhkexEn=J7BN8F3P3Vy+EAjwgGwMQPdeoYoQG+Bw@mail.gmail.com> <F19688880B763E40B28B2B462677FBF805BF0EAC8A@MX09A.corp.emc.com> <4E43AAD1.7090806@tonian.com> <4E4422FD.3060706@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4E4422FD.3060706-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benny Halevy <bhalevy-4/WYdZTkCtzQT0dZR+AlfA@public.gmane.org>, Sorin Faibish <sfaibish-mb1K0bWo544@public.gmane.org>, peter honeyman <honey-vtMw8L3fJ9vSiEDVxGk4TQ@public.gmane.org>
Cc: tao.peng-mb1K0bWo544@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org, bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Welch, Brent" <welch-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-raid.ids

What about the below? based on v3.1-rc1

----
From: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] pnfs: Automatically select blocks & objects layouts

Just like files-layout, blocks & objects layouts are part of the
NFS 4.1 protocol and should be automatically selected if NFS_4_1
is selected. The small problem is that these depend on other
Kernel support being present, while files only depends on NFS
itself.

This patch removes from the user choice the presence of objects
and blocks layout. But makes sure these are selected only if
the depended subsystems are present in the Kernel.

Signed-off-by: Boaz Harrosh <bharrosh-C4P08NqkoRlBDgjK7y7TUQ@public.gmane.org>
---
 fs/nfs/Kconfig |   14 ++++----------
 1 files changed, 4 insertions(+), 10 deletions(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index be02077..1b951cd 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -79,9 +79,6 @@ config NFS_V4_1
 	depends on NFS_FS && NFS_V4 && EXPERIMENTAL
 	select SUNRPC_BACKCHANNEL
 	select PNFS_FILE_LAYOUT
-	select PNFS_BLOCK
-	select MD
-	select BLK_DEV_DM
 	help
 	  This option enables support for minor version 1 of the NFSv4 protocol
 	  (RFC 5661 and RFC 5663) in the kernel's NFS client.
@@ -93,16 +90,13 @@ config PNFS_FILE_LAYOUT
 
 config PNFS_BLOCK
 	tristate
+	depends on NFS_FS && NFS_V4_1 && MD && BLK_DEV_DM
+	default m
 
 config PNFS_OBJLAYOUT
-	tristate "Provide support for the pNFS Objects Layout Driver for NFSv4.1 pNFS (EXPERIMENTAL)"
+	tristate
 	depends on NFS_FS && NFS_V4_1 && SCSI_OSD_ULD
-	help
-	  Say M here if you want your pNFS client to support the Objects Layout Driver.
-	  Requires the SCSI osd initiator library (SCSI_OSD_INITIATOR) and
-	  upper level driver (SCSI_OSD_ULD).
-
-	  If unsure, say N.
+	default m
 
 config ROOT_NFS
 	bool "Root file system on NFS"
-- 
1.7.6


--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
