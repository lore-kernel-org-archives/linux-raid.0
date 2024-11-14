Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2441F76D5
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 10:28:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731580083; cv=none; b=HWTCUbK2i71TwbkVRIiVtdQ2DOta6MI0eq6wyRss+EDkrVLaJgILyzKnAbQ+sAduINb0bbVggsl3ZS7QlGfxDA405tSnXvD9bvwwRTk/Tvufwx9aDqV0S0Lbk5z0MxzwRha2MeZ20yTb9UPzVNsY8FsMV3OXtxAQrF2xuKSBz3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731580083; c=relaxed/simple;
	bh=IgRjk/fsZjD6VqBcoT5CNbTsnvJQ1ez9EK6tmyHQTro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=glpVMb69CdP7aTEfs8z9Zq6jlrrm2OSfaVOnkOKix0igYInocWWFpLP7GMqDgmgX83cY3UcbESalwM2gieIyDx7lRo+2c0VkNuPFfqOBywtCQzYvHx39ZakYbkfKb3U7pz5H+5JjCJ7xmZ21PEYlM3aYDFe6vW9RzH4uPIVS1eM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=BZklAJa3; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="BZklAJa3"
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5c937982445so52974a12.2
        for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 02:28:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1731580079; x=1732184879; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hfYq7rCzXYPV1FvXr4+BRQyvXSUk9DuQiF1Nl1Kfcck=;
        b=BZklAJa3MmZZA343CuNMmBDXUOSXmkau3phyuei+BiWMaDOlXFrUfyP8fCFcXDfmtb
         wTEreYnY3VfzJyp2G++4bNHWEuGsEXbSNj00drwHr/VhNnXR0QHafCEQ6SOE+00PL6T3
         tV9oZs9SFP739wBMnizYmqbYbgmU+xbbEW9UxXLXFAEkqEVLZW5suIwPRqdG6Bp39bl5
         +fPHvFl9Y+nYknNIdgpGrO690dgcmcyToHmlr/+ZZe35yhsz2aFAkhHAjDenPhBJkWPr
         uKRciU+yuK2DrMPD7lnBKa83e6DFEUaM78YXiLkS0TNwAKLke31qi1XzSWK4tz02l4VL
         k0hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731580079; x=1732184879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hfYq7rCzXYPV1FvXr4+BRQyvXSUk9DuQiF1Nl1Kfcck=;
        b=OziwbZvMwMQBR/Csmyn6gQ3caFHSatj42EaHoToA4LHXD5yHNp+Wfc0HrlaQaBY8hq
         Z8g8Q2H/Vq+WNslu+ZUT23hDwuMQCw4BXRch7DK6U1QtjNDtWWlbgMS5tc9tHFoUR5sT
         lgl0DVkikUrcQNQy3SltC8qzBD3Z+DIljEHC2cvF4VUU15LY+9dh24laTRKsurASwkfc
         YtZpgeSRL5LK7si9N7kmZt73cl4tCHflzqFHc7vUlCiJnZmWYzLpcYY294hBpfbcpnSO
         DW90lkfo0/E8xKnpb1K9sYw45m9pSnJns2ZXmszFLG9e4EJITJHAPjur8dHdu3ZB4D/B
         vzng==
X-Forwarded-Encrypted: i=1; AJvYcCUOAH/nr9XhOz6WDkBOQmJSUGZVl4Klmz6NzlzY5byG4j5ylWuf9Gg7NeEtVaoPUYbUoHbGo7ht7vv5@vger.kernel.org
X-Gm-Message-State: AOJu0Yw4ik8jguLdmFABh1zDHYgxDtFlSS3cSj04FPJ8IRgZQR4ieOKt
	G8siv1G2LX7yuVv8c8lLuZA/bvEuwOauxVUrfSHGQOmspXtOKjcTCa/Zr+7VkhYRKnh8rWMiEH4
	mmIqaPg+H61lrwocZGpwOcT51imGOdWGwpDaIzg==
X-Google-Smtp-Source: AGHT+IFmmfsUZ5T8Gu+H5o6rCv98TQqEL7UjdriMn2UMqCGne6rdKDt+AuOwYvghQiI4UmtO/OIZHBLyfRHvC7CyteU=
X-Received: by 2002:a05:6402:348f:b0:5cf:77ac:4a5a with SMTP id
 4fb4d7f45d1cf-5cf77ac4d3emr489038a12.0.1731580078858; Thu, 14 Nov 2024
 02:27:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com> <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
 <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com> <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
 <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com> <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
 <3fbe69c8-375c-c397-d40d-bc26d4aeda1a@huaweicloud.com>
