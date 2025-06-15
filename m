Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBD2228EB
	for <linux-raid@vger.kernel.org>; Sun, 15 Jun 2025 03:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749957708; cv=none; b=LKTv9+dKgJqeTcn7nAjfUZ12J8/JaQwjthTdDgRiqTKhb8ZOSuZo6JALIAO7w9Au6Jb94OtzonkIHsKphQnHNg2nPTJVTs46qc+7LeBXYf5eLqVxe5KvdXSBYKFDYWz5j9JgoX+ZVcoLp3C1+2KwZw3cwLj2w1HXjGlYeSwloEQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749957708; c=relaxed/simple;
	bh=eVHSR/hPH8iY/te7yd6jeVdckpHp2F8aL8T03nT/140=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nK8/YS1b8W9Hd9fvldxdbFKxVOtQ+Vv4n93mtBSryvZ1NN62jpmIim4b9hDvLZcj01CuZZKSbpW4CsBRroHNtWhC5rPyoy4CFAJclJ0CYL5q2Dt7Cm2QBzR8C/LVe/bbB6KZdjsNLZ37fHSkw5kae9rt8GHPg+qRMuN3vBXa/jM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=H2HYj+nd; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="H2HYj+nd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1749957705;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=g3naeaqxC8P8s97goDHBVcjNXDEiFYR7chLwjXevluw=;
	b=H2HYj+nd4+qfB+AIu9iqqmCqHCdYZfbcBmE8ch0JSNQd0NARW6CmoSO1w+HMmeE921Q8Bk
	qS+Fc9O7zW0/4HAuQInfwdnnKUWoKo+YQiY32/rgAtaamuHtZ3UEVYqJQJIlbNBC7ZTHw+
	aucgOm/MyFZ1WaILtiMtsnZ+Hji9qJo=
