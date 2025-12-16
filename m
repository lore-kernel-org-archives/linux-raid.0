Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB8B33D6F5
	for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 11:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884024; cv=none; b=MTK/lQ7Xyxiwh+7TWT+euW/t6r7IAbPXbnlVK3ZdurcIoVUeOWv/J5/oOZWmWMc/sTHiHxWDJT5VitsNy08xEDmUxVZHFd0XiLW9TbQ4vMdNz98LybgofIdVM4ZuPrVSTGy2X/w6DmuSO0v7pI0pWSDrLy5pnYOof8O6kZA8GjE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884024; c=relaxed/simple;
	bh=Ir34V/AA4/Kn53Xt2wU7m430i1aPoGLugyeX+Sg5NA4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pHAVVdVDwH044Jp7dhKFWfcFiQBwVpTLGWacFUVQO83LV5sR/3iaWZCpAPg3sVqKdPf2yFA4WoXGhxkSxnUs0FjGrSp+uraDV+N2NNwRSV6eDfDJbSW2j0SxNR0NgRS2t2cFCLvNPjrgVYa0DtS0lDVwHAScVWctIFY/kIgoDoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CF/i1rxf; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=DdQ/gxxi; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CF/i1rxf";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="DdQ/gxxi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1765884022;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TWRZ0JhI9nv9UkoCkjiIAGd+WxbLXiOF8HjIaXhWnLA=;
	b=CF/i1rxfVeKFqM6DL2Edbr6yyLkBa2BVQyT9Inz8RMVlQf7D1GqhBM7PvHdpDr5OrE/c1N
	NWcINPkiDM2raCl09GAKEXMwmS1tYT7j9jPsDW6T8HiIX6NO1zz7xVDfSDbUoMC5szAZ/A
	gDKj0xsEAug/12mB2UI8Oi9pf4hoJGw=
