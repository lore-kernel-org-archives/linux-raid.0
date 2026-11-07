Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.82.181
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794069879;
	b=t6UT0yZRzC7m+mhn8d2nqAvlv+HkxI2p/0IGaNiBXRSozyPxtnUpAGf84qUqqzNjWmLQ
	 d1tEpvWgFadIvUvgRQ/QvEi8TWwTAbs3oni5RGLgDuRClDMjCrd+dYDM6apAhyJ+ay6W/
	 yItO+E+bd/NbrwvFFVI0YWyns5RuTDMTf9iNaOWAubb5yv5fCxzhvpEmKlOvTQvJF4elF
	 SDRCe1F3srnlktEft1G0eB9SkopLTefTWRpIX8MBJLFJrb1bqUngNazK8oplzSAyYjhyn
	 I3h1F8WM4SICjhnbe+jUJ6XXpCTICh4BCwnM1rlBTYjNBIRyi0TjeGkiyevidJRUO/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794069879;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-Id:X-Mailer:MIME-Version:Content-Transfer-Encoding;
	bh=cwPj/yL5tuc3miMt3pQkwgcVVGWR+Pp3SqkYDrCFSX4=;
	b=JAulS5+s6pcNDPQuK8//vUCZu9TspVKW6KMAY3dPyAFGoSRzWNDwbEXekgoNkIFgeUTe
	 E5Ccno5tjJU3eXPmXqLg2U0gcjlN7dg/ey7ZJT+NcAoK88yzk2hrG6DXi+rjrlpYv7rZp
	 5kiYX/F3YkuUbHFbPX+kq3TUpa7RNRt7O83i/dBlxC21cAC8yvzkqooxw2pAt/rXieQDi
	 gceiQe7ZPiZg/iRX0L2geFtsntQqGuF0cDN4KavLwpok1ME4D1yhvbJ1TiLRBXo8/O9Lg
	 SVpLPgG9K7j0iJ/6ByNsXW4AKr51ArYkr12TLMozM7IyH37tUZjOLZ53kERhA7xz/qQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bYZMD7DG;
	arc=none smtp.remote-ip=74.125.82.181
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25CA0606A33E
	for <linux-raid@vger.kernel.org>; Sat,  7 Nov 2026 16:44:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 25CA0606A33E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=bYZMD7DG
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36ecc11bd26so213981eec.3
        for <linux-raid@vger.kernel.org>; Sat, 07 Nov 2026 08:44:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794069878; x=1794674678; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cwPj/yL5tuc3miMt3pQkwgcVVGWR+Pp3SqkYDrCFSX4=;
        b=bYZMD7DGhru4EwZGA53HcQKs9PXfxWRoYdEa8UkS5cPIVeJk2Trobpsc6CR25V8iNg
         VtnDYeUP9TpLEQ9awEQPqbhrGzzb7CdET5VWPA8PWPk01v//VR0P9XtPLaXBCOdeUX8Q
         tZyTh1e5t9VZQv0e+WBaxcvXPpbXsRf54qKkEvHFI648VVT3A4sh85XmQcMrS7SzNEFJ
         1AzaymQ8xv72gaKHR0tbsS0hcegYTcXehOCNjd1hxesBbHFJwi8/4vUvBbGF8Cet+pQa
         xfXMB6rxqHKL9nz1EhDU7yvO+teM8IqQ/TRlqrvJpI2X/i8PCxhAIyRJjg2sMPyKyekr
         ftEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794069878; x=1794674678;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cwPj/yL5tuc3miMt3pQkwgcVVGWR+Pp3SqkYDrCFSX4=;
        b=B1j4a8XqNrbFCvdascjC+6utVFV5RBr1Bf7BWva0oJI2CZV6WZHN3enKXG5ziwCCus
         tAQBuWtEkhQ7QBLr+MhMneMOYFYb54Aokukat3SgcioPeSc4ZABCnYZ6PiKq0aehduuE
         vFHGslaPPoBqiVxBz8m56OgqbpdldgUpfxNw+xpCswynXr/oNngvBICz9dwCTkzWp8m7
         19Yi3d5LwRiJOyNmfjQ+9uFFTNTDkflx9k/i7V/LgnXzVd/BQUkXQ5mvOwwvO1iz16UH
         YTRo0aW02S3c/WWCCUX/1DetWNhvzgnejGE0LVG4CIfvdh2+fLOnCl8jdB/xbPbvTS9m
         ewWA==
