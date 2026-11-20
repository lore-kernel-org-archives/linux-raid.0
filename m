Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795173522;
	b=MwEMENTmDe65UeN6h2HZiB4hTbkaxXTPtMVF/Hc4TuwQUg8FX3YXzKr2jR8xMcn9fQnh
	 fBiOFRHJLaUREaDuEsXmBCekq9y7ZcyLFeBFSLh14RafOGZ9pGc/2ZsoPCndMQeGMdWdK
	 uwitu2CESdnLOffq/xqdboVyN/j2Iwu8p6jQW2jvyrXQiaq7uUGRw8cODdhHB9nRarsb5
	 27peFyrKrF+2ntbm2jnFbWWhjUMXqWNoiJUiaRQDTE4QpLWmWoohcCbkUkDpG4PL2vlfm
	 ntqEfsKgrup7AIqA8YTq6XnvHPNMJahe0GHGchou3kXhW67tdj+XRf7ybDiFkLOxKgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795173522;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=k601JWrAQP7gZSxEDk6d56SMgqLV0ht9a++a4PXuy4c=;
	b=Ea18f7r2MK8J9mVljtZxtVo3hxwCeOFAHyVawiDdFVyG94y92VEzDO4HJ3NmiPguwuhb
	 N8+1V29k2yTOz17mIkKD7TbwFkcasOBnZLZidqr6xL+/WH7nD2KRng5eIJQzO571mGPFa
	 zmK4Wku61SHHArcWanhp9+XQ9CJLETajRYzSBiGSo8auC9SHlOndlx2GflRjMKv7sQWbs
	 4rA33A2+UOqrLldwnEyknElnrkGM2+sa2v8F1O4EJmW3Pnpz0ia1ub+24VvY8d3nCJn8E
	 VVW4IjfhPXG7xVLGSNXa2bUdlTjsq9VGo7E1Da/WHO1sONqeFtS69Sp0xWwpftZFXmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ahWN85vH;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D668C606A338
	for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 11:18:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D668C606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ahWN85vH
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a35a60499eso5859165e9.0
        for <linux-raid@vger.kernel.org>; Fri, 20 Nov 2026 03:18:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795173520; x=1795778320; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=k601JWrAQP7gZSxEDk6d56SMgqLV0ht9a++a4PXuy4c=;
        b=ahWN85vHWoSEM4DwR9HOuN6FXWVtZUo0NPR4Avhttfx05MJ+e1d8qN4SiG5sP0qg5n
         U0ohEYbbXXXMuP6pZI/UCRHkJApTF4Cj9SGyYXNC/nI9kgXAx7Aucqs1wQ5jVfBVoh3P
         YqEdWI3IDAfvefQ27XsIjFRjcR8jC05OVmDoMFSNKWhy76qjq/E63ywDNA8LyUulORnp
         flIQDzvkQgucbmmQZtBVeOToOwCj4a7K7vt50OOYkf/Oh+FaUYNQVkH6siWVcDdHaXUz
         ACgnkiqOOkNyHWkgaLParD2vSGGxzcIsWof+jKVLRSszSSEL9S/xZ8i8LqJ/4PFSimJr
         zr+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795173520; x=1795778320;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=k601JWrAQP7gZSxEDk6d56SMgqLV0ht9a++a4PXuy4c=;
        b=BkpGVaYG61Ctml0NggVY5iaYmDnDFoqToHWPoFLJRJt9k9oFbYbmQy97B3DlCo4fk5
         YS/JETlCO5LgKzeU5xJl60+PjGyQ/qAOBb/gNO+2DxeMfRda7YkWDZFZOb8DZnZtxfI3
         U29HGLv+5ICRO6vItDT9U4OEIeffDLVS160Dp4jC96x95z1PEDtIpRmRB3a64Ea/JUnJ
         o37Y0DREJrvVKl/S/DfMD8aTdmSpQ7WF7ePW0Gy61qdyuAhmFQfyL6PjENv4jV634puM
         aV1P8YSCQm3TkTorhmbyYKx1KE4HfWo5+mh3gvwYxBFE4R+sqIO9hYkYTZL1JJ3q86XV
         Ljaw==
