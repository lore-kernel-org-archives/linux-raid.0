Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D390C3002A9
	for <linux-raid@vger.kernel.org>; Mon, 26 Jan 2026 08:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769415690; cv=pass; b=fMQjZ91OSFV7vFxowsWd36sylZIDVi316jwYqHz+Vd8v2BKD97WG3LwjD/aHgijib+C7L/ALGZzhu7GUdOaAkechcl/2hgy2WMfflCx0OwJRFVytdRi2FfC1Psm6sf23XoOMgz09p86cKF8GRdMMld+6axgA7apDY/N2akNhHZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769415690; c=relaxed/simple;
	bh=+BNGC4WEVqbGClN8H/L9TcBFADyZIq1jBtEdLt96YSg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RCnUWPcog57V2+wKWC26/nX2SFDn5RU/zk8mX9fOCYwBcFe/Or4tRa5x4gGRtHl7xIEYcHFZpjrKqzTptPbDWjQICZ6c0dfCvql2YVCi7h2T3GvRyBEY/s9BThOxIJ74iur2uefycRMMxa4/tJ+j4uDcee9Sdtb543iwtja3kVQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=BRaD5jjN; arc=pass smtp.client-ip=209.85.218.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="BRaD5jjN"
Received: by mail-ej1-f47.google.com with SMTP id a640c23a62f3a-b8864618c99so29065366b.2
        for <linux-raid@vger.kernel.org>; Mon, 26 Jan 2026 00:21:25 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769415684; cv=none;
        d=google.com; s=arc-20240605;
        b=ZMser6hnjBul/dxY9hyIFHlACVfqQPPn0q8soYZPSbwIbNyBLz66B3lkdChE2654sj
         6IKJYMw3r5+hcfwG7UAKumBTYmGNQLrPL+zBzDKXKIwgrwRjtjcsOCyDzSorwxjXxcEM
         Jnp+itZ5oqECsc4D7XWXCeNpDX4AY0qVc3Ey3timD46NknuvNaYCd4N/27W3BrmuF+ww
         Fla8u6MDynud3vwFfCRLNjJkdQ2BiWrir1fidx2y+l69FSiX9qMV/9hOqgZ8RXW5yGM0
         pWqKr5t9PBcML5JzVn8jccOfKfdXrHJp+eDfFiwmurwmyeSER74q3SAld9O9Ngfhag5a
         QUWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eG3ZppPTPtdXVcdYhPpP4n/OImRPF+Tu0E8qAIhhHrA=;
        fh=xJ49tIGZfzQCiBx8Qc5kjCV+DJxEcPaXh/bSynh3V0g=;
        b=USmji/kvyvwB+qoDm3VE5QvmW6oDIhgWm9vC11Tm+8EQVm57nLcMLYwwC6ApIGAnOj
         x4WYykH8sYNmCR6yCOnJkXfuAw54sdLr8/OnxsFN+s2UBFssDYFSCOO2p0X9BihOmxsx
         T7KRJ5WtqhK9xC7YW2uTf18jnFzTD7wAodFCUNbntl1ehcsYDMUEETYWh78OAjL0JoPN
         Nc2AYi7Lkw5siyKGlVtQrKW90XbNX7+9R1PPpI1bak/ZOpgW2NXmykVSTklaFkc/ZCAZ
         1w0k/37aUPounX+9Ve4RRRXf4icql/Cqo0h9ul1WQJfgeFAX8DYQ4Oo3KvRVDD4KMC/n
         gYkA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1769415684; x=1770020484; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eG3ZppPTPtdXVcdYhPpP4n/OImRPF+Tu0E8qAIhhHrA=;
        b=BRaD5jjNeKYINs1r1EUr6c9WZwqq6qVvmPWljYgJzgdG131FeeXhVqoY74dvf/W8DO
         PRiJoj85kHq2JccvxGXfgb2mT4QuoNDmRxfQDAYMd3dtqh2ZVauJOUJNun8Kq2aAXZt3
         L9BvJ/nmHcLM+4e/z9hmrJDjGKIw0BvCwDa2XqjIlyWaJ/m1yGhbiIgSXXA79lmcUIrY
         0hKOzebc4XqHs44KpJDY2TVxc0oxoIjnZ4XS5wQZ8MShqPoMfCADYWSMgu9woW2D56mr
         FLQyGGo53G0hKPpDjEFZ2uEvp1kL8HLjte3BMWYizRmg38LXD6w5GSzkCUTlE3PVmu0R
         N9bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769415684; x=1770020484;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=eG3ZppPTPtdXVcdYhPpP4n/OImRPF+Tu0E8qAIhhHrA=;
        b=lx0YaEmUaZ3A13+gWDF6SDlMqzt7XJuiWtWjE9BOHCQh2klXplNEvhSgrZvxcClNKn
         U+WShMhL7JNfjR0JAOCRK1NzY+LAIr+EXHK/B6CFb4W6RU7v8rh5sNAe2A5XAKI/vVSJ
         xX3ozoqKxAo8h6wFjEJlabsF9Ya6UaWfZqKR7cN+aygGPr60paGMuxLBNkMadvyaCgf3
         wYLnC0oMuYiSonLM3t7pE4mnv82NrFZeUSMg45psU1owMQss1m2tllHCTAEVBTHzaNSa
         5VDrxCdQhtxSOKdxA+/rgRNOX4MSai+4ZpTRCzjf7vpGAss2+sJ10zokpiKFbDPrbI2G
         5ljw==
