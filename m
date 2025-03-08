Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD3E428F3
	for <linux-raid@vger.kernel.org>; Sat,  8 Mar 2025 05:28:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741411691; cv=none; b=Ydx/fg8a6Et5ZHgx0VWfIl/p+IcAqz+Fg2WTEsK8wKAN6l1GXubIOiCS5bUTK0Tqg3ivnZfusn7lSsuGaniwxJXbiIfVvDLiIuWeyAB5mRyz9prqxJKNCL0PFBKTL/H4aOkyt6qNtOJqEgIql1g9+7ALVDeFtmVqF7U2b1w5zU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741411691; c=relaxed/simple;
	bh=sZcGoDfzeekDXT5BvrVgGqW+WS6RonJzCn/nyXCINUQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=j+iYuLjw7pV/PKt9t1ZBJqPUL7m567gKZtZUuk81hoURiLNUNQI97x0fCtv+pPKzFdL023gVH3CIEyYcRdiON2VdRhiUjElaH0wMk8m3JrO6vKWf9E4sP6DBeDkGdTSZTynrl5+3ma7sOr8L98fRMMqXW4k6mXkXdB3MD2P85xY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Lv8WSgsg; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Lv8WSgsg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741411688;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WbvTz/I1+VGv6PuGgdkAo1q0CjbNRXCZPriCRczOkWc=;
	b=Lv8WSgsgisL5eop6QGl4JsBeZqMW+96xcZ7QCsU1HJKIHK6QjPK4Vy8PgGCfQwKiSTp+Aa
	e4hTcJ3v9kGhoJ7ihoU3+BE1Fhkm61BdpIIUxccm8xG3RT/s9aSbu7CHU4YXZkUEQIjEQk
	F4Xh/aSUdBLEZkSONEeBgk4Fq7JDDTc=
