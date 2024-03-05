Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1587126F0C
	for <linux-raid@vger.kernel.org>; Tue,  5 Mar 2024 14:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709650407; cv=none; b=IhYShxUqWISQhhdhCeqfExmZkwiyr0c0Nue9S5a73slh6bEARi2+KjUGICLZz4+h7Q+eA2/8SRXLof2IwR0SuJU+vP7ZlfG8cmmPLx51ClnUkld1ypbqfXhJLlNimhoyOqUb6KbwArhCFq9ACBltlMnATLv4fjPgX0K9RqPtLdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709650407; c=relaxed/simple;
	bh=xh3TCu1LUeY41isIWZhqWVZBSJBxXEVr/+4iDNjfUZM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d9OIMBXBoMNkG4R768zpbChMxoVSUbHytYyQ06F+wijXUyiiLbBdTNoH4AIs3/Fj4j1Keg22EW9rY9ComcvYxFofb98vO9cOG5k8pHddcH0H0Fp0ZOPrNrDr8W48JzKLraj31pnHKyIe7dZnAsYB8UcJ6uqM/MK8AbFx38h82LA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=gWkXVLJb; arc=none smtp.client-ip=209.85.167.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="gWkXVLJb"
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5135540c40dso784121e87.3
        for <linux-raid@vger.kernel.org>; Tue, 05 Mar 2024 06:53:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1709650403; x=1710255203; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xh3TCu1LUeY41isIWZhqWVZBSJBxXEVr/+4iDNjfUZM=;
        b=gWkXVLJbEJlaMBBChDmqf9sWfbdcDOeSPz1xtyiBGQ4tB5MU4htWiU1L4jWwe/f2Ru
         Gucv/tochjT66I1ZTAbGvehFvqfLof0EbWFQizi9qDHIR6mYIM/nu3s/3bA0WLT/ygbi
         OvQmn3Dy2YnOPRFBYdxP2s0hwFsz5vFo4R7D9x2DvItuGxitXN6WbF1cQZRp2darriUS
         IGQVoVesEdnKJkIrqWj/6VEph8BoxTP09OfcuUVcOeLB7qHZV+GunE3CRjbSqiymJy4b
         1iNg+BMAqNLojVhNFKf0bTffJ+W4Hk9o6i1Snum+uDDYd4h/NfOLJ0QiIKlvnsZz+LzJ
         9RWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709650403; x=1710255203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xh3TCu1LUeY41isIWZhqWVZBSJBxXEVr/+4iDNjfUZM=;
        b=d9glvGzBbsFqu1KOZyDpN42aIh06bGQDsRvguATYurl01Hd0/fZLvGH1g79UPLZt6h
         BU4sDo4hB49onBSAEHwDDT+kjCflfPBB7nFm1FyliL0eT3xO/Ura5XUYabYI35wJNPLq
         NiBZEdTILyCv/r72RMTM8oQCPqaPN/0Xso60CAq2r0kFn92fiiKqz75XcS0Sq1lOghwb
         xJoOgh8ECggtCtoGLV20RQ6DPCiEID+VGv4P82ypQfTymjUtXgMP7FNqM8el2yrzf5/o
         dUOGzU5ja0jD4xZ22lAzxH7rUM1b1DUOarO9jR75NMi1IqaTRrfnPM+ShHaICDH7qCRG
         6fdQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpGmH5rthAPxchp2/ciu2qJKqQguiwjXpYmCM4osIFRAKbP5j7Ff4fqCK2PGBEnqhK06Kak+TTVO1MfH7j4ip0gRUJH/OQ+3OVLQ==
X-Gm-Message-State: AOJu0Yw73xlSxYplMGRrCG1SPKfy8Nf9PRVbUCD5HUFlk+zf1ILEff4J
	ozF04sQLA+Io1aZxq5yChsGHemyxbJfhz4uqfvlfbG5sCKuYhADmKGSK1D5pUPAre7zIaoCJzlh
	fSdIgMhc9uT1ZX2ogCFXxKoyuAHGiL5zWt9C8vw==
