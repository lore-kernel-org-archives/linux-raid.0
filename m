From: Luca Berra <bluca@comedia.it>
Subject: [PATCH] segfault in imsm create with wrong arguments
Date: Sun, 12 Dec 2010 12:33:55 +0100
Message-ID: <20101212113355.GA24577@maude.comedia.it>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="HlL+5n6rz5pIUxbD"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline

When calling mdadm -C --metadata=imsm -l 1 /dev/sd..
mdadm segfaults in default_chunk_imsm()
above syntax is incorrect, but mdadm should error instead of segfaulting

-- 
Luca Berra -- bluca@comedia.it

--HlL+5n6rz5pIUxbD
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: attachment; filename="mdadm-3.1.4-imsm-create-segfault.patch"

When calling mdadm -C --metadata=imsm -l 1 /dev/sd..
mdadm segfaults in default_chunk_imsm()
above syntax is incorrect, but mdadm should error instead of segfaulting

Signed-off-by: Luca Berra <bluca@comedia.it>

diff -p -up mdadm-3.1.4/super-intel.c.bluca mdadm-3.1.4/super-intel.c
--- mdadm-3.1.4/super-intel.c.bluca	2010-08-26 02:24:16.000000000 +0000
+++ mdadm-3.1.4/super-intel.c	2010-12-12 11:13:00.024371004 +0000
@@ -4119,7 +4119,7 @@ static int default_chunk_imsm(struct sup
 {
 	struct intel_super *super = st->sb;
 
-	if (!super->orom)
+	if (!super || !super->orom)
 		return 0;
 
 	return imsm_orom_default_chunk(super->orom);

--HlL+5n6rz5pIUxbD--
