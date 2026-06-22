Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD682BFC8F
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 11:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782128331; cv=none; b=MGMKWldyzn4rHqV9CtRUF12amX2Oyf5Ro04HlD/lIgd9niTxsxwgclsPTc1FmO4NVPC8VE56IsalJUrO+MbwTL3jgmK/BKOKCHDCC6yG6XWdTOkQsBehgbjGntazkJOiHA9vn9NzIG02eUFvYX39TZGM7WXWDkeE32Zs2yH3rVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782128331; c=relaxed/simple;
	bh=tqbs7oO63N8yR2HpmHerFlV4caaUVQvhUe66a3YmVAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mNx5LxfFXx7W56r3uUW4MHSsWi1Ym3BCKuvsP2+KS5OV1hYDi9kO9ISa7ILD7oHpVE32eTLiuTwq3bzCyRIoVpRIscSJo5Yj5e1853DwuzG4Z7yoSJQ6hPxHgS/JrlcT3HAxtNU9j0p2fmtC9pDzMp0Xfv9qBlM6fYTzZ/M/Cos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d9ev+yv8; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d9ev+yv8"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6978f80deb3so1896492a12.1
        for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 04:38:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782128329; x=1782733129; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ZN0bqyKdUNtriB1CVrOhR3qldEoHheMlch+Sf/+Qju0=;
        b=d9ev+yv86sLwuMsskJP/l+1riSeyska5sdi9lxAHA6twi9VopFUvCT+W48Eh5Im+Te
         uwKdki9x4V780cwYbxDSNrZNTviyYcutu7gJIJ3NbDjQod0zEajZy/EOGXY2ni68S/9d
         N631vDbmh8xElJMawvc9otUFB2qq25Z8MR76gjwAh47dMg9YejdBGmrbn7s6aPApGCNm
         j3ax1AZMkljbwsTdOjT1isYAJ9NtWDRmi3ff+gphbGG46dGY7qU6rZxyhWJ3sUZ4Dsji
         5QDKYSca6vndZ+B2AuJAKYTlrSY+M4ordcxWygz+fdQQQtJ3vC56veKPvf0Th8lxwGD7
         NbrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782128329; x=1782733129;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZN0bqyKdUNtriB1CVrOhR3qldEoHheMlch+Sf/+Qju0=;
        b=f4UBuAONnmEa8KzAXzQXtBKFTakZtRDP2GQC24FEJGBKwD+72wzb+f1X/Pk+NVyfN2
         M6RKpMfW25d80JcRMDgJsZRmDz/vxVyUlXpcuYSJt6GxVPbxJoQeRiZk3MqcNkQDoRt5
         s1D91qbWt8odkwD53bw2bcKTZWcsto46fL3nYblXdvz3YWZJl41N6xmBhkHmEgHBLQ5B
         ik7GDtw5Wu3pwOZ9UvLxYMzPCYBoqQhgbLztCZ7wPWYGHyZ78PCHLEXRRm7kdEtLH34q
         bmYx8/6BdHAi6gKiKOym1WLYkVP82R6/XWBQmFeg1VXxvVZtC83S+BVupTblXyj60TgN
         cyaw==
X-Gm-Message-State: AOJu0YwlFOoFPZdLHkvbbVwAqsK670JopvfvvTaCo1oZjYpv317WeKO+
	RUpLg5P5HnkuoiMPSFqKwqEMWDoGeZTOS5bgYtTqf14xchlG6boYQzOR
X-Gm-Gg: AfdE7cknzpSHwcYMTZUZKVfjjOJ29huOrJuPs4kMCFPBG1VO3GnF9YLBLLp2jQy3mbe
	uBwsvIqE9JFcwZyNxYeoe03jRGySNzvCW38VH4fAPnKlu4Vx5lsq3Qc8Te0AeoT8r0BOoTDzVmi
	mUdx8v1DcYyDVmMgxE4vZIiUAT7SQgbm+aE1+JMBWE2QdKjMEoNJa499ouyX+eLWeb8sTRyRAvD
	Qvwz3LXCPuqlKoPfVg7gdeZp1wTp1zm+p+IG4DS4Yaz6/sGmm3HgpcUiCskqBTYb+MrK7Ybujwr
	uxgYL5dFf8UelYMoi1mL4QkFIo2JRHwB8TnDa84Z1e2/OvROXsMTmXGQ308ciGSDFNbxsxcjz1l
	m0Mpz7xir8uSF8mmlORVR/yvuXiJXLT83TkHVnZvjNu5wJT9KQVo5UR6k+fnqrH+NrEbBA6Tq2J
	lr4VnUeC/R
X-Received: by 2002:a05:6402:4485:b0:691:956a:cf64 with SMTP id 4fb4d7f45d1cf-697029820d7mr6096784a12.12.1782128328809;
        Mon, 22 Jun 2026 04:38:48 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6977b86f480sm3150666a12.13.2026.06.22.04.38.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jun 2026 04:38:47 -0700 (PDT)
Date: Mon, 22 Jun 2026 14:38:44 +0300
From: Dan Carpenter <error27@gmail.com>
To: Sajal Gupta <sajal2005gupta@gmail.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org,
	linux-kernel@vger.kernel.org, skhan@linuxfoundation.org,
	me@brighamcampbell.com, linux-kernel-mentees@lists.linux.dev
Subject: Re: [PATCH] md/raid5-ppl: convert pending_flushes from atomic_t to
 refcount_t
Message-ID: <ajkexPNDqjzawft3@stanley.mountain>
References: <ajkVDGAdveCH_urr@stanley.mountain>
 <20260622112855.42685-1-sajal2005gupta@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260622112855.42685-1-sajal2005gupta@gmail.com>

On Mon, Jun 22, 2026 at 04:58:55PM +0530, Sajal Gupta wrote:
> > Heh.  Yeah...  There is not a chance I would merge a patch like this
> > without testing.
> 
> > It also really feels like an AI patch and you're supposed to say when you
> > use AI to generate patches.
> 
> I wrote the code myself. I did use Grammarly to help with my grammar and
> phrasing.
> 
> I'll send a v2 with just the break fix.

Thanks.

You're right that calling atomic_dec() in a loop seems pretty suspect
as a design...  But cleaning it up is risky as well.

regards,
dan carpenter
