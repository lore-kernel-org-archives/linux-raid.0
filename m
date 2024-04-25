Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D572AF513
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 16:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714063943; cv=none; b=cLDLHweYDglOS/AhNk1qkPignCPI7qpGDC7ahLGl0JPP80ZvN0wJdxdBbp/FtfYJwcUmwr28oW5XVOpcNNpgHRMyaBlppdQ9OdMxm5lkqFTOARz0nTPTztkf2g4lpDJf2ly/cwCinMh4dktWXmTfQt9J3Ghp+SvGS/i0j24ZpLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714063943; c=relaxed/simple;
	bh=ab29OZg4FBFnvYwAN/Vgs3tllM17qmF/Sl5HSOo2OXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fJMXhFbz2Nl2hdNJ91OG6HFSB6Dk/4necyvyEAleIICCZyvesOe6pX9mPqzESbb0Vwp5oBlBD6qK5y1pKw5NVRXuSVo9NQ/SX/x02IU4uPBf05TCkFLlHG4aeumcycEduiRwSRiVI2fGJn9dxWQI586wofBVXb3jBh0Oa9/KBig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W/kXyvPC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W/kXyvPC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D73FC113CE
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 16:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1714063943;
	bh=ab29OZg4FBFnvYwAN/Vgs3tllM17qmF/Sl5HSOo2OXc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=W/kXyvPCq2YQL47hH4CF/6fRrRIQTVsAiXuBz7DFAT32w9O660GliW1x+m1214zTI
	 tht5vI9Ahs9fxD8EtYzUMDPQ90Ie2fu8JwAlqgrJzxtIVFJR3+YJSQNjdaNp4Q69pU
	 HJeCh8k/zQwPA1ImiTcqPfq4hQ2X2TNlcdF6dLERMJrchVXaSLyD7JPBBUjqdnjT4z
	 jfppLw3I1dTrxXSOToENs9UZn8QuE4H5KwiMndSa8GPvbRk3Yg5+aubXtHeMc8+Y1r
	 3/o2qXSCo2qKtl/XcyobfmFUITLysEwhX12eAEntBUTI5XKvM/nsbh3T6dEa6OrADT
	 72IaCDVDRE+/A==
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-2def8e5ae60so9455031fa.2
        for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 09:52:23 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCX7+e+EW+hnHDsrz/R+9Hlav3cUXVCZ0chEZFl+Jv+UVzJmCw2g0UzQ12PTEyq7YkJ2T6hy/1Q9hU381YNfGZyiBUl3BtOp4Cl5HA==
X-Gm-Message-State: AOJu0Yyz0y8VZCXw7j194dYASQ8P2vfh+Em1shCKuLpIiSaVzFk56cVj
	O7WOi69qKqWbUitWHtewZ9FWZ7LurrJpqtsSkZenHNjV8xSpLrL4ZqPbyJkWyfMko0+Vqbd//mm
	SyStdTL6RnvNRa0qj9NbTUU8wmVg=
X-Google-Smtp-Source: AGHT+IE0g6DBL1xxAgfZ1l0vIiPDE4XvzatjcmoKRFnldTuJN/VfaPiTCJJS69Ksdyo3fbQWTY8j0JocF4YaenQFsyE=
X-Received: by 2002:a2e:9ad5:0:b0:2dd:bd92:63a with SMTP id
 p21-20020a2e9ad5000000b002ddbd92063amr3949141ljj.34.1714063941816; Thu, 25
 Apr 2024 09:52:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
 <a86ab399-ab3c-946c-0c2d-0f38bbde382a@huaweicloud.com> <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
 <75f30327-67b5-eca5-5cc8-f821ff0aeee7@huaweicloud.com> <14c84bbe-88e3-4ab4-afcc-2fef6397d6f4@redhat.com>
In-Reply-To: <14c84bbe-88e3-4ab4-afcc-2fef6397d6f4@redhat.com>
From: Song Liu <song@kernel.org>
Date: Thu, 25 Apr 2024 09:52:10 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7Tx4imRWgGsYsDJmNe3ih0pfyB1s_CGrSZ-=QQBaNBaQ@mail.gmail.com>
Message-ID: <CAPhsuW7Tx4imRWgGsYsDJmNe3ih0pfyB1s_CGrSZ-=QQBaNBaQ@mail.gmail.com>
Subject: Re: regression: CPU soft lockup with raid10: check slab-out-of-bounds
 in md_bitmap_get_counter
To: Nigel Croxon <ncroxon@redhat.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, linux-raid@vger.kernel.org, 
	Heinz Mauelshagen <heinzm@redhat.com>, Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 25, 2024 at 5:10=E2=80=AFAM Nigel Croxon <ncroxon@redhat.com> w=