In-Reply-To: <3fbe69c8-375c-c397-d40d-bc26d4aeda1a@huaweicloud.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 14 Nov 2024 11:27:48 +0100
Message-ID: <CAMGffEnSJ9KMtB8O4x7Mzyvt4X53CHDMHi9WArGecjOhjh2dTg@mail.gmail.com>
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, Xiao Ni <xni@redhat.com>, 
	=?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>, 
	linux-raid@vger.kernel.org, 
	=?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, David Jeffery <djeffery@redhat.com>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Kuai

On Thu, Nov 14, 2024 at 3:35=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/11/14 0:46, Haris Iqbal =E5=86=99=E9=81=93:
> > On Wed, Nov 13, 2024 at 8:46=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/11/11 21:56, Haris Iqbal =E5=86=99=E9=81=93:
> >>> On Mon, Nov 11, 2024 at 2:39=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.=
com> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2024/11/11 21:29, Haris Iqbal =E5=86=99=E9=81=93:
> >>>>> Hello,
> >>>>>
> >>>>> I gave both the patches a try, and here are my findings.
> >>>>>
> >>>>
> >>>> Thanks for the test!
> >>>>
> >>>>> With the first patch by Yu, I did not see any hang or errors. I tri=
ed
> >>>>> a number of bitmap chunk sizes, and ran fio for few hours, and ther=
e
> >>>>> was no hang.
> >>>>
> >>>> This is good news! However, there is still a long road for my approc=
h
> >>>> to land, this requires a lot of other changes to work.
> >>>>>
> >>>>> With the second patch Xiao, I hit the following BUG_ON on the first
> >>>>> minute of my fio run.
> >>>>
> >>>> This is sad. :(
> >>>>>
> >>>>> [  113.902982] Oops: invalid opcode: 0000 [#1] PREEMPT SMP PTI
> >>>>> [  113.903315] CPU: 38 UID: 0 PID: 9767 Comm: kworker/38:3H Kdump:
> >>>>> loaded Not tainted 6.11.5-storage
> >>>>> #6.11.5-1+feature+v6.11+20241111.0643+cbe84cc3~deb12
> >>>>> [  113.904120] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03=
/03/2021
> >>>>> [  113.904519] Workqueue: ib-comp-wq ib_cq_poll_work [ib_core]
> >>>>> [  113.904888] RIP: 0010:__add_stripe_bio+0x23f/0x250 [raid456]
> >>>>
> >>>> Can you provide the addr2line of this?
> >>>>
> >>>> gdb raid456.ko
> >>>> list *(__add_stripe_bio+0x23f)
> >>>
> >>> Sorry. I missed the first line while copying.
> >>>
> >>> [  113.902680] kernel BUG at drivers/md/raid5.c:3525!
> >>
> >> Can you give the following patch a test again, on the top of Xiao's
> >> patch.
> >>
> >> Thanks,
> >> Kuai
> >>
> >> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> >> index 6e318598a7b6..189f784aed00 100644
> >> --- a/drivers/md/raid5.c
> >> +++ b/drivers/md/raid5.c
> >> @@ -3516,7 +3516,7 @@ static void __add_stripe_bio(struct stripe_head
> >> *sh, struct bio *bi,
> >>                   bip =3D &sh->dev[dd_idx].toread;
> >>           }
> >>
> >> -       while (*bip && (*bip)->bi_iter.bi_sector < bi->bi_iter.bi_sect=
or)
> >> +       while (*bip && (*bip)->bi_iter.bi_sector <=3D bi->bi_iter.bi_s=
ector)
> >>                   bip =3D &(*bip)->bi_next;
> >>
> >>           if (!forwrite || previous)
> >
> > Still hangs. Following is the stack trace.
> >
> > [   22.702034] netconsole-setup: Test log message to verify netconsole
> > configuration.
> > [  134.949923] Oops: general protection fault, probably for
> > non-canonical address 0x761acac3b7d57b17: 0000 [#1] PREEMPT SMP PTI
> > [  134.950621] CPU: 35 UID: 0 PID: 833 Comm: md300_raid5 Kdump: loaded
> > Not tainted 6.11.5-storage
> > #6.11.5-1+feature+v6.11+20241113.0858+ed8e31b5~deb12
> > [  134.951414] Hardware name: Supermicro X10DRi/X10DRi, BIOS 3.3 03/03/=
2021
> > [  134.951814] RIP: 0010:rnbd_dev_bi_end_io+0x1b/0x70 [rnbd_server]
> > [  134.952185] Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
> > 0f 1e fa 0f 1f 44 00 00 55 b8 ff ff ff ff 53 48 8b 6f 40 48 89 fb 48
> > 8b 55 08 <f0
> > [  134.953311] RSP: 0018:ffffb5b94818fb80 EFLAGS: 00010282
> > [  134.953624] RAX: 00000000ffffffff RBX: ffff96e6a1d8aa80 RCX: 0000000=
0802a0016
> > [  134.954051] RDX: 761acac3b7d57aa7 RSI: 00000000802a0016 RDI: ffff96e=
6a1d8aa80
> > [  134.954476] RBP: ffff96d705c7d8b0 R08: 0000000000000001 R09: 0000000=
000000001
> > [  134.954901] R10: ffff96d730c59d40 R11: 0000000000000000 R12: ffff96d=
71b3e5000
> > [  134.955326] R13: 0000000000000000 R14: ffff96d730c589d8 R15: ffff96d=
715882e20
> > [  134.955752] FS:  0000000000000000(0000) GS:ffff96f63fbc0000(0000)
> > knlGS:0000000000000000
> > [  134.956237] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > [  134.956578] CR2: 00007fb5962bbe00 CR3: 000000060882c006 CR4: 0000000=
0001706f0
> > [  134.957003] Call Trace:
> > [  134.957151]  <TASK
> > [  134.957274]  ? die_addr+0x36/0x90
> > [  134.957480]  ? exc_general_protection+0x1bc/0x3c0
> > [  134.957762]  ? asm_exc_general_protection+0x26/0x30
> > [  134.958054]  ? rnbd_dev_bi_end_io+0x1b/0x70 [rnbd_server]
> > [  134.958377]  md_end_clone_io+0x42/0xa0
> > [  134.958602]  md_end_clone_io+0x42/0xa0
> > [  134.958826]  handle_stripe_clean_event+0x240/0x430 [raid456]
> > [  134.959168]  handle_stripe+0x783/0x1cb0 [raid456]
> > [  134.959452]  ? common_interrupt+0x13/0xa0
> > [  134.959690]  handle_active_stripes.constprop.0+0x353/0x540 [raid456]
> > [  134.960073]  raid5d+0x41a/0x600 [raid456]
> >
> > Maybe the same BIO handled twice - and so the clone (for IO-acct) got
> > put again (somehow) into md_account_bio()?
>
> I think the last change is reasonable, the BUG_ON() can be avoided and
> bio chain won't be messed up.
>
Yes, seem we are making progress, thx!
> The problem here looks like bio reference is not correct, I'll need some
> time to sort that out, too complicated in raid5.
>
> Meanwhile, can you try the following workround? I just revert the
> changes that I think introduce this problem, noted that performace can
> be degraded.
Do you want us to try the following change on top of the md/md-6.13
branch without Xiao's patch and your fixup alone, or combine them all
together?

BTW: we hit similar hung since kernel 4.19.

Thx!
>
> Thanks,
> Kuai
>
> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index f09e7677ee9f..07aa453bdb2f 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -5874,17 +5874,6 @@ static int add_all_stripe_bios(struct r5conf *conf=
,
>                          wait_on_bit(&dev->flags, R5_Overlap,
> TASK_UNINTERRUPTIBLE);
>                          return 0;
>                  }
> -       }
> -
> -       for (dd_idx =3D 0; dd_idx < sh->disks; dd_idx++) {
> -               struct r5dev *dev =3D &sh->dev[dd_idx];
> -
> -               if (dd_idx =3D=3D sh->pd_idx || dd_idx =3D=3D sh->qd_idx)
> -                       continue;
> -
> -               if (dev->sector < ctx->first_sector ||
> -                   dev->sector >=3D ctx->last_sector)
> -                       continue;
>
>                  __add_stripe_bio(sh, bi, dd_idx, forwrite, previous);
>                  clear_bit((dev->sector - ctx->first_sector) >>
>
