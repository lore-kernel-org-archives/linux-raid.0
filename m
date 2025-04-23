Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA12728CF7A;
	Wed, 23 Apr 2025 18:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432054; cv=none; b=qAOyp/xSN8SiW6e4LTIDnS4Sk3UNNZ8BJgTfwjsTUYpZMgKdLFpOqimAN7Lv8po3RQ81N8xRTktR0LxLC/9CaO9kTFQcB8kdQ3Fsip5htZ4lNx4+MXqrPHrrDsze+rDHaxqSbRlvpAc9Cipgur6b4l7D4w8oEZEZWUf1ADIWkxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432054; c=relaxed/simple;
	bh=4JC22pUjr3FEUyvUE39zXrZ8IUXJDGvcrodpViq8wnQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pcAriwotYTP2bNQcmNo4DNdgVwscU5jhrdYUNBBbmmGKaHq594jSlIxLU65WG9hokme561/Ari/Fuiy3sqNxs6G20i7MCmKbyZ5HSZPjcg3PdCdM7U7rC75nxsxRNQ3ELL6/E8cyGP346dn0SPhphQ0yBbrAOG9CtVzeSFgQW88=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hxtwqa1R; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hxtwqa1R"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-acbb85ce788so33186866b.3;
        Wed, 23 Apr 2025 11:14:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745432051; x=1746036851; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=N38OFQgH4rJbYV1raBQPBjITY/pMbj/1Np3A8vNBTro=;
        b=hxtwqa1R2EJA3yuhYrf+vd11XCoIL8WSY/U/B8fKxF3d+oTZS3n6isq4OBXwLx1OlS
         ittAqujEWyHrp9NF4N6vikrbTJJJgIumjjPdXG3NQnPluQDjyqdZkzbfUO23H16SIxXF
         JOEkD/isYj93+GuSqwD8Pip+6cRgicbm6Kuu5RHmkTqI8zBHZqoWWryUe5Nm45h299IM
         NuTnwGme1yaraIg9EpCRKhF62JYJZM+H6DSF7vIIQL1OFAkMhoueFdY82/fJtcyuMILr
         TQTx55sSbzhL7KFr4bPLxq6ringoescaNrNo0VncJ54hy4U4Bd5KcGo3oA6YOOtkxSDs
         ILgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745432051; x=1746036851;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=N38OFQgH4rJbYV1raBQPBjITY/pMbj/1Np3A8vNBTro=;
        b=BndY7zJJYgTl/Ifc6YutsNxuEmJEOpOus3ua9Xlp4OnBVpYpyvs0UlsLOLLkKXn3Lq
         AZ7tlAwiMt2THb0VDJcPVpXAGUZ9jxeQEJSsqwcm/p+CZNTTh7a2CNcpSLNUdKai5byE
         E0QGIrbj4xCMQvXTNe1HqEpkmO/FEZP9X8rt5+3dRrGhDxpvyzc5NlqIanYPR4ZgHdca
         bgyQ98n93J0Mp1VlCLPn+oyXUFCFbBaRAi5cww9PquEAy6BRnI5PUMl4lQYCy65JMDwV
         +f76q9x5qnKm23vwA8JClmHhTRY3qKkAG/5ljXW1CyHHtQdo/0bo83tXlQDPCEoItFIC
         LFGQ==
X-Forwarded-Encrypted: i=1; AJvYcCVnWzDXCAbGoEvo+Ugmt3fOyD6GdgWAvpidQmMoDV9JpobxBmnwvdVEhuLbY8pI7SsuHtewjfEhtsYQTQ==@vger.kernel.org, AJvYcCXA5QfSBwL5452xpgH362V3dcs07GdHuEGHvu66NLV/t8tb8KdZ0BO7Zktlo2g/JrPTsq+QdgTuY23/dXo=@vger.kernel.org
X-Gm-Message-State: AOJu0YyZyUfcBPpvJAaAKYd/IXOoFcAQOK6/J+GZJR4NQAVX84Qj9JBg
	RI2z0UXsmQa/kNGoholDRA5C4KlgY9SdQRJRuoPyQsYBKW7rKavS322yqFaG
