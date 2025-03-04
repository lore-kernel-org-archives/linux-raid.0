Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6641513D893
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 01:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741050423; cv=none; b=Djyqx3KSw0pe93/XVh4afIoI25OhGtKD6ImoYKN9jrUIKcyiV7oxKQO9G5h5AhTTKC6CExnKoNZ1FDDKGqu6UsjoYatP0in+hmg6E/C933yCZc99vByFBYpbvDmIl4QwFvvcl+I5jjwh6I/HJfgKtI2XxhU6dIPTvuELp+ittOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741050423; c=relaxed/simple;
	bh=m3mTb2I9RA7WcFVDTGu19h2c5WbM4XdqHUZFE+Wp4VQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QA3Wk6Ex0husw++ezRZicovpA6Ke5ZVpDcWGtXjrt+d/G+UIAtTCCOhlk4uLMQPIKzA0oG6/UdtQBvVH0KapVeifd4FUxPTt2aq5LeRfsnG3Gz4QIuCFftvWO2csha9xP4gN61DD+hchSVbo6+Ub1oP52N1Rrf0CEj+2WKhJ5n0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jRsIBxiH; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jRsIBxiH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741050419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EphVCaZVi/372Dv+7ykODQ/182aWfMiEI7oaAeSU/SU=;
	b=jRsIBxiHoS5Hgp7utRsUdhGk0hR/e3UCGNTWyuO8GTTLPkFwB5qXCWtXir0PLorjxAl7Y9
	RRTVm82+jyK0vx2xFn5PeT2lU2cUD27tWmVppfR/OWP8IC5kjLSmtfbAHXQHH0oJ/achAi
	BpfFOB7t8yFEGDK4FSSdsLQ7OteoCJ0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-312-OrwnxAqNPDiYR15C17tQ8Q-1; Mon, 03 Mar 2025 20:06:56 -0500
X-MC-Unique: OrwnxAqNPDiYR15C17tQ8Q-1
X-Mimecast-MFC-AGG-ID: OrwnxAqNPDiYR15C17tQ8Q_1741050414
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-54958ff5ce5so1550096e87.1
        for <linux-raid@vger.kernel.org>; Mon, 03 Mar 2025 17:06:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741050413; x=1741655213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EphVCaZVi/372Dv+7ykODQ/182aWfMiEI7oaAeSU/SU=;
        b=k0YAJqzaXZocNwzx0ghYc5kaa+7s9fyaw/Fgcn9L/G8yyu37WWMGU9l1d3MfaWBGB7
         OuLjMe8q+8yQ7xAUjWX17l0iNksLVyNXGs2tGKZOA52iOiWnUk/Xha1u8Wr/8IBlpikA
         27kFiKRxgmNFIaLlW7noDNIPtD/W2fcAcn4s04hu/5zRjuOH9z5E89IN+8n0kArj6XDJ
         zWMcDYPD+xijADjgVkKYK9375vS0FXoFkZma9QyUALbIeFRtT92qXE2YWSZjcGjgPIQw
         nv0Am0rLzEHOl+1lcOoaAKmm++NHxUsXenGj/3ua5pYSB44/fcckef+FhheWsirMM9xV
         VhDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUo/8+mymA1J/Nunn7e+qjpsI2HuF96eoSjtO9LP/rdDSsweGkyp1UlisY7oe57wsdBC4oardf2SC4D@vger.kernel.org
X-Gm-Message-State: AOJu0Yyd1e4P9iqA21aeJD7tvBNaFpoRqYKTEziggM8ksEPYnlUvb6pq
	e9JDAAyHCKA2Y9Dv1hs0EuL+KduLywa5z+WIEIdXRtqol+BEKtihnPwurA3GBxbNfWFBqOJiKUY
	E0dmGWF8sZ8Pw76kdrO5DY4Qriy6J7vjQi5OnbXAwj+DwaBQWPwNdRNAZoxzQfOqgtsuB4Pkoqe
	Fd3reK1D/IY8TMvj1CNndjw4/p3fMtxdihnoLU5xvvcdkJ9y8=
X-Gm-Gg: ASbGncsa/uTGifgG+WtOD+jN4rc+EJDPxoL3mH8dOIv1UOtGiBUfuibw1cTtSUbuzho
	ZFhwjEHTukUMDGSdRcgfFJORn9QB1pp589VKff88dgoxKkescqwTtVIwxIifsumi4Fw4nvM+h/Q
	==
X-Received: by 2002:ac2:4e14:0:b0:545:2c40:ec1d with SMTP id 2adb3069b0e04-5494c3550damr5827087e87.44.1741050412984;
        Mon, 03 Mar 2025 17:06:52 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHy41RlZVMltxp+K2zCFEcxLksn5gowdksqaZ4f8L44LOSnllmZ/PHtLIr/HLnLMOJGEEHEcQWsgzGJiign6pA=
