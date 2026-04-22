Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D02038F226
	for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 18:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776881974; cv=none; b=i8TJTIlEuUl8dzBMcKksf6d3FiHUKwk87C+NVyX3YntloSFLzvfFBOH4ngogCKCcuLRltPDEvCYLvnM7JHuCW+/KShqMB3pyAeM39UGOWTxN3MyAKNlGfZkKdZBPm6pvaqH67EdKGZ4YDJwSJcqFj5ApK1uY+e+LgUcYuJj/wUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776881974; c=relaxed/simple;
	bh=+Sfz/TbuXN6WiyV2mcY8E9Mqa6jAyuKik5u4nGTPy9w=;
	h=Date:From:To:CC:Subject:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=uoLV2BeIqmwkQOh/IhytiH4IKYwgTX0H8iVaFSMU8JAvYlVlfmmfNzDoiPUDX4I2AstvM+87lnVZthPbb5MUmUtjLWH7Dcvh2IIjsroDfrdtHTtgmts+vJs410dQ4+/DRhHaA94wTUjUCECepKJISn5oqDw2TTO/TIHDjwf6wNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rZxMsqNE; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rZxMsqNE"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-b9358bc9c50so769361466b.1
        for <linux-raid@vger.kernel.org>; Wed, 22 Apr 2026 11:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776881972; x=1777486772; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+Sfz/TbuXN6WiyV2mcY8E9Mqa6jAyuKik5u4nGTPy9w=;
        b=rZxMsqNE6z1OgRiHD6JzksZcZDkCZ/k1u4V95DhMKLdiTrPDUi5j0IPFaT74pd2k3Y
         DpxermbznGGG8wLa6cNTdRaAJ1Ta3/RuUySb+rJyxgeuthJvFMU72BIL1JWS2Ukfu6PD
         tKaGLv436MUhKcNz46OTlZMBuGWUXIzZuMEoQ4/ERBR53ATsFMb6cJP8TjKI4+7HGVOh
         LX8fVsVJdkAicjvkovCgzCDuo1efevWfHdJXas5zKVhcCBfg3ogaZcW0EwtoLHgP0U6K
         lWA5AbKTtOJf6u+0vWOPkJemOIgga+ups25TkUdgnOzSwMWIe74q9X+L65Ub3NSiTiTp
         ijOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776881972; x=1777486772;
        h=content-transfer-encoding:mime-version:message-id:in-reply-to
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+Sfz/TbuXN6WiyV2mcY8E9Mqa6jAyuKik5u4nGTPy9w=;
        b=q+YDrw+YVfMaTBjUx3JsD5I8Wp7dWnrOfjVXBOE3UsosgFTXJCXwhpqTv3PV36vGLc
         +OSQQeLSeVfTx01fKGuZelWMNcZ+51XlYDzooz/p4JzzV5CzUzS65gnegcWwg2bY92Xx
         RftvO2TWZpplrQ0MvbY1/Sr/we/itFFdqFbtnSQd+NXD/HG279L/mf9gQ8C6/C8Q5TYv
         SXRP+axrJB3PIQ+ZbhG4DlwDPGGV3qLp+2yTRpnC+xiF4lLf0nCw3ckTC+ZwMIv3JQr8
         SoLkxHIZToPTYj1qqVFW+FwU2LRi4jDlykW6E+3DMFOQGK1yp856lCIMCo0yR9VeZ9Uo
         FP0w==
X-Forwarded-Encrypted: i=1; AFNElJ/kZ08LFCWAkKXHPfCqzL6xCd5SYBLJ0+vzbv1zXFhdeM5Dh7IJGU22AccFNxoWr57K1xF/hpkIjC+m@vger.kernel.org
X-Gm-Message-State: AOJu0YzQ0Fp4Bq49Jg/YMROZ1r3OVseckeGzbYG0qrI8AsuonB/Urr1n
	XUwDWGYxwj47rHS2iBzxE9iTvEtnc3D7NH3x5GHA5Zjt/zOB6W2FM9ud
X-Gm-Gg: AeBDiesm0+2Ou0BaX7WZ9i6HX9QluEoLcH9h3S+vbpURRJbKBV7pe4kKrDg6i267dau
	cp9wRrKaMybyihLQlZcmkOxuLs56E3OKP87bubi4aZRLhToVgJOX4XtgKk12Smhwi6SrmepHO71
	oDi5c5CbRFBMuDJFg+bRnexDZlj0olekBqnMZFELp523T7gPQ1CFR1P/Lm1241K2WUGk6dBQJCQ
	/m7cQzXqFz9PmfJ25Qz27hdeDY+WvfD0KYIF+XCFMEBoygpW0nMuR1mK+ROQe9EMqI9kw3Mg9t5
	5E2/dSnLgK6vdRhZeceU0Ew2cscg639ludZgWfIEWDRu4TodLia+7ETTAUsDsEEMjp9o++LTPFh
	5Ztt4kolCHPoQ0hT2HkXqBQ7/s461ybr3fHUFTpN5b3zlNUwWVVP3POjY28UbfPUyhflvnYP8ax
	CxpqHhPA7K+6HmZXrpgyFCsUyWoEZEJLeoMrOd
X-Received: by 2002:a17:907:9308:b0:ba7:34cb:388b with SMTP id a640c23a62f3a-ba734cb3cd2mr794916766b.42.1776881971338;
        Wed, 22 Apr 2026 11:19:31 -0700 (PDT)
Received: from ehlo.thunderbird.net ([86.1.69.5])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ba45553980csm575137766b.58.2026.04.22.11.19.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2026 11:19:31 -0700 (PDT)
Date: Wed, 22 Apr 2026 19:19:31 +0100
From: Josh Law <joshlaw48@gmail.com>
To: ardb+git@google.com
CC: ardb@kernel.org, arnd@arndb.de, ebiggers@kernel.org, hch@lst.de,
 linux-arm-kernel@lists.infradead.org, linux-crypto@vger.kernel.org,
 linux-raid@vger.kernel.org, linux@armlinux.org.uk
Subject: Re: [PATCH 6/8] crypto: aegis128 - Use neon-intrinsics.h on ARM too
In-Reply-To: <20260422171655.3437334-16-ardb+git@google.com>
Message-ID: <C4E4FF7A-8CCD-44CA-8AD9-5BA8D177E1DF@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8bit

Hi ard, this is a good cleanup!

Being able to drop <arm_neon.h> and just using
<asm/neon-intrinsics.h> across both architectures makes the C code much
cleaner.

-# Enable <arm_neon.h>
-CFLAGS_aegis128-neon-inner.o += -isystem $(shell $(CC) -print-file-name=include)

Getting rid of the isystem is good. iirc that was a hack anyway, feel free
to correct me on that

Reviewed-by: Josh Law <joshlaw48@gmail.com>

