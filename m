Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682AF19993D
	for <linux-raid@vger.kernel.org>; Tue,  5 Nov 2024 09:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730797739; cv=none; b=eENVop1dELhJ5lZwNtIrxSvDgBrJklxCZJaaEHlM7LqwwcL+8VCvczHpKR8pdnHVL80a8KVZeBK/IJXmgpCOQYQ+TTAXYNQz3JDbr5kkMxt1+pL4cSA/FaWvjGELeYHkfAkzkAm8RGAqg4ybEuLMAZ3z5I2zMecMIYrJ1BXqvxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730797739; c=relaxed/simple;
	bh=JXktp7OTinGcNm+C1pLaFRYyO2GgUGb9RQv6bHDFnhs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=n+GTEeNus9ZOxa6isDgPxZAo6MvvDl9cHGJX4pN+Rglkus5r21WpYZRM69yfyH2TyebZTb0eILowyRBXKVBaoDX/w6UOVTFZsY3eH2XfvEMJI9FbnHr5hBit5z7JADgyauImv6q8QeJf5Ck2FRo+bIEpevZa/zGFzTjNpvjPJcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Z+XlGyES; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Z+XlGyES"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1730797736;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=snACynnCVLqZQdVLsU1zBCYyQ+3cJwYxLcUYn7ItX5U=;
	b=Z+XlGyESvF+3Tu2m1hlK270M+yTVmVtNPT31BDzQL6OBRqonuxyiR3kEOP4PkK82Q06cqZ
	jG4gsKgz7WpmSzKVc1cwMe/CKR1UGHuIC8YXUwEJ0XS/96T5EmX1RVNW/qpNcVtBKYhoIL
	MLAlyfSWzHjzCqCC8kFhQNj4roZaqeo=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-171-mwRXrmfAMhKrl-SrYDKjKw-1; Tue, 05 Nov 2024 04:08:55 -0500
X-MC-Unique: mwRXrmfAMhKrl-SrYDKjKw-1
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-43159603c92so35242735e9.2
        for <linux-raid@vger.kernel.org>; Tue, 05 Nov 2024 01:08:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730797733; x=1731402533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=snACynnCVLqZQdVLsU1zBCYyQ+3cJwYxLcUYn7ItX5U=;
        b=qskkU5UVMAmXsuObOoBRLcX5Rhb19A0EDtoTNlrqOZJmHy24+eKzm0/oRDZKrOhSJP
         fk5qSJEP2aYHb2jTEXJEImh7n+qz5JdsQ+z9cRQuVAsbYQQ5Mzw2Gz/hblxaf3wz5WSR
         PqDZatub8RS3EalcCE7KVu63EqkKtYkP8SgsIxOi5oOX8ew8Nz5ZGNIXSVrVqRgsUz/N
         2ANfhynYmCiI24hIzMrXGk2YZeP72QZ9S628dXYKQDQEQkMv4BxHPPNzoCwJg8EchOsn
         An7WRmMg2MlThCTTeE0x1p4KxC1rsBfFhPLk28UA//LQkx5evkR+WIWd9dzIXi//WyoN
         s1Rw==
X-Forwarded-Encrypted: i=1; AJvYcCXxUetNG0o7nmVnxUIrUNPHMwpRm7UkLj8MGwW/DWek1Ea2VPmYFVf8ihN3RdFYmiHZ+Z5CT0P+YlZC@vger.kernel.org
X-Gm-Message-State: AOJu0YxQwfAb/Gqwimf2cC82KxYboqFzEcerybTtNWrkPLILcng8npai
	x0qHHa+/8lJwahYl3Mab+CBDwfhatgAKu6BxzezPONEtd1PpBIz1R4XArci37L62mL1WRzYXe0f
	5Y0LRNDn8zJkaFD03FHvWGbqbZESoTkXSTGRWy7MbWXka0ATju5oDhcZh0OBJYQdfrBnhfJTbUy
	OYEdUz8nBSAHYJwoPacU8Nl1eN/GxykLVWuItODgoR6P7i
X-Received: by 2002:a05:600c:5250:b0:431:54f3:11af with SMTP id 5b1f17b1804b1-43283296643mr131437035e9.31.1730797733579;
        Tue, 05 Nov 2024 01:08:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEbU5sJbeVeQAYrUXDadaccCo1/Vyr9bX8xK/7Gia39VGAcGqTfR4x3pe4LVbrFWvzlnRz99ZY2a0ZMviJfTr4=
X-Received: by 2002:a05:6512:b97:b0:52e:9cc7:4461 with SMTP id
 2adb3069b0e04-53d65dd1d63mr8178944e87.5.1730797328000; Tue, 05 Nov 2024
 01:02:08 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241105075733.66101-1-xni@redhat.com> <20241105091601.00001267@linux.intel.com>
 <08186a07-57b4-9e8f-d088-0e009ebe8fa5@huaweicloud.com>
In-Reply-To: <08186a07-57b4-9e8f-d088-0e009ebe8fa5@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 5 Nov 2024 17:01:56 +0800
Message-ID: <CALTww2_PV8=1G1TUasA=nwXgE2+jRWcVtQpVxmB35xSAQ1ea2Q@mail.gmail.com>
Subject: Re: [PATCH RFC 1/1] md: Use pers->quiesce in mddev_suspend
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, song@kernel.org, 
	linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 5, 2024 at 4:29=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2024/11/05 16:16, Mariusz Tkaczyk =E5=86=99=E9=81=93:
> > On Tue,  5 Nov 2024 15:57:33 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> >
> >> One customer reports a bug: raid5 is hung when changing thread cnt
> >> while resync is running. The stripes are all in conf->handle_list
> >> and new threads can't handle them.
> >
> > Is issue fixed with this patch? Is is missing here :)
> >>
> >> Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
> >> pers->quiesce from mddev_suspend/resume, then we can't guarantee sync
> >> requests finish in suspend operation. One personality knows itself the
> >> best. So pers->quiesce is a proper way to let personality quiesce.
> >
> >>
> >> Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> >> Signed-off-by: Xiao Ni <xni@redhat.com>
> >> ---
> >>   drivers/md/md.c | 6 ++++++
> >>   1 file changed, 6 insertions(+)
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index 67108c397c5a..7409ecb2df68 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -482,6 +482,9 @@ int mddev_suspend(struct mddev *mddev, bool interr=
uptible)
> >>              return err;
> >>      }
> >>
> >> +    if (mddev->pers)
> >> +            mddev->pers->quiesce(mddev, 1);
> >> +
> >
> > Shouldn't it be implemented as below? According to b39f35ebe86d, some l=
evels are
> > not implementing this?
> >
> > +     if (mddev->pers && mddev->pers->quiesce)
> > +             mddev->pers->quiesce(mddev, 1);
>
> It's fine, the fops is never NULL, just some levels points to an empty
> function.
>
> The tricky part here is that accessing "mddev->pers" is not safe here,
> 'reconfig_mutex' is not held in mddev_suspend(), and can concurrent
> with, for example, change levels. :(

Hi Kuai

Now mddev->suspended is protected by mddev->suspend_mutex. It should
can avoid the problem you mentioned above? level_store calls
mddev_suspend and mddev->suspended is set to mddev->suspended+1. So
other paths will return because mddev->suspended is not 0.

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Is it reproducible with upstream kernel?
> >
> > Thanks,
> > Mariusz
> >
> > .
> >
>