X-Received: by 2002:ac2:4e14:0:b0:545:2c40:ec1d with SMTP id
 2adb3069b0e04-5494c3550damr5827081e87.44.1741050412587; Mon, 03 Mar 2025
 17:06:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6083cbff-0896-46af-bd76-1e0f173538b7@redhat.com>
 <8318b662-e391-d7d2-0014-173a16c4bc20@huaweicloud.com> <CALTww2_BtecKOjJy+2xDAeAB26BgOhHF8fk-=ksjThebATdeKQ@mail.gmail.com>
 <o6yip2tw.fsf@damenly.org>
In-Reply-To: <o6yip2tw.fsf@damenly.org>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Mar 2025 09:06:41 +0800
X-Gm-Features: AQ5f1JqVXtmrCra8E2b_coZf_GSbXw6nYwbxKh8Uaw_enMLiScDFxcKV0OYq_v4
Message-ID: <CALTww2_Z=Kq5-Apxq1-Yd_rhxkJvYMvMRQ0J+dBmaDoGgtBLHA@mail.gmail.com>
Subject: Re: md bitmap writes random memory over disks' bitmap sectors
To: Su Yue <l@damenly.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Nigel Croxon <ncroxon@redhat.com>, 
	linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, 
	Jonathan Derrick <jonathan.derrick@linux.dev>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 3, 2025 at 11:16=E2=80=AFPM Su Yue <l@damenly.org> wrote:
>
> On Fri 28 Feb 2025 at 15:46, Xiao Ni <xni@redhat.com> wrote:
>
> > On Fri, Feb 28, 2025 at 10:07=E2=80=AFAM Yu Kuai
> > <yukuai1@huaweicloud.com> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2025/02/25 23:32, Nigel Croxon =E5=86=99=E9=81=93:
> >> > -       md_super_write(mddev, rdev, sboff + ps, (int) size,
> >> > page);
> >> > +       md_super_write(mddev, rdev, sboff + ps,
> >> > (int)min(size,
> >> > bitmap_limit), page);
> >> >          return 0;
> >> >
> >> > This patch still will attempt to send writes greater than a
> >> > page using
> >> > only a single page pointer for multi-page bitmaps. The bitmap
> >> > uses an
> >> > array (the filemap) of pages when the bitmap cannot fit in a
> >> > single
> >> > page. These pages are allocated separately and not guaranteed
> >> > to be
> >> > contiguous. So this patch will keep writes in a multi-page
> >> > bitmap from
> >> > trashing data beyond the bitmap, but can create writes which
> >> > corrupt
> >> > other parts of the bitmap with random memory.
> >>
> >> Is this problem introduced by:
> >>
> >> 8745faa95611 ("md: Use optimal I/O size for last bitmap page")
> >
> > I think so.
> >
> >>
> >> >
> >> > The opt using logic in this function is fundamentally flawed
> >> > as
> >> > __write_sb_page should never send a write bigger than a page
> >> > at a time.
> >> > It would need to use a new interface which can build
> >> > multi-page bio and
> >> > not md_super_write() if it wanted to send multi-page I/Os.
> >>
> >> I argree. And I don't understand that patch yet, it said:
> >>
> >> If the bitmap space has enough room, size the I/O for the last
> >> bitmap
> >> page write to the optimal I/O size for the storage device.
> >>
> >> Does this mean, for example, if bitmap space is 128k, while
> >> there is
> >> only one page, means 124k is not used. In this case, if device
> >> opt io
> >> size is 128k, this patch will choose to issue 128k IO instead
> >> of just
> >> 4k IO? And how can this improve performance ...
> >
> > It looks like it does as you mentioned above. Through the commit
> > 8745faa95611 message, the io size(3584 bytes, 7 sectors) is
> > smaller
> > than 4K. Without the patch 8745faa95611,  the io size is round
> > up with
> > bdev_logical_block_size(bdev). If we round up io size with
> > PAGE_SIZE,
> > can it fix the performance problem? Because bitmap space is
> > 4K/64K/128K, if it doesn't affect performance only changing the
> > round
> > up value to PAGE_SIZE, it'll easy to fix this problem.
> >
>
> I'm afiraid that the perf will drop if rounding up io size to 4K
> for devices
> optimal I/O size smaller than 4K. IMO better version of
> md_super_write to is
> necessary to handle bitmap pages as Nigel said.
>
> --
> Su

Hi Su

You're right. Thanks for pointing out this.

Best Regards
Xiao
>
> > Best Regards
> > Xiao
> >
> >> Thanks,
> >> Kuai
> >>
> >>
>

