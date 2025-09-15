Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B871DF75B
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 08:51:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757926264; cv=none; b=Qw/+Crb/2lcoqExyCL5ubnqZB2KbUU+KCLBLAwa3a9jzslsk0cmgavEhs/Ir7CoF1XA0WRrfalJulFpWQCT9fWFZttaWjpZeg4fmqeip5AsZLv+m5Ee31zPmXdqZNk41r7ivh++t7s6HGzqb1EcaOWGW098E+d8TpaWLGckeueE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757926264; c=relaxed/simple;
	bh=wPZPeUMuJZB6mmUn0N0BcQU5xP2lBbhUb5Om7x+1yKA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HxXdJYiGSlGb/KirMhdfaH5lCuj9GQl4XKzjDbuQIbUIsMxNP0+9S+9zHvvkoTNzDnY/3nydfN8pi06DtPJaf6scIH91K/v9lTb56mgAUhVB8KCt9A+MKDXonuCmSvV9Mg31Fb5e1IV4UiJlW2Y2t7nsjV3P5p7ynecG4CZhzoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=W+SJpYe2; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W+SJpYe2"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757926261;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iHAiXvx7xZu60Hqr98Fl5/ljjKFjkxjgYFM+bVq7QJ8=;
	b=W+SJpYe2MZDYjBwoWsyQ/bJgSkElVdcGT/0IszCXz+cGmReqm8K736i/bUINaaFdjE9Pf0
	63BjvzHIULJ5MZElMChZFKZhcO88EgD1eSEOx0xiV9u0/RF2XHXjlZGXsKSr6GsuyoIcpl
	8//m7EXPw9YnhCGRe49BRZLODcnuPw8=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-111-tMmq4-50N0ODYabTLr_SGw-1; Mon, 15 Sep 2025 04:51:00 -0400
X-MC-Unique: tMmq4-50N0ODYabTLr_SGw-1
X-Mimecast-MFC-AGG-ID: tMmq4-50N0ODYabTLr_SGw_1757926259
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-337e4d53fdbso24019811fa.2
        for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 01:50:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757926258; x=1758531058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iHAiXvx7xZu60Hqr98Fl5/ljjKFjkxjgYFM+bVq7QJ8=;
        b=HESOj03ApS5DIA/kpexOQYFY8BTVe2G36upMrlAiDXL/PLaNnP8IyRvElmEAXckdas
         ALnaycLZbBtEGAXjeSRV39FoswNVlBHZX8F9wlfvrBA7Tl8qDv63DgEuyVP7ejHwxhCl
         sBPtI6knf0BPvLDq2vTM0zql6Pof2r0tSdWldR/C910lPbJdsFmTrX6X54VqBUzjDqzF
         SX22xVEIW5FMvbd+RKnhNH+Nl+5QTkXsOU0UHWq+/syRzACAlQOB5IAQOduurslUjF2l
         j3I91AXivKinakvwHKySrbsSco9W0Gx7bn+l1mbkg7MvC4N6pfgWcrcTsST1qEJAMx8x
         Dp7g==
X-Forwarded-Encrypted: i=1; AJvYcCUMuH1pCJFhi9SXp7AU8QccBq7VF67Cv+n+3+iNSoINOYk00YXfoo+aS4Tzg2rX0R9V8lwqakWM0BsM@vger.kernel.org
X-Gm-Message-State: AOJu0Yxcv9YbkWl6img+33uQpQ0mKnOtiB6pmG7koy9qVpxH0h19zlRj
	kiBnh9DuvVWjb3K0ru+s3svNPgKZN8J/7pt3lQv44EqE5G7Np9xxc8OTZEXDK9HKN3fHQ199UFu
	G0LbIfKVl0kddQ5lelYFsSTr3I6eUeM6PVz2gV8LtpKR29yevKZgzBRbKNdoPudXdfa6eTPyiBN
	l3FZPSXSlMS/RuK2WKRblt3pzyqMsTKquJCJqCfZ+yTk9kPg==
X-Gm-Gg: ASbGncuK9KVbWHLHdMbJa6ZcKMxURURABHuvcq4YFwrj15FpVSJKnGOWiLWX4ORgUL8
	SX5zsVVXN/anVotQy3SZqFXqvIUdaZlGkqLAN9IbsXs9MogJmgUhRbb84bvk8GWmXZITUK1ATot
	wOP2/YvkDZF/6u5qT/k+Yz/g==
