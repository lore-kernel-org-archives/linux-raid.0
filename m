Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.214.180
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794127656;
	b=RR2brm+YXBbz1NgWOyqntoOH9Se01yocExZ90BtuDPLMhFFQ6FkouSBNzHcKYnA4rzLN
	 wS1uXvS+bfjJ3oZGWfEG+CxxrVYuqqFp8ASITbdTfuItHPr8v+aNd7NGXB2CLwthNrWVS
	 Px/CK/vleO9J/dSZqVoST1O/AvpG7470tF3aeMqgcfmVZK5bVn6kjsxsNj93/geOz/O0A
	 kWknwBpYTNNafqC2Ps4hFvLpjcJ4lDsDWnR/LVzXmxyl3saK7NoLPQZCAxogtsMqvI016
	 P/CUzL/rrUFT99NCR9wOT50lVy9Ool1UXqnnKFm+YFdKVV2bpx2XW6NHVqj2G5R5awA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794127656;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:User-Agent;
	bh=oImRzjWDz8Wxxig3JSKCeNvDBZv9ghzuzFbbGiNLN58=;
	b=3N/WDnVjkZD+BnU4dzCpdV0W6VPa2jzlf9xD2/eLf/0y+/mqqoJ/M6LojYwNQkVpSMFk
	 nWtMavvg/bo/B+1zbLome94e0vtfdCS5fDxQym+DmMlh3H76bOyyzh8w+F/ILIm4WHfQj
	 Kyb8U/gvrsNwjI0GTyH+d307rCNYMF4e559GFxKYUkf98spcxbFSjxC4gCxtCYJwEA0aB
	 FeybaKKnRPQCIBJsqU60XHv5ZQDgJIvvJ+WFKnhXRZlGQiycKSnu0E3ntTDdMqqphVYrd
	 Hq5ZgrgcR2WgiSeFoE9ljGfKnxJErxmtauZURaEO8VcmHtYGL8i3xpJd0UF+PT6xhuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=chrisdown.name;
	spf=pass smtp.mailfrom=chrisdown.name;
	dkim=pass header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=drMYhROL;
	arc=none smtp.remote-ip=209.85.214.180
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724DD606A320
	for <linux-raid@vger.kernel.org>; Sun,  8 Nov 2026 08:47:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 724DD606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chrisdown.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=chrisdown.name header.i=@chrisdown.name header.a=rsa-sha256 header.s=google header.b=drMYhROL
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2e9d1114320so1886235ad.3
        for <linux-raid@vger.kernel.org>; Sun, 08 Nov 2026 00:47:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chrisdown.name; s=google; t=1794127656; x=1794732456; darn=vger.kernel.org;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oImRzjWDz8Wxxig3JSKCeNvDBZv9ghzuzFbbGiNLN58=;
        b=drMYhROLQAzQQ0rCvGEW7U6+4IS+QEXz/+0FkEIiLobw7IaBIVdyXViS1ICHUVrB5e
         bQSZVXmdMJ/FHLzna2uXzpaACX1RrMI8fEQg+In6z3kQVB3rbAs5i+Y4sk1uCE3jruNU
         At/6FWAaHlS1dN4I7SabSoDcdqgB87zdbm9jU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794127656; x=1794732456;
        h=user-agent:content-disposition:content-type:mime-version:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=oImRzjWDz8Wxxig3JSKCeNvDBZv9ghzuzFbbGiNLN58=;
        b=LxKkVqBluJBkpTC4tWsqystFXpm0p5OqahOjmoRwVbkAXR4llYMC35e9gWmzt5KKVb
         NEsvVDdEFS0mLq3cI+V1OevnaWB4hKsDG2Zbc36dL15w0avjmKWHcFBEMvpsuIYI1rg6
         JGz80IMfHeZ2z62D56QkRTvjTJNsjDhvefh4ebFlmtjXU+3K/coHiwKqqdJNO0dcAhcC
         8HgCwz1Nd2jHPY7yAfNQzUcfIN88iuSfad47IDHCK1D/WOFKwi4xdIunsAVbupzrtxW1
         L5e5ofRxQQ1iVOF90ZDvF+ebXeNr0bvamFJmO+w7gpzmsEm0y88ZaNoh/+JasBDUL7Jm
         nqgw==
