Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F15927E07F;
	Thu, 10 Jul 2025 01:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752111902; cv=none; b=UtA70dXbxogsrjJNbBlO0FHFp7TvxMh1H/7qeGin9QaeX/hIdz3OdWhUEkMIJm/yshT7iDZ3lIXodoDBgf0VJfSoqZmgv87YJQL4o4wpHCLMTyA7jN/5y8pcpIJ2Sto8AkGuscnQtaSHEv1N8JJjYTA2ydlE3KDDt5BdiNtBLm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752111902; c=relaxed/simple;
	bh=ceq9ufKCZANtVe+Yu/j2KztjUjRWT8pQBYZw+EcF6gM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bRvOAoWC2MluZmgHxF5BS7Jksj4UesywKybppMNoxk42CLfKGkpWtQBG/kzm34giXEvKeIiyIHiyAVuxVS9w/vOpIJhJpyBWo4ilAKUw8n0TJpSiQBFZGFWUo39OE9FNCJuQlwni4OKmyqxHggjykl5/QIFZ47ZuWb1JOsapQfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VP5OM/ot; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VP5OM/ot"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-40af40aeef6so180066b6e.3;
        Wed, 09 Jul 2025 18:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752111900; x=1752716700; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KpbUI1og+WbCg0ZLSD0ymybRvQZPRR2w3JRs6++rOrc=;
        b=VP5OM/otCyZ5ZMDimDsWG/eLU9M16XeOpsM6EzTANqALsdKj5UHlizzAGdSxQLVd5b
         sXpOC28TslxRGf0u3o0O7yQu3dGd2LgUUOy02SDS/0JZvftsXVRZJkkXE8x+6ZCSsQIm
         vtu3sTqiXjKBdoDyAimHekGZSOKpaPSno4WSUPE2HDaYIbzwqrfULRj4xDw1dqIvi4dj
         CzQDhP2jl2neyM8qOZSI/UNI2u8KQgXtRd2I/Xd+QWlzCN/sH0v11fnOTjzIQu91EtRO
         V7CPlWM3BcO7lkbYNRHdAlfopeBRre9LBIYpiAxBmEm5thebPVTHSt8u+u8U+d2IabEp
         g5Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752111900; x=1752716700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KpbUI1og+WbCg0ZLSD0ymybRvQZPRR2w3JRs6++rOrc=;
        b=XrKCElF3pWt6db1re5NohkuE1YQQBh1GWzv+JllX/QlohNYbrHV3NcvtKSfO2Jv/E/
         W88ShblGl3D4zq+YJcfnZo1CC/4C36h4ioy2Njlt6lpjM1lwMP8OouAUFW9dRYBNxREN
         6EF2jFBq+DUgc3mxTxDiqUIrITb1JBKEuvM2yBDPF/znC7/tQK2sUbKPaZEr7S5Uzo+V
         QcrARGE6GSQTz0RGp1Rt+7sLMmPGZ7bPcIyMPVLFUqmW/SUZILXNQbRqkedYy0yXP0Wj
         zRM5A0FOEnr0q9UZGSM22Az9yTm6vJcmk/YwAQsr+EK7K/8goP4BSZDATuviCmlwcxBa
         90lg==
X-Forwarded-Encrypted: i=1; AJvYcCWt6mJuN8Xwm5l4vAHgWtHS9N25wCEPhtsfIl7jTFEkfBFIUiEJ38JwtLzYEm8/oXsonvq07f38Hpgoxw==@vger.kernel.org, AJvYcCXg8wnIKQNqOZdtyLZPoAehqphO6hApW6UHu3j7yB9fgvqVyiMBHGr0TMDASWLcg4Srb3XbpgypQLnbFVI=@vger.kernel.org
X-Gm-Message-State: AOJu0YxsSpVwqRRF//zUJl8JWwSQrilqtTVqaLyxsgQPDHiRVdYN0mSR
	9eQNpN0powEythp7N/svJL0BDWP5tShY3Ue2v39Xwtq7sysf0Fgs57fdgY3uj3Z0L3VfiKyBy/B
	3dJkIPiuPuam+pUtR9dGIoyM50d5qK5Q=
