Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCC1C287503
	for <linux-raid@vger.kernel.org>; Mon, 16 Jun 2025 01:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750038224; cv=none; b=bawRGT9FXN3QRObknEv+FsA4MxFKnoKkanMorHWvqvGn5pfskdwFlmNw4LJVDlw3zfpvfa3LdSqLrKnLXpl9kdnJioTVrkk3cL4FUV2kUWGtvtY/G49KztBmH1L+PYr3j/LOeIg3gpFue5hsFS5kjNEBf9V9COyNeVRNJZn4yVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750038224; c=relaxed/simple;
	bh=A2ehdn0dlvpHODW+gbLhTKc5Q1cJ7UwEIdk0d2CIIV8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z/GufG0mIsZhoN3cj13xb85ayd//D/pT9RB/mweGwibdbkDlGpzveB6CWIAs47M15/HthRCRp8maeFa/2jw37lkYn8canOJDI53kiYEgyNBb9uBGFsTnc1p4tDFUmv3CHp2L4r58qb8BthMQVLj0WsdyDQ6y7stX9ZHBzgBi0ss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bJckl14D; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bJckl14D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750038221;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sJtuIN2qeI4QaNh0Ye2L3YdlIRGQiJNwqYX5jnbpwCI=;
	b=bJckl14D+ElpOlJ/GhHHw9F3cTgDvRrCnYiPewc5oaR3ylAy3ClUuTvQ3Rwx1s+0nq3YgW
	gOnJEhv/r9m4ImiiegtwUdT+ew2hdjG1Rfsu462ox/WR+TsYbCTNToAZlL6ijBi63Eaj/a
	MltPQ/A4HZ5iGBQzNllcy7HzTrpX5v0=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-1--aX3h3S5N_uyA18_oRmaCQ-1; Sun, 15 Jun 2025 21:43:39 -0400
X-MC-Unique: -aX3h3S5N_uyA18_oRmaCQ-1
X-Mimecast-MFC-AGG-ID: -aX3h3S5N_uyA18_oRmaCQ_1750038218
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-551ec3101c7so1999072e87.2
        for <linux-raid@vger.kernel.org>; Sun, 15 Jun 2025 18:43:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750038218; x=1750643018;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sJtuIN2qeI4QaNh0Ye2L3YdlIRGQiJNwqYX5jnbpwCI=;
        b=fEUOkU9YoWNvaLHgLc6kbV3gcZHfQXsiZD0+UWaOj2xaDYfyWeFRuqOO2/vB5hoGDZ
         V4oqjZATrE33VdtWfzZY0nZCfFRElPwl9jEORENrC+2GhY6MwjCvBqTr0Omrj+NaVflR
         Bvvef/D3ZqoWhEF9c9k1hAcIz21Q2EfSSzTHFoFXXqWx0VkkAjKCwk7Yr2h3+ao7mcDK
         15KaCySUG+1vdOztbAI5aMTwikWciTkRIEg2MUu/x08ClWxfr/p30l0pT14dOzYxk2jZ
         5ty/36LjJuCfjns6d6JjsM+vtuqlavQKQlm96hgfuG6M8TKiROkNZetBk4Q+r14z63GQ
         K4vw==
X-Gm-Message-State: AOJu0YzNr0iqmxk94/9HBYQpbgbZ0EP8Fe22JjIDIt6RbC1crDOn0Bco
	4fyqWtv2yHB3ABJjL9YATAOI7lep5WwagZKnm/y4K5pShSQPa0O73lF1p2OOHJsUW5BZ8RSyX+4
	H1y76PhAN65Mj/f31Gf3oVffocDMrMyyT8KAHbfOTyq/S+DWMcLkERZjfkeXFjqmhEbkncavf+5
	QuZ+Ek0oDBwUZcMDby84y4B4o5TUCSxTR6QglKVg==
X-Gm-Gg: ASbGncsf1Ip45AGBW7kGra/IPTXDiiRcqylxdib4x5LrTl65wHysW01+Bm1mZEIUXvO
	j8Mg+hIlA7+V/mFxwpFDSZ+3pRi8P/P4LcFguB8Odf3UfwYZUeUXHmUyKQ04ZlHF2Qtv/NfCK1N
	k/A0RD
