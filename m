Received: from forward500d.mail.yandex.net (forward500d.mail.yandex.net [178.154.239.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E88C13C;
	Mon, 22 Jul 2024 17:56:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.154.239.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721671024; cv=none; b=NLJBbZixZNNhibLVr2NNehryKYHzoMkS4FsenKmayiVz853fviVjghYGD+sR7jQhfcSFhVmttfAT5R73/jNuc+XpMq70TNt1nV9be7Zp1l+9nprzXMOVDrcKPpvpCC41PIyurl+1q9XaWBiAoWKITBlSxs2rBQkkyR64uNVTGjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721671024; c=relaxed/simple;
	bh=yPpL6oe42dLTZp5uU5OTc5tOwtAVq1CoWFThS3HQxVA=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pktGh8aPLhpScsVWTTxVssE4YRxooiMkbepgTjBmReLUwTWQv82U3UUzyQR9iMPWRldYSbd3UOw29C4zZcQz7LGpzbKIRDzHIzFaPglw97HAAWEtuvXSzZ2otRBe3Lt26wC5MfoBCS/+9eF7mH1zxFxeUh4vwE1oje8Bx43DO24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru; spf=pass smtp.mailfrom=yandex.ru; dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b=EbaFcVO+; arc=none smtp.client-ip=178.154.239.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=yandex.ru
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yandex.ru
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=yandex.ru header.i=@yandex.ru header.b="EbaFcVO+"
Received: from mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net (mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net [IPv6:2a02:6b8:c42:2e23:0:640:e883:0])
	by forward500d.mail.yandex.net (Yandex) with ESMTPS id F195160CA1;
	Mon, 22 Jul 2024 20:56:51 +0300 (MSK)
Received: by mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net (smtp/Yandex) with ESMTPSA id ouRpL75m70U0-LGeuwe7p;
	Mon, 22 Jul 2024 20:56:51 +0300
X-Yandex-Fwd: 1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex.ru; s=mail;
	t=1721671011; bh=6mBv2LuIC04HW36BwRBTUhRpyKQwuvnW5K+3eMpsC2E=;
	h=In-Reply-To:Date:References:To:From:Subject:Message-ID;
	b=EbaFcVO+4FPsYKT3PdE0zYzUDKBGD4zmfONmSZZgv+x6JDbuAjOB/o4z2DL+sHvxJ
	 72CV0Uzif1zFHMzenhEcuQ5OSSgdh+P4VPpORkrU8tIa/zNa4m2fYI2zeG3rLZT/kp
	 SebTekiuHtdWIHQ+7E8fIhlFjXqVMnZE24e5NQSg=
Authentication-Results: mail-nwsmtp-smtp-production-main-77.klg.yp-c.yandex.net; dkim=pass header.i=@yandex.ru
Message-ID: <57241c91337e8fc3257b6d4a35c273af59875eff.camel@yandex.ru>
Subject: Re: Lockup of (raid5 or raid6) + vdo after taking out a disk under
 load
From: Konstantin Kharlamov <Hi-Angel@yandex.ru>
To: Yu Kuai <yukuai1@huaweicloud.com>, Song Liu <song@kernel.org>, 
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yangerkun@huawei.com" <yangerkun@huawei.com>, "yukuai (C)"
 <yukuai3@huawei.com>
Date: Mon, 22 Jul 2024 20:56:50 +0300
In-Reply-To: <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com>
References: <a6d068a26a90057fb3cdaa59f9d57a2af41a6b22.camel@yandex.ru>
	 <1f879e67-4d64-4df0-5817-360d84ff8b89@huaweicloud.com>
	 <29d69e586e628ef2e5f2fd7b9fe4e7062ff36ccf.camel@yandex.ru>
	 <517243f0-77c5-9d67-a399-78c449f6afc6@huaweicloud.com>
	 <810a319b846c7e16d85a7f52667d04252a9d0703.camel@yandex.ru>
	 <9c60881e-d28f-d8d5-099c-b9678bd69db9@huaweicloud.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.52.3 
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Hi, sorry for the delay, I had to give away the nodes and we had a week
of teambuilding and company party, so for the past week I only managed
to hack away stripping debug symbols, get another node and set it up.

Experiments below are based off of vanilla 6.9.8 kernel *without* your
patch.

On Mon, 2024-07-15 at 09:56 +0800, Yu Kuai wrote:
> Line number will be helpful.

So, after tinkering with building scripts I managed to build modules
with debug symbols (not the kernel itself but should be good enough),
but for some reason kernel doesn't show line numbers in stacktraces. No
idea what could be causing it, so I had to decode line numbers
manually, below is an output where I inserted line numbers for raid456
manually after decoding them with `gdb`.

    [=E2=80=A6]
    [ 1677.293366]  <TASK>
    [ 1677.293661]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
    [ 1677.293972]  ? _raw_spin_unlock_irq+0x10/0x30
    [ 1677.294276]  ? _raw_spin_unlock_irq+0xa/0x30
    [ 1677.294586]  raid5d at drivers/md/raid5.c:6572
    [ 1677.294910]  md_thread+0xc1/0x170
    [ 1677.295228]  ? __pfx_autoremove_wake_function+0x10/0x10
    [ 1677.295545]  ? __pfx_md_thread+0x10/0x10
    [ 1677.295870]  kthread+0xff/0x130
    [ 1677.296189]  ? __pfx_kthread+0x10/0x10
    [ 1677.296498]  ret_from_fork+0x30/0x50
    [ 1677.296810]  ? __pfx_kthread+0x10/0x10
    [ 1677.297112]  ret_from_fork_asm+0x1a/0x30
    [ 1677.297424]  </TASK>
    [=E2=80=A6]
    [ 1705.296253]  <TASK>
    [ 1705.296554]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
    [ 1705.296864]  ? _raw_spin_unlock_irq+0x10/0x30
    [ 1705.297172]  ? _raw_spin_unlock_irq+0xa/0x30
    [ 1677.294586]  raid5d at drivers/md/raid5.c:6597
    [ 1705.297794]  md_thread+0xc1/0x170
    [ 1705.298099]  ? __pfx_autoremove_wake_function+0x10/0x10
    [ 1705.298409]  ? __pfx_md_thread+0x10/0x10
    [ 1705.298714]  kthread+0xff/0x130
    [ 1705.299022]  ? __pfx_kthread+0x10/0x10
    [ 1705.299333]  ret_from_fork+0x30/0x50
    [ 1705.299641]  ? __pfx_kthread+0x10/0x10
    [ 1705.299947]  ret_from_fork_asm+0x1a/0x30
    [ 1705.300257]  </TASK>
    [=E2=80=A6]
    [ 1733.296255]  <TASK>
    [ 1733.296556]  ? asm_sysvec_apic_timer_interrupt+0x16/0x20
    [ 1733.296862]  ? _raw_spin_unlock_irq+0x10/0x30
    [ 1733.297170]  ? _raw_spin_unlock_irq+0xa/0x30
    [ 1677.294586]  raid5d at drivers/md/raid5.c:6572
    [ 1733.297792]  md_thread+0xc1/0x170
    [ 1733.298096]  ? __pfx_autoremove_wake_function+0x10/0x10
    [ 1733.298403]  ? __pfx_md_thread+0x10/0x10
    [ 1733.298711]  kthread+0xff/0x130
    [ 1733.299018]  ? __pfx_kthread+0x10/0x10
    [ 1733.299330]  ret_from_fork+0x30/0x50
    [ 1733.299637]  ? __pfx_kthread+0x10/0x10
    [ 1733.299943]  ret_from_fork_asm+0x1a/0x30
    [ 1733.300251]  </TASK>

> Meanwhile, can you check if the underlying
> disks has IO while raid5 stuck, by /sys/block/[device]/inflight.

The two devices that are left after the 3rd one is removed has these
numbers that don't change with time:

    [Mon Jul 22 20:18:06 @ ~]:> for d in dm-19 dm-17; do echo -n $d; cat
    /sys/block/$d/inflight; done
    dm-19       9        1
    dm-17      11        2
    [Mon Jul 22 20:18:11 @ ~]:> for d in dm-19 dm-17; do echo -n $d; cat
    /sys/block/$d/inflight; done
    dm-19       9        1
    dm-17      11        2

They also don't change after I return the disk back (which is to be
expected I guess, given that the lockup doesn't go away).

> >
> > > At first, can the problem reporduce with raid1/raid10? If not,
> > > this
> > > is
> > > probably a raid5 bug.
> >
> > This is not reproducible with raid1 (i.e. no lockups for raid1), I
> > tested that. I didn't test raid10, if you want I can try (but
> > probably
> > only after the weekend, because today I was asked to give the nodes
> > away, for the weekend at least, to someone else).
>
> Yes, please try raid10 as well. For now I'll say this is a raid5
> problem.

Tested: raid10 works just fine, i.e. no lockup and fio continues
having non-zero IOPS.

> > > The best will be that if I can reporduce this problem myself.
> > > The problem is that I don't understand the step 4: turning off
> > > jbod
> > > slot's power, is this only possible for a real machine, or can I
> > > do
> > > this in my VM?
> >
> > Well, let's say that if it is possible, I don't know a way to do
> > that.
> > The `sg_ses` commands that I used
> >
> > 	sg_ses --dev-slot-num=3D9 --set=3D3:4:1=C2=A0=C2=A0 /dev/sg26 # turnin=
g
> > off
> > 	sg_ses --dev-slot-num=3D9 --clear=3D3:4:1 /dev/sg26 # turning
> > on
> >
> > =E2=80=A6sets and clears the value of the 3:4:1 bit, where the bit is
> > defined
> > by the JBOD's manufacturer datasheet. The 3:4:1 specifically is
> > defined
> > by "AIC" manufacturer. That means the command as is unlikely to
> > work on
> > a different hardware.
>
> I never do this before, I'll try.
> >
> > Well, while on it, do you have any thoughts why just using a `echo
> > 1 >
> > /sys/block/sdX/device/delete` doesn't reproduce it? Does perhaps
> > kernel
> > not emulate device disappearance too well?
>
> echo 1 > delete just delete the disk from kernel, and scsi/dm-raid
> will
> know that this disk is deleted. However, the disk will stay in kernel
> for the other way, dm-raid does not aware that underlying disks are
> problematic and IO will still be generated and issued.
>
> Thanks,
> Kuai
