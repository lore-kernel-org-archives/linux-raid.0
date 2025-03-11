Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79D4A1E5B7D
	for <linux-raid@vger.kernel.org>; Tue, 11 Mar 2025 02:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741660104; cv=none; b=DwdH9hXq7HmsMPO0phK+C1HKPA2YQAJ5+uWv9rVrUD7thhpUC8JuYNf4Usdu+j8pavz/F3xY6dWQq8PuGNjIBhIJKRzFr71zFjBX8wDU2Vfacp5o74nWb8H3dd1HFT0aWi4MmXYxBbEx+XX2YqUbGkt3O0pasKOC0w8VWHYOOdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741660104; c=relaxed/simple;
	bh=8awqdpV9Fk0WnZ3rn8FwL58jLBakzm5kH9vAPRXMomY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Z0Q7qcQFEhGK963l00vFqWK/DRXnufgFmYA6Ja1toxC7p0V3eeLuz2+JgFRtZMMfrD/8c/wUIRGhTYUny/hStUnE9jYnNl44Q4ck4fwq4h6CYfmX8OJ3ZD30bK6mf9C32l5ChmcKFp0IVvgf71BcHGO06aSVhGepeKONbrHdcgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jF+Taruh; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jF+Taruh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741660101;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tbD7gWj/zWm2Gy/Tydz6GoIPYKm2OnWQsJTFA1AbkPM=;
	b=jF+TaruhfxLQsgydeSicYY9J3ycHgc33dgV/sc/tik7dBCGBFF8G91kSnyH1Jou+JvAJ+7
	MTokCvsUDHx+StRSXdf+7mGJgSqIH67mt94AqPf2d3cqaZFBD2MNNvAjVr7nDQSyMB32d5
	jBi8OKCaddY8/pwQRj/nuOkCGhgH87Q=