Received: from mail-lj1-f197.google.com (mail-lj1-f197.google.com
 [209.85.208.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-615-PSkHsLsdMtGSz2Ut6gNwvg-1; Sat, 14 Jun 2025 23:21:44 -0400
X-MC-Unique: PSkHsLsdMtGSz2Ut6gNwvg-1
X-Mimecast-MFC-AGG-ID: PSkHsLsdMtGSz2Ut6gNwvg_1749957703
Received: by mail-lj1-f197.google.com with SMTP id 38308e7fff4ca-326ad1825c1so14916811fa.1
        for <linux-raid@vger.kernel.org>; Sat, 14 Jun 2025 20:21:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749957702; x=1750562502;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g3naeaqxC8P8s97goDHBVcjNXDEiFYR7chLwjXevluw=;
        b=YjM4XKvLmLwy9nlcwBOKnqls0WkmlcO5Enq9ZCzglV0/avYN5xT+nznyW8Zu6rCF7w
         AuvWOhzLiN1pMsfaCP1j3A+CrN4isIJpPvh7DS2k08I7eDJ+MPV48ha2SaPADzZvrJVz
         I7h3xQDZfFBUNbxiNic7l+Nd3Oiw4FKZJJTHhuVRopk+zh+IriWB2ykVKu+waLZI1S8B
         fB7IUpSeucji4GjWpo8PBAa6WQ29jIIBzy5r7ibfw4UBBeAGa9Nr3ZfN9EQJ8STdThh1
         c7+awA4nDLUJj8cn23hxJbAV7Gz9wMEvbwLIPM6AJB5Ytig319b++IQ83oIVZOsBhK7s
         H2FA==
X-Gm-Message-State: AOJu0Yz/AiwJAd+tg6EkcEb24I7SKV2fhJKm6b2ft7S5wUoghgIJTom1
	4e2i6OfkaVbw/m1uc4ET5RS2Uzsvnt38w3tx6w5PMDuF6mPR0qESAI0UAMW//mb7Ph1fcMdYf/g
	SS3Dkr8NzRV7IWkKC+Btj+cuxXsAvIA1gkB18gjnLc9AoaFItiQMdr4Fyi6sjhbB3zdJXe2ot5w
	UOl4oNC1H9UC5yZk82JZpE02RaNaPIcy0wXNTlYA==
X-Gm-Gg: ASbGncvzN1ngLMt+TO4vb1RkOBBXr1aySt5ic5mJzg5c+N9jf6rCmNVdCyMGZGOfb+v
	jfjCOJ/tUoaLNbN4O+dypUMaBi4hd8NTlvDmtd+RK2qQELEgWb2yaQ6tYqrVKmdutm1RhGa7rK9
	v0J9C/
X-Received: by 2002:a05:651c:19a8:b0:32a:8591:66a0 with SMTP id 38308e7fff4ca-32b4a308942mr11628621fa.1.1749957702396;
        Sat, 14 Jun 2025 20:21:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFIwnOhnirOTtTBv5LtyZgfnL9GdpdS+LjAllUQbIjdm2voCJ9qA4Iq6F3kG8DiV8g+4pqclDZmCD8OK7pX0n0=
X-Received: by 2002:a05:651c:19a8:b0:32a:8591:66a0 with SMTP id
 38308e7fff4ca-32b4a308942mr11628571fa.1.1749957701766; Sat, 14 Jun 2025
 20:21:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250611073108.25463-1-xni@redhat.com> <b94ee45c-06ea-1d4d-8a88-7a88db1f0b6f@huaweicloud.com>
In-Reply-To: <b94ee45c-06ea-1d4d-8a88-7a88db1f0b6f@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sun, 15 Jun 2025 11:21:29 +0800
X-Gm-Features: AX0GCFvn9VDr9kuJtTvxb7NXukGi4hjqlv9KniEksK7ytUSP4MZAY6egrpqMaRE
Message-ID: <CALTww29pNN2QxyFZp1P+qm2=xeuBNGBH9JmJNY64vMkBjPumCw@mail.gmail.com>
Subject: Re: [PATCH V6 0/3] md: call del_gendisk in sync way
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, song@kernel.org, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 14, 2025 at 4:18=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/06/11 15:31, Xiao Ni =E5=86=99=E9=81=93:
> > Now del_gendisk is called in a queue work which has a small window
> > that mdadm --stop command exits but the device node still exists.
> > It causes trouble in regression tests. This patch set tries to resolve
> > this problem.
> >
> > v1: replace MD_DELETED with MD_CLOSING
> > v2: keep MD_CLOSING
> > v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop pa=
th
> > and adjust the order of patches
> > v4: only remove the codes in stop path.
> > v5: remove sysfs_remove in md_kobj_release and change EBUSY with ENODEV
> > v6: don't initialize ret and add reviewed-by tag
> >
> > Xiao Ni (3):
> >    md: call del_gendisk in control path
> >    md: Don't clear MD_CLOSING until mddev is freed
> >    md: remove/add redundancy group only in level change
> >
> >   drivers/md/md.c | 49 ++++++++++++++++++++++++++----------------------=
-
> >   drivers/md/md.h | 26 ++++++++++++++++++++++++--
> >   2 files changed, 50 insertions(+), 25 deletions(-)
> >
>
> Just running mdadm tests with loop dev in my VM, and found this set can
> cause many tests to fail, the first is 02r5grow:
>
> ++ /usr/sbin/mdadm -A /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
> ++ rv=3D1
> ++ case $* in
> ++ cat /var/tmp/stderr
> mdadm: Unable to initialize sysfs
> ++ return 1
> ++ check state UUU
> ++ case $1 in
> ++ grep -sq 'blocks.*\[UUU\]$' /proc/mdstat
> ++ die 'state UUU not found!'
> ++ echo -e '\n\tERROR: state UUU not found! \n'
>
>      ERROR: state UUU not found!
>
> ++ save_log fail
>
> I do not look into details yet.
> Thanks
>

Hi Kuai

You need to use the latest upstream mdadm code
https://github.com/md-raid-utilities/mdadm/

Regards
Xiao

