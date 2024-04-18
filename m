Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 867C415AAAD
	for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 09:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713434309; cv=none; b=IGEV3gdx+5MPjZfd/h30wfqix6mobb9ma82W6yzUJn3v8NUfmCDD/L3ppjIPI7QuYq8WBEmOGq09pwKvp3i9QfD56kJ+Zr7IznwbXSHXkhuTw/w9YRzqhlqz3upmNugp5tWoiz3JqZQsW5YpikuOzG79OLACXahNfKszwQTEIEA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713434309; c=relaxed/simple;
	bh=IYL6T+V3bODA/4KtalNC0fiFQICw8IbbpWhSWYj7wXA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WKTtONvq/HPo+toJn7ATLhK8KXvhEnKQoZeuJMVlBwlBulT3DXEZzL1Xe3ibqSfQdsBzEYYsoRaJZZR7u1dIcuGLkzm32JWMG85OtNbHx0jRcn5Jm08ORS6IdjT9wh4EYPZTzVQ2IQ8u1rs7ODPgH9KtncakpIRqX5KeU9/j/jE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=TJdK6Jk5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="TJdK6Jk5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1713434306;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=zKPGI9ew2fkbkDGXx4HvqG1PWWY8ELG5N7Cy+nQnEhg=;
	b=TJdK6Jk5h2+6tETntqQfqFELn9F4Z8eytRG14JYSITHebLRmSnBT9x5xzvHh+OUdYwtOBh
	GYBWB6hFVBv5+rjn/vFGZ1vzNR3O6ZjmIpK9KdcgWelrFMEc5LwBN1DHp5D0PN4OHhOa+d
	B/plrdQwK1mbdjUdNS340R1RMwl9ccY=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-523-kIiRfmI4PKeBlpaEVYAONw-1; Thu, 18 Apr 2024 05:58:24 -0400
X-MC-Unique: kIiRfmI4PKeBlpaEVYAONw-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5c66a69ec8eso654292a12.3
        for <linux-raid@vger.kernel.org>; Thu, 18 Apr 2024 02:58:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713434303; x=1714039103;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zKPGI9ew2fkbkDGXx4HvqG1PWWY8ELG5N7Cy+nQnEhg=;
        b=qHQPB8CwzWTu5YYOBmtaDkdyiHLiobWMBYiu4rn8o9aNcOPwJj+giKJ47NSFCfnfHO
         sr24ehpRrWZkMzUhik1b/i6D6mflSWa/6S+K78OluZMjTOkw4akspPYo42RGGwluZXp4
         tAucWJ41qV3iiMPy3rebpyNJHzhcJBM1+NyHkoz9xAsRk71cpoKeAUJdOKs2Gmw2blsK
         uKS2SKyeoPbSSp8cIYIkGVxT/qqphJ2OgiZg8QYUuUX2UkLoAH9FiDJGOrddnpFX8YDM
         djmsO83IXy6+kNjcYcwxtGAjqiAvGFJFNA+LMzMgHcxuHPSyLcPpmOLCRWWknfUcH7kR
         qR1w==
X-Forwarded-Encrypted: i=1; AJvYcCWpsTZ5brTo/kRv6CtllE3pHPFlskt4I+RWRaYcKYpENLsl9+JhtcGMVTOwcquJ6PvYBfdFi/ZWkJayCBqCSV0afzNMWH/TP5lU4Q==
X-Gm-Message-State: AOJu0YzpgzkKROr4CZDu/Shus4J3VkwHx5Aqu/giluMq87XeiManABDb
	+5qRDyoxiYny0jdEVt8M598V7np3WrZVmWbiZhMAZyH40PCCz7duzKgN9vc8bbtRMP/H5u3Tq/D
	LxRfa9h6sjlRrBFbcwYm2TK1dZHQgKq5YwPSyH5IiqvGsP//NNmoWgJe/fnc7+Ss2UYlurNNWL2
	7cywA4bHdxyX8/vsJG4vteR2WrqwmJEu/P+g==
X-Received: by 2002:a05:6a21:1644:b0:1a9:86dd:177b with SMTP id no4-20020a056a21164400b001a986dd177bmr3290234pzb.44.1713434303413;
        Thu, 18 Apr 2024 02:58:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGa4dwQFhrk1w0SYLZzniPfi43GT7mCS2Xf+l6IkxifisTK5fxxbC7c3s1aLJXxzomHmCC4Yk8eG0UTt2+BxDo=
