Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12AC71E4AE
	for <linux-raid@vger.kernel.org>; Sun, 27 Apr 2025 02:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745721952; cv=none; b=KAwHClZZ5lvUTGTdAqEHLhxfRo/44kadY+fZJxvg2SwWvPn5faVm+qGBXmW+ceyqInrR5vS0LQKADLfwa17FoghNiXzTbAj1JWDNMxox54+syni5t3SADctveqhZ8r8H1rF71RSyOwRSS7+Qy0tRzlPMxQK228C2D/MukOQPI14=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745721952; c=relaxed/simple;
	bh=9HyWmovfxbdO9WlvHm/CrZCGdDuQYBCiz0YIKAxiQIw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UuYZe22rks5DlqkyBdHjcyuxo4TZ5EQL7+I1cXcPltkCuW1S7nltXSQAQzOUdj3b36RRAgmTkQX8GASYlDrmtSzZ4PeF1/ZkpE4wCY5tmAyXDmx/KrGu2nFPPGNAi6r3V5gNqDbWzG5NtLLB2jpWX2JnrKAtAS66I3cMnszMJD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=F8qyf2oo; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="F8qyf2oo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1745721949;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5lOD5wJKRJSGzLBcfg1idl+BdURTBGXU653f/FvKAjA=;
	b=F8qyf2ook5WUjOC8eDxwf7LWmqHqkQ5RRfw7vB+H0EMXBndZpBQ/f85qFeLNrdZFxNMHk+
	67W081A8a3G3kwEXCK853KE4f6PR+E+Vd5z1hU05+CpFgw7kjZvuA3d38hw+3vyhHQnaJI
	SD97eQd4+vPkiJsUoK4GEAGzjWCY7T8=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-640-J0yYV2EjPNe-ThED1QFvRA-1; Sat, 26 Apr 2025 22:45:47 -0400
X-MC-Unique: J0yYV2EjPNe-ThED1QFvRA-1
X-Mimecast-MFC-AGG-ID: J0yYV2EjPNe-ThED1QFvRA_1745721946
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-30bff0c526cso17693851fa.0
        for <linux-raid@vger.kernel.org>; Sat, 26 Apr 2025 19:45:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745721946; x=1746326746;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lOD5wJKRJSGzLBcfg1idl+BdURTBGXU653f/FvKAjA=;
        b=JHHnc23i5IHeosOGDObjCVHcaPaV72amIy4vEmuCjkzdJcHpn4qmf+MCRbp8F4ngUX
         e/SwuKRKrfLBSRyD4fXtzk8qRdkULaon1OpRv5Asa7pXGHt4BncA1iQA8VvDRUHl+AiI
         wmBWToqPM4agIlFzLmdqTCy2PBhrXtyIhSrZV3r/OYEjbWH9qlk12ZNwtzk2raiHpHku
         4cGUZ/dOuXU9QGYVjjabtNWyOyfGo+aTCjONwX6VJPlWoKxfSIluUhXHnxxPqAW1yTpp
         aYzRqp0cmJheVrGFS5r3tshyqKnQheQO8q+MXGwaASm5X/8YrZpJ/8SZdFl4ZVAFV7Cv
         cCMw==
X-Forwarded-Encrypted: i=1; AJvYcCWuYWpGoYYxRN7IWgIfl5nqTs/VQHG545AyHSHiXQLOyiOaJ+S0HNyh+K1iuJ00CpPEJSrE3+FkJerV@vger.kernel.org
X-Gm-Message-State: AOJu0YzVxqZ/0ZS5cojZvGUXhHHMwpQoncgaWdSUlZRQgWmxIEVTigYw
	sYUSEd707b1EJ7p/ZBhteV+hmWmTjEzgoUfC/qCCE9Y9hxQETobfsRJORpf9ox8tdd/b7tD60Hc
	LFucEBU1Oh18jZBi2zOC3FtOILaXpdd7ZdvK+AZK6wFv1LZ/RFt4qDMnNkk/hND+m4jJDvHy7VO
	lFDhheE8BJb2Eb9bAapp+s2kUOES3lXNmnuA==
X-Gm-Gg: ASbGncvl147pC0/zyYkS7T/wvpiwY3oj1r7PHMs/RBUbHModRiGsWMthYMrDZzPqfNz
	9ITXO24mKodfhiZN3IsyXl/O+xF0vBT9a15q7D9nFOnq0Nh01pSJwZfSsghThBw8GMwGV9w==
X-Received: by 2002:a2e:bc13:0:b0:30c:1441:9e84 with SMTP id 38308e7fff4ca-3190614e2efmr19465661fa.13.1745721946225;
        Sat, 26 Apr 2025 19:45:46 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGS0Yc4bGIbl2/v9OhZ9z0uTs3mIqptakH90A1Qqw9fP/ktQZ1u60ZhGAtb0KMTfZsMAlADrGR3uW4Ef7E40xE=
X-Received: by 2002:a2e:bc13:0:b0:30c:1441:9e84 with SMTP id
 38308e7fff4ca-3190614e2efmr19465581fa.13.1745721945851; Sat, 26 Apr 2025
 19:45:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250418010941.667138-1-yukuai1@huaweicloud.com>
 <20250418010941.667138-5-yukuai1@huaweicloud.com> <CALTww29aehPQcbcy0j+V69r+RVgzNPwNhpAQ-7wWMdD-VPfNgQ@mail.gmail.com>
 <f14eac30-ab65-85b2-3e65-de6d50ea15e2@huaweicloud.com>
In-Reply-To: <f14eac30-ab65-85b2-3e65-de6d50ea15e2@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 27 Apr 2025 10:45:34 +0800
X-Gm-Features: ATxdqUFJRCKVD9aqKTI3GFPq-KDsm4Enqte1rPq47L--gyfTK3VWtePr_uH3814
Message-ID: <CALTww29b1MN8Q-ayFLxnRA=+=J-jrR90nrDrrY7xs1C_2k8KXQ@mail.gmail.com>
Subject: Re: [PATCH v2 4/5] md: fix is_mddev_idle()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, 
	song@kernel.org, viro@zeniv.linux.org.uk, akpm@linux-foundation.org, 
	nadav.amit@gmail.com, ubizjak@gmail.com, cl@linux.com, 
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, 
	dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com, 
	yangerkun@huawei.com, johnny.chenyi@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 27, 2025 at 9:37=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/04/22 14:35, Xiao Ni =E5=86=99=E9=81=93:
> >> +       unsigned long                   last_events;    /* IO event ti=
mestamp */
> > Can we use another name? Because mddev has events counter. This name
> > can easily be confused with that counter.
>
> Sorry for the late reply.
>
> Sure, how about, normal_IO_events?

It looks much better, thanks for this. I guess it's a typo error about
uppercase IO, right? We usually use lowercase.

Best Regards
Xiao
>
> Thanks,
> Kuai
>