rote:
>
>
> On 4/24/24 2:57 AM, Yu Kuai wrote:
> > Hi, Nigel
> >
> > =E5=9C=A8 2024/04/21 20:30, Nigel Croxon =E5=86=99=E9=81=93:
> >>
> >> On 4/20/24 2:09 AM, Yu Kuai wrote:
> >>> Hi,
> >>>
> >>> =E5=9C=A8 2024/04/20 3:49, Nigel Croxon =E5=86=99=E9=81=93:
> >>>> There is a problem with this commit, it causes a CPU#x soft lockup
> >>>>
> >>>> commit 301867b1c16805aebbc306aafa6ecdc68b73c7e5
> >>>> Author: Li Nan <linan122@huawei.com>
> >>>> Date:   Mon May 15 21:48:05 2023 +0800
> >>>> md/raid10: check slab-out-of-bounds in md_bitmap_get_counter
> >>>>
> >>>
> >>> Did you found this commit by bisect?
> >>>
> >> Yes, found this issue by bisecting...
> >>
> >>>> Message from syslogd@rhel9 at Apr 19 14:14:55 ...
> >>>>   kernel:watchdog: BUG: soft lockup - CPU#3 stuck for 26s!
> >>>> [mdX_resync:6976]
> >>>>
> >>>> dmesg:
> >>>>
> >>>> [  104.245585] CPU: 7 PID: 3588 Comm: mdX_resync Kdump: loaded Not
> >>>> tainted 6.9.0-rc4-next-20240419 #1
> >>>> [  104.245588] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> >>>> BIOS 1.16.2-1.fc38 04/01/2014
> >>>> [  104.245590] RIP: 0010:_raw_spin_unlock_irq+0x13/0x30
> >>>> [  104.245598] Code: 00 00 00 00 00 66 90 90 90 90 90 90 90 90 90
> >>>> 90 90 90 90 90 90 90 90 0f 1f 44 00 00 c6 07 00 90 90 90 fb 65 ff
> >>>> 0d 95 9f 75 76 <74> 05 c3 cc cc cc cc 0f 1f 44 00 00 c3 cc cc cc cc
> >>>> cc cc cc cc cc
> >>>> [  104.245601] RSP: 0018:ffffb2d74a81bbf8 EFLAGS: 00000246
> >>>> [  104.245603] RAX: 0000000000000000 RBX: 0000000001000000 RCX:
> >>>> 000000000000000c
> >>>> [  104.245604] RDX: 0000000000000000 RSI: 0000000001000000 RDI:
> >>>> ffff926160ccd200
> >>>> [  104.245606] RBP: ffffb2d74a81bcd0 R08: 0000000000000013 R09:
> >>>> 0000000000000000
> >>>> [  104.245607] R10: 0000000000000000 R11: ffffb2d74a81bad8 R12:
> >>>> 0000000000000000
> >>>> [  104.245608] R13: 0000000000000000 R14: ffff926160ccd200 R15:
> >>>> ffff926151019000
> >>>> [  104.245611] FS:  0000000000000000(0000)
> >>>> GS:ffff9273f9580000(0000) knlGS:0000000000000000
> >>>> [  104.245613] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> >>>> [  104.245614] CR2: 00007f23774d2584 CR3: 0000000104098003 CR4:
> >>>> 0000000000370ef0
> >>>> [  104.245616] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> >>>> 0000000000000000
> >>>> [  104.245617] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> >>>> 0000000000000400
> >>>> [  104.245618] Call Trace:
> >>>> [  104.245620]  <IRQ>
> >>>> [  104.245623]  ? watchdog_timer_fn+0x1e3/0x260
> >>>> [  104.245630]  ? __pfx_watchdog_timer_fn+0x10/0x10
> >>>> [  104.245634]  ? __hrtimer_run_queues+0x112/0x2a0
> >>>> [  104.245638]  ? hrtimer_interrupt+0xff/0x240
> >>>> [  104.245640]  ? sched_clock+0xc/0x30
> >>>> [  104.245644]  ? __sysvec_apic_timer_interrupt+0x54/0x140
> >>>> [  104.245649]  ? sysvec_apic_timer_interrupt+0x6c/0x90
> >>>> [  104.245652]  </IRQ>
> >>>> [  104.245653]  <TASK>
> >>>> [  104.245654]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
> >>>> [  104.245659]  ? _raw_spin_unlock_irq+0x13/0x30
> >>>> [  104.245661]  md_bitmap_start_sync+0x6b/0xf0
> >
> > Can you give the following patch a test as well? I believe this is
> > the root cause why page > bitmap->pages, dm-raid is using the wrong
> > bitmap size.
> >
> > diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
> > index abe88d1e6735..d9c65ef9c9fb 100644
> > --- a/drivers/md/dm-raid.c
> > +++ b/drivers/md/dm-raid.c
> > @@ -4052,7 +4052,8 @@ static int raid_preresume(struct dm_target *ti)
> >                mddev->bitmap_info.chunksize !=3D
> > to_bytes(rs->requested_bitmap_chunk_sectors)))) {
> >                 int chunksize =3D
> > to_bytes(rs->requested_bitmap_chunk_sectors) ?:
> > mddev->bitmap_info.chunksize;
> >
> > -               r =3D md_bitmap_resize(mddev->bitmap,
> > mddev->dev_sectors, chunksize, 0);
> > +               r =3D md_bitmap_resize(mddev->bitmap,
> > mddev->resync_max_sectors,
> > +                                    chunksize, 0);
> >                 if (r)
> >                         DMERR("Failed to resize bitmap");
> >         }
> >
> > Thanks,
> > Kuai
>
> Hello Kaui,
>
> Tested and found no issues. Good to go..
>
> -Nigel

Thanks for the fixes and the tests.

For the next step, do we need both patches or just one of them?

Song