X-Received: by 2002:a05:6512:b1a:b0:553:32f3:7ec6 with SMTP id 2adb3069b0e04-553b6f2ad2cmr1737116e87.42.1750038218238;
        Sun, 15 Jun 2025 18:43:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGngsKMFBSkXzw8+w+JCIANOO/9mtTOvOTcblqSpvOgVNDoQzvQ4ioqTYxj5yL9Nd2jsbc9mC1rY4v2tNe4Azk=
X-Received: by 2002:a05:6512:b1a:b0:553:32f3:7ec6 with SMTP id
 2adb3069b0e04-553b6f2ad2cmr1737114e87.42.1750038217832; Sun, 15 Jun 2025
 18:43:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611073108.25463-1-xni@redhat.com> <b94ee45c-06ea-1d4d-8a88-7a88db1f0b6f@huaweicloud.com>
 <CALTww29pNN2QxyFZp1P+qm2=xeuBNGBH9JmJNY64vMkBjPumCw@mail.gmail.com> <8ff80111-33dd-40c6-cf84-cd99090e2f0f@huaweicloud.com>
In-Reply-To: <8ff80111-33dd-40c6-cf84-cd99090e2f0f@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 16 Jun 2025 09:43:26 +0800
X-Gm-Features: AX0GCFt8vmgDq6nuIzkE9OdGbvfePo_GutDrMraSN7Oi3LAA9_3ohA7gWfhQbdw
Message-ID: <CALTww2-mfKeXe_2j6PpTeuhUUqMJNWCpmBEsgYreSOoG_6nQuA@mail.gmail.com>
Subject: Re: [PATCH V6 0/3] md: call del_gendisk in sync way
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, song@kernel.org, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 9:18=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/06/15 11:21, Xiao Ni =E5=86=99=E9=81=93:
> > On Sat, Jun 14, 2025 at 4:18=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2025/06/11 15:31, Xiao Ni =E5=86=99=E9=81=93:
> >>> Now del_gendisk is called in a queue work which has a small window
> >>> that mdadm --stop command exits but the device node still exists.
> >>> It causes trouble in regression tests. This patch set tries to resolv=
e
> >>> this problem.
> >>>
> >>> v1: replace MD_DELETED with MD_CLOSING
> >>> v2: keep MD_CLOSING
> >>> v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop =
path
> >>> and adjust the order of patches
> >>> v4: only remove the codes in stop path.
> >>> v5: remove sysfs_remove in md_kobj_release and change EBUSY with ENOD=
EV
> >>> v6: don't initialize ret and add reviewed-by tag
> >>>
> >>> Xiao Ni (3):
> >>>     md: call del_gendisk in control path
> >>>     md: Don't clear MD_CLOSING until mddev is freed
> >>>     md: remove/add redundancy group only in level change
> >>>
> >>>    drivers/md/md.c | 49 ++++++++++++++++++++++++++-------------------=
----
> >>>    drivers/md/md.h | 26 ++++++++++++++++++++++++--
> >>>    2 files changed, 50 insertions(+), 25 deletions(-)
> >>>
> >>
> >> Just running mdadm tests with loop dev in my VM, and found this set ca=
n
> >> cause many tests to fail, the first is 02r5grow:
> >>
> >> ++ /usr/sbin/mdadm -A /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
> >> ++ rv=3D1
> >> ++ case $* in
> >> ++ cat /var/tmp/stderr
> >> mdadm: Unable to initialize sysfs
> >> ++ return 1
> >> ++ check state UUU
> >> ++ case $1 in
> >> ++ grep -sq 'blocks.*\[UUU\]$' /proc/mdstat
> >> ++ die 'state UUU not found!'
> >> ++ echo -e '\n\tERROR: state UUU not found! \n'
> >>
> >>       ERROR: state UUU not found!
> >>
> >> ++ save_log fail
> >>
> >> I do not look into details yet.
> >> Thanks
> >>
> >
> > Hi Kuai
> >
> > You need to use the latest upstream mdadm code
> > https://github.com/md-raid-utilities/mdadm/
> >
>
> I use the repo from:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
>
> With the latest commit:
> 8da27191 ("mdadm: enable sync file for udev rules")
>
> Do we not update mdadm here?
>
> I'll run the test soon, and BTW, wahy in the above commit, test can
> pass before this set?

Hi Kuai

It doesn't have the patches which were submitted to github recently. I
don't have the permission to sync from github to
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git

https://github.com/md-raid-utilities/mdadm/commit/ea4cdaea1a553685444a3fb39=
aae6b2cfee387ef
fixes the problem which can be introduced by this patch set.

Regards
Xiao
>
> Thanks,
> Kuai
>

