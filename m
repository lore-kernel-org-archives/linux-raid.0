Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A18C5D52F
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 16:08:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PHN4qLpx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C27AC433C8
	for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 16:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701014880;
	bh=COqMh75JfW0hCNk1docW696MmaeAeTPI/v2D8coYND0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=PHN4qLpx7wn1ApbNUkgIfdxNns5zSpjImDcQolriDZwzz5qjwwDdXRWiZovPtWqjb
	 3gqvdh+ItCsqDdASYN9KJ47rCXQnkBQHc87blQukEtsfZWkEFzmOHQvFDOtUcq+q1g
	 8iaJxJ99XZBnYiDK0wwLO6W30m8pVKykGH+dUY4qaecnnIB2U2ck8PwBdjLq4U0Zss
	 F/fQnQf8X8x4eL5aESBQOPAMMxj7WITA9+4E4UoI6IYfq2CDhmntRZIQCNjECVwlmk
	 a2+vXH7n4CY+o7IftWRWLmauEqugUyHtSMJopiVUd3dhLyc54j2T1SrgC3KTAplB+t
	 RNyKd4ZXnr5Kw==
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-50ba73196b1so2160596e87.0
        for <linux-raid@vger.kernel.org>; Sun, 26 Nov 2023 08:07:59 -0800 (PST)
X-Gm-Message-State: AOJu0YyJUY3XD5sCrKcqKE2b9lB18sRKt0XGb7utAjUQXTRlDwAmX7Yu
	XolYKMai5sMcNotZ1DWQ9N3EWfPWjOjCEKn+y6s=
X-Google-Smtp-Source: AGHT+IEotRFtzXOUGIxK0I4LYs4B4lY89Ng4Fh9GcuAkBqcZC2CK1BA/DZKiMpTsTLXrO8LMKGP/8F+SZzSfBPkJeyw=
X-Received: by 2002:a19:7604:0:b0:507:96e5:2ff4 with SMTP id
 c4-20020a197604000000b0050796e52ff4mr5794210lff.52.1701014878183; Sun, 26 Nov
 2023 08:07:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com> <CAGRgLy6KH9WfqHzN2OkFg5tb49Y=wKnBqQCdWifoFV13aD17Dg@mail.gmail.com>
In-Reply-To: <CAGRgLy6KH9WfqHzN2OkFg5tb49Y=wKnBqQCdWifoFV13aD17Dg@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Sun, 26 Nov 2023 08:07:46 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6AT5_=d9ibfwBedsd-aVrdM1tfBnJpYD=hoiOeKMCpAw@mail.gmail.com>
Message-ID: <CAPhsuW6AT5_=d9ibfwBedsd-aVrdM1tfBnJpYD=hoiOeKMCpAw@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 26, 2023 at 1:18=E2=80=AFAM Alexander Lyakas <alex.bolshoy@gmai=
l.com> wrote:
>
> Hi Song,
>
> Thank you for your response.
>
> On Fri, Nov 24, 2023 at 1:58=E2=80=AFAM Song Liu <song@kernel.org> wrote:
> >
> > Hi Alexander,
> >
> > Thanks for the report.
> >
> > On Wed, Nov 22, 2023 at 1:42=E2=80=AFAM Alexander Lyakas <alex.bolshoy@=
gmail.com> wrote:
> > >
> > > Hello Song Liu,
> > >
> > > We had a raid6 with 6 drives, all drives marked as In_sync. At some
> > > point drive in slot 5 (last drive) was marked as Faulty, due to
> > > timeout IO error. Superblocks of all other drives got updated with
> > > event count higher by 1. However, the Faulty drive was still not
> > > ejected from the array by remove_and_add_spares(), probably because i=
t
> > > still had nr_pending. This situation was going on for 20 minutes, and
> > > the Faulty drive was still not being removed from the array. But arra=
y
> > > continued serving writes, skipping the Faulty drive as designed.
> > >
> > > After about 20 minutes, the machine got rebooted due to some other re=
ason.
> > >
> > > After reboot, the array got assembled, and the event counter
> > > difference was 1 between the problematic drive and all other drives.
> > > Even count on all drives was 2834681, but on the problematic drive it
> > > was 2834680. As a result, mdadm considered the problematic drive as
> > > up-to-date, due to this code in mdadm[1]. Kernel also accepted such
> > > difference of 1, as can be seen in super_1_validate() [2].
> >
> > Did super_1_validate() set the bad drive as Faulty?
> >
> >                 switch(role) {
> >                 case MD_DISK_ROLE_SPARE: /* spare */
> >                         break;
> >                 case MD_DISK_ROLE_FAULTY: /* faulty */
> >                         set_bit(Faulty, &rdev->flags);
> >                         break;
> >
> > AFAICT, this should stop the bad drive from going bad to the array.
> > If this doesn't work, there might be some bug somewhere.
> This can never happen. The reason is that a superblock of a particular
> device will never record about *itself* that it is Faulty. When a
> device fails, we mark it as Faulty in memory, and then md_update_sb()
> will skip updating the superblock of this particular device. I have
> discussed this also many years ago with Neil[1].

Thanks for pointing this out. I think this is the actual problem here. In
analyze_sbs() we first run validate_super() on the freshest device.
Then, we run validate_super() on other devices. We should mark the
device as faulty based on the sb from the freshest device. (which is
not the case at the moment). I think we need to fix this.

> Can you please comment whether you believe that treating event counter
> difference 1 as "still up to date" is safe?

With the above issue fixed, allowing the event counter to be off by 1 is sa=
fe.
Does this make sense? Did I miss cases?

Thanks,
Song

> Thanks,
> Alex.
>
>
>
> [1]
> Quoting from https://www.spinics.net/lists/raid/msg37003.html
> Question:
> When a drive fails, the kernel skips updating its superblock, and
> updates all other superblocks that this drive is Faulty. How can it
> happen that a drive can mark itself as Faulty in its own superblock? I
> saw code in mdadm checking for this.
> Answer:
> It cannot, as you say. I don't remember why mdadm checks for that.
> Maybe a very old version of the kernel code could do that.
