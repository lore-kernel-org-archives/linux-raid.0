Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05F60C61DA4
	for <linux-raid@archiver.kernel.org>; Sun,  5 Mar 2023 22:36:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbjCEWge (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Mar 2023 17:36:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCEWgd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Mar 2023 17:36:33 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1650DC650
        for <linux-raid@vger.kernel.org>; Sun,  5 Mar 2023 14:36:31 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 83AE1226A4;
        Sun,  5 Mar 2023 22:36:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1678055790; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bIkFHz1I/KOqHu3E9aPCDLukmbUVYvHZke9XB78slJo=;
        b=qPBItAgoH0j4ouxY1Kv8G21Fu+HELBy/AQzwScmBY5SQDDp/F3EzlVt3rayd659HWVrvWM
        1Tg/BhTSipevMZajCn//4VXoTlexZeAMhO0ylD953+l6S8TtnzWO9GUoiQqwisP0z4toR7
        L6QYbQxKq/jp+OM1+LtdiQgPOA+7o+g=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1678055790;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=bIkFHz1I/KOqHu3E9aPCDLukmbUVYvHZke9XB78slJo=;
        b=uKcpBMaOjMStA13jAu1BoQybKEGVkCMn4PVKnUW0QgMzljew8Ilru788zLtyv0KWdGMc9f
        6fFScFMJ+RB3EBDQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 410B31339E;
        Sun,  5 Mar 2023 22:36:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id fRXtOGwZBWTYGAAAMHmgww
        (envelope-from <neilb@suse.de>); Sun, 05 Mar 2023 22:36:28 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
From:   "NeilBrown" <neilb@suse.de>
To:     Song Liu <song@kernel.org>, Dan Carpenter <error27@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: [PATCH] md: avoid signed overflow in slot_store()
Date:   Mon, 06 Mar 2023 09:36:25 +1100
Message-id: <167805578596.8008.14753053536858832084@noble.neil.brown.name>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


slot_store() uses kstrtouint() to get a slot number, but stores the
result in an "int" variable (by casting a pointer).
This can result in a negative slot number if the unsigned int value is
very large.

A negative number means that the slot is empty, but setting a negative
slot number this way will not remove the device from the array.  I don't
think this is a serious problem, but it could cause confusion and it is
best to fix it.

Reported-by: Dan Carpenter <error27@gmail.com>
Signed-off-by: NeilBrown <neilb@suse.de>
---
 drivers/md/md.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 02b0240e7c71..d4bfa35fb20a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -3131,6 +3131,9 @@ slot_store(struct md_rdev *rdev, const char *buf, size_=
t len)
 		err =3D kstrtouint(buf, 10, (unsigned int *)&slot);
 		if (err < 0)
 			return err;
+		if (slot < 0)
+			/* overflow */
+			return -ENOSPC;
 	}
 	if (rdev->mddev->pers && slot =3D=3D -1) {
 		/* Setting 'slot' on an active array requires also
--=20
2.39.2

