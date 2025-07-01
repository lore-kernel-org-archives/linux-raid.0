Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E771442E8
	for <linux-raid@vger.kernel.org>; Tue,  1 Jul 2025 02:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751337136; cv=none; b=oRxIuPZkN6BIhF3FM1hx3tIVrvF+iE48cEMRD2YH619Nfb3yk+eSpqHJJhMgZB6icBD3gadQMlyL5oqrQzA7z72FpgJjyGGH4mOjSi6pW1CLFGSl5XvroySzuZb5BwtvN4Iev8IPznSmJMUechBNOpMm4KPKJygn1bVfmnbLC1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751337136; c=relaxed/simple;
	bh=rRVdG5V5THof2kVFbuGpoPO6Ew/jSkC8Uar+R290sas=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GmYvqIC34R5NKla6v2yHIEd/lklwV5lKalHKIa4C+crLkOTBtHXbBslZdalSxjc0zHgPwDpYUz73uXHdjgBKmBpEz8KqGNVfTYqmOuG82A4JwqrfIsThGwplRuXMMuYCpZQhrtyuVAkSxWgS5CaPbzsbNUq+8YdXc0c6uLAZj+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=hsQjokHb; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hsQjokHb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1751337134;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rRVdG5V5THof2kVFbuGpoPO6Ew/jSkC8Uar+R290sas=;
	b=hsQjokHb7oONY4dnBLXNEtlI5qZ++9RL6QqW4YbI/Fhd5VUdfLTDVCrheEPwov6Rhp20Vn
	CiuRk+Gb4v+4RvPVUvG4w9I2fF6Y1xMukyu7ztl5qaFGaq5BCpg6QlP+I6clKkzUGmpClk
	L8RuLNroLjFz/PvEHPf9BplgC5bigrE=
Received: from mail-lf1-f71.google.com (mail-lf1-f71.google.com
 [209.85.167.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-688-DF7EBLvcO-WTxVI7nNO3pQ-1; Mon, 30 Jun 2025 22:32:11 -0400
X-MC-Unique: DF7EBLvcO-WTxVI7nNO3pQ-1
X-Mimecast-MFC-AGG-ID: DF7EBLvcO-WTxVI7nNO3pQ_1751337130
Received: by mail-lf1-f71.google.com with SMTP id 2adb3069b0e04-554f7b19481so2989698e87.0
        for <linux-raid@vger.kernel.org>; Mon, 30 Jun 2025 19:32:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751337130; x=1751941930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rRVdG5V5THof2kVFbuGpoPO6Ew/jSkC8Uar+R290sas=;
        b=V8TGMygK+cPS2oyLtwxYqIs0ZBlHNxRu8NvVqNAtF+ddEbrU34MrWLHgVoTVanhaHe
         7Ph2JP1TX4g+8iw6yhcjILS4FPldAEMC6nRBVOac3KOamYNXxIp4xBS/Xg9fzdbSTaDo
         TFc8VGUOPKj9LgZmmpwMaVD+1/E+7u7pDJS91E22MJinAmb8WJSyLKFVCbnmcziK9+pB
         0J9JxiOhzYgPiKR0Tm7u+1Qia1X2BRp0JSQJKGlBXuio/zj8PGcI4crounoyG2fJSNCs
         Nthh/+0Q4YeXh8EuTVarAYQLZ/WCZSaFC2GPiKyBBZ2rNmGfwtrNmnABl7902UqZ5kv6
         QPMQ==
X-Forwarded-Encrypted: i=1; AJvYcCXdF2llLAfKyaDn6jXcErj7zdPwWJ9oMMaR1k7zoI39mr4sf4JtlFRWQvMeXwUFLgXXDDwMLQzqrm9q@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7PQwIt069OacmBDlFi5nsJaAlby+cUby0V5Da9Qk489fYPVTF
	t9ojBIYYDp2ilYdjlNxjMD4s3qXzpFFqZJXecvEFLRoSga7rcw/ZiH/XzQljmpijGhr/8k/G2Nb
	lX7M+nEHVlWQHKntFR2TpgLXEWdMRcvoqWhSE9mXjzuRJpXCoxMavvAqR9Xa93KuK+P9ZNB1Qnp
	z596P3M4CIoLXUNxUzazxrOxEhS/T1yt74d8+YrA==
X-Gm-Gg: ASbGncuTpQ+XFGRPkiauTbuI+pn1At3mSGxvxwnda1P4NCYZxRfajwo/cAIkVBl38fk
	KAFEc9pIjwMgRVRHFx+RsDjICtJ6AmHEcGWkn2Q8HZTHNQ6CnZKeEykMncFxnKijBq/0o738aCp
	N/EJL5
X-Received: by 2002:a05:6512:3f14:b0:553:33d5:8463 with SMTP id 2adb3069b0e04-5550b85a6aemr5124504e87.24.1751337130032;
        Mon, 30 Jun 2025 19:32:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHYxhicPvjsrYMTzNnBgN66EEIC9O090pHpKX6MSHN6FdUCZQawP5ktZNml7ohAaKF8rzbjcIZejG5Mnsuzl5U=
X-Received: by 2002:a05:6512:3f14:b0:553:33d5:8463 with SMTP id
 2adb3069b0e04-5550b85a6aemr5124492e87.24.1751337129620; Mon, 30 Jun 2025
 19:32:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-17-yukuai1@huaweicloud.com> <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
 <cf6d7be1-af73-216c-b2ab-b34a8890450d@huaweicloud.com> <CALTww2-RT64+twHo3=Djpuj81jArmePQShGynDrRtYab3c1i2w@mail.gmail.com>
 <93166d88-710f-c416-b009-5d57f870b152@huaweicloud.com> <CALTww2820X=HU3Zuu+z19oCaPL+oQ4bMNostoAgfDk1-3nB3aQ@mail.gmail.com>
 <ede16ca4-96ef-e8e6-45fd-1c88cddc7f4a@huaweicloud.com>
In-Reply-To: <ede16ca4-96ef-e8e6-45fd-1c88cddc7f4a@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 1 Jul 2025 10:31:56 +0800
X-Gm-Features: Ac12FXzhMQGjHMGlqGWC7dqp0aHNgDpMVdT7Q6bEMzZcdixQ6dP5r4Yqwzr1sd4
Message-ID: <CALTww29r76X9C2-AEVGLqQ=BaWba8yrCCLcwkwVdO9ZhpkvWvA@mail.gmail.com>
Subject: Re: [PATCH 16/23] md/md-llbitmap: implement bit state machine
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, colyli@kernel.org, song@kernel.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 1, 2025 at 10:03=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/07/01 9:55, Xiao Ni =E5=86=99=E9=81=93:
> > If there is a filesystem and the write io returns. The discard must
> > see the memory changes without any memory barrier apis?
>
> It's the filesystem itself should manage free blocks, and gurantee
> discard can only be issued to free blocks that is not used at all.

Hi Kuai

Thanks for all the explanations and your patience.

Regards
Xiao
>
> Thanks,
> Kuai
>

