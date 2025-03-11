Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92B784207F
	for <linux-raid@vger.kernel.org>; Tue, 11 Mar 2025 01:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741655447; cv=none; b=r+nEmTLoOGzDjSFSPlKokfe4BAZ5izbq5XJcMd+B7X6kFPnIsZ9HPZNE2T1Rgl3x0cl1gpil0197jJSuuPpYqB/qySCLPKBvVvnLy/59P551/f3G89EF6uvyT48E4XI53tlq2bqYDaDpz4PwbvDhKmf6v+BNfwEfhj3Ys02HKpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741655447; c=relaxed/simple;
	bh=h4/4Rx0bjlBWlFvT+Hj3iRO1vgZKzz+k1id8e1ENqHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IWOQ+7THSp4EzaS/NxQkFoJEZyImJR07hyiFmlHGKDyougIu8Nz8vHSITOapL2f0R7qL6h77SnRi/MbA92qZw/30BcBczHUdRNQUJdHLOrZWMXr9aZ08KT9OZkHn5DxMP8MnZMgMzv2P+e/q4L2Xc+Rh8iSrr/tXvoI3k+7Ztcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HLHOBQRg; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HLHOBQRg"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741655443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Bn/4buFv9/bGXKz0dMa+HKPPcucMzoNnIFLgoSBqt8M=;
	b=HLHOBQRgBb07OB0kHQcXTXdKT/+dgRu29bAW1oDknHugoGvqz6vPOUy9UTgZS9Ymz2SOH+
	5s0P4h6AUrQ7OjGBT5Tq8C3Z9YSWG8pgF1WVsC3f2VexDfNipEvcdvFERpMqnbXYOkirlj
	nxzythKWnYidqVgJm4RsPbEen+9Ysa4=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-690-lBPeiMYhOYSCrzF86DCTXQ-1; Mon, 10 Mar 2025 21:10:40 -0400
X-MC-Unique: lBPeiMYhOYSCrzF86DCTXQ-1
X-Mimecast-MFC-AGG-ID: lBPeiMYhOYSCrzF86DCTXQ_1741655439
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-30bb33dc319so20875711fa.2
        for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 18:10:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741655439; x=1742260239;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Bn/4buFv9/bGXKz0dMa+HKPPcucMzoNnIFLgoSBqt8M=;
        b=jSLGQe4dLcqHaBQITDTXcZYxJaEdasGmwULhrtKzvIew27osal7qOjG/wPl6RnCYza
         rD1vo836+aWyiUQiI8LoNJ+QBnVNEFqBL93dR1xuIxnZndzBcTuJ9pe/TtMNy1jWygOe
         dn5LgzKOfw3c09fMq1rWPOwZUYPXp0qYY/2Dm/o0e4kulwHZusjXyFfM+wObPxdx6T5R
         /9BBgtEaHeOOxg1/x6ZI445zXKoCe5D4UPKWyIVqTS6LxHmJSW3k5WReN4c0uSvzgfvx
         +YmIZaQZRWxo7BW4M+l9ivimp8IRzkJ0um2xgBzoHI4IZzJo8C4vu1ja+eoDMoFEIhz0
         IRuw==
X-Forwarded-Encrypted: i=1; AJvYcCUMDnxGXXmmOHhl6+1K1I6v5A/Hh3fQoQO92ojfrHO9jLBi5ncEO6myLjB0vAJxoxxmmgd839X5lmdL@vger.kernel.org
X-Gm-Message-State: AOJu0YxZTqeGlcrNbxLQXjMAF/ERpBlKD0k+YcmPvof4xB+bEpQq6zBW
	6BeaHa0krl1ysHHulgRoB0hU0ecJbkx/ptGzoRTjCeAFKymvgNbiblcJkMxw0OPWlHung5jw+91
	vxa5ZfNMaccvs6MbOS2p3ZZHl498UrmUlo2ZZAyRtlQvEOF4fJxflI7ZI+sc78NS5yyZvQzXl2n
	Ts2uDc54s2kJRCZogCOQ8LOI39Ef1uYgBz/Q==
X-Gm-Gg: ASbGnctOmwtcyWiOsGcjY/xLUNChBIsdsHThEdnkt5iVPhuJKpHe27PvaULgQmpBwYD
	a51XEt3BHoJxJ/grseL+fWYAG0c3iTwiuH+GBFvCmaUy/jyM075Gc2cUUg6kwpPoaNBIlqYSnrw
	==
X-Received: by 2002:a05:6512:3d15:b0:545:8f7:8597 with SMTP id 2adb3069b0e04-54990e58529mr6680767e87.16.1741655438918;
        Mon, 10 Mar 2025 18:10:38 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFeh17jk6S5paMoQZlSou+53/9+v4fDyYA4XCd1/WdGihwSo/LQdWRnqXpqm4gYGZIHAcmIos9rAL4FaqL+afg=
X-Received: by 2002:a05:6512:3d15:b0:545:8f7:8597 with SMTP id
 2adb3069b0e04-54990e58529mr6680758e87.16.1741655438424; Mon, 10 Mar 2025
 18:10:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b894d081-eda9-6b28-5fef-75753838a916@huawei.com>
 <27127b7d-7da6-cd31-01db-6725884a7286@huawei.com> <20250310154159.00007ea6@linux.intel.com>