X-Gm-Message-State: APuU4Z8W0Pm/cD4p+an4BlQTZ4uYSRarSVew0tw+V7/0XzCd7rB5Sl1+
	IQ4gBBdCflM0ndMMA9paCKkBsmkuzMMg/WAtXvLDpzGckzpEPF0K0vbo8M36nb4FDDlwt/CL
X-Gm-Gg: AYBFou0Bx9jxBsAMAQ8BObgqeFspI1Y/Z0WLuZE3cXAXMFCFoHPp07PrZo3P6OY1wmZ
	TKeADJWp3NaH/Lg7JFx9hmf7Bp04Yuz8sSpoTuGH/y6KqCt3N9wsgBSqXAkssEt7aqWPLhPleA0
	cJYxn5/sMl7hG1PoVxVWEig3JxsZjT7iVos9tasSxuFfcTFbldn6Q+HXpKyGTVCXQXoval5ZY92
	W8UQblSfOsQonkBAcEvKgUKzsM9kEQ0IohY7YCtV00NxRnXqKJsKSkhf7W4Us6h302q9WtBNXg9
	tolwakm4JGshBPejOlzObUVOSOXYKReCBy+KrGMs45wMaitX5PkJ4ekwr3VNjpx8Uc9bUyAPHeE
	YDKOaBFCXbKkrmeANZfT7lXU/yXOEhvR13rs3m3W1vZcsFjTiUPUS79I9BHAV2C2BSSMV/2bJFU
	JDnc+9qKFJo2bLT1iYCOTQET7K5uvYyOjbiFqC1LfQoKONRYqIwtr6Zh8TjZc/gkiDwlWMzhdrA
	+Mh+F94iYBH0eQ1cUoloDtn3Uq7U3NhqafH+vxBVaIiMKj/1pe3VsGnaTFH2Yw5ctHMj1RJzaT5
	kpIXsQKKBm2Cu6VfCgrZErsIYM6y6hq+KHKKGI8tc/RTxrITP+bphRMQX4k3K0S7pshIEAT51A=
	=
X-Received: by 2002:a05:600c:820d:b0:4bb:6cef:d14b with SMTP id 5b1f17b1804b1-4bb887c34f1mr65783585e9.2.1795173519913;
        Fri, 20 Nov 2026 03:18:39 -0800 (PST)
Received: from DESKTOP-OL07BOP.localdomain ([87.116.183.240])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4ab658e2d60sm4985562f8f.3.2026.11.20.03.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Nov 2026 03:18:39 -0800 (PST)
From: nenkov2004@gmail.com
To: linux-raid@vger.kernel.org,
	yukuai@fygo.io,
	song@kernel.org
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	magiclinan@didiglobal.com,
	xiao@kernel.org,
	neil@brown.name,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	bmarzins@redhat.com,
	syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com,
	Hristos Nenkov <nenkov2004@gmail.com>
Subject: [PATCH v2 2/2] md/raid10: Preserve recovery flags on reshape abort
Date: Fri, 20 Nov 2026 12:17:57 +0100
Message-ID: <20261120111757.4705-3-nenkov2004@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261120111757.4705-1-nenkov2004@gmail.com>
References: <4d13edef-f454-437b-8910-3a905697303e@fygo.io>
 <20261120111757.4705-1-nenkov2004@gmail.com>
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

From: Hristos Nenkov <nenkov2004@gmail.com>

raid10_start_reshape() can fail before it updates the recovery flags.
Its abort path clears the entire recovery word, including the
MD_RECOVERY_FROZEN bit that dm-raid requires until raid_resume().

Keep the recovery word intact when rolling back reshape setup. The
preceding dm-raid change clears MD_RECOVERY_WAIT on failure in the
caller that set it.

Fixes: bb63a7019df9 ("md/raid10: resize bitmap when required during reshape.")
Reported-by: syzbot+8b22a0459202f76b4096@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=8b22a0459202f76b4096
Signed-off-by: Hristos Nenkov <nenkov2004@gmail.com>
---
 drivers/md/raid10.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 066c43154..1fd3f5f4f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4490,7 +4490,6 @@ static int raid10_start_reshape(struct mddev *mddev)
 	return 0;
 
 abort:
-	mddev->recovery = 0;
 	spin_lock_irq(&conf->device_lock);
 	conf->geo = conf->prev;
 	mddev->raid_disks = conf->geo.raid_disks;
