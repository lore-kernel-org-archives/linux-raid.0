Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4045B1E2858
	for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 08:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751271936; cv=none; b=jU3QQUz92208WW9DqUQ2hUdxwRZfq0D3BnwhhX2N2kTHnhQB9VkOIDk0vo4GrdSzfZDTy6l11EjW4+8fRgpK1XSszf5wPHwNCi5Qmw+/nTSwpP4mB2OcHiN5op70+3SBUpygJ5GeWRNf8b8bOvgzUDdMRrDxsHmkFKrePcJmjjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751271936; c=relaxed/simple;
	bh=3i7exFRMw/cozc31u51qSuQ6FVkvdtk5t2I0S/5G5wk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W8sWucwJQighg8qpo6K7TebOWWu039Lr1O5jNFtTTkR2HYJO/i7N1v4o2GPDR+M4cs2yL225AuGpPBAxMs7/jn9ux97O17XVtnvc51zZS8r1+dJjHkKtzc430lb9E0WLYQQz38N/6Vz6/fwghZ/f0TkP6AXvJ7EatZaPyTtC8YQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YCh6nmsz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YCh6nmsz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751271934;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3i7exFRMw/cozc31u51qSuQ6FVkvdtk5t2I0S/5G5wk=;
	b=YCh6nmszW+/15AkG9SrcxvB3jUjmntnFvnBp32xPOdEuVV4rApPj4swSRmiyJN8I09WyBM
	oItyGpMwIQ2mzq0IGpGB70iTCqZGvYQfwdjY6Q2H0BgZWtMZGCB4+SVm6Y+vYebIfDq2d7
	ChWWFYJDZ59goOaxgVDlSHqfjoeXlDU=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-YaWX16YrP2iThKLIlUy8PA-1; Mon, 30 Jun 2025 04:25:22 -0400
X-MC-Unique: YaWX16YrP2iThKLIlUy8PA-1
X-Mimecast-MFC-AGG-ID: YaWX16YrP2iThKLIlUy8PA_1751271921
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-32b378371b1so16627581fa.2
        for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 01:25:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751271921; x=1751876721;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3i7exFRMw/cozc31u51qSuQ6FVkvdtk5t2I0S/5G5wk=;
        b=I/ZIvP/bOnf5hEXY3/FHupE0JnNRD2y4YwHpPpGaFoGA+rhZflLaEcwMHeqUmbt7HK
         9q5XJJoMayk0N0Z9EWHlsVqUzMAJd1MowLwa4qySM5RawvsGAc4IWysY1cTKHnngbGg7
         UptEziTW9h0tFxiIfhjUJHmbMp8qltGnPrq9IDRJVj6aX1i2I/NwmJAFKp2vc1YB7Bs7
         OMzuXwjr8yCwWaU78r6AkzZCbRR8WjLwV3DVv5s21MYhRtTfV6EKcuPR8Oyrn0wTxlLK
         eTU3n8HnXcpijJl1bdSf+Qks1IYFgs9x5ho9OfvyuFko+UNn+jvND9KtINBMRLNPbBow
         DeGA==
X-Forwarded-Encrypted: i=1; AJvYcCXzrppLSJFIDXFrSEEyrGMeVfEyrcbJI2H7gYoWQSTbsVeGFJQ/qIaq8tEa64PK8bvpYcSTWpaQOKDU@vger.kernel.org
X-Gm-Message-State: AOJu0YyO/f8t5Lg76FHc1yc5LzvULW5JzVzud/uE1kMo0m4cqVcu0rR+
	Uv6mCEKcowI4/GFLc4Xjm5kJcpgXwnw2D4VDqhRlkRQlfYzgJ2WXOY2Ec8bwMFMGbHS+Sgvs4Rw
	Fd+B65biDLVww/699ZpwwajkAORciVpv3sb538swEssslFMhHasi7597XHpYOnxhzIPtIaL+eEn
	GFLpFi810gwkcnTPDsTnzHIN2KLBiwmJJmAfOylA==
X-Gm-Gg: ASbGncsoOmGMVly3xzCOvo1WnLIIa7uD7a4j/GPigJYW2FbJ++wIFgvmULMVKxpv11S
	fawy8VlP0YHdNMoFPG42trCm0DieU1jIVPjBNKhzHaMwfiLW7xkTstRiLBljzH8DVvP0f0uwUV2
	j+4MkO
X-Received: by 2002:a05:651c:4117:b0:32b:755e:6cd3 with SMTP id 38308e7fff4ca-32cdc532c2cmr22541671fa.41.1751271920836;
        Mon, 30 Jun 2025 01:25:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGOD7CVZuRKH0gNSW9nJZzyhf8E2LUvK9KnuDXKhGnQuR+p0oOC4yON8e9NAf5N+eFAGQxCUQo8KCHTCYXupAo=
X-Received: by 2002:a05:651c:4117:b0:32b:755e:6cd3 with SMTP id
 38308e7fff4ca-32cdc532c2cmr22541551fa.41.1751271920400; Mon, 30 Jun 2025
 01:25:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-17-yukuai1@huaweicloud.com> <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
 <cf6d7be1-af73-216c-b2ab-b34a8890450d@huaweicloud.com>
In-Reply-To: <cf6d7be1-af73-216c-b2ab-b34a8890450d@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 30 Jun 2025 16:25:07 +0800
X-Gm-Features: Ac12FXxrOjnQjLYtYr_oMWC178CsZXqR9oTQxnqBCt1WFfve1EisfYIBhUPGmic
Message-ID: <CALTww2-RT64+twHo3=Djpuj81jArmePQShGynDrRtYab3c1i2w@mail.gmail.com>
Subject: Re: [PATCH 16/23] md/md-llbitmap: implement bit state machine
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 30, 2025 at 10:25=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2025/06/30 10:14, Xiao Ni =E5=86=99=E9=81=93:
> > For reload action, it runs continue here.
>
> No one can concurent with reload.
>
> >
> > And doesn't it need a lock when reading the state?
>
> Notice that from IO path, all concurrent context are doing the same
> thing, it doesn't matter if old state or new state are read. If old
> state is read, it will write new state in memory again; if new state is
> read, it just do nothing.

Hi Kuai

This is the last place that I don't understand well. Is it the reason
that it only changes one byte at a time and the system can guarantee
the atomic when updating one byte?

If so, it only needs to concern the old and new data you mentioned
above. For example:
raid1 is created without --assume-clean, so all bits are BitUnwritten.
And a write bio comes, the bit changes to dirty. Then a discard is
submitted in another cpu context and it reads the old status
unwritten. From the status change table, the discard doesn't do
anything. In fact, discard should update dirty to unwritten. Can such
a case happen?

Regards
Xiao
>
> Thanks,
> Kuai
>

