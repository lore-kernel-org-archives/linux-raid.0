Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36C9B1FF7B3
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 12:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741090965; cv=none; b=W77gqoJYENqhOuVfOEU5sF9B91xeIeSXPA+pQk8WTzLMO2EnJc5Chc0kVxvA0hdTyVDX0rCmYwHFQ9XT7zO760oxAyZtZkorEngH+gTBELPbOZCTNXLKyedkkPdqH+rlWn8rfJv6HM1V7zWlqvklQTdWQVnxvr+ub1ldBsMXWjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741090965; c=relaxed/simple;
	bh=gOCa8LWx7QDE/aAsn73ciKnsYp78x0QR7nJFk69vmj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HUUVpNQUwgVsYJwIZ4lOrTtP9GztkJYqMjlnwSDMNanKTCXjEdK21gxvI5X98FEQ5zau/nv3pFwako8GzhTzA3+vthjJnHhaqkhHbvos0KAMZUWmZc9nb4MATWpRqycTjbKzeFPhvlzdIfS0WUhFsXTgl/Uj66A+3fP90PqqWUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=VAYPzIv1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="VAYPzIv1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741090960;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=VIpvfpG0dWCZFFQGhItZuwbToxwj427tjJdShTJRx6U=;
	b=VAYPzIv1I0LdhFWk0z8YZcCFDYHbW02YeeIBrYVnOAgXc+6GHsXd8fgRNkFZtmeWRfJu0U
	JN0n7o1mtbxK42F8s+uEIRVdGXfFqwUzRehek7HPGm2ygeLKO3Vzm635EzWIX+7wq0qN8m
	5vIt/AHTUHGS5gZkD2OUwZhxN8AL+4g=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-384-1JuYiiJmOKG9z--eRkeoQg-1; Tue, 04 Mar 2025 07:22:38 -0500
X-MC-Unique: 1JuYiiJmOKG9z--eRkeoQg-1
X-Mimecast-MFC-AGG-ID: 1JuYiiJmOKG9z--eRkeoQg_1741090957
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-5495b38958fso1749699e87.0
        for <linux-raid@vger.kernel.org>; Tue, 04 Mar 2025 04:22:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741090957; x=1741695757;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VIpvfpG0dWCZFFQGhItZuwbToxwj427tjJdShTJRx6U=;
        b=HoZN394THtBYf4g6gDTSZTZd90yL5cqrDWMBoTNfVQ2Vi6EVobIMrGtLW5lkJgvrs0
         36R/a1iYpLiX9JaHdlWCnFh0/t6rkH31SXx1OS5eIEWoRomdsyyu3uEoKcwsIH3J8TUe
         7seowt5dL+RNrdoii7XjP3hqpKJZgptkGUR7F696PBDZgSE8dr+I4ME1DyZOfDM31JwH
         FC1SRcuTLOpZXbVpzeTXIfRxNnFnYJqd0vkomxQBH+Oepv9WPJNNqnHHyR82HxuXwugT
         93dtioFNGZmyTXkY/R/1gYumHE+OyMQarr2nI6gogfyN9pbNszkWUQhhk1a/CwGhW9kS
         eBvg==
X-Forwarded-Encrypted: i=1; AJvYcCUmij5XtC42zNsLfh2gBN294XhGnlQY6La/cSkjSf755fbZ5ItwikDbG/tTe6QnSS6KvVU0sz2tJx2U@vger.kernel.org
X-Gm-Message-State: AOJu0YzKOMxr8s2sCJZnqFj3Yqdz9vpApbJjMmZ8VtYfaNwDkoZRkf3v
	ai8FNem+dG1bgEPSKrHVaR0POTFNFoOALqFRtDesTX9938nQktSXW79Jeh985FeQdsKV1qJypZW
	dOc66SsM2q8kMBvy2imcOvbZ7c4rEJ+9k0YnCH4o6GRL7Q4KJZm4YLQt+752ec4RxjfAKMUNEP0
	+MUa0hXzI06X2e+t3y02EDggsm6CoQWDlSVbTIsUatI7QM/kk=
X-Gm-Gg: ASbGncshtixxguvC1VEL+6w5NL/NMMXWHS27rrdUcj5R/pJsAhU3+00yHeoQjwfZZ4B
	6i8+UXDfMXMRGUr96LRSbx1dOmtLRTN7Ejo5YZ2SuILLOPjRDZnoYLlEj4wsi5Pq/aUCCfnfumg
	==
X-Received: by 2002:a05:6512:3053:b0:549:61d9:bc12 with SMTP id 2adb3069b0e04-54961d9be0dmr3658065e87.51.1741090956670;
        Tue, 04 Mar 2025 04:22:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHyERs9JtmrN8feXI2B9U1EAyuB2uPeMgddkul+4ZWXvPbo78A6ksIzMW/RSfN1iGOhE3PoXO+b7SZpJ7MLUBs=
X-Received: by 2002:a05:6512:3053:b0:549:61d9:bc12 with SMTP id
 2adb3069b0e04-54961d9be0dmr3658054e87.51.1741090956278; Tue, 04 Mar 2025
 04:22:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304104159.19102-1-xni@redhat.com> <2c14d833-12ce-42ef-80ba-a02c5e489195@molgen.mpg.de>
In-Reply-To: <2c14d833-12ce-42ef-80ba-a02c5e489195@molgen.mpg.de>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Mar 2025 20:22:23 +0800
X-Gm-Features: AQ5f1Jp1wu5HR3f6HHtNF0PMc6GBOoyqdj-luohAoKM_m3O6hb0z6ISpbOhQMCM
Message-ID: <CALTww2_101s+zoe42oMkDYQ5pq=Kg=PJKciPhv+d9Kjzvb4+UQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: wait barrier before returning discard
 request with REQ_NOWAIT
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: yukuai1@huaweicloud.com, song@kernel.org, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 7:03=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de> =
wrote:
>
> Dear Xiao,
>
>
> Thank you for your patch. A minor thing, I=E2=80=99d add a verb to the
> summary/title:

Thanks for pointing out this.

>
> > Add wait barrier before =E2=80=A6
>
> Am 04.03.25 um 11:41 schrieb Xiao Ni:
> > raid10_handle_discard should wait barrier before returning a discard bi=
o
> > which has REQ_NOWAIT. And there is no need to print warning calltrace
> > if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
> > dmesg and reports error if dmesg has warning/error calltrace.
>
> As written in the other thread, please add, why the warning is not
> useful. Somebody added that warning probably with some reason.

For me, it's overkilled to print a warning calltrace if one bio has
REQ_NOWAIT flag. It's a normal request rather than a dangerous thing
happens, right? If we want to print some logs, we can use pr_info
rather than WARN_ON_ONCE.

Best Regards
Xiao

>
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/raid10.c | 3 +--
> >   1 file changed, 1 insertion(+), 2 deletions(-)
> >
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 15b9ae5bf84d..7bbc04522f26 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -1631,11 +1631,10 @@ static int raid10_handle_discard(struct mddev *=
mddev, struct bio *bio)
> >       if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> >               return -EAGAIN;
> >
> > -     if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> > +     if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
> >               bio_wouldblock_error(bio);
> >               return 0;
> >       }
> > -     wait_barrier(conf, false);
> >
> >       /*
> >        * Check reshape again to avoid reshape happens after checking
>
>
> Kind regards,
>
> Paul
>