X-Google-Smtp-Source: AGHT+IFxzkErFYOEJqpaFV3ch/t/ZvVCQk+SWaKyGPMydbdF8WbAsAIFiSLt0fzlCaZWsdBwwKsbqZssDsFpluGsF+c=
X-Received: by 2002:ac2:495d:0:b0:513:f34:3f1c with SMTP id
 o29-20020ac2495d000000b005130f343f1cmr1315199lfi.27.1709650402831; Tue, 05
 Mar 2024 06:53:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240305105419.21077-1-jinpu.wang@ionos.com> <9874f0e8-32d4-4c29-a332-718fb95a365a@molgen.mpg.de>
 <CAHJVUegG9cL6WnNCeokOnAAJyb4yEWnyzi=S20=K=sREJy3AOQ@mail.gmail.com>
 <7709385e-1770-4fc3-bc92-7a93b754375f@molgen.mpg.de> <CAHJVUehN_q8J96mtuq-DSmw2V4JVMcQ7GPROF2L-2GQTTH1RPQ@mail.gmail.com>
In-Reply-To: <CAHJVUehN_q8J96mtuq-DSmw2V4JVMcQ7GPROF2L-2GQTTH1RPQ@mail.gmail.com>
From: =?UTF-8?Q?Florian=2DEwald_M=C3=BCller?= <florian-ewald.mueller@ionos.com>
Date: Tue, 5 Mar 2024 15:53:12 +0100
Message-ID: <CAHJVUeijmJh2G+bqBXngC-2e4c9MmcoCK3SNUV2ofg1yZz2K2g@mail.gmail.com>
Subject: Re: [PATCHv2] md: Replace md_thread's wait queue with the swait variant
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Jack Wang <jinpu.wang@ionos.com>, song@kernel.org, yukuai3@huawei.com, 
	linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

PS: backend devices were/are SSDs.

On Tue, Mar 5, 2024 at 3:52=E2=80=AFPM Florian-Ewald M=C3=BCller
<florian-ewald.mueller@ionos.com> wrote:
>
> Hi Paul,
>
> Regarding the IDLE state waiting:
> - yes, this could/should be backported to any version which already
> has swait_event_idle() macro(s) - and so also TASK_IDLE - defined.
>
> About our fio driven tests
> - we used fio "ini" files similar to:
>
> [global]
> description=3DRandom Read/Write Access Pattern
> bssplit=3D512/8:1k/4:2k/4:4k/30:8k/20:16k/10:32k/8:64k/12:128k/4
> cpus_allowed=3D0-31
> cpus_allowed_policy=3Dsplit
> numa_mem_policy=3Dlocal
> fadvise_hint=3D0
> rw=3Drandrw
> direct=3D1
> size=3D100%
> random_distribution=3Dzipf:1.2
> percentage_random=3D80
> ioengine=3Dlibaio
> iodepth=3D128
> numjobs=3D1
> gtod_reduce=3D1
> group_reporting
> ramp_time=3D60
> runtime=3D300
> time_based
>
> [job0]
> filename=3D/dev/disk/by-name/vol0
>
> [job1]
> filename=3D/dev/disk/by-name/vol1
>
> ... and so on for >=3D 100 logical volumes.
>
> Best regards,
>
> On Tue, Mar 5, 2024 at 3:14=E2=80=AFPM Paul Menzel <pmenzel@molgen.mpg.de=
> wrote:
> >
> > Dear Florian-Ewald,
> >
> >
> > Thank you for your quick reply.
> >
> > Am 05.03.24 um 13:25 schrieb Florian-Ewald M=C3=BCller:
> >
> > > Regarding the INTERRUPTIBLE wait:
> > > - it was introduced that time only for _not_ contributing to load-ave=
rage.
> > > - now obsolete, see also explanation in our patch.
> >
> > Yes, I understood that. My question was regarding, if this should be
> > backported to the stable series.
> >
> > > Regarding our tests:
> > > - we used 100 logical volumes (and more) doing full-blown random rd/w=
r
> > > IO (fio) to the same md-raid1/raid5 device.
> >
> > Do you have a script to create these volumes and running the fio test,
> > so it=E2=80=99s easy to reproduce?
> >
> > Was it a spinning disk or SSD device?
> >
> >
> > Kind regards,
> >
> > Paul
