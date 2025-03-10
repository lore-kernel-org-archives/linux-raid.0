Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EFBA2248A8
	for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 10:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741601441; cv=none; b=Xe6BDI0nQ5njrj+bIb2DelwL3Ee72p1qbhd3wi1sYC4+E8P9kaevGbeKSwu+mLIRh66fHpHisV+QLjxzyClYFtrFA+R3thWpL4YlqgHDtrVCl4TW5RCE/ooVhCqIHOTHiuy9wVWReIHEkszNkRg1TCrkAX3fHD82mz7ZJA4+Bhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741601441; c=relaxed/simple;
	bh=fMjBOSlYs7ymdLI5QALEx/TsG32GxnphcETGPP6xZUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QNjo0YPn1E8hWQwIl4u+QyC3L0ajldvcMfYTBrU5Pg7xp0r1tGY7v8YHrwDQABfMq55iGnJIH3jCzbh7h/cA+nw5bgLvN1gB+vKb9q4KV4AcNHlXURQX4a7tkF6fPOzMF4D4LobVgdrmbKIUAKyAIPYCcuKtVrqX9qCPZTjf0hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jF2kA6ML; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jF2kA6ML"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741601438;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iBsYvONK6eeN+YFhrT9b8OJjcDDDVT3cHtVzNh75neg=;
	b=jF2kA6MLRzZyxGBikcyrZleqBATAdCPHBwgVb7eyKAtMwUCL4bDy07qrI3lzqzFoN7dKl1
	6sGCdGZF6yU/6f9wfuW9gE8N7j+8/CqSlf6DM3RTJc7UcZuufk7WzYhN0HhUZWG7koRmuf
	kfF62eyEETL7MXSCNhrAoHxlxMDt3V4=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-185-GdHLmDJSPqeR0ONuNzrsOg-1; Mon, 10 Mar 2025 06:10:37 -0400
X-MC-Unique: GdHLmDJSPqeR0ONuNzrsOg-1
X-Mimecast-MFC-AGG-ID: GdHLmDJSPqeR0ONuNzrsOg_1741601436
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-543bb2be3dcso2147349e87.2
        for <linux-raid@vger.kernel.org>; Mon, 10 Mar 2025 03:10:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741601435; x=1742206235;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iBsYvONK6eeN+YFhrT9b8OJjcDDDVT3cHtVzNh75neg=;
        b=JDRqKkZoUknuNG4pP5edFkYXN2bf5HiFe+3N2tUJpwxi6gzT4yIdrefSBTWoyDgIlR
         cgERn+VXd1MYTa9Mgi/u8h314xrglEp+qT9m+73yi/xyOg3wcU4s6hhkVLaebPn+j/hb
         2+jOHeEnTZ9EuYXWKZVE5MEQW5Zv0tHr/IWlrtCmfu+AlZHAY2GQOMYevJU+ly9eGH8c
         M9mdWyEQ8aJ2IWUyHB5Sk9WB6bgt0eh1wh4CAfSPjiX5cBXGf6kN5uTaCPc+iX4hIJ76
         5FYA85/1jJevbWdAaDh8Z4cdbtf86sViWM8Z6+Qmk9XvQcJvhNg0OkT8DiyZnmU6xSMF
         Irmw==
X-Forwarded-Encrypted: i=1; AJvYcCXOIqSh8dJi+K0HSktn8FPFJN+ycFodQ2hZsMLe/4vKBXmaixKse+SowJgAmY9IToQ3vq941i8LtGbA@vger.kernel.org
X-Gm-Message-State: AOJu0YxRzD8SzlGRsSSx0jsR/J+jhqoNQo1M/8BZj59eikYb6VzMr7CB
	jC5jpm5Ss4zuWxoxsg9a/AJTi1lFaTPuGaaDAbAv8wV1M1LOFS2ZOovzk8Hh69a0d3K8YSIM7uT
	jNqDKXzvDwSdts+Um+QgH3qIUCcmx3zGtisLdR0CgGOKI22IN+PakMWkzpj8PCjkOBVrg7O4k4m
	s72777pt2piyS4kHrNpFO3UXV/hVk9imJcbQ==
