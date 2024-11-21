Received: from mail-ed1-f53.google.com (mail-ed1-f53.google.com [209.85.208.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 385721531E1
	for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 08:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732178783; cv=none; b=sFclJllDy0GXiOJaj/MUR3I9ZeFHfCBLj3EcBeQX1GNRkJAqBPdGZC4KwlJHB/q62WFzv0NpMib0vWmmVStCFDg8cp+19hNaF2Ds6OtPJDG6+FDsaayZkVOlX4/1B6i/G1Dcd83KI+ypQn2d3N37DKIczd+snECs16t2F14ODdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732178783; c=relaxed/simple;
	bh=9qt1EpV1bysbJHfhnYNJdFDp5xfXTjrCsxoooow0Xfs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZpfKxOUGO0FhQ0qPIDwvdaYzlySecKu8K1zYu6x82JdyKQhAUgZFIfHgwIscjafBiXPn/4JjQxwtrnpZExY9f8yNHbqAdhtoWmR4q7hoFXi+b21bxLZB9UxjxE3jEixCLE6QJRNsgny6gcbAcQVMx+/yYZa1ogvYPBU2LEHbIIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=CT23zlq0; arc=none smtp.client-ip=209.85.208.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="CT23zlq0"
Received: by mail-ed1-f53.google.com with SMTP id 4fb4d7f45d1cf-5cfe48b3427so77279a12.1
        for <linux-raid@vger.kernel.org>; Thu, 21 Nov 2024 00:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1732178778; x=1732783578; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9qt1EpV1bysbJHfhnYNJdFDp5xfXTjrCsxoooow0Xfs=;
        b=CT23zlq0sUeL3u+bpWjE7jcpKfhEu7rjAtkZ6AfcF5kVEUWniaj6YEIz4roRdN32n2
         Jw1qpJxPoDyr4rE6g3wg019XElcox/WfqVRWM1AWcg6bdjh80pAXL4CH5JZoJGIB9RUQ
         9gvXw9KoZpID4k9GOs1mWa6Oq5ChEHkgpPAzk//monTlz+NjR3ZxUq6UHbVDTeBjgBL8
         X6oStyC5GXay3wAGDUi90+nZewLxl1nndPM+iGBoGIlypylMqGGJpZVQdjbK5j507UaJ
         00CqfMuhKOj/g+VpvYqAASe/AIwc75sT/ys5itr/X+qSW9FRis6Js/BARimHVQu0of7z
         MXSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732178778; x=1732783578;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9qt1EpV1bysbJHfhnYNJdFDp5xfXTjrCsxoooow0Xfs=;
        b=pHqKt3vF0srVSu0G70r1ECPoDtPJDI0iauHv3VIwwbGBc4HxVm9IvCpqPwurPHearR
         nNqB29cKarNj1bMghkMgbfkY4dk7zX51to5xm8KEU5PhO7KF2FGxACTzByoEBrgwwHSe
         KiYnZ9lL9k3ijdPlFIym4D3MjzW8Iw0nq12pDsb0Ne51E5z0pVJ2NfKjBvtHpvBkTZoa
         mkRlXIKU4RiVJ/Q1TqyeL+ob6LOxg86eqoTFWtB/KIFmlXszD2FkMjzu2sKJp15CX6D3
         BcIwwFwlLsCeUb/VQkJoASHrBoBb7O066ditxImxmihcn0oaZ3hL+TRZoDgGFLwP/UKG
         TA7g==
X-Forwarded-Encrypted: i=1; AJvYcCUvH/j6+Pm4qc5/wlwKxDXDt8qFJl/eti1ShdZH8GTV+fM0J/UKOEbFgB6ODr7gTAATqD30eznuf2hR@vger.kernel.org
X-Gm-Message-State: AOJu0Ywj51yMmYuu88yFf8jbP/DUzjU0DyZWVSiWFn+X3TpIYy3aN71g
	w06tApNWRsHk+5EVbG1/696g62TiM6AVUS96bFQm0YYBmGQnBzdzRirpBUET/UAOPRm+pRC2/zH
	ZvJfrRn/2lLa+Y2bqDFW9qyNMj6MkgioXKFeXoQ==
X-Gm-Gg: ASbGncv88f82106ah7gXkytvOv+hoGg1yZdDZWykfQs3/kmEDQZlzJfNEBO0bnP0QzS
	BiWduzWpBwwI+RUihlQP5UebELWd0vuI=
X-Google-Smtp-Source: AGHT+IGogOxhYP0i1TIV8N4U2jFv/3TwdSfcYGe1+KmvUFQgNDY+0i5crU2hWbGWyo3fjct6LbG5gQlZuypGj1x05pg=
X-Received: by 2002:a05:6402:5186:b0:5ce:fa24:fbaf with SMTP id
 4fb4d7f45d1cf-5cff4d04716mr1797534a12.9.1732178778547; Thu, 21 Nov 2024
 00:46:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com> <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
 <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com> <CAMGffE=hKeWTJzna8gFi=Q9wSuY9SLFScftdGVqc5MNW_jxQ4Q@mail.gmail.com>
 <19e59a67-35a8-164d-67e7-bc55508f4dd0@huaweicloud.com>
In-Reply-To: <19e59a67-35a8-164d-67e7-bc55508f4dd0@huaweicloud.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 21 Nov 2024 09:46:07 +0100
Message-ID: <CAMGffEkc_8=FkieQ6QfM9wHMBxaLOnoSzi_ujadKX-P3-UUKQA@mail.gmail.com>
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, song@kernel.org, xni@redhat.com, 
	yangerkun@huawei.com, yi.zhang@huawei.com, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	Christian Theune <ct@flyingcircus.io>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 21, 2024 at 9:44=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/11/21 16:40, Jinpu Wang =E5=86=99=E9=81=93:
> > Hi
> > On Thu, Nov 21, 2024 at 9:33=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/11/21 16:10, Jinpu Wang =E5=86=99=E9=81=93:
> >>> On Tue, Nov 19, 2024 at 4:29=E2=80=AFPM Jack Wang <jinpu.wang@ionos.c=
om> wrote:
> >>>>
> >>>> Hi Kuai,
> >>>>
> >>>> We will test on our side and report back.
> >>> Hi Kuai,
> >>>
> >>> Haris tested the new patchset, and it works fine.
> >>> Thanks for the work.
> >>
> >> Thanks for the test! And just to be sure, the BUG_ON() problem in the
> >> other thread is not triggered as well, right?
> > Yes, we tested the patchset on top of md/for-6.13 branch, no hang, no
> > BUG_ON, it was running fine
> >>
> >> +CC Christian
> >>
> >> Are you able to test this set for lastest kernel?
> > see above.
>
> Are you guys the same team with Christian? Because there is another
> thread that he reported the same problem.
No, we are not the same team with Christian, I guess he will test on his si=
de.
>
> Thanks,
> Kuai
>
> >>
> >> Thanks,
> >> Kuai
> > Thx!
> >>
> >>>>
> >>>> Yes, I meant patch5.
> >>>>
> >>>> Regards!
> >>>> Jinpu Wang @ IONOS
> >>>>
> >>>
> >>> .
> >>>
> >>
> >
> > .
> >
>
