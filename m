Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1096933F399
	for <linux-raid@vger.kernel.org>; Fri, 12 Jun 2026 16:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781281189; cv=pass; b=TfSAxMxz3Bi1tlQAA50NeX5sNfAlJUVfIQ48E592SYG0gsYIPuVe7PWA1Af9WFAoW+pqWsn61RQg00t0oCp86VyXY6SjCvLyfNvDPoLoidaNjEKaX+GveYorIfu7A7XdgVOp5PS+j0jB6ltlMPtE8HiFNcmIqa5CNqWS8SSnoGo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781281189; c=relaxed/simple;
	bh=lneOiyv0gwKIduIIbPK6ifsYgDWd2qr/ZZL2BZRVBjk=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=MpU1CdvzyYZvMMnWt/AYU1YVXubbloSjxptNmAxiV+aOfudzL6QhOx2fXcLxbRZe8ITjM273T2weM6vQjBbk/XgMRWWMZYf5LOk54rKRtL1aQsOPV3dPacEElZk4AAh2TYZwoZPkbpfOLrEqQLYOHNVF7fMhb6GBkZ+nH9gdpkE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=b7talsod; arc=pass smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="b7talsod"
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-68852b58d87so2102002a12.3
        for <linux-raid@vger.kernel.org>; Fri, 12 Jun 2026 09:19:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781281186; cv=none;
        d=google.com; s=arc-20240605;
        b=Sm1ybbT1aUJJxwmc4isytcFa8DPXb5I1I8gWLNGLd5Q0t5b+4wC/Hpi6iS1qviOtMW
         P1H/OE8YuLhgqqL1MAmAGnPnTQuhqHO6+8nw+0nDBSXkr4YjB4S4IoRX1XqHR2gR1/cK
         uoL5oaKNLzJL3wWdx8mP1hgWlV823CRUKofD454hqd77QPMrbNoxBTMb8PVdlZzI6H/m
         DTL/LyvGNU3XDRMCkHOWAJ8KL9fe3HXhjMaOPHCFHbrzIeOzxRYqq6Mc9Cl060/7IuYi
         rP274QgKXERyuxShwT2JZKPHRC7AOkH9DthCFmSZZiyp5yT9LjoBLqnGbgcxGEwv19u9
         8U+g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=lneOiyv0gwKIduIIbPK6ifsYgDWd2qr/ZZL2BZRVBjk=;
        fh=X3wQ2D3DBAZuXswHTOsYFcAief3bMBJ7HKWbj/5u/jo=;
        b=NYxVKXUBzOwLZ/llEdADZpBnCBTyUsFOec2j1JMk+cCjkirDpdWpWvZJ7ETKRo03ro
         OMWVkPgIl/WQj5r5uHlMm98aWZ1j08PE9LifEB8RyuuIP3ygiW/43F2Pg/6MnBmdSuUG
         zOWrwgylZNrEJ3QtGUJTq73ZzWaV+/bpVuyCjSt79ykQ5l9LQ9DBx9IlZdL0Yfr6xnrk
         IaDULQk2Fd4l8cx5YReECp9zpnstSw3JSpbDvCySmwEwjaxsWb2i853DKxAb+TBBcb4w
         5zBs0t3Py+VP91DJj5RwDeAHyPzgZIOB9L1mqqCvIfE1DjNhjh4timbkgL4td83qbN9c
         LlJQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781281186; x=1781885986; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=lneOiyv0gwKIduIIbPK6ifsYgDWd2qr/ZZL2BZRVBjk=;
        b=b7talsodOg4tVRrIjMwwlQ62QoDR4mi528xL6678baaflOjuqilVZN/9wqQPeLRzpQ
         nrsg4uRFv8ohWhIPD9SNrqZIMtEjp+FcsScDI8ZiwVmT30HLTgYmqJKv6H3FeRg7aKEL
         w5U/0AjSIj+ZOA2eKwUnTUiBBDQQhQ/Y8gdfRSUiMrdrWAVKY3qQJTgGVuzpQYj328Wl
         MGFYvxPMvurtjegA9muA6Yg+Umj7fRHqAOoO453k4py+wJxOEUu4JRmxKczquLMdBkAn
         gHHKanHUq6uN7J+XUb56+T7Wif/CvmM5thhByKRTV8px6MszNvd3cjgAA8mIFG6wq++2
         Jjkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781281186; x=1781885986;
        h=to:subject:message-id:date:from:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lneOiyv0gwKIduIIbPK6ifsYgDWd2qr/ZZL2BZRVBjk=;
        b=CN5Q1IoYVvAWIIh+kuLIr3fvATk/RvHdkHZiH5fap35Io1NJDdjyCV8os36YCvZtIO
         bgv6JOm1bZhnZYlPiEin9lUlJ9pJY+PASpwrBF6H5BnlRMVShKvKgFF5XY811NpVzROT
         1uR+b4bevAz7oQqeevT2AqNIUcdwDaez9kwRsct6kWNROUTVszVQrz4GYvmy4lGzzgNY
         T9G8KB2wYc2jT8RnjrCG8fDpGai0UpSDBnT4pdAkCR+wG5TCUT3qsBT9fwHycJsNcC4i
         ZTXo/bR1N6dVI6e5ldfJIjrI0IuHdbBxVbpcrg3oICYXssSwqytYRMC0RZgk/LEjG0ih
         RboA==
X-Gm-Message-State: AOJu0YxbmEyRCQ70Km3kmLzr/cLJcE3KwTj3p5RdVX+eXG3G2+jQAnJT
	savs4XaympCVM9m06bD1IVBBp6vs5Oo8w/fiseYhpq2zuaePwboHe/KGgy7Ecvq/khItMDphK76
	NA2yfHAPM8tDDPBdNj9axYCPcb8kaLakS6WBq
X-Gm-Gg: Acq92OGko90fMXchsicKhiyplZTCk71GtYgX39TXBxL8EmNCpmXmmyv6HvYOqjpJWky
	GtufbXWAEWZpnRmHw1XM06Ne41dm+iqFsqckyWfJVPrYj2Ws6WXDWP+/cbxDEsWm9EZwKZ2osVU
	fej9E8yKdfSYK6NCRimonaab97jYK5iMtxiIrnFmJjnd3FGKj/npjrdHuloM001924xwr9pupGy
	ixaE7z8hm+fJXO7VGshvaJDE3vWkz6wYDKU8ZaKolxPaa/AaAKhzYWWLjEvVBby/DJN0QOgMaGZ
	KZc6/i2R
X-Received: by 2002:a05:6402:4494:b0:68d:642b:3d4c with SMTP id
 4fb4d7f45d1cf-693788feeb8mr1660538a12.11.1781281185426; Fri, 12 Jun 2026
 09:19:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Anton Gavriliuk <antosha20xx@gmail.com>
Date: Fri, 12 Jun 2026 19:19:33 +0300
X-Gm-Features: AVVi8CdtH_xSBU8KRDIksVLZo1JXuouxGS42-tRZhdzHpNYeyUdKaKSdUP1tjZ0
Message-ID: <CAAiJnjqmW9PWQGacci0pNi2uT59uS142kGtLs_C9d6R2=eR2UQ@mail.gmail.com>
Subject: AVX-512 Optimization For Linux RAID Showing Up To 41% Improvement
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi

https://www.phoronix.com/news/AVX-512-Linux-RAID-Optimization

I'm just want to clarify - will help to improve write performance and
raid56 build/rebuid time on modern hardware - amd zen5 (9005 series)
and pci5.0 nvme ssds ?

Anton
