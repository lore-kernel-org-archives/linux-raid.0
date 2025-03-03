Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EBFE212D66
	for <linux-raid@vger.kernel.org>; Mon,  3 Mar 2025 13:41:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741009287; cv=none; b=BKA1iVsPGzaf0eWqW21yy6XIco+JyPkH3BImE/6r4RCHjoA/ac8Eyl5x0ZCzghgaJmejcN6HCcGIj87CIcOAtv9EQ1VJ/hPy7b++Zy60bKjdPI3oj4M4j4pDIiFPXU7bT+5Hp7T3+gIuPCzhjy55rBTRbcm9x1a81tnYnJ3dWgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741009287; c=relaxed/simple;
	bh=wMurG/jpTt0/5Hm4eSgIzicIDw6Cp3r7iEAPBf2GKM0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UAp39ccj+Zzyv68oHsPiW1JxJolpdFrjR6IcsHMhK5ume10Adfdo8GKKEPRRuGKBRY6Eiq4vvVJCfs3ikPmQpV8vquWYpG1VFyIe13dCqUsHMcOMscu14Or3p5vbxwOGLtShn/Zkz0XIRQav/SI5I5WbOlgxxvzxDJsMOw/lRnU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hpfprPJw; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hpfprPJw"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741009284;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vixwvjRW5Jmi5YKrVbgMyTZQr/eYv0Cn/e+Pyfg5aNA=;
	b=hpfprPJwfb9j3Sxp2ddOh+ReZddO41I3j/tpsiXL+Wx8DHsQ5XL/oMlDG/NQkCqK1bwV+w
	KN3r+aGLzzfrvNrMbh4XHuRSmnZpEzvCx4P5ON4/73+zo1H42Iax6OmNsCkoRgES0TQo6m
	6MQemgXMhB6kRvE76v6jT5AmxN993Ns=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-696-ra77YhWoM-SKK5kwUeAhnQ-1; Mon, 03 Mar 2025 08:41:07 -0500
X-MC-Unique: ra77YhWoM-SKK5kwUeAhnQ-1
X-Mimecast-MFC-AGG-ID: ra77YhWoM-SKK5kwUeAhnQ_1741009266
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-54966c49a34so581260e87.0
        for <linux-raid@vger.kernel.org>; Mon, 03 Mar 2025 05:41:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741009266; x=1741614066;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vixwvjRW5Jmi5YKrVbgMyTZQr/eYv0Cn/e+Pyfg5aNA=;
        b=qKpPJN50rIpltkF1dScA0jr9DQo23WL9TWW+L6NT89uO4FkSoSVWYBmguv1wj+77Jy
         QN3dpZ2KrMKklOkxP44wqcHKYG/P+FOgqePBVF2ng8TxaGoMxzzIvjX7NpVoC660BTuq
         OFrj8u2PPvOODWtZGPPc5MwT3MqzDNX52/laP2as6hbFOzcbxRsYgb1vQkjMXSRA9Jan
         mwVoOBtADn81V1ow7EntKt5eIoObI1AaaSWNsfGnf22QR9P18Ca7fHrdXLyC+9jwzAqQ
         7DoVKSlf4B6EuGyIhfTzdd8K6ppUemhbmND4wTCWC9hytSyYFniRVB4qLXDsn6GYSZVt
         g2dw==
X-Forwarded-Encrypted: i=1; AJvYcCX4XZCO17r74g5NRObgXZviPIl9FAkMgmbl8yktwLwxT4E6NtKZbb21B3zt75VJUf4a0TaMpuU05YCD@vger.kernel.org
X-Gm-Message-State: AOJu0YxXd2adzW3t+8RyzgUyJQsznsDrM3AXOI3T/pu5JRVMT/1mu3yX
	QNIXBkuvZzZSbGUkLyr7TP4/KB1ygbdYh8AOgimqbnZecyjuJ2iGNkbw3v1RCQ+NY9XV/ENkgTj
	3xxnMl+GM6VzUBN84l0GiWMekYh/MGDmsHC5BGL9HuX9YYGoMD/U0NHmOiSQpoiEig31q0JQpzn
	emKomP0HddzAZS2r8OYy5R5R9JQZ1sHyJ1jA==
