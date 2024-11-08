Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3836233D8C;
	Fri,  8 Nov 2024 22:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731104394; cv=none; b=OYKgFPI/G/oB/s/pin4v4nIdpDEZHGz0XNNCVpoz2Rqe5aVe6xZwXi94gyR6xmjNWW44wtGdqGykRcVxX5T+DfabT5jO4pBZ8KPvX5ZFi8PIujB0pVoKHyTaSjadpP80vX0N9UffQZELO5We0+eYZUbyBAxCch+46miI9lcqw34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731104394; c=relaxed/simple;
	bh=23UjeEUivmVwsb+kirIXaCrXN0BlGADYbG5nSjE52ZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PSF415K3xKtWw5JG0XBDaVb3CMu0EN9CTME6t2EhY8gQKp6Owyu9M15faaLBr8XXw4mhnpcWSqubjZ6ECtIag3C2iBcjZN/25INfjtCIYpsvaMY9IpqRDmRQSaIqG63cl0uQIPRR1prv9vwX6K5VgMKd50n7TjbJuVzSn7VMt9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b=SIuZiP6D; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pkm-inc.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pkm-inc.com header.i=@pkm-inc.com header.b="SIuZiP6D"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2e2ee0a47fdso299204a91.2;
        Fri, 08 Nov 2024 14:19:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pkm-inc.com; s=google; t=1731104392; x=1731709192; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=akIVwvFuI+JeZE7yxR1K4TB9zAa3pvQZ1RXICx3q1/w=;
        b=SIuZiP6D756UYTLWSDsf6LNsPvHF+TbmGBuPki2QrdiRnbV273W7nagW43idN1y8z1
         aNoaiphUZvKu05dS2aLogBN31PH+LFcLPwim3OZdMLg17qQaFbS52wS4CujF7F7ub3GB
         YRbeK1TfD8mwfroRIMS7UGal/KYD2hTQAQRYjttS23G0KL7/BEnHh5endckBImH3cu5K
         uX3dUvqzZqmV9TmMOGXL3MQM1S1nrZTGGWYuyTeulcrVSVk42GRo89mKVJtPmnS8vFNE
         gdUytBkdZFFROCdltsVG/H8+ltBbEuZkNnLuO3z1xUvssFBrPGVo6MJ7UBcrPPTRKQTe
         zwtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731104392; x=1731709192;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=akIVwvFuI+JeZE7yxR1K4TB9zAa3pvQZ1RXICx3q1/w=;
        b=nCQD16J1WUYqXTic8tijCDHCUh8MZ5GnDhavU0tpCAEihn7THS8CTjE0AV/1a2B5gv
         WTHA3B+TmVpPKYKLqKAcfv3/NpFxdPrN2c+EOQymKlA7wELzqNlnldnBoZG4JEMp82A3
         ksb0AIygtegiq7ojyaq4EHsuB+sXIV8lvGrUjzYWM0kEA/5pUUsBEWciR/Rpnq7fov6C
         NCuAdjSYwEzFc46aKSRU5ar6W0xu/NsLAHQkLZjBj3mc6xea4TBVL9UQlaq+WOj84qAU
         noIPjYgZgrXFmUEmKy2D6+sVo4I249oit0mRMFcqw5K1bhh3ACOUEqSnwC59So/OCnsf
         Bd1g==
X-Forwarded-Encrypted: i=1; AJvYcCUs3Tp6utc7Hc5lVEnprgJrm12fG8seWHqA7HChEjDhnT8hrXWI1efoRgepinHDe98YLF7G7vwSSu3cSW4=@vger.kernel.org, AJvYcCV8UiS0BXr7tinYRFwtho54mMn1ExO9xcDYqwzOZjNWbHhPO++TxctgkyUESwOjCR5N8ODt8vVNs+qfwA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwNyVoiYBtPUpFkN6P54Xor7kI/G7lsNvvYZf3s+QpCaaY4Q3Z6
	/SCPkqteEtqF+EtRV8jU8z98l6Qow4rrIDTuWnePGtc6UH10TDV57AqiSMFeHCzJUAExGjBKvhs
	orrLR5l/7H4cjd3+Kao45upJYedUOZANAY6jg4g==
X-Google-Smtp-Source: AGHT+IExFAqaZOcsqb50s/jec5FHnVt6PQYF3hf8ganxBcdN7P6KgPg1W8t9Iu5aCCK3R4313i6iaFH3koqzsLBvO5U=
X-Received: by 2002:a17:90b:1812:b0:2e2:ebce:c412 with SMTP id
 98e67ed59e1d1-2e9b14c7409mr2675592a91.2.1731104392127; Fri, 08 Nov 2024
 14:19:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
 <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com> <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
 <CALtW_agCsNM66DppGO-0Trq2Nzyn3ytg1t8OKACnRT5Yar7vUQ@mail.gmail.com> <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com>
In-Reply-To: <8ae77126-3e26-2c6a-edb6-83d2f1090ebe@huaweicloud.com>
From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Date: Fri, 8 Nov 2024 23:19:40 +0100
Message-ID: <CALtW_ajYN4byY_hWLyKadAyLa9Rmi==j6yCYjLLUuR_nttKMrQ@mail.gmail.com>
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 Nov 2024 at 07:07, Yu Kuai <yukuai1@huaweicloud.com> wrote:


> I don't think external bitmap can workaround the performance degradation
> problem, because the global lock for the bitmap are the one to blame for
> this, it's the same for external or internal bitmap.

Not according to my tests:

5 disk RAID5, 64K chunk



Test                   BW         IOPS
bitmap internal 64M    700KiB/s   174
bitmap internal 128M   702KiB/s   175
bitmap internal 512M   1142KiB/s  285
bitmap internal 1024M  40.4MiB/s  10.3k
bitmap internal 2G     66.5MiB/s  17.0k
bitmap external 64M    67.8MiB/s  17.3k
bitmap external 1024M  76.5MiB/s  19.6k
bitmap none            80.6MiB/s  20.6k
Single disk 1K         54.1MiB/s  55.4k
Single disk 4K         269MiB/s   68.8k



Full test logs with system details at: pastebin. com/raw/TK4vWjQu


>
> Do you know that is there anyone using external bitmap in the real
> world? And is there numbers for performance? We'll have to consider
> to keep it untill the new lockless bitmap is ready if so.

Well I am and it's a royal pain but there isn't much of an alternative.
