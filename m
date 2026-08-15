Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14CBF36074F
	for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2026 23:39:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786837144; cv=none; b=Emkf8l0jyejKdDv7MuFV23ghOOfq8GoJpd0QehAgPCnLu4BVM7xDzQbrkjr4KrWzqgiKrWQtVIUyLFwIY0RP+PdpbwPPq5weFy86PF/fnPRRbEPIoa5PZhkKiJMNMA8k8R2YM4DBioUGh+HPgfbUUzdwueFP76DyUCsH7a3yUec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786837144; c=relaxed/simple;
	bh=MfXhbakq6teIyb5f90CoM9h56piffmzOtlyLBqM0Er0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=I4p61bjPWzmvr9iabOhjXKR+E72fez9srtU7c5PaF1XcirayI1vevBqU8J1+Z2AVTBzVisX/eZRpTbywOOvJUNr3+68sf1kMzLVWWETgfvApoeszzMbinBrpNw0jlvHEgLeDMO1w09lvMyF38rkVDXYlV5rqPsLQcl5j7x/4ZzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=dKzn88BT; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="dKzn88BT"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7e9f69ee6f4so2239378a34.2
        for <linux-raid@vger.kernel.org>; Sat, 15 Aug 2026 16:39:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786837141; x=1787441941; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e438uvYsHZelLiRM7egZvoN6MhVvRzsj/8jIT9YSHRQ=;
        b=dKzn88BTsb6FLzwM8p4pucHN9Tdb9X1EYF5A60xNW6V5T7Pbduny37cbDZlT2qXv1t
         fGMBAM/Gt/IbsxeWES59QG41D/vRCpuR7yEg4AKkxVuIXiLOhavUzvF/Sn8vVFyfMVlF
         bBvDZ4ougOeByYiGOnh2L5VKCit0H+ZMbTbj8Ul6N+Rzqq+ap5Mr2SsUOXcS9AIIg/75
         pMRRaQ2CEMGwir3qLpmSUwumiBvuXAK2jeuQfPEbVLIhwdh7FOylqx9YAcIDdoaDuWHI
         PgUsu+ATfy+8N/rlKJOtYXZf2DS5RMLJQxuF5nVWpx5S7QvhQ6GTxPR+jz520gxJOy8n
         zydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786837141; x=1787441941;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e438uvYsHZelLiRM7egZvoN6MhVvRzsj/8jIT9YSHRQ=;
        b=cki3pYcakxp8+xAoeiCg+smYq/ksnIlrMuU3cDJKn9hPjzIrUy/6xGtiMrPe8eAJSG
         oeEtIhc5er74KCztJ4hDZVq7mqIQ9o6d6yz0UGtUQ3fyrKl6pemGQf2Z3mRScw52/Gn1
         S9HOgguza4p2mfLXzA3JDZNpqIFkeL6xXv8o3tCA4EtAbWB2eOwC2XzLMDQ8W4l37+8D
         ZXHJuWT9UwyVC8bkP0W3QVVrTtRbFzZx4sFl2ZoSjWvE29yN3R/1GFyQlllySBqwU0CO
         kwZqyRiFpb+869V8kDTnmWktrkgoh+GMks4V1rHG+ThTnyejmuU4daNI0YgO1qNxsH9s
         7AwA==
X-Forwarded-Encrypted: i=1; AHgh+Rqe+iYIM9xdxCwHhGc8ueBwcjKQbGomRkdNtIFjeI5X27ldxpqBeDFwuAV5slwgjk7uRSWzK9zh9XH8@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/L75gOXy4pRDmS4k9w/FVczwuwQY1elHQU5ITLWtl1Jfcid7Y
	M+1wn2W9urGpJHYcx5rVB9hnhSPIDpjtWrDE4Vd31X5sB1/hBvkXl3xCvSea8fEwmYo=
X-Gm-Gg: AR+sD101H3KYpuNkY59ABXPDL0blXkOP2UZFpiZvfqdjhkBq8sGZaY89m+YS39WpUbC
	k/ODcuESC6JxitY4ypKkiHLLXbgeL1cjShsnhmf59vADP/Aool92EknKN1hYiOT+S7tNEHsWlZ+
	XaTMPjymdedi/zMXLbHryxX2JBR6Gn9JW9rKd6GCfZRcj1W3Le802/v/6xjwWe2GEZkwU02Kv8d
	U77Duw8mNE1dDLhIlXSOkLmzCCSDXYdzCSFCgBdHvmiDFJGVucywh5Zyn+hS76GNqp9Nc14S1In
	JB9HUK6AmHCoNTUReO38Q8QXyEXEM0A9Oog+wh4dlOLPRagaDOslWOGBHoDamNFj/7XJYPzntWE
	lXTD3J6vKKiMvmktZPGNsBTN8r5h+Ftm7iMhvQxhEJOg3uGAH6IjamZ58kPs8niwvBhbce69Z1r
	R1TjkmnZjubEGj+9/QztwMuJvZMhLHNesXnu1FOxrE4L/g9hFusu1dJAcuodKTlH9VEtQaFSxPd
	Ccy+shidJA9vE/LaM+P6qxXrM6QwLD0WUOOgHyXTUOcTeu+boRF
X-Received: by 2002:a05:6830:67cc:b0:7e9:3765:79c2 with SMTP id 46e09a7af769-7f3de6089bfmr16447186a34.12.1786837140889;
        Sat, 15 Aug 2026 16:39:00 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3e862829bsm4885308a34.15.2026.08.15.16.38.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 16:38:59 -0700 (PDT)
Message-ID: <2c5431e1-1d7c-4b8d-a857-321d2d61719b@kernel.dk>
Date: Sat, 15 Aug 2026 17:38:58 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-7.3-20260809
To: Yu Kuai <yukuai@kernel.org>
Cc: Yu Kuai <yukuai@fygo.io>, linux-raid@vger.kernel.org,
 linux-block@vger.kernel.org, Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
 Bruce Johnston <bjohnsto@redhat.com>, Chen Cheng <chencheng@fnnas.com>,
 Coly Li <colyli@fygo.io>, Genjian Zhang <zhanggenjian@kylinos.cn>,
 Hiroshi Nishida <nishidafmly@gmail.com>, Martin Wilck <mwilck@suse.com>,
 Sajal Gupta <sajal2005gupta@gmail.com>, Wale Zhang
 <wale.zhang.ftd@gmail.com>, Yunye Zhao <yunye.zhao@linux.alibaba.com>
References: <20260809075555.3215963-1-yukuai@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260809075555.3215963-1-yukuai@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/9/26 1:55 AM, Yu Kuai wrote:
> Hi Jens,
> 
> Please consider pulling the following changes into your for-7.3/block
> branch.

Pulled, thanks.

-- 
Jens Axboe

