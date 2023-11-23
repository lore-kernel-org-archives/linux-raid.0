Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731693D3A0
	for <linux-raid@vger.kernel.org>; Thu, 23 Nov 2023 23:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mSUbOlDU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50C2DC433C7
	for <linux-raid@vger.kernel.org>; Thu, 23 Nov 2023 23:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1700783904;
	bh=Z3/8egssVM2gTH3peqhhle6o6wSrSj9+BzrYmnTEyL0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=mSUbOlDUTaIx71AblSeIrABUkLuEvCZDv449Cmd97mDY3FoK/L7/dRR+AV+1iGOvT
	 XbVqwmI2gkK9w7vNz9X31VU8LnE/u9/U9Dw7BlmDW7dEPfKWNBeK5rhn+F1BbtM6jT
	 PWrNQ2avKAahgne2XZq0G6AVa8CyemKTpEcPBmx5oPaMWWHAQCP8f23cYLE3hJe/wk
	 vrVNo+1bRvJgquJ6ZxYkiBJHPbxEM6zVSrzhnUwpdxXN75uts8FPMbcwchhBUdjKdm
	 rEtKltFcaMlWbVfBPqOIb83t1s4aKQ6HuCARmFlTtnOEE/5POBkYDGi715T6s6XEWg
	 ysoXsnsge97/g==
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-50943ccbbaeso1843741e87.2
        for <linux-raid@vger.kernel.org>; Thu, 23 Nov 2023 15:58:24 -0800 (PST)
X-Gm-Message-State: AOJu0YxtdunJcVlnHPrP8Ue4DXmo+3RedDE8CPnoz3zg4Y7HgpHLk5BH
	8FXkHy7H7CgCYLHdnrtgULKdjHKylodshuHzCQU=
X-Google-Smtp-Source: AGHT+IF68B6JoyUrCTNB+tjkYLKRYyXubJT1QiW1bVrah1x2Db5/wD44X4wWkf80rkfPY4ecRAQjJ1jDf05LSoSlxZE=
X-Received: by 2002:ac2:488d:0:b0:509:7915:a1d6 with SMTP id
 x13-20020ac2488d000000b005097915a1d6mr451288lfc.58.1700783902510; Thu, 23 Nov
 2023 15:58:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
In-Reply-To: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Thu, 23 Nov 2023 15:58:09 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
Message-ID: <CAPhsuW4z7U-Aq=YemQjFKtcaB7k9x+T_=zM8oBkR3aK2fRzo=A@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Thanks for the report.

On Wed, Nov 22, 2023 at 1:42=E2=80=AFAM Alexander Lyakas <alex.bolshoy@gmai=
l.com> wrote:
>
> Hello Song Liu,
>
> We had a raid6 with 6 drives, all drives marked as In_sync. At some
> point drive in slot 5 (last drive) was marked as Faulty, due to
> timeout IO error. Superblocks of all other drives got updated with
> event count higher by 1. However, the Faulty drive was still not
> ejected from the array by remove_and_add_spares(), probably because it
> still had nr_pending. This situation was going on for 20 minutes, and
> the Faulty drive was still not being removed from the array. But array
> continued serving writes, skipping the Faulty drive as designed.
>
> After about 20 minutes, the machine got rebooted due to some other reason=
.
>
> After reboot, the array got assembled, and the event counter
> difference was 1 between the problematic drive and all other drives.
> Even count on all drives was 2834681, but on the problematic drive it
> was 2834680. As a result, mdadm considered the problematic drive as
> up-to-date, due to this code in mdadm[1]. Kernel also accepted such
> difference of 1, as can be seen in super_1_validate() [2].

Did super_1_validate() set the bad drive as Faulty?

                switch(role) {
                case MD_DISK_ROLE_SPARE: /* spare */
                        break;
                case MD_DISK_ROLE_FAULTY: /* faulty */
                        set_bit(Faulty, &rdev->flags);
                        break;

AFAICT, this should stop the bad drive from going bad to the array.
If this doesn't work, there might be some bug somewhere.

Thanks,
Song

>
> In addition, the array was marked as dirty, so RESYNC of the array
> started. For raid6, to my understanding, resync re-calculates parity
> blocks based on data blocks. But many data blocks on the problematic
> drive were not up to date, because this drive was marked as Faulty for
> 20 minutes and writes to it were skipped. As a result, REYNC made the
> parity blocks to match the not-up-to-date data blocks from the
> problematic drive. Data on the array became unusable.
>
> Many years ago, I asked Neil why event count difference of 1 was
> allowed. He responded that this was to address the case when the
> machine crashes in the middle of superblock writes, so some superblock
> writes succeeded and some failed. In such case, allowing event count
> difference of 1 is legitimate.
>
> Can you please comment of whether this behavior seems correct, in
> light of the scenario above?
>
> Thanks,
> Alex.
>
> [1]
> int event_margin =3D 1; /* always allow a difference of '1'
>        * like the kernel does
>        */
> ...
> /* Require event counter to be same as, or just less than,
> * most recent.  If it is bigger, it must be a stray spare and
> * should be ignored.
> */
> if (devices[j].i.events+event_margin >=3D
>     devices[most_recent].i.events &&
>     devices[j].i.events <=3D
>     devices[most_recent].i.events
> ) {
> devices[j].uptodate =3D 1;
>
> [2]
> } else if (mddev->pers =3D=3D NULL) {
> /* Insist of good event counter while assembling, except for
> * spares (which don't need an event count) */
> ++ev1;
> if (rdev->desc_nr >=3D 0 &&
>     rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
>     (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
>      le16_to_cpu(sb->dev_roles[rdev->desc_nr]) =3D=3D MD_DISK_ROLE_JOURNA=
L))
> if (ev1 < mddev->events)
> return -EINVAL;