In-Reply-To: <20250310154159.00007ea6@linux.intel.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 11 Mar 2025 09:10:26 +0800
X-Gm-Features: AQ5f1JrwLPEnl4WjE09ox4a19_J_JokNti3Tkme-m-MYMGU5pletmsWjhbA7peQ
Message-ID: <CALTww29ouYDA0VeVFpGo1PUSaj2jPeFyu8WbFbOUtsU5ffYHvw@mail.gmail.com>
Subject: Re: [PATCH v2] mdadm: Clear extra flags when initializing metadata
To: Blazej Kucman <blazej.kucman@linux.intel.com>
Cc: Wu Guanghao <wuguanghao3@huawei.com>, 
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Yu Kuai <yukuai1@huaweicloud.com>, 
	ncroxon@redhat.com, linux-raid@vger.kernel.org, liubo254@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2025 at 10:42=E2=80=AFPM Blazej Kucman
<blazej.kucman@linux.intel.com> wrote:
>
> On Mon, 10 Mar 2025 19:09:36 +0800
> Wu Guanghao <wuguanghao3@huawei.com> wrote:
>
> Hi,
> Thanks for your patch.
>
> you are only adding a change to native metadata so it would be good to
> emphasize this in the title, please change "mdadm:" to "super1:"
>
> There are also a few checkpatch issues,
>
>
> > When adding a disk to a RAID1 array, the metadata is read from the
> > existing member disks for sync. However, only the bad_blocks flag are
> > copied, the bad_blocks records are not copied, so the bad_blocks
> > records are all zeros. The kernel function super_1_load() detects
> > bad_blocks flag and reads the bad_blocks record, then sets the bad
> > block using badblocks_set().
>
> WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit
> description?) #8:
> the bad_blocks records are not copied, so the bad_blocks records are
> all zeros.
>
> >
> > After the kernel commit 1726c7746("badblocks: improve badblocks_set()
> > for multiple ranges handling"), if the length of a bad_blocks record
>
> please use SHA-1 ID - first 12 characters and space between ID and
> (Tile)
>
> > is 0, it will return a failure. Therefore the device addition will
> > fail.
> >
> > So when adding a new disk, some flags cannot be sync and need to be
> > cleared.
> >
> > Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> > ---
> > Changelog:
> > v2:
> >     Add a testcase.
> >     Clear extra replace flag.
> > ---
> >  super1.c                 |  4 ++++
> >  tests/05r1-add-badblocks | 25 +++++++++++++++++++++++++
> >  2 files changed, 29 insertions(+)
> >  create mode 100644 tests/05r1-add-badblocks
> >
> > diff --git a/super1.c b/super1.c
> > index fe3c4c64..f4a29f4f 100644
> > --- a/super1.c
> > +++ b/super1.c
> > @@ -1971,6 +1971,10 @@ static int write_init_super1(struct supertype
> > *st) long bm_offset;
> >       bool raid0_need_layout =3D false;
> >
> > +     /* Clear extra flags */
> > +     sb->feature_map &=3D ~__cpu_to_le32(MD_FEATURE_BAD_BLOCKS |
> > +                                          MD_FEATURE_REPLACEMENT);
>
> ERROR: code indent should use tabs where possible
> #36: FILE: super1.c:1976:
> +                                          MD_FEATURE_REPLACEMENT);$
>
> WARNING: please, no spaces at the start of a line
> #36: FILE: super1.c:1976:
> +                                          MD_FEATURE_REPLACEMENT);$
>
> However, in this case the code will fit on one line, the limit is 100
> characters.
>
> > +
> >       /* Since linux kernel v5.4, raid0 always has a layout */
> >       if (has_raid0_layout(sb) && get_linux_version() >=3D 5004000)
> >               raid0_need_layout =3D true;
> > diff --git a/tests/05r1-add-badblocks b/tests/05r1-add-badblocks
> > new file mode 100644
> > index 00000000..88b064f2
> > --- /dev/null
> > +++ b/tests/05r1-add-badblocks
> > @@ -0,0 +1,25 @@
> > +#
> > +# create a raid1 with a drive and set badblocks for the drive.
> > +# add a new drive does not cause an error.
> > +#
> > +
> > +# create raid1
> > +mdadm -CR $md0 -l1 -n2 -e1.0 $dev1 missing
> > +testdev $md0 1 $mdsize1a 64
> > +sleep 3
> > +
> > +# set badblocks for the drive
> > +dev1_name=3D$(basename $dev1)
> > +echo "10000 100" > /sys/block/md0/md/dev-$dev1_name/bad_blocks
> > +echo "write_error" > /sys/block/md0/md/dev-$dev1_name/state
> > +
> > +# maybe fail but that's ok, as it's only intended to
> > +# record the bad block in the metadata.
> > +mkfs.ext3 $md0
> > +
> > +# re-add and recovery
> > +mdadm $md0 -a $dev2
> > +check recovery
> > +
> > +mdadm -S $md0
> > +
>
> Since you added the test, would you be able to issue a PR on github
> to get the tests running?

Hi all

I've been fixing the test failures recently and I'll create a PR for
this patch set. So you can create a PR tomorrow. If you are not
familiar with this, I can help.

Regards
Xiao
>
> Thansk,
> Blazej
>