Received: from mail-lf1-f69.google.com (mail-lf1-f69.google.com
 [209.85.167.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-682-8m6c0LBHMVSy_xLfWZUUjw-1; Mon, 10 Mar 2025 22:28:19 -0400
X-MC-Unique: 8m6c0LBHMVSy_xLfWZUUjw-1
X-Mimecast-MFC-AGG-ID: 8m6c0LBHMVSy_xLfWZUUjw_1741660098
Received: by mail-lf1-f69.google.com with SMTP id 2adb3069b0e04-5495851a7a9so2914124e87.3
        for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 19:28:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741660098; x=1742264898;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tbD7gWj/zWm2Gy/Tydz6GoIPYKm2OnWQsJTFA1AbkPM=;
        b=VuMYdY+fe5yWIpJLRWcgbf2FxqqdAei+6ceK2vfuJhJNsmT/rH3P9sWBFnNNgbN4K4
         F4ltp8SuvEqqN1L9u44pg3UoV6uHhDDm0730LLlr3HRsG7gtAkt7cXpbFaGb4FgcyQrU
         6Kesqc+nU4HSkJnbURyLfvQmLRMHROds3TvAkRcbE8ADo6hmd7+gxMWTmPFiqhuSxz8E
         PmPbY+lPeK2oJT25tn8NR2sbg6kaiI6EKwbQgbfWhAOTcZRSKLBPxkDbnBkJdpzI0YOa
         6lh0xr476c78YjK1CeTF0164vhYhHfkNzHBYMAiPMs07yuTR51hjoNEso5+TbI8B68k6
         l8qg==
X-Forwarded-Encrypted: i=1; AJvYcCU6y+Dqgrz7kV/y0ehYED67OuUN8Sh00xv0SbfknQeEZbHCb0ZzY5rCYyIHEuD1HlQRKqUXrLT7jSGl@vger.kernel.org
X-Gm-Message-State: AOJu0YznshSanpCNwO74zI62y2PBAd941qxj0PKTiYv+Ena/MjbZamLk
	X0PUccT63AQHqBh3TAjsb97A3BF4Ovuv6MNxd32Qz94AU5FXxfvRJqdrSN7+NbvRx21jDG/XfB6
	91aXi+6NihBtnH8S1PFGKqhxzxW04Q9QOVFpiKBfzIktoEOL6s9oUGnS8PMSZIjHHGD9s7U2hwR
	Sw9yGYSdzv7V4HwqxROThgnNbv8JLmlg1OWg==
X-Gm-Gg: ASbGnctXyVTYIUYr0m2NYwIG8DiK3C2WhRTpW6zZgqGmg0qFaotoeeBllnXJQkkHkOL
	lN51tCly0zbZFiRkxOx3qCm8944bUNi2+W+F9QJMO/I29d1gdmwIPTZseMPP6Hj04G6pMFPh+eQ
	==
X-Received: by 2002:a05:6512:2393:b0:545:2950:5360 with SMTP id 2adb3069b0e04-54990e5e2a1mr4946829e87.22.1741660098035;
        Mon, 10 Mar 2025 19:28:18 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IF1Xwe/cWgc4Ax+5zmhHMM4R59xxM8yJG3tFtvx2nP6LFU0NDJL3wAZaMnxMFuQy/NGvdIlrfl7sx5ENTvLFn8=
X-Received: by 2002:a05:6512:2393:b0:545:2950:5360 with SMTP id
 2adb3069b0e04-54990e5e2a1mr4946824e87.22.1741660097598; Mon, 10 Mar 2025
 19:28:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <b894d081-eda9-6b28-5fef-75753838a916@huawei.com>
 <27127b7d-7da6-cd31-01db-6725884a7286@huawei.com> <20250310154159.00007ea6@linux.intel.com>
 <CALTww29ouYDA0VeVFpGo1PUSaj2jPeFyu8WbFbOUtsU5ffYHvw@mail.gmail.com> <9f0914e0-fce2-6360-fa6a-e79c46f234fa@huawei.com>
In-Reply-To: <9f0914e0-fce2-6360-fa6a-e79c46f234fa@huawei.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 11 Mar 2025 10:28:04 +0800
X-Gm-Features: AQ5f1JrokLKiG_uFo0Q-olV0F5jkgAlRgIdWJ7yCnTfOnJ4P7rqp8792TmzUsY8
Message-ID: <CALTww2-P2R2gLMVNNsnE+ENvKtTcgDdXG-YLV3ohsAnYa6J=HQ@mail.gmail.com>
Subject: Re: [PATCH v2] mdadm: Clear extra flags when initializing metadata
To: Wu Guanghao <wuguanghao3@huawei.com>
Cc: Blazej Kucman <blazej.kucman@linux.intel.com>, 
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, Yu Kuai <yukuai1@huaweicloud.com>, 
	ncroxon@redhat.com, linux-raid@vger.kernel.org, liubo254@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 11, 2025 at 10:08=E2=80=AFAM Wu Guanghao <wuguanghao3@huawei.co=
m> wrote:
>
>
>
> =E5=9C=A8 2025/3/11 9:10, Xiao Ni =E5=86=99=E9=81=93:
> > On Mon, Mar 10, 2025 at 10:42=E2=80=AFPM Blazej Kucman
> > <blazej.kucman@linux.intel.com> wrote:
> >>
> >> On Mon, 10 Mar 2025 19:09:36 +0800
> >> Wu Guanghao <wuguanghao3@huawei.com> wrote:
> >>
> >> Hi,
> >> Thanks for your patch.
> >>
> >> you are only adding a change to native metadata so it would be good to
> >> emphasize this in the title, please change "mdadm:" to "super1:"
> >>
> >> There are also a few checkpatch issues,
> >>
> >>
> >>> When adding a disk to a RAID1 array, the metadata is read from the
> >>> existing member disks for sync. However, only the bad_blocks flag are
> >>> copied, the bad_blocks records are not copied, so the bad_blocks
> >>> records are all zeros. The kernel function super_1_load() detects
> >>> bad_blocks flag and reads the bad_blocks record, then sets the bad
> >>> block using badblocks_set().
> >>
> >> WARNING: Prefer a maximum 75 chars per line (possible unwrapped commit
> >> description?) #8:
> >> the bad_blocks records are not copied, so the bad_blocks records are
> >> all zeros.
> >>
> >>>
> >>> After the kernel commit 1726c7746("badblocks: improve badblocks_set()
> >>> for multiple ranges handling"), if the length of a bad_blocks record
> >>
> >> please use SHA-1 ID - first 12 characters and space between ID and
> >> (Tile)
> >>
> >>> is 0, it will return a failure. Therefore the device addition will
> >>> fail.
> >>>
> >>> So when adding a new disk, some flags cannot be sync and need to be
> >>> cleared.
> >>>
> >>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> >>> ---
> >>> Changelog:
> >>> v2:
> >>>     Add a testcase.
> >>>     Clear extra replace flag.
> >>> ---
> >>>  super1.c                 |  4 ++++
> >>>  tests/05r1-add-badblocks | 25 +++++++++++++++++++++++++
> >>>  2 files changed, 29 insertions(+)
> >>>  create mode 100644 tests/05r1-add-badblocks
> >>>
> >>> diff --git a/super1.c b/super1.c
> >>> index fe3c4c64..f4a29f4f 100644
> >>> --- a/super1.c
> >>> +++ b/super1.c
> >>> @@ -1971,6 +1971,10 @@ static int write_init_super1(struct supertype
> >>> *st) long bm_offset;
> >>>       bool raid0_need_layout =3D false;
> >>>
> >>> +     /* Clear extra flags */
> >>> +     sb->feature_map &=3D ~__cpu_to_le32(MD_FEATURE_BAD_BLOCKS |
> >>> +                                          MD_FEATURE_REPLACEMENT);
> >>
> >> ERROR: code indent should use tabs where possible
> >> #36: FILE: super1.c:1976:
> >> +                                          MD_FEATURE_REPLACEMENT);$
> >>
> >> WARNING: please, no spaces at the start of a line
> >> #36: FILE: super1.c:1976:
> >> +                                          MD_FEATURE_REPLACEMENT);$
> >>
> >> However, in this case the code will fit on one line, the limit is 100
> >> characters.
> >>
> >>> +
> >>>       /* Since linux kernel v5.4, raid0 always has a layout */
> >>>       if (has_raid0_layout(sb) && get_linux_version() >=3D 5004000)
> >>>               raid0_need_layout =3D true;
> >>> diff --git a/tests/05r1-add-badblocks b/tests/05r1-add-badblocks
> >>> new file mode 100644
> >>> index 00000000..88b064f2
> >>> --- /dev/null
> >>> +++ b/tests/05r1-add-badblocks
> >>> @@ -0,0 +1,25 @@
> >>> +#
> >>> +# create a raid1 with a drive and set badblocks for the drive.
> >>> +# add a new drive does not cause an error.
> >>> +#
> >>> +
> >>> +# create raid1
> >>> +mdadm -CR $md0 -l1 -n2 -e1.0 $dev1 missing
> >>> +testdev $md0 1 $mdsize1a 64
> >>> +sleep 3
> >>> +
> >>> +# set badblocks for the drive
> >>> +dev1_name=3D$(basename $dev1)
> >>> +echo "10000 100" > /sys/block/md0/md/dev-$dev1_name/bad_blocks
> >>> +echo "write_error" > /sys/block/md0/md/dev-$dev1_name/state
> >>> +
> >>> +# maybe fail but that's ok, as it's only intended to
> >>> +# record the bad block in the metadata.
> >>> +mkfs.ext3 $md0
> >>> +
> >>> +# re-add and recovery
> >>> +mdadm $md0 -a $dev2
> >>> +check recovery
> >>> +
> >>> +mdadm -S $md0
> >>> +
> >>
> >> Since you added the test, would you be able to issue a PR on github
> >> to get the tests running?
> >
> > Hi all
> >
> > I've been fixing the test failures recently and I'll create a PR for
> > this patch set. So you can create a PR tomorrow. If you are not
> > familiar with this, I can help.
> >
> Is this the repository: https://github.com/md-raid-utilities/mdadm/ ?
> If so, I will crerate a PR containing the new changes.

Yes,  you're right.

>
>
> > Regards
> > Xiao
> >>
> >> Thansk,
> >> Blazej
> >>
> >
> >
> > .
>

