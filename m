Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDDEF3176E4
	for <linux-raid@vger.kernel.org>; Wed, 26 Nov 2025 12:51:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764161495; cv=none; b=fY78V/PiUhxnWHiU0GiprwRrj7VxelNSAhrFhWYed5fkJLmtyEhapc84WkmHRjRfDTxqFer6347LGgd1k4xX32LXUccgK7QGnN7GPbC0Kroy86tRIUgmzr4LTTQ959i/WDsc0z5bJwMluqoLjZYwrgM/rIVAUBBBSp/ivOgtXMk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764161495; c=relaxed/simple;
	bh=+yhdGxDT8/FxwW8mMSJ4ztUo9kxr7Tbq3tBd5Rjb3FA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m4z1vU+JSVWe7wHWsIAFyoaPcSQA6vDO4QtRXZXM/2i+4Az7fH3b2nfST+VRO2fY3iqHs+G5BabbHJVB1KTKqcfw1vE9vdCfvz5wHkoy1frPknYRQBnv0IwOFKOzQrXUwtUxX1bP+QyX4+bxTRYD/XAvSp+kwr9OavmWeSeka80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nLWu8TKE; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nLWu8TKE"
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-9486d008fdbso41530939f.1
        for <linux-raid@vger.kernel.org>; Wed, 26 Nov 2025 04:51:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764161493; x=1764766293; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IftgS+SqRiORt75QLzOlSBI34TvyfdYZdE/tNo4H79o=;
        b=nLWu8TKExr5DkegN5p0HKUvHPQib7fD6icWwLvuJ/UN7HWFJ/0iKbdItq5887NQJYK
         LppJjd43ayGwjBItd6CUCsn2yqQGhzsWFdV+GqgxrFqsQi7OcZF+kSBCDE/KxHxNbsS1
         GIqaTketoNw6hkZVOH1fRkrOWjr6UrbZacr54Q8sI15bWYDsx2I8L9mdthI5cG+btzDX
         nj0ffmElUuYGNSObzpEoZTDLCoNnsnEHv3RRY+zcrPdFh25/55RfotViVlfDIfYXsnuk
         Vg362xi9aB+IVh7lDs5kx/VaG6B8mdMXhKarBOHYZ2Yqze9baBjaTFXvfWRNq+18lb8c
         YSqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764161493; x=1764766293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IftgS+SqRiORt75QLzOlSBI34TvyfdYZdE/tNo4H79o=;
        b=HPq8SK7zsjD5d/dBLXwHazgK42sw/aV6psHJSDSFUVdfDxiWd4/DgdgvmgX6SeE44O
         6RkwKS325bZ8b8D2+pHfNHXtkgnZ3hzDPcduR38yQnN7/DXczCmWKZxgbxEHkHLH6dJy
         4fd8lojX3mVfdkEzVY0+WUlCGWfhHcXjO2o0uihOWyVJNNfCd2sDUwukkyBrDXHSJQsF
         EKvsjyBaVxJzi+i6tTxee/SGTpNXFwg6/TWekYYahWNeWp8I93ejph67Q/urn5DiVk6a
         bAiUcfVF3uTFcAloFFgPSXEpMTsQaekIQsmnnzEKCO0ADXCjhxn5HVQaj8m/mruVQIo3
         gC/g==
X-Forwarded-Encrypted: i=1; AJvYcCXczTP++dkjUFVcz7+jVkV5jz1h9H5qGnACdxl5Nb6y+6gTiBiXrqVD37GaR3q6NeQWvPlP3xXSVO9R@vger.kernel.org
X-Gm-Message-State: AOJu0YxrLHzJ+gRLYPBMWNcl4OcsZRQ6mpzg/DXb7Qu2T5i4FcVu7hgy
	jScXFuafIs3AFy6v8nQaNSombbTCEWBjUu09+WeTbq83oTmJhYd6ISm7buxVhvAEIzRBN7Erh8O
	nLTKsFof95Byxw+6Q85cK25nCS0i5QnQ=
X-Gm-Gg: ASbGncunjZfNsw/yxkxCLo7xYNhFl6vx6qWCadXgqBSGHAQG9q1qinrdPKgkbNoLc05
	rrB+nM+cGSFS1o23asqcdtLlDPmnR5Xiap88R5qAeph0vilCZMonU++MaHAE+pzPRroRW0IC9Zg
	JewQXI+QIc6KXsMia39kRbrQLqNM/zKYNgrqcGNejq+hbI4rGd4+fFL3tCI1dhg+3wMA/wPY+V7
	SVQ6hD3pDYdCqhoytkM9uPWlkegWNb2bmD9s3jbbStiUUAmOfqjS+zUTyulEgmjtZOnng==
X-Google-Smtp-Source: AGHT+IHhS34m+1SD8tJpx138zZD3EsRZi3N15GwK1gcW6eip8X0EM83IiyMjYmPSNpcESushN3pe3bG8ne7Hpsjh5vQ=
X-Received: by 2002:a05:6638:8721:b0:5b7:10ea:e2a7 with SMTP id
 8926c6da1cb9f-5b965b1af7bmr16025724173.8.1764161492726; Wed, 26 Nov 2025
 04:51:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAO9zADxCYgQVOD9A1WYoS4JcLgvsNtGGr4xEZm9CMFHXsTV8ww@mail.gmail.com>
 <07500979-eca8-4159-b2a5-3052e9958c84@youngman.org.uk> <20251126001526.GA13846@twin.jikos.cz>
In-Reply-To: <20251126001526.GA13846@twin.jikos.cz>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Wed, 26 Nov 2025 06:51:21 -0600
X-Gm-Features: AWmQ_bntz_i1QiEa4TH0U930vkLMkc6r-_qhym5yOt8grjTnHgC7kUI2p-Jq3qw
Message-ID: <CAAMCDefgRUH5ygs10_=x75tOybvPPsYC-Q+KCFPP+9Le-x5RBQ@mail.gmail.com>
Subject: Re: WD Red SN700 4000GB, F/W: 11C120WD (Device not ready; aborting
 reset, CSTS=0x1)
To: dsterba@suse.cz
Cc: Wol <antlists@youngman.org.uk>, Justin Piszcz <jpiszcz@lucidpixels.com>, 
	LKML <linux-kernel@vger.kernel.org>, linux-nvme@lists.infradead.org, 
	linux-raid@vger.kernel.org, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 25, 2025 at 6:15=E2=80=AFPM David Sterba <dsterba@suse.cz> wrot=
e:
>
> On Tue, Nov 25, 2025 at 06:25:41PM +0000, Wol wrote:
> > Probably not the problem, but how old are the drives? About 2020, WD
> > started shingling the Red line (you had to move to Red Pro to get
> > conventional drives).
>
> The WD SN700 is an NVMe, though one can imagine how they could be
> actually shingled with slightly tilted overlapping sockets.
>

You have to get a red plus or red pro in spinning disk to be conventional.

On the nvme: I would check for a firmware update.  I have seen
multiple SSD drives from several manufacturers that had timed
housekeeping processes where something went badly wrong with that
housekeeping process and locked the drive up.    Some of the issues
lock the drive up until a reset and then when it fires again (hours or
days later after the reset) it locks up again, and some of those
firmware bugs brick the drive.    If the timed housekeeping it would
likely be some set time after you powered it up.
