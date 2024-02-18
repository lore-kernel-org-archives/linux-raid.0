Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C72CAA29
	for <linux-raid@vger.kernel.org>; Sun, 18 Feb 2024 02:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708223275; cv=none; b=Z2vPXQizW7TvV/W8bhWlVgW/HibW+ZQuTFUikKyXqHqUnIGfOKxdnhfmcubYTLkrx5kO/BDvvSdhHm1t2l8hm0TAi2uc9xuyJnu9TGQ6RWODh1GvAG5t1oOjTuNiiZ/iNgioiK9I/vGIXJiQHaqD9LnJ7fMcZUrzE7p4IUqqZmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708223275; c=relaxed/simple;
	bh=nKsx+TvlDRCfg/EURkIhikZLmq+YLEYvNN++aBLHASQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LiuzPgRdy4+IlVyUMDT6NXVJrYjcdvv3jP+pUDXm3DcySWD5iBCy1AVOWINbar0shehnw57ncrkH2wBgj2doF05+A7xKukKKg0iXQhOQh4/8UXgBih4vglN1+xo29xTaEGKOwidwlIps5kAyFFCUesjMjNRpeMi1Yc3hcxY5gHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=N84lRDD1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="N84lRDD1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708223272;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKsx+TvlDRCfg/EURkIhikZLmq+YLEYvNN++aBLHASQ=;
	b=N84lRDD15aXus10mUmm7eVvxpS0Y0UUttX98ym/kcUf77eltjBaOlqtt7yKINqdHKV2hz6
	3KM5LuqjgBRk25ERopWMtYKwAaozZ0+lSQ+1wbtpX1IERzxBnZNSnNn2GpAzwCXkzQOhPH
	cT0z80TNoztXbI0aFKz2AFvIYY7gAPA=
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com
 [209.85.216.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-oVO4aaSONCWA5zJTVNInzg-1; Sat, 17 Feb 2024 21:27:51 -0500
X-MC-Unique: oVO4aaSONCWA5zJTVNInzg-1
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-299678318dbso299551a91.3
        for <linux-raid@vger.kernel.org>; Sat, 17 Feb 2024 18:27:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708223270; x=1708828070;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nKsx+TvlDRCfg/EURkIhikZLmq+YLEYvNN++aBLHASQ=;
        b=kW803hnoS5QjlplnGeXgS/ovhMH0AyEzqS/FFbLwlHOwa6TLAK4XRsXzH6wE42m58s
         9GN7Jp3Nu/VhX5tqEo6ue6lxBd/k0jQxgc3OlEvZflz+S9pA/2nPz7t3Fu7NaBdO2+a9
         Pe5cm2tXVgDufG8eEpfjSfnwQoKNhPhUMeemUyXeSds8cglcjkIkNP45QCW+FqE04JYY
         To370h3o7UXwScdGexcWIUEUtATZ7BzUs1yYWmHg0Su9mpx7iFyE3q4XHA0NumTFTCHZ
         5nwIcQEfCjcnWBo9MlPWZgTmm9UtEbn1sCqq3mevnedqul7xVHSk3ucfYVLZ/LJHoPkc
         UatQ==
X-Forwarded-Encrypted: i=1; AJvYcCUy2sqAp3OEEKjwzNaZ2xai/zPn+He4ILJ2AT5Gh6T9VEGSDdhmY2D8/qEt70IAg4p+kC6UtO78moC/8TXjiThxavwLGZpSX8fr+Q==
X-Gm-Message-State: AOJu0YxkYD0NiOOONfB04k/mPiGjunwXeaHOhW5xehK/bn7EnZhymHS3
	9W3VEVWEcotBj27feE/ngofT+jJsgsVu9DwWQneKNW4mdCuSZ4PjLqblvQ1VHunbv1sAzS/KvCT
	9NdOYPQI7Ob4fw8C0O2eRuv2SwQiArPWf8S2C/kdBEi5szCanCBuwSny+bFeN0f3UaoFc7CFWeO
	gxf5EIhbf8bDzGdT6PQpbO1iA9bEzFrVFrfQ==
X-Received: by 2002:a17:90b:78e:b0:299:3e54:83fe with SMTP id l14-20020a17090b078e00b002993e5483femr3558420pjz.36.1708223269820;
        Sat, 17 Feb 2024 18:27:49 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGO+Z325KAFI0GSZHw8iD5qIOQx10QeQ1N76fEOCkdUvi6n8sFtZCH4pi9EU3V0YpRBSBxKSb8bnmRvh9gR8PM=
X-Received: by 2002:a17:90b:78e:b0:299:3e54:83fe with SMTP id
 l14-20020a17090b078e00b002993e5483femr3558413pjz.36.1708223269552; Sat, 17
 Feb 2024 18:27:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240201092559.910982-1-yukuai1@huaweicloud.com>
 <20240201092559.910982-2-yukuai1@huaweicloud.com> <CALTww2-ZhRBJOD3jXs=xKFaD=iR=dtoC9h2rUQi5Stpi+tJ9Bw@mail.gmail.com>
 <64d27757-9387-09dc-48e8-a9eedd67f075@huaweicloud.com> <CALTww28E=k6fXJURG77KwHb7M2OByLrcE8g7GNkQDTtcOV48hQ@mail.gmail.com>
 <d4a2689e-b5cc-f268-9fb2-84c10e5eb0f4@huaweicloud.com>
In-Reply-To: <d4a2689e-b5cc-f268-9fb2-84c10e5eb0f4@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 18 Feb 2024 10:27:38 +0800
Message-ID: <CALTww28bUzmQASme3XOz0CY=o86f1EUU23ENmnf42UVyuGzQ4Q@mail.gmail.com>
Subject: Re: [PATCH v5 01/14] md: don't ignore suspended array in md_check_recovery()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mpatocka@redhat.com, heinzm@redhat.com, blazej.kucman@linux.intel.com, 
	agk@redhat.com, snitzer@kernel.org, dm-devel@lists.linux.dev, song@kernel.org, 
	jbrassow@f14.redhat.com, neilb@suse.de, shli@fb.com, akpm@osdl.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Feb 18, 2024 at 9:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/02/18 9:33, Xiao Ni =E5=86=99=E9=81=93:
> > The deadlock problem mentioned in this patch should not be right?
>
> No, I think it's right. Looks like you are expecting other problems,
> like mentioned in patch 6, to be fixed by this patch.

Hi Kuai

Could you explain why step1 and step2 from this comment can happen
simultaneously? From the log, the process should be
The process is :
dev_remove->dm_destroy->__dm_destroy->dm_table_postsuspend_targets(raid_pos=
tsuspend)
-> dm_table_destroy(raid_dtr).
After suspending the array, it calls raid_dtr. So these two functions
can't happen simultaneously.


>
> Noted that this patch just fix one case that MD_RECOVERY_RUNNING can't
> be cleared, I you are testing this patch alone, please make sure that
> you still triggered the exactly same case:
>
> - MD_RCOVERY_RUNNING can't be cleared while array is suspended.

I'm not testing this patch. I want to understand the patch well. So I
need to understand the issue first. I can't understand how this
deadlock (step1,step2) happens.

Regards
Xiao
>
> Thanks,
> Kuai
>