X-Forwarded-Encrypted: i=1; AL+hErEXpbSe1SR3N3wm60bbPU2GMjWEukUrPyPKX9aRnQPJpfeL+iKiXwEZpmjsw2/wGAi6apAC1ii2FYHB@vger.kernel.org
X-Gm-Message-State: APuU4Z8cb6qysx7nyFunCxq9118EYKn9tmdzWH7GmjrH36ALfpy+OhKl
	pxALtiMI9ZIVzsMro5TnsttY+vc5zkeK2TxF4CxuHC17WOUbuL5iFbMPKuV1VlEN/to=
X-Gm-Gg: AYBFou1PLD/JISqw9AZGauDa0wfMaE91uD4CfhRHJbCN9A199ImWwnS3ImM7TOmtsu+
	nEuCAwAioCeiEZMEzJmRb18mifI6vvRpfSbcO5AIaTFXsbvBxHMKXXRtO80/v9mEpA26mnS7lZm
	MZD/cDXJfugZBuXnqzoFpXZ0OhMR2tAU7cTcx+V0tqALqtfVksRuWNUTejufgZ3doojNzFVKQL4
	OF7kY2HKKVe6QbnT7QL6uFx83DQ/kuhdaQoHcr5F4khqYWRZNfxQxSF2SAFcf6ZBP24Tfr6oMAG
	4a4dMImQuFGyF3tFisK5v3ZS6BSgkUgI9B3QO39HOUawgTxPzwJyuMLvCOR3ZbxUcSPXjpN7DIp
	NsRf4bjUsob0uyjcLXUT9woWVWhac7UCH1XU1ZJHvJnP1r6h1kQIuFBzhOEnjegO/NPimqWQRUp
	Q58cSlMg9wnEjfG13hChHamxK4HWDDKnsnjNmssDSeFvZ9s7wZqoE2+7Qo0wApdtuTVq9I9Y/Iy
	r5eRIcKJzdgfJZALtNc60szt423nZn+FcD9EkEqznVqfCBmB4xaN6FUa8zAoGwE3Vq/ehtW4NPQ
	1UQ0LQyw9imN7JLtdzc1FNTZa6H97KWjBHrpaFxq/ReMqdw+xnwOcKKAzFymfOFE7uJjydPb+eX
	c94YGu4AAr3dtA82/Gog6BTqelJP/e7vTo3B/TACywgf0jiIoBl0BA1IB8d1oiTz2igFvsOORYx
	iO/dQOWSp9BEsiDtGwrfL+IcSJqfGOs+wuU4Qi/hpZenMxvXz4T6ok
X-Received: by 2002:a17:902:ec8b:b0:2ed:3f47:9699 with SMTP id d9443c01a7336-2ed837dab45mr8233875ad.38.1794127655733;
        Sun, 08 Nov 2026 00:47:35 -0800 (PST)
Received: from localhost ([50.175.87.158])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ed815e72acsm3030105ad.13.2026.11.08.00.47.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Nov 2026 00:47:35 -0800 (PST)
Date: Sun, 8 Nov 2026 00:47:33 -0800
From: Chris Down <chris@chrisdown.name>
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] md/raid10: Prevent data corruption after a rejected
 backwards reshape
Message-ID: <avA3JQ6lyAlMm1Q8@chrisdown.name>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/2.3.3 (9073d26d) (2026-06-12)

A rejected backwards RAID10 reshape can leave the array using the
requested geometry because raid10_start_reshape() updates conf->geo
before checking whether the new geometry can hold the current array
size. If the check fails, we return -EINVAL with the new geometry still
in place. Subsequent I/O then uses a layout the data hasn't been moved
to, so reads can return the wrong data and writes can silently corrupt
the array.

To fix this, let's take the existing abort path to restore the old
geometry.

Fixes: 3ea7daa5d7fd ("md/raid10: add reshape support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Chris Down <chris@chrisdown.name>
---
 drivers/md/raid10.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 066c43154497..4ade0cf3281f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4393,7 +4393,8 @@ static int raid10_start_reshape(struct mddev *mddev)
 			spin_unlock_irq(&conf->device_lock);
 			pr_warn("md/raid10:%s: array size must be reduce before number of disks\n",
 				mdname(mddev));
-			return -EINVAL;
+			ret = -EINVAL;
+			goto abort;
 		}
 		mddev->resync_max_sectors = size;
 		conf->reshape_progress = size;

base-commit: 47e1b18f38d74015cb9fd30b5ff2a1eb88e77d31
