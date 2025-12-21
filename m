Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94FC42FD694
	for <linux-raid@vger.kernel.org>; Sun, 21 Dec 2025 15:40:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766331604; cv=none; b=qDIAmGCVsXrQ7eH/qMjae1JsGa2R1l9jV7l4XpTJakvDSZMYX+r7gRfDDmUBlMyIjwqdevzYttiqs/eGuXHhoV0fOjwc9R1CpmQ8IexLPAyjywjZ2029ZT99wLKawkIvGc2QfvvlIztG5t5uycAlsntF2zQMZw39MPV6rwPce7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766331604; c=relaxed/simple;
	bh=mnZjXNK0u+HP/XUiaDYnE60D1RSlqmCcOGyEHMy6J80=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OYE7KsDIo+kEgiME61oaCiV1yHB5CLFH3134r7fUzFB8/v0/l28rHjlAgpN2u1ZXo5wKUl1G5BNdKcuRT47mWPISnFPzMIk+8wOE6nAlDrmOmkWVGRyDvmvTFiYP1b3v0XpIjgS8NqXIUnwcx/D/N/2sfmOx0w1XPRV9+aC9W8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fttG2Je7; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=XM/GWV4t; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fttG2Je7";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="XM/GWV4t"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1766331601;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+KE66w4YWw6ndgVPN9WJoeENuvGjofTuSeoIQ9xGNDM=;
	b=fttG2Je7tdPOfLijYFhXFq3PE3AKCw6AQNJoJS1mI71qQq+TxQDEPYBBt6SS1Dp57w5qD7
	UYCri/YFtUkTv2MRs6daOTYs5v2OUv8HvFYCcr7jN0dEfgATrZwVtAhZ4MNRg0LCX20bjY
	xUoPIgUQDJrr+9L+UnTYemEK8FkcUxw=
