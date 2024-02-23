Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AA4D7FBD7
	for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 13:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708696198; cv=none; b=VABBRlLjQaneDMl2UZKVoagI3A1caHTmGinHTicxsIVaVI1cI/VTGMASeL4dv73nqIjdoc+tofmIiW481B8TtOROqYkg5WBH1/ffiIuMZXHcmfvYS/agP7A4aY8M+sBLXdq05+A7OwnKJ6yH4ioq+MG0UwXPbAOxkHAY4/bZZpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708696198; c=relaxed/simple;
	bh=EUy3OE1tf6D7N57nMeA/9FZvI1nqisSpUaKPM/1NR14=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L2ASA4aDC5nle3r5oZxrlJX6iQJvWf+/1WJn/1uAYzpg08YMmmooJER4Myk/c/1qlBMKXStGE2tTRLDUYLhxMa/HrooEfXd5vLywmok2QMGuAnQE0IHhJqcHLKyxiibuOy48Pz8EswB/Dq+uk5122JzllhrHsRMFWcwoiksyarE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VQghUeGM; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VQghUeGM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1708696195;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qRJGiEK2y2n/ne+i7hF7lrmOvkwWDv1nO09eJH8xkiI=;
	b=VQghUeGMJMKNTQG3dG8ZfzOTmwOhC0dFqJBbwhyi96ZT1ukwR9Ja6Fxyb3vZyPLCfu1Gw0
	QFFDKFvEtyUammqjfAQt3SLYB8PzPlU3bnPMxY8S/hm4AAvic11mph8PjvsRsyRsT3IgFH
	Sh/ZK0noyEMckVNeDFWy6v+a3kjNDB0=
Received: from mail-pl1-f198.google.com (mail-pl1-f198.google.com
 [209.85.214.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-537-NDatQuC_O_-07AZ5szvnBA-1; Fri, 23 Feb 2024 08:49:54 -0500
X-MC-Unique: NDatQuC_O_-07AZ5szvnBA-1
Received: by mail-pl1-f198.google.com with SMTP id d9443c01a7336-1dc6f81c290so1321115ad.1
        for <linux-raid@vger.kernel.org>; Fri, 23 Feb 2024 05:49:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708696193; x=1709300993;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qRJGiEK2y2n/ne+i7hF7lrmOvkwWDv1nO09eJH8xkiI=;
        b=AP7TJMmOJIgS7T70HJz8EN5BzQjtrtxcxbys/gWYRNxvX56kTXnM9acYXwWtNgu7tE
         zqqxCS71BrBw23oBxUp3tYAxqvn3Gout+FGP5rd0hbZLQgIYgGc2wW9i7Qr56j+cduoA
         0zwaxf7BMTeN4LoiAVmej3232AR1ibRo+7AYPGqMTv5b7Yq1lxhSE4vwBL307RRAYHpp
         sA/ldtspHJYKh1kCVBxx3in3z/0IAXZEFn4ovydPCzsudjQKgzfPxNZOnXUG+BzgDt0c
         AIsNTuQAZR+rVKLd1vIz/CnoE+xBkq9zuPY+joLW3N+V0Ppzfdut10uhX9lJUP5mPbof
         ALLA==
X-Forwarded-Encrypted: i=1; AJvYcCXT0oeI5FV6l6ByBEwhsqMRMWzMDLFddljAHVfpmtaj1iMG3Yncb171VisTKN7pL6SYtwMo3hRkh+t8WfUnLE45QCxRX6DmcTiHlQ==
X-Gm-Message-State: AOJu0YzeUBMhtUDmELA6rjvMWFReQniBql2oom7SBfCNEdxKYjv8jvBd
	G3+OahiHXb+3YFJb79QcRNe2dRCnrophv7cr0P/0BV8YsIkff7o2nDFhMo0ZjOdhMuvEzEyNqio
	b3Z1/1GQzFJ7anpp1ccriBrwUqAufNnAaSaQxqNfLcem7nXCil5oNA6zgDALbYre2AZrVobaHFj
	XETpOKinP5Hz83/hbxTDFbf8SfWhWWyennvA==
X-Received: by 2002:a17:903:24e:b0:1dc:4a8b:2e21 with SMTP id j14-20020a170903024e00b001dc4a8b2e21mr1934119plh.19.1708696193004;
        Fri, 23 Feb 2024 05:49:53 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHg4XuRNe5wpL7uz2gKLB2aFRvKxdipIv+peW02sFUpWSChz8uYkhouqKGDAIG3nZ/GKZRngfiCM1WSQ9fNzhM=
X-Received: by 2002:a17:903:24e:b0:1dc:4a8b:2e21 with SMTP id
 j14-20020a170903024e00b001dc4a8b2e21mr1934094plh.19.1708696192681; Fri, 23
 Feb 2024 05:49:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240220153059.11233-1-xni@redhat.com> <20240220153059.11233-4-xni@redhat.com>
 <773e5948-79a6-1270-4b74-cb1a3a60d243@huaweicloud.com>
In-Reply-To: <773e5948-79a6-1270-4b74-cb1a3a60d243@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 23 Feb 2024 21:49:41 +0800
Message-ID: <CALTww2-iPKrujozWRSGJQsJtN0QJS3risegCuZLUXGAm2FOLjw@mail.gmail.com>
Subject: Re: [PATCH RFC 3/4] md: Missing decrease active_io for flush io
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, bmarzins@redhat.com, heinzm@redhat.com, 
	snitzer@kernel.org, ncroxon@redhat.com, neilb@suse.de, 
	linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 23, 2024 at 11:06=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
>
> Hi,
>
> =E5=9C=A8 2024/02/20 23:30, Xiao Ni =E5=86=99=E9=81=93:
> > If all flush bios finish fast, it doesn't decrease active_io. And it wi=
ll
> > stuck when stopping array.
> >
> > This can be reproduced by lvm2 test shell/integrity-caching.sh.
> > But it can't reproduce 100%.
> >
> > Fixes: fa2bbff7b0b4 ("md: synchronize flush io with array reconfigurati=
on")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
>
> Same patch is already applied:
>
> 855678ed8534 md: Fix missing release of 'active_io' for flush

Thanks for the information. I used Linus's tree so I missed this one.

Regards
Xiao
>
> Thanks,
> Kuai
>
> > ---
> >   drivers/md/md.c | 6 +++++-
> >   1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 77e3af7cf6bb..a41bed286fd2 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -579,8 +579,12 @@ static void submit_flushes(struct work_struct *ws)
> >                       rcu_read_lock();
> >               }
> >       rcu_read_unlock();
> > -     if (atomic_dec_and_test(&mddev->flush_pending))
> > +     if (atomic_dec_and_test(&mddev->flush_pending)) {
> > +             /* The pair is percpu_ref_get() from md_flush_request() *=
/
> > +             percpu_ref_put(&mddev->active_io);
> > +
> >               queue_work(md_wq, &mddev->flush_work);
> > +     }
> >   }
> >
> >   static void md_submit_flush_data(struct work_struct *ws)
> >
>