X-Gm-Gg: ASbGncu2ljgIG9+1DXUJrosNLndquMevSz3LstFhGOvDleuwsBp+SwYdWzC8OV70k5j
	DTlGBpT4OhWqkMaH1HJUquJBWsbT+EIaIeHBz+2C2Ag5gakajO33g5GsmmXyPUAL3GUalDPeFuA
	H+CVH0ixR2SR/o07vzW+7l/eMYYBKCdzasVZ4gtOKC1eKy0vS2637I3KSTXfYbtOrALL5Sk1vfC
	EV6y45xQEA4ARJ+XjZaXgMQvo9PmAeVLg5YVWMMcp1rknvWgsN7rWIljeEfjNsF+LiZSr/z6gNV
	TRa0xJP3gwAZyAtlU0hXaC9uju8yLZkNdYEEIYgRFbfJPttRmw21Vdef5I1RwDG+quK1ITZUGA=
	=
X-Google-Smtp-Source: AGHT+IFMlXIPTFT4ln1LIoHIiN0yBilnqV1l8jFJ/7besP0nipzmBe1LCsN2p4R1gCZruu5fx0syoA==
X-Received: by 2002:a17:907:3f19:b0:ac8:14ad:f3cf with SMTP id a640c23a62f3a-ace54eec178mr8227966b.23.1745432050712;
        Wed, 23 Apr 2025 11:14:10 -0700 (PDT)
Received: from eldamar.lan (c-82-192-244-13.customer.ggaweb.ch. [82.192.244.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-acb6ef475a0sm840074766b.147.2025.04.23.11.14.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Apr 2025 11:14:10 -0700 (PDT)
Sender: Salvatore Bonaccorso <salvatore.bonaccorso@gmail.com>
Received: by eldamar.lan (Postfix, from userid 1000)
	id 6B9C8BE2DE0; Wed, 23 Apr 2025 20:14:09 +0200 (CEST)
Date: Wed, 23 Apr 2025 20:14:09 +0200
From: Salvatore Bonaccorso <carnil@debian.org>
To: Yu Kuai <yukuai1@huaweicloud.com>, gregkh@linuxfoundation.org,
	sashal@kernel.org
Cc: stable@vger.kernel.org, song@kernel.org, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, yukuai3@huawei.com,
	yi.zhang@huawei.com, yangerkun@huawei.com, johnny.chenyi@huawei.com
Subject: Re: [PATCH 6.1 0/2] md: fix mddev uaf while iterating all_mddevs list
Message-ID: <aAkt8WLN1Gb9snv-@eldamar.lan>
References: <20250419012303.85554-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250419012303.85554-1-yukuai1@huaweicloud.com>

Hi Greg, Sasha, Yu,

On Sat, Apr 19, 2025 at 09:23:01AM +0800, Yu Kuai wrote:
> From: Yu Kuai <yukuai3@huawei.com>
> 
> Hi, Greg
> 
> This is the manual adaptation version for 6.1, for 6.6/6.12 commit
> 8542870237c3 ("md: fix mddev uaf while iterating all_mddevs list") can
> be applied cleanly, can you queue them as well?
> 
> Thanks!
> 
> Yu Kuai (2):
>   md: factor out a helper from mddev_put()
>   md: fix mddev uaf while iterating all_mddevs list
> 
>  drivers/md/md.c | 50 +++++++++++++++++++++++++++++--------------------
>  1 file changed, 30 insertions(+), 20 deletions(-)

I noticed that the change 8542870237c3 was queued for 6.6.y and 6.12.y
and is in the review now, but wonder should we do something more with
6.1.y as this requires this series/manual adaption?

Or will it make for the next round of stable updates in 6.1.y? 

(or did it just felt through the cracks and it is actually fine that I
ping the thread on this question).

Regards,
Salvatore