X-Received: by 2002:a05:6a21:1644:b0:1a9:86dd:177b with SMTP id
 no4-20020a056a21164400b001a986dd177bmr3290218pzb.44.1713434303098; Thu, 18
 Apr 2024 02:58:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <3c0ab8eb94ad4b6fb4cb2159f0638650@kioxia.com>
In-Reply-To: <3c0ab8eb94ad4b6fb4cb2159f0638650@kioxia.com>
From: Xiao Ni <xni@redhat.com>
Date: Thu, 18 Apr 2024 17:58:11 +0800
Message-ID: <CALTww2_zw8=_wizsA=msnYsx-cKAHzHBB4maYp7T+GZmkAQvqg@mail.gmail.com>
Subject: Re: [PATCH v2 00/11] md: avoid counter operation conflicts
To: tada keisuke <keisuke1.tada@kioxia.com>
Cc: "song@kernel.org" <song@kernel.org>, "yukuai3@huawei.com" <yukuai3@huawei.com>, 
	"linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 18, 2024 at 2:21=E2=80=AFPM tada keisuke <keisuke1.tada@kioxia.=
com> wrote:
>
> Changes in v2:
>  - Add message of performance in cover.
>  - Fix a problem of error code initialization in patch 6.
>  - Fix a problem of sleeping during rcu_read_lock() in patch 9.
>  - Change base-commit from md-6.9 to md-6.10
>
> Currently, active_aligned_reads and nr_pending used as counters are atomi=
c types.
> Therefore, when inc/dec in a multi-core results in conflicts and READ I/O=
 becomes slow.
> To improve performance, use "percpu_ref" counters that can avoid conflict=
s and maintain consistency.
>
> Switch modes of percpu_ref to achieve both consistency and conflict avoid=
ance.
> During normal operations such as inc/dec, it operates as percpu mode.
> When consistency is required, it operates as atomic mode.
> The operations that require consistency are as follows:
>  - Zero check for the counter
>  - All operations in RAID 1/10
>
> Patches 1, 3, 6 change active_aligned_reads, and patches 2, 4, 5, 7 to 11=
 change nr_pending.
> nr_pending temporarily switch from percpu mode to atomic mode in patch 7.
> This is to reduce the amount of changes from patches 8 to 10.
> Finally, nr_pending switch from atomic mode to percpu mode in patch 11.
>
> We applied the patch to base-commit and used fio to compare IOPS.
> CPU: AMD EPYC 7313P (3.0GHz, 16cores)
> DISK: ramdisk x 3 (modprobe brd rd_nr=3D3)
> RAID: level 5
> fio config: bs=3D4k, rw=3Drandread, iodepth=3D128, numjobs=3D16
>
> without patch: 3.64 MIOPS
> with patch   : 3.84 MIOPS

Hi Tada

Thanks for the patch set. Have you done tests with nvme/ssd or hdd?
It's better to see the results with real disks.

Best Regards
Xiao
>
> Keisuke TADA (11):
>   add infra for active_aligned_reads changes
>   add infra for nr_pending changes
>   workaround for inconsistency of config state in takeover
>   minimize execution of zero check for nr_pending
>   match the type of variables to percpu_ref
>   avoid conflicts in active_aligned_reads operations
>   change the type of nr_pending from atomic_t to percpu_ref
>   add atomic mode switching in RAID 1/10
>   add atomic mode switching when removing disk
>   add atomic mode switching when I/O completion
>   avoid conflicts in nr_pending operations
>
>  drivers/md/md-bitmap.c   |  2 +-
>  drivers/md/md.c          | 48 ++++++++++++++++++---
>  drivers/md/md.h          | 62 +++++++++++++++++++++++----
>  drivers/md/raid1.c       | 37 +++++++++++------
>  drivers/md/raid10.c      | 60 ++++++++++++++++-----------
>  drivers/md/raid5-cache.c |  4 +-
>  drivers/md/raid5.c       | 90 +++++++++++++++++++++++++++-------------
>  drivers/md/raid5.h       | 17 +++++++-
>  8 files changed, 238 insertions(+), 82 deletions(-)
>
>
> base-commit: 9d1110f99c253ccef82e480bfe9f38a12eb797a7
> --
> 2.34.1
>
>
>