X-Gm-Gg: ASbGnctztLKbMOndQaKvwh7cDnhfDUHVhQ0MDwCst/IJ00CnbV9NmwOlxHZTYHwpgee
	RLO5HTW6dmtbdOv0pkktKVoAzKOCeUvObvposAUhiJ/XUgDVpN0NBxJUK8DxwTz6OXCDc75NNvA
	==
X-Received: by 2002:a05:6512:281b:b0:545:2c40:ec1d with SMTP id 2adb3069b0e04-549910d721dmr4540261e87.44.1741601435260;
        Mon, 10 Mar 2025 03:10:35 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHU4rBZcqQWNt9mQKIW5i9t7Xx7jyniLqfs88jkonkao+NTc8edQaRDC81LGcJk+iCWvIFFn/GervElGAYPLUM=
X-Received: by 2002:a05:6512:281b:b0:545:2c40:ec1d with SMTP id
 2adb3069b0e04-549910d721dmr4540245e87.44.1741601434801; Mon, 10 Mar 2025
 03:10:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <d78cbb12-9a9c-7965-db9a-70b4b277f908@huawei.com>
 <42e56670-e595-1c66-208c-40c103262890@huaweicloud.com> <CALTww2_yMs_QYSWaQgRFNRgkaZi15KDmdH_00QeTOJWmp1YHcQ@mail.gmail.com>
 <CALTww2-AnS+t3-W=6cAwTn-oQooOo2Svv-=ozSg7PthsEO9-UQ@mail.gmail.com> <f2ecb825-e8a9-7c18-eb8f-55bd5c0ced7f@huaweicloud.com>
In-Reply-To: <f2ecb825-e8a9-7c18-eb8f-55bd5c0ced7f@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 10 Mar 2025 18:10:22 +0800
X-Gm-Features: AQ5f1Jpb6bp5Fls-FyIAg0mkH8tnXXk_PrrXGGTRK3eSmo7PwaukLOrUUCOiuM0
Message-ID: <CALTww29bo6oZR0VyFAXuLQhNk5pyUMfrYr2kHMQ6mNpjNWAc-Q@mail.gmail.com>
Subject: Re: [PATCH] mdadm: Don't set bad_blocks flag when initializing metadata
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Wu Guanghao <wuguanghao3@huawei.com>, 
	Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>, ncroxon@redhat.com, 
	linux-raid@vger.kernel.org, liubo254@huawei.com, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 10, 2025 at 9:38=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2025/03/08 13:27, Xiao Ni =E5=86=99=E9=81=93:
> > On Sat, Mar 8, 2025 at 11:06=E2=80=AFAM Xiao Ni <xni@redhat.com> wrote:
> >>
> >> Hi Guanghao
> >>
> >> Thanks for your patch.
> >>
> >> On Tue, Mar 4, 2025 at 8:27=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>>
> >>> Hi,
> >>>
> >>> =E5=9C=A8 2025/03/04 14:12, Wu Guanghao =E5=86=99=E9=81=93:
> >>>> When testing the raid1, I found that adding disk to raid1 fails.
> >>>> Here's how to reproduce it:
> >>>>
> >>>>        1. modprobe brd rd_nr=3D3 rd_size=3D524288
> >>>>        2. mdadm -Cv /dev/md0 -l1 -n2 -e1.0 /dev/ram0 /dev/ram1
> >>>>
> >>>>        3. mdadm /dev/md0 -f /dev/ram0
> >>>>        4. mdadm /dev/md0 -r /dev/ram0
> >>>>
> >>>>        5. echo "10000 100" > /sys/block/md0/md/dev-ram1/bad_blocks
> >>>>        6. echo "write_error" > /sys/block/md0/md/dev-ram1/state
> >>>>
> >>>>        7. mkfs.xfs /dev/md0
> >>
> >> Do we need this step7 here?
> >
> > I confirmed myself. The answer is yes.
> >>
> >>>>        8. mdadm --examine-badblocks /dev/ram1  # Bad block records c=
an be seen
> >>>>           Bad-blocks on /dev/ram1:
> >>>>                       10000 for 100 sectors
> >>>>
> >>>>        9. mdadm /dev/md0 -a /dev/ram2
> >>>>           mdadm: add new device failed for /dev/ram2 as 2: Invalid a=
rgument
> >>>
> >>> Can you add a new regression test as well?
> >>>
> >>>>
> >>>> When adding a disk to a RAID1 array, the metadata is read from the e=
xisting
> >>>> member disks for synchronization. However, only the bad_blocks flag =
are copied,
> >>>> the bad_blocks records are not copied, so the bad_blocks records are=
 all zeros.
