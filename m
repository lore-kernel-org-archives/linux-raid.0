Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED1291C54AA
	for <linux-raid@vger.kernel.org>; Tue,  4 Mar 2025 13:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741096140; cv=none; b=KwNUg8ESSk7ZmWjZULpGPRZbGk6rVpDy8co/NFahXEr8eP6p1mPaXrgThmYZVp+9lHfLcQ79Z6AYm9qEr57JDJPG8V1FLdhsOyh8YuV5sJ8tQeVYIRV14k3qUxDFawrDv5y+XtJp4buzZwuA8h7ICi/t0JF9i5+HnFQbxdIYaOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741096140; c=relaxed/simple;
	bh=yxvR94Ft62gN9Lo7hCe6gWntrPLSZnzK3pNTwL9vvkM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=U1MIuzptQyEvRfok5LA9oMbMQsdxUU7TbRMeIXQldDGJ9Ae37pCxFNrBmtTNZ0I2ndXQX8/ZFhcBw51lublYj8rnQaeSozlrn8hQM7Q+AvuNLwTa28wPQ92+ujP/YoL8bCittsVg976Men5QoDnudZjABSTnei15vxorTaj5UeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=PhvB3m59; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PhvB3m59"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741096137;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xj6cBFN3a2C6l4/IapGVH26/MJee78grHJo4NXVFfvE=;
	b=PhvB3m599xpAAkv2QGN0cYU42i4uGvBXUi1Hbe1zv3ENZJYmQgyUpeb8T6rNYhTqdsICXH
	qBLwhGbtHMPV/M4FOeaS/N8Jv3/9AbNUan+aW4hNPr6WKxdJNzL5co4+9S22+SNaKUkYO6
	2oK/hpZykeP3jvsY7varUY6yaI33eMI=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-UX67LY0uPZGKFo38CP0ycg-1; Tue, 04 Mar 2025 08:48:56 -0500
X-MC-Unique: UX67LY0uPZGKFo38CP0ycg-1
X-Mimecast-MFC-AGG-ID: UX67LY0uPZGKFo38CP0ycg_1741096135
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5495a1c0be4so1883315e87.2
        for <linux-raid@vger.kernel.org>; Tue, 04 Mar 2025 05:48:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741096135; x=1741700935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xj6cBFN3a2C6l4/IapGVH26/MJee78grHJo4NXVFfvE=;
        b=pqUp7JJCePE+SVSpaiP0s5JjbQMSBREq5rL68kM5md9RUIjZiP0GnBkcZpCVZiXAem
         pjYS08GwaEOiQKODWx1neSRgH42STiL3KXxaYmcSSFU/h1JJH7KNFXL/GItRu9oqYDdD
         sGlsw6ZiTrttAMULQGWrzf+HttC5U0/I6i3enycncJZWbC3k/MPecFe7G9UjGEcWdxHX
         5vPfrULwAXAyxmmcqavbNVwWI9+RIjJz5+952EWkzi9uWHdKY2cpjZ6F4sHBpyztQ813
         q9aHYjrlGd4kfBBOjI6/NsiIBXq/chbZc7zWhpXZx/sKgsQHsaZOSPliY0wzdQj8Mab0
         NuNg==
X-Forwarded-Encrypted: i=1; AJvYcCXz3hMkKC/VX3BwMoqZGaBZhwuBowqd/y4v6nkRdu1ONTgU0o2Ba1w/B4y9oopBHboBq2QnUvnT6VF4@vger.kernel.org
X-Gm-Message-State: AOJu0YxdHIInmnBkGHhsCNg8ZM2jTATX36dePhVqfo/UA7lldcJV/pac
	7k1E8UmJ1Fu2kMRunYHoWq68A3+TvqRUQTgEopZXVSdNA1iVUuAvUYXQRYEf5BpKUGUEPFX54XP
	vWh2hxOwkuG5bln8MT9Ku5P2yobXTe0lJa/cmvCzM9q3fOr9zkT7V4dmlWs63nu8Kge0eldULGF
	RZgzfJIm0toWYaEhl5Yq0KliBYufwI4PeqnQ==
X-Gm-Gg: ASbGnctd567vrh1BJs3wQShf41P2BcR413NvynA6y7q/IEu5u5zi0rLZCksci/w/UOg
	ZxVJsh3TmgxugTsmO7LrKTr5Iz3qeEXk/wfSEGL1TX72pGAOUyi58OcCjetf52PFdMI1A9e3vvw
	==