X-Forwarded-Encrypted: i=1; AJvYcCUWudBrEut8OS0EL0yyOqezC9vEX7RWRQE4m1ppLo2myg+IfeWgyvYxYqnxZ+NktvDXHYiKaTOE7KHw@vger.kernel.org
X-Gm-Message-State: AOJu0YzK+00SRKSQkFXbpuDvnpuljP4DirL65/B8zEMUnenuVKslTbh3
	iU7ga4cpy0ZyFbt7fZTxyCnrhXKyJFNLoIISUwOG5OO19e5nhZDAGFVuvVQL6TziKOATPyhXNyc
	VHPEZVbBdwwP3Ws6OQQXrSBWptw0V3RYEFybhenkUYg==
X-Gm-Gg: AZuq6aI55qsOljhLMOfVTiCbhu8RNuNSA4CSt0Z/ETHpDfAUaVmh1ouXy808n6wwqdy
	jodDmOoGykGOWkxTblA7qz9D1/2V9kEPknFMEeRD4zMobLdJHiHXTQyxv5TdQtIgf/O0FbTiTBf
	H5MNIdIvrQOywjJFiB19JBM0gu/1kXe84WfSfZ11FBff+nbjFQRW6uyz2QFbi7i/IsbB5Fy7bhJ
	kppgK4eoUsfLPCYp2zLePTcqYn5yIjDklSvd8487504gzTxcCnUNHgWza08ykEw8E61P2ojFq8t
	S1J++UXDj4erdHK7TTaz4kjz1JQY
X-Received: by 2002:a17:907:9815:b0:b86:f194:9ed5 with SMTP id
 a640c23a62f3a-b8d2e89ad90mr160498366b.1.1769415683602; Mon, 26 Jan 2026
 00:21:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260120102456.25169-1-jinpu.wang@ionos.com> <ad63a8bf-410f-4b91-aa89-3963dadf87af@fnnas.com>
In-Reply-To: <ad63a8bf-410f-4b91-aa89-3963dadf87af@fnnas.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Mon, 26 Jan 2026 09:21:12 +0100
X-Gm-Features: AZwV_QhAKRF4wc3dvy-SsqLo7TFQAhS2khNRUxzM3lwuAcJgFOvRv00CwSTWBVY
Message-ID: <CAMGffEmMO59xc2DOVo2A4dat7Vm7N6E+tHH2ZM0GpVCD796mtw@mail.gmail.com>
Subject: Re: [PATCH] md/bitmap: fix GPF in write_page caused by resize race
To: yukuai@fnnas.com
Cc: song@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 26, 2026 at 6:33=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote:
>
> =E5=9C=A8 2026/1/20 18:24, Jack Wang =E5=86=99=E9=81=93:
>
> > A General Protection Fault occurs in write_page() during array resize:
> > RIP: 0010:write_page+0x22b/0x3c0 [md_mod]
> >
> > This is a use-after-free race between bitmap_daemon_work() and
> > __bitmap_resize(). The daemon iterates over `bitmap->storage.filemap`
> > without locking, while the resize path frees that storage via
> > md_bitmap_file_unmap(). `quiesce()` does not stop the md thread,
> > allowing concurrent access to freed pages.
> >
> > Fix by holding `mddev->bitmap_info.mutex` during the bitmap update.
> >
> > Closes:https://lore.kernel.org/linux-raid/CAMGffE=3DMbfp=3D7xD_hYxXk1PA=
aCZNSEAVeQGKGy7YF9f2S4=3DNEA@mail.gmail.com/T/#u
> > Cc:stable@vger.kernel.org
> > Signed-off-by: Jack Wang<jinpu.wang@ionos.com>
> > ---
> >   drivers/md/md-bitmap.c | 3 ++-
> >   1 file changed, 2 insertions(+), 1 deletion(-)
>
> Applied with a fixtag:
>
> Fixes: d60b479d177a ("md/bitmap: add bitmap_resize function to allow
> bitmap resizing.")
>
> --
> Thansk,
> Kuai
Hi Kuai,

Thanks for applying the fix with the fixes tag.

Best,
Jinpu