X-Gm-Message-State: APuU4Z/iAuOUMdi0T8KT6fd2xYgfvw6M7f5VOAC+gFZe5pHYxfI0jiAv
	i/05nLuf2mo9SDp+X/umRtC9gsBbF1yhC87PRmTVrueZx/IDfiw/98+fqxsodHC1
X-Gm-Gg: AYBFou1cve8t4DWADJm58bWhH179fgmEozuEuF0PY4aJZIVv2nl7Oy/0ozFkegZ7WzC
	JXrWqqDPY1gpIImwtFLP6YHsdt08Vv/eeqAVJ3HD0iJj0B4g6J86iNcefeqOoIaGWWBygKaB5nX
	uj084P6zMCCyWo1xauXp4no8w40HcmfwVDkxe5K3749lRwP5PEu1m6+Y78xQJoCsufLTBEjGoh+
	0WDsuU7gontQuzbmlHrcQF6LVqsynAHjmr9zcBwOSHD8JzTjiaIazhFvxbNdYXpDCaTaF/bu87b
	dBiWnlZNA9dvKjhXo1eKRcnl/K51ECVMwfvZ8swmFIbvYc/WpkKtnglZsRYI84RkDrej11U+QT2
	Ow+3cFKlStgQNKg2JVocWOAK4NeBVHJFnx7OCrt9l+v2V2GMY1qATGBPghse2cACWLYEBGym2DB
	66qlpRzesE/kQm91EhAc85fO/+DblXY13dpilZ98vh83d2L7sD0jWs7m5HOyIsx71mjN7AcoZ0V
	nCGf7UHBHPQbnbZ01PZh5xqI0ou8KcGOqsWMYAijObrxR33zgbA0PaVe9thQUko6nju/p4oszaE
	sK++xoycykWnt09iI8opLxWr05/txrdHDRFpFRAELqem9J7jm7C29oLtGQLstA==
X-Received: by 2002:a05:693c:8852:b0:36c:a1bc:6114 with SMTP id 5a478bee46e88-36f6f3a068dmr6131284eec.0.1794069878005;
        Sat, 07 Nov 2026 08:44:38 -0800 (PST)
Received: from localhost.localdomain ([142.249.36.161])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36fa8d44a5fsm16172802eec.7.2026.11.07.08.44.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 08:44:37 -0800 (PST)
From: Chengyu Liu <lui2012qwq@gmail.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	yukuai@fygo.io,
	Chengyu Liu <lui2012qwq@gmail.com>
Subject: [PATCH] md/bitmap: fix missing_pages restore in resize rollback
Date: Sun,  8 Nov 2026 00:43:05 +0800
Message-Id: <20261107164305.11476-1-lui2012qwq@gmail.com>
X-Mailer: git-send-email 2.25.1
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The rollback for a failed clustered-raid bitmap preallocation copies
old_counts.pages into missing_pages instead of old_counts.missing_pages.
The counter then reports every page as missing and can grow past the
page count as pages are freed later, making the used_pages stat in
/proc/mdstat wrap around.  Accounting only, no corruption.

Signed-off-by: Chengyu Liu <lui2012qwq@gmail.com>
---
 drivers/md/md-bitmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b8325cb09a37..66ed92a0715b 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2495,7 +2495,7 @@
 				/* restore some fields from old_counts */
 				bitmap->counts.bp = old_counts.bp;
 				bitmap->counts.pages = old_counts.pages;
-				bitmap->counts.missing_pages = old_counts.pages;
+				bitmap->counts.missing_pages = old_counts.missing_pages;
 				bitmap->counts.chunkshift = old_counts.chunkshift;
 				bitmap->counts.chunks = old_counts.chunks;
 				bitmap->mddev->bitmap_info.chunksize =
-- 
2.25.1