Received: from mail-yw1-f198.google.com (mail-yw1-f198.google.com
 [209.85.128.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-324-245OBeD4MGqH4aJrmdpAIQ-1; Sun, 21 Dec 2025 10:39:59 -0500
X-MC-Unique: 245OBeD4MGqH4aJrmdpAIQ-1
X-Mimecast-MFC-AGG-ID: 245OBeD4MGqH4aJrmdpAIQ_1766331599
Received: by mail-yw1-f198.google.com with SMTP id 00721157ae682-787d4af9896so40280957b3.3
        for <linux-raid@vger.kernel.org>; Sun, 21 Dec 2025 07:39:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1766331599; x=1766936399; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+KE66w4YWw6ndgVPN9WJoeENuvGjofTuSeoIQ9xGNDM=;
        b=XM/GWV4t5bhW/CXc1eTGegsHWhcSygiHGujZphzwTqn5/6LDn4ODMGWBYqzamq5ksp
         vC3eM6pul+UOVPqUTrkprLC8tf9JkXHTl7Kdn3U1GBr6YzfjaZfniBfGrZWa/k0vHVrF
         uN54aE+u+CAKKRVzWMPs692lPFF9Q6IMJ/LfE0fUhlo5vMqLo4/WPVwe/7QgKcIBTwE5
         ocq07T0xOWTLN4Zj90RAMWllVGvDaVmUEKQ5FPnjZ8bL3kEVaVlG5kj/3Bhu+tuooAMr
         wnKx5Flea13rb/gex/sDWE2cTe1ndirBUbbjZB3V4niqLfmun25MAvNuJyxvlHOTXozO
         4rcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766331599; x=1766936399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+KE66w4YWw6ndgVPN9WJoeENuvGjofTuSeoIQ9xGNDM=;
        b=ZiGB4xDrLvJZhtAOwTxpAZU4BpZ3ls2CvHTg3p65MAXFi0lE2zlkkedSJT/AAaUOKP
         C+l1ysZFWCm2Ri/cAgU674Gq7TPYj+vkZ4SKbGgJrSaNSCGZD9QfTIMDLTrKvPeRQmzG
         ENQ7DSv41rQyFfUZPos/nGkObh7EQNzEH2ebmtlPb8UmOGaMTsNz+VHT3M6XAOgYYyOX
         LTSPeJGL9iq+LzM09QnaYCUFpmgvaLESM7EaeFER0LeQ1IyPOgmClpkUTI0KmNkIQqS4
         fpWtDv+UOZ0hmkhWn+MG7YJmkj2QP8s4z9j+qAZ7JpUwwgIWkUoqp7Xt8abdD0uqt7wT
         70Ag==
X-Forwarded-Encrypted: i=1; AJvYcCX5Tu6Z55geS3bEr1ChW4C31CyMrT5VPx2y7ppAxYKuIlK/z8vUhgHYlb0lxYXdA0dNdSOB1WG4zkG4@vger.kernel.org
X-Gm-Message-State: AOJu0YwxbPj5spQFAn5L7BJdBnh2Rno+Xks8IzxvmG77oc09Mk5oReBh
	o/qo+i/1t0dmjEQEQHRVmydB8zmEdnyZ9RlrKGiXUmKklwAtCGrAw7FhTs2I9kchQBggAWoraN9
	nDKm8iTrfSt73WAJM/ClZILzFWzGFehhl+4oxzOygAVppopKxvybISD29WQEKFNFp0aKuo0D7sq
	FA5YG41vgAE7sn9qRfTaGrhFijgXGrvJUVHa/e5g==
X-Gm-Gg: AY/fxX6gBNIovnQVEVSoNTmQamnD2C3OJqicpnQNzVOzz6VgB8wfWLr6SqYb+cWvtmN
	/V1KC+DNXNyEFV7qE6dP26wpc2jaaTUxxCCZburo88s6Xe16QbyNuL9iMWc/20n4y7gjSXLKJXz
	o6bmK3noN6mmOZLBrwWQZUYs8o0xRgbu90NIEGCWKmwJRYJwNFzAaInpBuGkFRxUyx65QIhqPHk
	OpXcdjBjhTljW3FgK/3YMyX+OE6fNe5MPXeExM3dTOtPwIHwLaIKQ==
X-Received: by 2002:a05:690e:1284:b0:644:60d9:866c with SMTP id 956f58d0204a3-6466a92dc91mr6656842d50.93.1766331599154;
        Sun, 21 Dec 2025 07:39:59 -0800 (PST)
X-Google-Smtp-Source: AGHT+IFC7mRAlf3U3160pFy0QO4PEVMCEcrUcemZaiGKUncjGrA9BOh5VcTiZvbH4/xJJSP0FWrca5aMSKuDJG3O3Q8=
X-Received: by 2002:a05:690e:1284:b0:644:60d9:866c with SMTP id
 956f58d0204a3-6466a92dc91mr6656830d50.93.1766331598821; Sun, 21 Dec 2025
 07:39:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20251221025233.87087-1-agruenba@redhat.com> <20251221025233.87087-2-agruenba@redhat.com>
In-Reply-To: <20251221025233.87087-2-agruenba@redhat.com>
From: Andreas Gruenbacher <agruenba@redhat.com>
Date: Sun, 21 Dec 2025 16:39:47 +0100
X-Gm-Features: AQt7F2o4CmeFGTIojqbpS0PVmjVAd-d4HUDEVdSFp54dsbxM3ZckXV6-nNPzQZs
Message-ID: <CAHc6FU6vAokT9ugX1DA8iQLbeu7=Eixr9bq6z0o77_Nq+PyXvw@mail.gmail.com>
Subject: Re: [RFC v2 01/17] xfs: don't clobber bi_status in xfs_zone_alloc_and_submit
To: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, Chris Mason <clm@fb.com>, 
	David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Dec 21, 2025 at 3:52=E2=80=AFAM Andreas Gruenbacher <agruenba@redha=
t.com> wrote:
> Function xfs_zone_alloc_and_submit() sets bio->bi_status and then it
> calls bio_io_error(), which overwrites that value again.  Fix that by
> completing the bio separately after setting bio->bi_status.

By the way, this bug makes me wonder if we shouldn't just get rid of
bio_io_error() in favour of bio_endio_status(bio, BLK_STS_IOERR). The
latter would be a lot more obvious.

Andreas

> Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
> ---
>  fs/xfs/xfs_zone_alloc.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/xfs/xfs_zone_alloc.c b/fs/xfs/xfs_zone_alloc.c
> index ef7a931ebde5..bd6f3ef095cb 100644
> --- a/fs/xfs/xfs_zone_alloc.c
> +++ b/fs/xfs/xfs_zone_alloc.c
> @@ -897,6 +897,9 @@ xfs_zone_alloc_and_submit(
>
>  out_split_error:
>         ioend->io_bio.bi_status =3D errno_to_blk_status(PTR_ERR(split));
> +       bio_endio(&ioend->io_bio);
> +       return;
> +
>  out_error:
>         bio_io_error(&ioend->io_bio);
>  }
> --
> 2.52.0
>