X-Gm-Gg: ASbGncsWxecc+QPUPmong/7vDjTsAMyekhxs1Qx7YJUMioXoClTAcX49f8NNvW1Ijg2
	+LPgjCp2EHaB0Av77Roxl/3XV3eZA9YINHLWAk5+1rYdECLRv5TcDghCiStUkYbX4wayeymPXXA
	==
X-Received: by 2002:a05:6512:3189:b0:545:16d5:8e9f with SMTP id 2adb3069b0e04-5494c312581mr3717337e87.8.1741009266073;
        Mon, 03 Mar 2025 05:41:06 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHZd5GS5X5HGo2mZs3uQIToxSJM18tRoy6M4FVvleOJrqRYpe0a8vBNJh/L32Gz0pzCPoj+KcYgqFBVQwP6Rug=
X-Received: by 2002:a05:6512:3189:b0:545:16d5:8e9f with SMTP id
 2adb3069b0e04-5494c312581mr3717329e87.8.1741009265607; Mon, 03 Mar 2025
 05:41:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6083cbff-0896-46af-bd76-1e0f173538b7@redhat.com> <8318b662-e391-d7d2-0014-173a16c4bc20@huaweicloud.com>
In-Reply-To: <8318b662-e391-d7d2-0014-173a16c4bc20@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 3 Mar 2025 21:40:52 +0800
X-Gm-Features: AQ5f1JrPX52GZEVu5I69gbd5U0YVRpUDy6rFboLtBbSfExOsUMoJaBJqmvf9ygE
Message-ID: <CALTww2-sZNHv+FbKYD=EcH19=R8bn829nU1fnBLfWecM+ore6Q@mail.gmail.com>
Subject: Re: md bitmap writes random memory over disks' bitmap sectors
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Nigel Croxon <ncroxon@redhat.com>, linux-raid@vger.kernel.org, 
	Song Liu <song@kernel.org>, Jonathan Derrick <jonathan.derrick@linux.dev>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 28, 2025 at 10:07=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2025/02/25 23:32, Nigel Croxon =E5=86=99=E9=81=93:
> > -       md_super_write(mddev, rdev, sboff + ps, (int) size, page);
> > +       md_super_write(mddev, rdev, sboff + ps, (int)min(size,
> > bitmap_limit), page);
> >          return 0;
> >
> > This patch still will attempt to send writes greater than a page using
> > only a single page pointer for multi-page bitmaps. The bitmap uses an
> > array (the filemap) of pages when the bitmap cannot fit in a single
> > page. These pages are allocated separately and not guaranteed to be
> > contiguous. So this patch will keep writes in a multi-page bitmap from
> > trashing data beyond the bitmap, but can create writes which corrupt
> > other parts of the bitmap with random memory.
>
> Is this problem introduced by:
>
> 8745faa95611 ("md: Use optimal I/O size for last bitmap page")
>
> >
> > The opt using logic in this function is fundamentally flawed as
> > __write_sb_page should never send a write bigger than a page at a time.
> > It would need to use a new interface which can build multi-page bio and
> > not md_super_write() if it wanted to send multi-page I/Os.
>
> I argree. And I don't understand that patch yet, it said:
>
> If the bitmap space has enough room, size the I/O for the last bitmap
> page write to the optimal I/O size for the storage device.
>
> Does this mean, for example, if bitmap space is 128k, while there is
> only one page, means 124k is not used. In this case, if device opt io
> size is 128k, this patch will choose to issue 128k IO instead of just
> 4k IO? And how can this improve performance ...

This problem should already be fixed by patch
commit ab99a87542f194f28e2364a42afbf9fb48b1c724
Author: Ofir Gal <ofir.gal@volumez.com>
Date:   Fri Jun 7 10:27:44 2024 +0300

    md/md-bitmap: fix writing non bitmap pages

Regards
Xiao
>
> Thanks,
> Kuai
>
>

