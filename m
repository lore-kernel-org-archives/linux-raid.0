Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED21276D12
	for <linux-raid@vger.kernel.org>; Fri, 28 Feb 2025 07:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740728819; cv=none; b=RpGF6WAZwi6YTT6C5A+4LSCaHa1lV8vK8tvcMtuvjXeTo0dhfiBBuRKZhIaBFMBAO7D2Yzx2ZK2WCNz5sVMcJkj03PZISokYlyfrgdbMrKKkpfWCLkD2nxR3T6orChylWjsbn3Qi6LNPVdD0Nh+9q374h7iDCyrSHsKdwkHf0q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740728819; c=relaxed/simple;
	bh=ObRFdiswz75f9pyvd2qzJw/nPazVS7LIxjHRmKGvzoY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aRpeXM1RWqnN4hBtA784TaaVBRhWDZTWwgK8C6rgJ+QPEFaYC/OMMuzF6nVKILvpE6S8wcvCCQmrXgDrbhe/pxHMqbMYUHTWImIzfb/lrgAEab2U9UXsKfr6lBZX3AbpMcwUKmiASPkx0TsF0Nir+1gaPGzmpp1KCOggY3nRnvc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=MqdqM5G4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MqdqM5G4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1740728815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BJOXQzQyoABib/Rko8rJikSLoPQ3gnFGr04C3gQQ1/o=;
	b=MqdqM5G4V82T+bK9PTjiW7OeNGe9j9ng7TFJenHdyJrZtBIQnwfTX/vZ1SWxspaZ6+biqx
	s9ppxnXu9XpvvyXE5JZQu8UuZtu2W5nDyPEO7ys8QW1pdfl9XMPtGVOrYt9BIctSQ1U98W
	8eiQHHycAUy/sbQTra2ydLF0s3eclBk=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-394-OIfboN6OOKe2sxyQwnYQvw-1; Fri, 28 Feb 2025 02:46:52 -0500
X-MC-Unique: OIfboN6OOKe2sxyQwnYQvw-1
X-Mimecast-MFC-AGG-ID: OIfboN6OOKe2sxyQwnYQvw_1740728811
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-54621912db4so1155719e87.2
        for <linux-raid@vger.kernel.org>; Thu, 27 Feb 2025 23:46:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740728811; x=1741333611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BJOXQzQyoABib/Rko8rJikSLoPQ3gnFGr04C3gQQ1/o=;
        b=SiFQP68BYG06iU+ZNKp1KN2CE38yZYINuEM3zU78HsrFZHwtu8VmaDXUL7xUlJ3hIn
         xqfwqlUpfWv8vT+LhgvGqpTEbP2pf3XC13w8UmpZhWRnoD4CNBDhD1grz70C91LzAmHX
         GjG3X43yCEXbp2YMX/+7NQSAjGA/7Mhkh9kCn2aBbul2uE+016UZ1H2Hv8jbqcgc1wOg
         axabz6bUtOqTXXREpBD0Cjjo3aET3btNqhHDu3oTaVf4LdVl5Xz+4duLynJ7KwmTuFJg
         x+zdEXn3YOrNBaX6I7cPiFo5HoDSaKnCI5p5tIJFY6jWorvgPBaL2qhdHqFsOFPlNQoB
         wwVQ==
X-Forwarded-Encrypted: i=1; AJvYcCVr1tOYcrx//yZtOTLilherIklOtkrpP87eDS98NQFkW7pcXEjoX3I4fy9zBRvVmytgRT05Rm5BoL7y@vger.kernel.org
X-Gm-Message-State: AOJu0Yx6RlkBQN/Puv6Wb6f0OnXWhMHsEuc313gr+tNYVyLhLDzyB3xw
	ziS9IuXY3jpxJ775fA6vbqoqXcuXtaT1uXP9rYjdUjKj1onx/jQ4jAlm8k40cCgtZIYAbSH6Om2
	p8xItYurl6Cn5GNEVdO6sqDlTYkVIAU5h5vayE129dd84NyBfASocblxwQHxOy4IOrQ3KWCxqky
	g/jOlolPHsvDFkYY8takYtY5ah25UEq+kWJQ==
X-Gm-Gg: ASbGncvx3rTtAwj/9Qiea/dCEpY49incXT/CTu1S5S4qakT3ZUilbHIduMiu35bZGDE
	zROUspE47RcjykHBQTToqWOzBN10lKnXgWS6W0n3FIMSPKUMi9Ii/RduDESomkN729wSyzyDfoQ
	==
X-Received: by 2002:a05:6512:114b:b0:545:2871:7cd5 with SMTP id 2adb3069b0e04-5494c328046mr1098140e87.15.1740728811251;
        Thu, 27 Feb 2025 23:46:51 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHeJ0KSZFVlCrURVgbUms6sSTDF/Sm7ytAT5WP4u+jZnLsFXCvav38tD6qsw8NaLf8KvrkM1bwLhr5Sq3bgUGA=
X-Received: by 2002:a05:6512:114b:b0:545:2871:7cd5 with SMTP id
 2adb3069b0e04-5494c328046mr1098128e87.15.1740728810869; Thu, 27 Feb 2025
 23:46:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <6083cbff-0896-46af-bd76-1e0f173538b7@redhat.com> <8318b662-e391-d7d2-0014-173a16c4bc20@huaweicloud.com>
In-Reply-To: <8318b662-e391-d7d2-0014-173a16c4bc20@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 28 Feb 2025 15:46:39 +0800
X-Gm-Features: AQ5f1JqdBlViawYJ7ojyuNUE2VCOlpLS2pVTeLuhDQWMMpNVyCP69eb_d-aElaQ
Message-ID: <CALTww2_BtecKOjJy+2xDAeAB26BgOhHF8fk-=ksjThebATdeKQ@mail.gmail.com>
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

I think so.

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

It looks like it does as you mentioned above. Through the commit
8745faa95611 message, the io size(3584 bytes, 7 sectors) is smaller
than 4K. Without the patch 8745faa95611,  the io size is round up with
bdev_logical_block_size(bdev). If we round up io size with PAGE_SIZE,
can it fix the performance problem? Because bitmap space is
4K/64K/128K, if it doesn't affect performance only changing the round
up value to PAGE_SIZE, it'll easy to fix this problem.

Best Regards
Xiao

> Thanks,
> Kuai
>
>