Received: from mail-lj1-f198.google.com (mail-lj1-f198.google.com
 [209.85.208.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-8S4pXPapOMi7Psp_KdFPqQ-1; Sat, 08 Mar 2025 00:28:07 -0500
X-MC-Unique: 8S4pXPapOMi7Psp_KdFPqQ-1
X-Mimecast-MFC-AGG-ID: 8S4pXPapOMi7Psp_KdFPqQ_1741411686
Received: by mail-lj1-f198.google.com with SMTP id 38308e7fff4ca-30bad8f7228so13068201fa.0
        for <linux-raid@vger.kernel.org>; Fri, 07 Mar 2025 21:28:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741411685; x=1742016485;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WbvTz/I1+VGv6PuGgdkAo1q0CjbNRXCZPriCRczOkWc=;
        b=tSbh8Nnc9gC6RhtT9GClzRXDghhROj3SRN5Y3GPCZZrsCvRmulJb2fM8UNhiFreFB8
         798qp+xRaTLK4pPQPBV8roGczojUSmub+gQmK25TxAPy2vHmKMwrfKwrXNz7keosPVaL
         b4y2/75Twx/Y81JC1zDGqOcug3fMBpIFvmUU0yoAEXETA7qbq8jJamm1ERKOlu3Z0j0r
         RGDJgWKtrRbybQM3shwN6x+JgT0ZX//0bSkZjvr4SPQ3AHYwbMbUeOcuYZBEWL+zp+V6
         RYoLPtOZtyiFKRIOf097lqmq60oA6kPGGlRRcVVo094NnoNh3+tKcXgIYDljNn+Jf7KE
         oZjg==
X-Forwarded-Encrypted: i=1; AJvYcCUFA+U4inyAzKdD7LsXqHzfaY8bzymaxwMsNuh7l0twIoMIITB5/hmgbHuRyu1WkxU9phZhBvejf98W@vger.kernel.org
X-Gm-Message-State: AOJu0YxTzW78iMd1mp60+hSGVLUCGBNsrHlB1wrgkmWn9IRgz4Z7r8bS
	+Ubvx3iUBwEEBps7BfrOBaUbN/mk7+XJYQNxfIeHIKBs4In/BE51kwiue7FigzlcwjkTIROHZWK
	gH98X34XLRfVMo35d32WbZT77UXPqVeKPyWl8oEeNlnuijteZBVHVTSp/FN+NToL39wFzq9WQxE
	6G/DEOh0b9VTuhb/Ga46eoikyDtkRRtpjW+Q==
X-Gm-Gg: ASbGncvQOQjsl6A6+xmU8NfOshaqUZciiey3GM21sIEI0FLwRMiKMb4QNDC5GGA7ND0
	g9SNt9x7BK1/cFvoGmJBG8C7muKdtWmzjYZe6eZefIopUBOLtWUO89iXgWNYwk89BPKa/74xQag
	==
X-Received: by 2002:a05:6512:39c7:b0:545:a5e:b4ef with SMTP id 2adb3069b0e04-54990e5d3c1mr2793079e87.16.1741411685438;
        Fri, 07 Mar 2025 21:28:05 -0800 (PST)
X-Google-Smtp-Source: AGHT+IHOpz98hAEKETf5xfOHDKmZPj2r9RSVw2A3whP8IU0oZDNUfwge3dgZu4UWpuzHBv8sIyA8rpl+ls9wU1IJb8Y=
X-Received: by 2002:a05:6512:39c7:b0:545:a5e:b4ef with SMTP id
 2adb3069b0e04-54990e5d3c1mr2793063e87.16.1741411684963; Fri, 07 Mar 2025
 21:28:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com>
 <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com> <CALTww2_yMs_QYSWaQgRFNRgkaZi15KDmdH_00QeTOJWmp1YHcQ@mail.gmail.com>
In-Reply-To: <CALTww2_yMs_QYSWaQgRFNRgkaZi15KDmdH_00QeTOJWmp1YHcQ@mail.gmail.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 8 Mar 2025 13:27:53 +0800
X-Gm-Features: AQ5f1JoPRFyBNJ1_6RcKhlT9vrNIUNPCzojHAQc4wGQZX1tMPBm820OCfHetdFw
Message-ID: <CALTww2-AnS+t3-W=6cAwTn-oQooOo2Svv-=ozSg7PthsEO9-UQ@mail.gmail.com>
Subject: Re: [PATCH] mdadm: Don't set bad_blocks flag when initializing metadata
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Wu Guanghao <wuguanghao3@huawei.com>, 
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, ncroxon@redhat.com, 
	linux-raid@vger.kernel.org, liubo254@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Mar 8, 2025 at 11:06=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
>
> Hi Guanghao
>
> Thanks for your patch.
>
> On Tue, Mar 4, 2025 at 8:27=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> =
wrote:
> >
> > Hi,
> >
> > =E5=9C=A8 2025/03/04 14:12, Wu Guanghao =E5=86=99=E9=81=93:
> > > When testing the raid1, I found that adding disk to raid1 fails.
> > > Here's how to reproduce it:
> > >
> > >       1. modprobe brd rd_nr=3D3 rd_size=3D524288
> > >       2. mdadm -Cv /dev/md0 -l1 -n2 -e1.0 /dev/ram0 /dev/ram1
> > >
> > >       3. mdadm /dev/md0 -f /dev/ram0
> > >       4. mdadm /dev/md0 -r /dev/ram0
> > >
> > >       5. echo "10000 100" > /sys/block/md0/md/dev-ram1/bad_blocks
> > >       6. echo "write_error" > /sys/block/md0/md/dev-ram1/state
> > >
> > >       7. mkfs.xfs /dev/md0
>
> Do we need this step7 here?

I confirmed myself. The answer is yes.
>
> > >       8. mdadm --examine-badblocks /dev/ram1  # Bad block records can=
 be seen
> > >          Bad-blocks on /dev/ram1:
> > >                      10000 for 100 sectors
> > >
> > >       9. mdadm /dev/md0 -a /dev/ram2
> > >          mdadm: add new device failed for /dev/ram2 as 2: Invalid arg=
ument
> >
> > Can you add a new regression test as well?
> >
> > >
> > > When adding a disk to a RAID1 array, the metadata is read from the ex=
isting
> > > member disks for synchronization. However, only the bad_blocks flag a=
re copied,
> > > the bad_blocks records are not copied, so the bad_blocks records are =
all zeros.
> > > The kernel function super_1_load() detects bad_blocks flag and reads =
the
> > > bad_blocks record, then sets the bad block using badblocks_set().
> > >
> > > After the kernel commit 1726c7746("badblocks: improve badblocks_set()=
 for
> > > multiple ranges handling"), if the length of a bad_blocks record is 0=
, it will
> > > return a failure. Therefore the device addition will fail.
>
> Can you give the specific function replace with "it will return a failure=
" here?

I know, you mean badblocks_set which is called in super_1_load. It's
better to describe clearly in a commit message.
>
> > >
> > > So, don't set the bad_blocks flag when initializing the metadata, ker=
nel can
> > > handle it.
> > >
> > > Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> > > ---
> > >   super1.c | 3 +++
> > >   1 file changed, 3 insertions(+)
> > >
> > > diff --git a/super1.c b/super1.c
> > > index fe3c4c64..03578e5b 100644
> > > --- a/super1.c
> > > +++ b/super1.c
> > > @@ -2139,6 +2139,9 @@ static int write_init_super1(struct supertype *=
st)
> > >               if (raid0_need_layout)
> > >                       sb->feature_map |=3D __cpu_to_le32(MD_FEATURE_R=
AID0_LAYOUT);
> > >
> > > +             if (sb->feature_map & MD_FEATURE_BAD_BLOCKS)
> > > +                     sb->feature_map &=3D ~__cpu_to_le32(MD_FEATURE_=
BAD_BLOCKS);
> >
> > There are also other flags that is per rdev, like MD_FEATURE_REPLACEMEN=
T
> > and MD_FEATURE_JOURNAL, they should be excluded as well.
>
> Hmm, why do we need to remove these flags too? It's better to use a
> separate patch rather than using this patch and describe it in detail.
> It's better to give an example also.

Please answer this question.

Regards
Xiao
>
> Best Regards
> Xiao
> >
> > Thanks,
> > Kuai
> >
> > > +
> > >               sb->sb_csum =3D calc_sb_1_csum(sb);
> > >               rv =3D store_super1(st, di->fd);
> > >
> >
> >

