Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 806AB25F7A5
	for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 10:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782557231; cv=none; b=I5r9j+0ljGbpaki0qAJedgB+0vgXEMlLB6JkJg62xCBgcQ7d4keaGclgtiP+OC4oriIud5XumlhP5l9BCAa02zhutBFsETK3ZBKIFRp/Bbc5So7pqhjrC0uGPnTCoU7/4zLEf3uPeiBt/ZylJSeXvhs4gtKFdYhU62L//iMwl2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782557231; c=relaxed/simple;
	bh=6pHxHyWJUD3ftUhNZzXjTVg8hPVaPTh+cOba9zXGVRc=;
	h=From:To:Cc:Subject:In-Reply-To:MIME-Version:Content-Type:
	 References:Date:Message-ID; b=sK3MEAGJW7QawGF5MAmFekbTDAuJXXPLeyXfhoT2dW7eZoGJe+NGOVclNucaR8+DzVBup62iVRNlDlhARuVYQxTStw6S12/UDwK4yD5Xu+Fb+BQZuA7cYBZZGdqzI4nidQjZv9dZcJu1CTQDvg+irWpHZ46eoBjyWqDh/WrjgMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BXQf2pgR; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BXQf2pgR"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-493a287b8c1so685395e9.0
        for <linux-raid@vger.kernel.org>; Sat, 27 Jun 2026 03:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782557227; x=1783162027; darn=vger.kernel.org;
        h=message-id:date:references:mime-version:in-reply-to:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=PgcKKFFDiI1sINhyMP2MXaZCJOFKbCazvuFE82CAKss=;
        b=BXQf2pgR2A0ZgfgMJm93MPCw1S2tQMcFM5HY98ZqiYKQ8+uxt9B1pleORkXN959XSG
         mUzZua+uWZgSFtTnlHui7rWSOpPHjL1gnP94xuP2kv3LMJxqp8jjCvF1v0qWd0uBdjoC
         AILIgKhCSqmVLTWqhyXE408b44NouGd/yC0QLdkds1YQ7YoVSU8H2md/QMpB//BTRvh+
         KBRbBgzQ4x71LmNqXUIkEg6SBfBmgCMMTz48nOckLuapywnUFtZNlJBB6tEo31ItR54M
         BJ6SeEyjHtCdh9t3xZ/XARcaIe7whTo5pvK4FlJJ0maZdi5hSLDpXKOTvjSOBH4s6spp
         3uiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782557227; x=1783162027;
        h=message-id:date:references:mime-version:in-reply-to:subject:cc:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PgcKKFFDiI1sINhyMP2MXaZCJOFKbCazvuFE82CAKss=;
        b=MZqyKJXaPmOgH5LcixVrL7pli+m9Bjv4UYJmpSNiXD7N7hs+00ubnpCJEe7Me2eYGg
         gWbTUdQtIgOWhf6pNXfyqN2VD0T0rXq6MWzBtoqepZSEIp3hDJE0Tb+48HJJLQn+eZYZ
         SCOo8xfSyo+Zi6jZt+7PAHpIbk+79kCMQUqDIoCwZ7fuQwq5suqkmf5llZuv2IagmAU/
         r3aavVza3n1GM81apvNDg5qP784WZ5Z3IfRGBP/fwuHaMjw2drt0hU61CK4qsFk3iEdJ
         KtGbZvwb3KLb0PF1uLBZjbte13RCFKSWJe6sorkMOQf9I8kzIKIGN4dHOxmb0w/jAXIJ
         shMg==
X-Forwarded-Encrypted: i=1; AFNElJ+geaXWFGE59rJPzDKRKXhvMJyjz9LyJj1aAzcXJ0NXf1YtwnwST81eMD09PfOZu3qAE4wbFOKygU4q@vger.kernel.org
X-Gm-Message-State: AOJu0YzhmjoJuQo4JWEWSUdo2Gz/LQTYigARLWpMPhDCNQQzXqqSiKuc
	RnLU1SklwJsvpBLGl34+zVh0oaFReoghb7o/a8a2AyOCyRIZSHVJjERV
X-Gm-Gg: AfdE7ck0/nG1a1Luyto4DHlMQAGFXr3fvKJF5EMWIuqLy1Za5G5pJUbSzSuA5ys538C
	3G3EORk3H8eWsCz/9C2KVppWfF2NlrNy99htZHQyKKOxu2SaGv+m21o4FdLlN/sd1yfCQ1TDR6S
	dataQ5B9R6XEtoIe0aT/mQCLTdTi7Tr+hkCm+x+9bEY9sZ2WltolxF7Wnz169rwj6CeB0+MAyE4
	8dcudKVx3/bzGbijicunIRmfMS1kVxICrQ9Coy64RBxm+mj1b4nyJGl5Lh9hkHJtTJNAgxKK1LC
	gJTzXDVgCC6VOQloy7ng9HwhRBo6j9zT/V3U8jK/AUIbSSTZYHWMVzeezjCNejaXBfBxE/kHdFe
	PdOcg+/Gy58+Z7wlOPWWTAh3LL3sQj2i2wdrO7PgH78ls9kbptF/qo/Mqs75y9NEOfYTA4A4qIJ
	+TYh1OjmXvlYjl1ztH6e+des7XMVEJFVoAB9j1BFqXP7xJdQ==
X-Received: by 2002:a05:600d:6405:20b0:490:bb3e:30b0 with SMTP id 5b1f17b1804b1-4926685feabmr119517985e9.4.1782557226603;
        Sat, 27 Jun 2026 03:47:06 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([141.2.113.129])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-471490336d5sm3421142f8f.35.2026.06.27.03.47.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Jun 2026 03:47:05 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Chen Cheng <chencheng@fnnas.com>, linux-raid@vger.kernel.org,
 yukuai@fygo.io
Cc: chencheng@fnnas.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md: protect read mddev->recovery in md_sync_action()
In-Reply-To: <20260627102909.141036-1-chencheng@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
References: <20260627102909.141036-1-chencheng@fnnas.com>
 Hi Chen,
Date: Sat, 27 Jun 2026 12:46:51 +0200
Message-ID: <m25x341cro.fsf@gmail.com>

On Sat, Jun 27, 2026 at 18:29 +0800, Chen Cheng wrote:
> From: Chen Cheng <chencheng@fnnas.com>
>
> md_sync_action() read mddev->recovery in lockless path, use READ_ONCE()
> instead of u64 plain read.
>
unisgned long is not always u64...
I can not see what it fixes, is this just to silence KCSAN? If so,
please say so in the commit message.

> Fixes: e792a4c2156a3 ("md: add new helpers for sync_action")
>
> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
> ---
>  drivers/md/md.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c5c50640b684..f4415c1a79d9 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5074,11 +5074,11 @@ static enum sync_action md_get_active_sync_action(struct mddev *mddev)
>  	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
>  }
>  
>  enum sync_action md_sync_action(struct mddev *mddev)
>  {
> -	unsigned long recovery = mddev->recovery;
> +	unsigned long recovery = READ_ONCE(mddev->recovery);
>  	enum sync_action active_action;
>  
>  	/*
>  	 * frozen has the highest priority, means running sync_thread will be
>  	 * stopped immediately, and no new sync_thread can start.
> -- 
> 2.54.0
>

-- 
Best Regards,
Abd-Alrhman