> >>>> The kernel function super_1_load() detects bad_blocks flag and reads=
 the
> >>>> bad_blocks record, then sets the bad block using badblocks_set().
> >>>>
> >>>> After the kernel commit 1726c7746("badblocks: improve badblocks_set(=
) for
> >>>> multiple ranges handling"), if the length of a bad_blocks record is =
0, it will
> >>>> return a failure. Therefore the device addition will fail.
> >>
> >> Can you give the specific function replace with "it will return a fail=
ure" here?
> >
> > I know, you mean badblocks_set which is called in super_1_load. It's
> > better to describe clearly in a commit message.
> >>
> >>>>
> >>>> So, don't set the bad_blocks flag when initializing the metadata, ke=
rnel can
> >>>> handle it.
> >>>>
> >>>> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> >>>> ---
> >>>>    super1.c | 3 +++
> >>>>    1 file changed, 3 insertions(+)
> >>>>
> >>>> diff --git a/super1.c b/super1.c
> >>>> index fe3c4c64..03578e5b 100644
> >>>> --- a/super1.c
> >>>> +++ b/super1.c
> >>>> @@ -2139,6 +2139,9 @@ static int write_init_super1(struct supertype =
*st)
> >>>>                if (raid0_need_layout)
> >>>>                        sb->feature_map |=3D __cpu_to_le32(MD_FEATURE=
_RAID0_LAYOUT);
> >>>>
> >>>> +             if (sb->feature_map & MD_FEATURE_BAD_BLOCKS)
> >>>> +                     sb->feature_map &=3D ~__cpu_to_le32(MD_FEATURE=
_BAD_BLOCKS);
> >>>
> >>> There are also other flags that is per rdev, like MD_FEATURE_REPLACEM=
ENT
> >>> and MD_FEATURE_JOURNAL, they should be excluded as well.
> >>
> >> Hmm, why do we need to remove these flags too? It's better to use a
> >> separate patch rather than using this patch and describe it in detail.
> >> It's better to give an example also.
>
> This MD_FEATURE_REPLACEMENT should be removed, because this is per-rdev
> flag, means this rdev is an replacement, and this should never be copied
> to new rdev:
>
>          if (le32_to_cpu(sb->feature_map) & MD_FEATURE_REPLACEMENT)
>                  set_bit(Replacement, &rdev->flags);
>
> This is exactaly the same as MD_FEATURE_BAD_BLOCKS, means this rdev has
> bad blocks.
>
> And I'm wrong about MD_FEATURE_JOURNAL, this doesn't not mean this rdev
> is journal.

Thanks for clarifying this. So please send the new version of this patch.

Regards
Xiao
>
> Thanks,
> Kuai
>
> >
> > Please answer this question.
> >
> > Regards
> > Xiao
> >>
> >> Best Regards
> >> Xiao
> >>>
> >>> Thanks,
> >>> Kuai
> >>>
> >>>> +
> >>>>                sb->sb_csum =3D calc_sb_1_csum(sb);
> >>>>                rv =3D store_super1(st, di->fd);
> >>>>
> >>>
> >>>
> >
> >
> > .
> >
>