X-Received: by 2002:a05:6512:3194:b0:545:2550:7d67 with SMTP id 2adb3069b0e04-5494c37eea9mr6030440e87.36.1741096134907;
        Tue, 04 Mar 2025 05:48:54 -0800 (PST)
X-Google-Smtp-Source: AGHT+IF+iY+4tXygOwdzs60Gd32l9Z4KmiQhmffYtMK5r/fI2fIRcHKHf3d1v9mCGRmkrG5BiU5rfBevBA9Q+A2DBVM=
X-Received: by 2002:a05:6512:3194:b0:545:2550:7d67 with SMTP id
 2adb3069b0e04-5494c37eea9mr6030433e87.36.1741096134518; Tue, 04 Mar 2025
 05:48:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250304104159.19102-1-xni@redhat.com> <2c14d833-12ce-42ef-80ba-a02c5e489195@molgen.mpg.de>
 <CALTww2_101s+zoe42oMkDYQ5pq=Kg=PJKciPhv+d9Kjzvb4+UQ@mail.gmail.com> <32eb3557-ac39-37d0-c65e-f4875fff8980@huaweicloud.com>
In-Reply-To: <32eb3557-ac39-37d0-c65e-f4875fff8980@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 4 Mar 2025 21:48:43 +0800
X-Gm-Features: AQ5f1Jo6NGMXxvS3obkBmia4staW47thxiCMNGoCdBIjo5SD5UiSHq4JLIbFQRU
Message-ID: <CALTww2_eVMvSftwGJSveMOyd9gH_J4SF9h9KenVvtYMzJTCGtQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid10: wait barrier before returning discard
 request with REQ_NOWAIT
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, song@kernel.org, linux-raid@vger.kernel.org, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 4, 2025 at 8:34=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2025/03/04 20:22, Xiao Ni =E5=86=99=E9=81=93:
> > On Tue, Mar 4, 2025 at 7:03=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.=
de> wrote:
> >>
> >> Dear Xiao,
> >>
> >>
> >> Thank you for your patch. A minor thing, I=E2=80=99d add a verb to the
> >> summary/title:
> >
> > Thanks for pointing out this.
> >
> >>
> >>> Add wait barrier before =E2=80=A6
> >>
> >> Am 04.03.25 um 11:41 schrieb Xiao Ni:
> >>> raid10_handle_discard should wait barrier before returning a discard =
bio
> >>> which has REQ_NOWAIT. And there is no need to print warning calltrace
> >>> if a discard bio has REQ_NOWAIT flag. Quality engineer usually checks
> >>> dmesg and reports error if dmesg has warning/error calltrace.
> >>
> >> As written in the other thread, please add, why the warning is not
> >> useful. Somebody added that warning probably with some reason.
> >
> > For me, it's overkilled to print a warning calltrace if one bio has
> > REQ_NOWAIT flag. It's a normal request rather than a dangerous thing
> > happens, right? If we want to print some logs, we can use pr_info
> > rather than WARN_ON_ONCE.
>
> Just take a look at block layer and other drivers, there is no such
> warn in this case. And I think you can add a fixtag:
>
> c9aa889b035f ("md: raid10 add nowait support")
>
> This commit just forbid discard with REQ_NOWAIT in raid10.

Ok.

>
> BTW, I think the abouve checking can be removed as well:
>
>          if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
>                  return -EAGAIN;

Now we can't remove it. raid10_handle_discard doesn't consider the
reshape situation. So raid10 will use the old way to handle discard if
reshape happens.

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Best Regards
> > Xiao
> >
> >>
> >>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>> ---
> >>>    drivers/md/raid10.c | 3 +--
> >>>    1 file changed, 1 insertion(+), 2 deletions(-)
> >>>
> >>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> >>> index 15b9ae5bf84d..7bbc04522f26 100644
> >>> --- a/drivers/md/raid10.c
> >>> +++ b/drivers/md/raid10.c
> >>> @@ -1631,11 +1631,10 @@ static int raid10_handle_discard(struct mddev=
 *mddev, struct bio *bio)
> >>>        if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
> >>>                return -EAGAIN;
> >>>
> >>> -     if (WARN_ON_ONCE(bio->bi_opf & REQ_NOWAIT)) {
> >>> +     if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
> >>>                bio_wouldblock_error(bio);
> >>>                return 0;
> >>>        }
> >>> -     wait_barrier(conf, false);
> >>>
> >>>        /*
> >>>         * Check reshape again to avoid reshape happens after checking
> >>
> >>
> >> Kind regards,
> >>
> >> Paul
> >>
> >
> >
> > .
> >
>