X-Received: by 2002:a05:651c:4418:20b0:336:d1c3:37a7 with SMTP id 38308e7fff4ca-3513d579c3cmr30012641fa.26.1757926257828;
        Mon, 15 Sep 2025 01:50:57 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGl0ZUO2JTUZirUwacmY7tp8JOoWQWR66JhMiR7uFGREt2YvznZEpf+Aap5lqTItF9SsIhP1MK0sxbosCwSIes=
X-Received: by 2002:a05:651c:4418:20b0:336:d1c3:37a7 with SMTP id
 38308e7fff4ca-3513d579c3cmr30012451fa.26.1757926257122; Mon, 15 Sep 2025
 01:50:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250911073144.42160-1-linan666@huaweicloud.com>
 <20250911073144.42160-3-linan666@huaweicloud.com> <CALTww2_z7UGXJ+ppYXrkAY8bpVrV9O3z0VfoaTOZtmX1-DXiZA@mail.gmail.com>
 <9041896d-e4f8-c231-e8ea-5d82f8d3b0d2@huaweicloud.com>
In-Reply-To: <9041896d-e4f8-c231-e8ea-5d82f8d3b0d2@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 15 Sep 2025 16:50:45 +0800
X-Gm-Features: AS18NWBaOBbr4paKcZMzxqFFD0Hqf4jhv8wGm06I2UjwMAQ7TTVLejBmju46_1U
Message-ID: <CALTww28y7D32SAeoGgv2HjFJW471AtTD-SG0yxed4ZCJSOCHUw@mail.gmail.com>
Subject: Re: [PATCH v4 2/2] md: allow configuring logical_block_size
To: Li Nan <linan666@huaweicloud.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de, 
	martin.petersen@oracle.com, bvanassche@acm.org, filipe.c.maia@gmail.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 15, 2025 at 10:15=E2=80=AFAM Li Nan <linan666@huaweicloud.com> =
wrote:
>
>
>
> =E5=9C=A8 2025/9/15 8:33, Xiao Ni =E5=86=99=E9=81=93:
> > Hi Nan
> >
> > On Thu, Sep 11, 2025 at 3:41=E2=80=AFPM <linan666@huaweicloud.com> wrot=
e:
> >>
> >> From: Li Nan <linan122@huawei.com>
> >>
> >> Previously, raid array used the maximum logical_block_size (LBS) of
> >> all member disks. Adding a larger LBS during disk at runtime could
> >> unexpectedly increase RAID's LBS, risking corruption of existing
> >> partitions.
> >
> > Could you describe more about the problem? It's better to give some
> > test steps that can be used to reproduce this problem.
>
> Thanks for your review. I will add reproducer in the next version.

Thanks.
>
> >>
> >> Simply restricting larger-LBS disks is inflexible. In some scenarios,
> >> only disks with 512 LBS are available currently, but later, disks with
> >> 4k LBS may be added to the array.
> >>
> >> Making LBS configurable is the best way to solve this scenario.
> >> After this patch, the raid will:
> >>    - stores LBS in disk metadata.
> >>    - add a read-write sysfs 'mdX/logical_block_size'.
> >>
> >> Future mdadm should support setting LBS via metadata field during RAID
> >> creation and the new sysfs. Though the kernel allows runtime LBS chang=
es,
> >> users should avoid modifying it after creating partitions or filesyste=
ms
> >> to prevent compatibility issues.
> >
> > Because it only allows setting when creating an array. Can this be
> > done automatically in kernel space?
> >
> > Best Regards
> > Xiao
>
> The kernel defaults LBS to the max among all rdevs. When creating RAID
> with mdadm, if mdadm doesn't set LBS explicitly, how does the kernel
> learn the intended value?
>
> Gunaghao previously submitted a patch related to mdadm:
> https://lore.kernel.org/all/3a9fa346-1041-400d-b954-2119c1ea001c@huawei.c=
om/

Thanks for reminding me about this patch. First I still need to
understand the problem. It may be a difficult thing for a user to
choose the logcial block size. They don't know why they need to
consider this value, right? If we only need a default value, the
kernel space should be the right place?

Regards
Xiao
>
> --
> Thanks,
> Nan
>