X-Gm-Gg: ASbGncuQrs7sBIPIKOV2Y1SdZMibITEc8B2amvOpqX/RM44liuqIylyS7Fow6jQChjm
	EHthxQwqufrvWIOjpNKyENxBVuwC0FVOyGHhpLevDVfKIkwS/UKj78pmBkxNP4SlcgV/t2YZz9q
	mwraw9jU+4h+A6/lfCH6tOfWJ6ShoVPfe7t9JqRCikZMeUgDOgl1JjmqozABY2Hp78aHL1S3Lqx
	Xc=
X-Google-Smtp-Source: AGHT+IHZnHuOYbgM4o20piIG+wjZN6Ae24TgWByOcCOSK6jsx/DzIizD83ptEp+E7b+w0L5u6UoTRCXAexH7DkA+j3E=
X-Received: by 2002:a05:6808:319a:b0:401:ea7b:e535 with SMTP id
 5614622812f47-413adec70b2mr1594888b6e.22.1752111899833; Wed, 09 Jul 2025
 18:44:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250610101234.1100660-1-zhangchunyan@iscas.ac.cn> <8a1b1610-02b1-46a8-9a10-c19c1580c017@ghiti.fr>
In-Reply-To: <8a1b1610-02b1-46a8-9a10-c19c1580c017@ghiti.fr>
From: Chunyan Zhang <zhang.lyra@gmail.com>
Date: Thu, 10 Jul 2025 09:44:24 +0800
X-Gm-Features: Ac12FXy5RekAAJElSH1GjaYFg2lQc5TLrPYlv66sNpWZ556eU9tAfMub6Xg2bbU
Message-ID: <CAAfSe-s1g8h+HpYz8FmW4n7h+hhi5W0_N-jpfAD5Ldai8NjwHw@mail.gmail.com>
Subject: Re: [PATCH 0/4] Fix a segmentation fault also add raid6test for
 RISC-V support
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Chunyan Zhang <zhangchunyan@iscas.ac.cn>, Paul Walmsley <paul.walmsley@sifive.com>, 
	Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
	Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>, 
	linux-riscv@lists.infradead.org, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Alex,

On Wed, 9 Jul 2025 at 23:18, Alexandre Ghiti <alex@ghiti.fr> wrote:
>
> Hi Chunyan,
>
> Patch 2 was merged via fixes, do you plan on resending a new version for
> 6.17 that takes into account Palmer's remarks?

Yes, I'm preparing the patches these days, just haven't figured out
how to set NSIZE properly for user space.

I probably should split the patchset, send out one today.

Thanks,
Chunyan

>
> Thanks,
>
> Alex
>
> On 6/10/25 12:12, Chunyan Zhang wrote:
> > The first two patches are fixes.
> > The last two are for userspace raid6test support on RISC-V.
> >
> > The issue fixed in patch 2/4 was probably the same which was spotted by
> > Charlie [1], I couldn't reproduce it at that time.
> >
> > When running raid6test in userspace on RISC-V, I saw a segmentation fault,
> > I used gdb command to print pointer p, it was an unaccessible address.
> >
> > With patch 2/4, the issue didn't appear anymore.
> >
> > [1] https://lore.kernel.org/lkml/Z5gJ35pXI2W41QDk@ghost/
> >
> > Chunyan Zhang (4):
> >    raid6: riscv: clean up unused header file inclusion
> >    raid6: riscv: Fix NULL pointer dereference issue
> >    raid6: riscv: Allow code to be compiled in userspace
> >    raid6: test: add support for RISC-V
> >
> >   lib/raid6/recov_rvv.c   |  9 +-----
> >   lib/raid6/rvv.c         | 62 +++++++++++++++++++++--------------------
> >   lib/raid6/rvv.h         | 15 ++++++++++
> >   lib/raid6/test/Makefile |  8 ++++++
> >   4 files changed, 56 insertions(+), 38 deletions(-)
> >
