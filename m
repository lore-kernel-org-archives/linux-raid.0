Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A147DC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 25 Apr 2022 13:30:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232474AbiDYNdD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Apr 2022 09:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242079AbiDYNbT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Apr 2022 09:31:19 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E33464132D
        for <linux-raid@vger.kernel.org>; Mon, 25 Apr 2022 06:27:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1650893276;
        bh=gV/hPuUJICY9enrRUhSl+zl2wnV79qBG8edSPL+dd8Y=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
        b=ipSrFP+nGSo05i5WHpCGCVSSZrap2IGuT76hVjPLlX0YQBuxJIIXmt+W1DFeY7h62
         ekLlL1U6v5Db+dvo2PGr0h8yATCd0WsDTCCeEhqBfU22pP8wSIMTjUiRotEBmMLrU+
         /ys/oPD2fpEdNef6Elh1zIA2halbRkeMV4UStXp0=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from linux-9lzf.suse.de ([77.4.84.6]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MkHQh-1oBgft0FYn-00kdii; Mon, 25
 Apr 2022 15:27:56 +0200
From:   Marius Kittler <mariuskittler@gmx.de>
To:     linux-raid@vger.kernel.org
Cc:     Marius Kittler <mariuskittler@gmx.de>
Subject: [PATCH] Print concrete error when creating mddev
Date:   Mon, 25 Apr 2022 15:27:45 +0200
Message-Id: <20220425132745.7952-1-mariuskittler@gmx.de>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:SOrNFxZHiiVdltGzSED5QLTl7vGEMBgfspXiK33TjJ3zm+LJ0ZP
 rdpYBdfEKNM78Llz5IbYY4WE70A2NRhgdOoIzdq/eKAb1qJmgoJMnp8ZMiFcVumR6expTQs
 3Q+HUYhA1cE+bT8I1d51Hr1FAzqVZ7i3S5AsgVZP0EajIq3th3DCKZ2ZRppOYXWBcK+yIgB
 c2V6CY0l7Bw5KGOcoPfjg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:ddg737QhqSA=:qszJx08jmGGnL2G380Ph7K
 9WYejU9ZW72pq7k4pD3QZ4x7+QsoxKU5JMSSz/SMcGBtHSM2JwDJptXbx6Orwo3IQidEB1RGw
 lxKdjkvH93jrMTzYVITtC/CpwEPwMeg9blv4BEISOzPE37yEpWR9fviNouV8UHKv3EIbh0Uma
 KU6pyJOjogvYOA4JLAOjtM/FHZqeIXl7YBpxRD3p70jb7PFo7aqA6/T87n4w5IYFPh4Q3WHnG
 wxBM31KC1QsaRY5qtX0lsJw+ye9+GmlqkzZzsMiQ2HCKWh30zEe8xwCwmq97awmDIyc8UUnUq
 MmlOjjqHg/Lii2W01LpJdt7hA/pzHxIw3oWsIZ9EMi5evQIKIzvnHnP7C6vXuFmNsiatR2siC
 BXm/ls9TOJakqVLWQxTkhdseia/Wnx/9TdFWD5ysW5VaZYB6FD7dp/CcVYpbNBswiPwyM4EMM
 b12RCGHmR/PW35XrsDXsWD+JEasE3Fr1PsKbuiJnNo7UQsN9lfvp9Cd7gSF2BkPvy7xgNsy5j
 wKiO16ZVQtw+mMCIwKjYucCrnyQj2/XE+D3ifqP4PwTddpgAG3O5krSZ9LbnyPIvIN1NyK77U
 F8vofsYuwclDE0B/vSSnV8qoNGMY99ppXvNLI4rMwuVx+He/nua+gR2r4+o1bY7LE2kkmVY4O
 ssi56DzmaeRAbgidz4RjeNg7G4+H03vsVR2ZvEz0VGk7+s7KI8202b6ct0jO0SOd11AjdWKTh
 zcaxms6J+WggheP8AMyyAXTYik1G3JLJh/qXNut2rDPzcWqf9glKd6f8QiUyqWnS4hm1FMXdv
 3+dWMJx02lW6JZmeqSl9gFOYnHIcQSlLYC8JRYEEVbhx0L/jpXDDSEVcCpW/PFGx4wSjmpTVf
 oV1/UYpOpfRnRyVBBFct5aU/Pistakz184GMtnVN5ZJ0/nY0wRHnRvayREoAQcYDJkLMkC9Yh
 +7Ag21WxSEYFL+TV9GNSUwyQMkGD6Cu5ot7KWVRp6kF10C2sNDNq7czgk/R02Zd9YLMReWk5i
 z8jxKbsGJYbTvwalLAS2omvm9zr735b3GB2gzZW/5vz4vCriNm3cZZeYlRADcIQpeHxwIKpAC
 BOtx6xzN9b6RUM=
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Example from my testing:
```
mdadm: unexpected failure opening /dev/md127: No such device or address
```

Before it would just print:
```
mdadm: unexpected failure opening /dev/md127
```
=2D--
 mdopen.c | 4 ++--
 util.c   | 5 +++--
 2 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/mdopen.c b/mdopen.c
index 245be537..c8e5cb9d 100644
=2D-- a/mdopen.c
+++ b/mdopen.c
@@ -444,8 +444,8 @@ int create_mddev(char *dev, char *name, int autof, int=
 trustworthy,
 	}
 	mdfd =3D open_dev_excl(devnm);
 	if (mdfd < 0)
-		pr_err("unexpected failure opening %s\n",
-			devname);
+		pr_err("unexpected failure opening %s: %s\n",
+			devname, strerror(errno));
 	return mdfd;
 }

diff --git a/util.c b/util.c
index cc94f96e..7c8c0bb1 100644
=2D-- a/util.c
+++ b/util.c
@@ -1088,8 +1088,9 @@ int open_dev_excl(char *devnm)
 	long delay =3D 1000;

 	sprintf(buf, "%d:%d", major(devid), minor(devid));
+	int fd =3D -1;
 	for (i =3D 0; i < 25; i++) {
-		int fd =3D dev_open(buf, flags|O_EXCL);
+		fd =3D dev_open(buf, flags|O_EXCL);
 		if (fd >=3D 0)
 			return fd;
 		if (errno =3D=3D EACCES && flags =3D=3D O_RDWR) {
@@ -1102,7 +1103,7 @@ int open_dev_excl(char *devnm)
 		if (delay < 200000)
 			delay *=3D 2;
 	}
-	return -1;
+	return fd;
 }

 int same_dev(char *one, char *two)
=2D-
2.35.3