Received: from mail-yx1-f72.google.com (mail-yx1-f72.google.com
 [74.125.224.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-695-LnMhj-LPOh2ZyXrOt47wug-1; Tue, 16 Dec 2025 06:20:18 -0500
X-MC-Unique: LnMhj-LPOh2ZyXrOt47wug-1
X-Mimecast-MFC-AGG-ID: LnMhj-LPOh2ZyXrOt47wug_1765884018
Received: by mail-yx1-f72.google.com with SMTP id 956f58d0204a3-6455711052dso5405766d50.3
        for <linux-raid@vger.kernel.org>; Tue, 16 Dec 2025 03:20:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1765884018; x=1766488818; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TWRZ0JhI9nv9UkoCkjiIAGd+WxbLXiOF8HjIaXhWnLA=;
        b=DdQ/gxxiM4Q4+mxpMmDf0BNn0HUobvKwTPeLKuTLP3nIL2dVN9LPiwN9cttrOvM98R
         8FuQ/TEdOXvM866VsORzsMktkaFzRgijcmY+6fgUZscV8t/+E7+2D3j9s4K8JXdUI8tB
         rWc3opUwh659zS+Tmzld3uOYxsSFnoEvFXdurSYoJIhGNM66WRphPfHeee1Vm5xyGi+J
         lUt3gsO34maU2lsY+khRBqyljf82AsQMgLa4MjGQD9pUoQSlCyAtqTDHRqS6YM3ry++v
         ELq0i8kb7e69vPyMnWCzwjZa+SqIVuCrR+LV2KOuwIaP2n+dT3RGdv2SzXcQklQMNBTh
         msMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765884018; x=1766488818;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=TWRZ0JhI9nv9UkoCkjiIAGd+WxbLXiOF8HjIaXhWnLA=;
        b=U7PP+I4PKYq94EYs79kJxGb/fMSg+hBQdSVaB5bOEiJkMNygR7AXlqRb6ibC8X8Ktl
         WzOYPnprl6OF9Mered8TMjKdStgf5EFYrq/uPi2nKCOE9WXFU10mkpNTpid1hrN62WOE
         iyZChnZhcvu7sEn/a41sezEIAWaXR7lCwBtkc6rh9GMNzP44Ty++SJ/kVMORq52i2Zny
         9Ibix5BwodFpaIsaj4ay5k4hf1u/UOTyz4HxeynInSKtgsVaDtqrln+ij0Plsr5/+Hk9
         w9DG21o2UgBDeYBmg6b/6hFQ3oT//NnGUovYKOAA6+D7tdQ1PSnw2TrJcDqUHGDOfUHq
         cNEw==
X-Forwarded-Encrypted: i=1; AJvYcCVlwx79kCHY1pYpejWlMOSYDlGuFGXdfdrTb1JP9vgcnaJ1D8SGdyuXAKXcqSv3Ty6mn+Q1yoJG0ZtU@vger.kernel.org
X-Gm-Message-State: AOJu0YygJXdiDmcId9+6Tj0NsvEQcVtQ+CQIdp41shbtEGjns6d3NWjv
	kQNyn2gTka4idD4plwWo3xwwN3X5t3+L+I6rN4bRD1n0qLxO8bIuK9yZKkqyFSSPx8Wu9tYwDQz
	42++ye9giLaLybADpL1CbQAmdgESQGAm1LceGfm7bOKXdleXHtS9i5eMQr1j7QBQyk9bWAwTF18
	KQyQlZARkm+XlocyMsVNp2tc5LBJMeJ+oMzAxI7A==
X-Gm-Gg: AY/fxX7hA5j9VQ2ENwrVFJ6Sj8wRedL7MBpT3BuCFTFrK3ZECdI+wzgZ3Slvc0WAaGl
	HY6tPKWxg7951vv8xjFAKDh7IYj7qRqPSyooXpJ3CpBnbjtQZCbSEfgWm2GN3AhdhuQPkc/Mf/K
	ldEqDiJBLOESJ88E3alhRZgF8QMb6OWWZstuU1WIKY7w1tOToVpSaw/0cTdmEfBCfo
X-Received: by 2002:a05:690e:118a:b0:641:f5bc:695c with SMTP id 956f58d0204a3-64555661ec4mr12407312d50.72.1765884018384;
        Tue, 16 Dec 2025 03:20:18 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHE1hRYagai5ZNpwc4wQBEIkmKE4t8Gn5ugUaYPF0w5F6afO5UP4qTUeJlKU6zAyLz8ccdYL4yR/SJoQvAZlXU=
X-Received: by 2002:a05:690e:118a:b0:641:f5bc:695c with SMTP id
 956f58d0204a3-64555661ec4mr12407292d50.72.1765884018076; Tue, 16 Dec 2025
 03:20:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251208121020.1780402-1-agruenba@redhat.com> <20251208121020.1780402-7-agruenba@redhat.com>
 <aUERRp7S1A5YXCm4@infradead.org> <CAHc6FU6QCfqTM9zCREdp3o0UzFX99q2QqXgOiNkN8OtnhWYZVQ@mail.gmail.com>
 <aUE3_ubz172iThdl@infradead.org>
In-Reply-To: <aUE3_ubz172iThdl@infradead.org>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Tue, 16 Dec 2025 12:20:07 +0100
X-Gm-Features: AQt7F2q5uYepYK7esYO29pN2NRPzWpk3ITk8uPFpAWNLoGj4HZrc4JFHmQEXPKs
Message-ID: <CAHc6FU4OeAYgvXGE+QZrAJPqERLS3v7q64uSoVtxJjG0AdZvCA@mail.gmail.com>
Subject: Re: [RFC 06/12] bio: don't check target->bi_status on error
To: Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>, 
	linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 16, 2025 at 11:44=E2=80=AFAM Christoph Hellwig <hch@infradead.o=
rg> wrote:
> On Tue, Dec 16, 2025 at 09:41:49AM +0100, Andreas Gruenbacher wrote:
> > On Tue, Dec 16, 2025 at 8:59=E2=80=AFAM Christoph Hellwig <hch@infradea=
d.org> wrote:
> > > On Mon, Dec 08, 2025 at 12:10:13PM +0000, Andreas Gruenbacher wrote:
> > > > In a few places, target->bi_status is set to source->bi_status only=
 if
> > > > source->bi_status is not 0 and target->bi_status is (still) 0.  Her=
e,
> > > > checking the value of target->bi_status before setting it is an
> > > > unnecessary micro optimization because we are already on an error p=
ath.
> > >
> > > What is source and target here?  I have a hard time trying to follow
> > > what this is trying to do.
> >
> > Not sure, what would you suggest instead?
>
> I still don't understand what you're saying here at all, or what this is
> trying to fix or optimize.

When we have this construct in the code and we know that status is not 0:

  if (!bio->bi_status)
    bio->bi_status =3D status;

we can just do this instead:

  bio>bi_status =3D status;

Andreas

