From: <tao.peng-mb1K0bWo544@public.gmane.org>
Subject: RE: Linux 3.1-rc1 (nfs/pnfs and drivers/md)
Date: Wed, 10 Aug 2011 23:26:47 -0400
Message-ID: <F19688880B763E40B28B2B462677FBF805BF0EAC8A@MX09A.corp.emc.com>
References: <CA+55aFwkJdyEpyNY64aAQ5ChrPZ8Kvx9iRUwy1J6_SRaxoN=zA@mail.gmail.com>
 <20110810122304.96b8be67.rdunlap@xenotime.net>
 <CA+a=Yy5izxiyvW5eYiWuute9E1vXwNTj4frdzNeEwsLDrszesg@mail.gmail.com>
 <20110810175829.a834d80f.rdunlap@xenotime.net>
 <CA+55aFzcSLrhkexEn=J7BN8F3P3Vy+EAjwgGwMQPdeoYoQG+Bw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+55aFzcSLrhkexEn=J7BN8F3P3Vy+EAjwgGwMQPdeoYoQG+Bw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org
Cc: bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Trond.Myklebust-HgOvQuBEEgTQT0dZR+AlfA@public.gmane.org, linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Hi, Randy and Linus

> -----Original Message-----
> From: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-nfs-owner-fy+rA21nqHI@public.gmane.org=
rnel.org]
> On Behalf Of Linus Torvalds
> Sent: Thursday, August 11, 2011 9:10 AM
> To: Randy Dunlap
> Cc: Peng Tao; Trond Myklebust; linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Linux Kern=
el Mailing List;
> linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: Linux 3.1-rc1 (nfs/pnfs and drivers/md)
>=20
> On Wed, Aug 10, 2011 at 5:58 PM, Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org> =
wrote:
> >
> > The blocklayout parts of NVS_V4_1 could depend on BLOCK. =A0or all =
of NVS_V4_1
> > can depend on BLOCK.
>=20
> Absolutely. Replace "could" by "should".
>=20
> There's no way I'll take a patch to make NFS "select BLOCK". If the
> block layer isn't enabled, then NFS obviously shouldn't be doing any
> pnfs stuff.
I see. How about the following patch? We used to do like following for =
PNFS_BLOCK but it was changed during code review.


=46rom 833b59c1d24b43a9a4d47f777abab2cd9d041c68 Mon Sep 17 00:00:00 200=
1
=46rom: Peng Tao <bergwolf-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Date: Wed, 10 Aug 2011 18:29:21 -0400
Subject: [PATCH] NFS41: make PNFS_BLOCK selectable

PNFS_BLOCK needs BLK_DEV_DM/MD, which is not a dependency for other
pnfs layout drivers. Seperate it out so others can still build when
BLK_DEV_DM/MD is not enabled.

Also change select to depends on to avoid build failures.

Reported-by: Randy Dunlap <rdunlap-/UHa2rfvQTnk1uMJSBkQmQ@public.gmane.org>
Signed-off-by: Peng Tao <peng_tao-mb1K0bWo544@public.gmane.org>
---
 fs/nfs/Kconfig |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index be02077..0d30613 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -79,12 +79,9 @@ config NFS_V4_1
 	depends on NFS_FS && NFS_V4 && EXPERIMENTAL
 	select SUNRPC_BACKCHANNEL
 	select PNFS_FILE_LAYOUT
-	select PNFS_BLOCK
-	select MD
-	select BLK_DEV_DM
 	help
 	  This option enables support for minor version 1 of the NFSv4 protoc=
ol
-	  (RFC 5661 and RFC 5663) in the kernel's NFS client.
+	  (RFC 5661) in the kernel's NFS client.
=20
 	  If unsure, say N.
=20
@@ -92,7 +89,14 @@ config PNFS_FILE_LAYOUT
 	tristate
=20
 config PNFS_BLOCK
-	tristate
+	tristate "Provide support for the pNFS Block Layout Driver for NFSv4.=
1 pNFS (EXPERIMENTAL)"
+	depends on NFS_FS && NFS_V4_1 && BLK_DEV_DM
+	help
+	  Say M here if you want your pNFS client to support the Block Layout=
 Driver
+	  (RFC 5663). Requires Multiple devices driver support (DM) and Devic=
e mapper
+	  support (BLK_DEV_DM).
+
+	  If unsure, say N.
=20
 config PNFS_OBJLAYOUT
 	tristate "Provide support for the pNFS Objects Layout Driver for NFSv=
4.1 pNFS (EXPERIMENTAL)"
--=20
1.7.4.2



--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
