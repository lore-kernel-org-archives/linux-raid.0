Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SCSqO/rb"
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5BB4197
	for <linux-raid@vger.kernel.org>; Wed, 22 Nov 2023 04:03:21 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id ffacd0b85a97d-3316c6e299eso3115582f8f.1
        for <linux-raid@vger.kernel.org>; Wed, 22 Nov 2023 04:03:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700654600; x=1701259400; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ug8e0LAInrNR5WplTamLtQmtDI/YVAzzKHYREu70dAs=;
        b=SCSqO/rblZPS4SXkF+REwlyVPFgDgdOLdB8OBgmJZo3l+hFS7H4muXTcsVekjMz5S5
         B924845Iz0ax2ZGwNmUZ+bPn/d82l5dufOcwpN6zP0Giork2yTEbeV5yCAw68Vq0wL9Z
         evLiRQzoivU5JXo6zyKWKAd1G3kQFu94QAkpQtwsvRuAZBTwM61BdDhPf1ZcsiigmfpP
         3u7E7muhMui/ERsld18sWh+cKPYq+jAozvoBqY0wLh7VI+tARN/OOB2jxE3JBNadEi9q
         H7c5jjkbagCtrAZsL7r2KLoui4kBChj8FxeQCb8NXxPTnES81wZ/54JlY5BsK702jHjC
         6MuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700654600; x=1701259400;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ug8e0LAInrNR5WplTamLtQmtDI/YVAzzKHYREu70dAs=;
        b=UsVjhV3IyIaM3HaZBcXnA2Pd9P/ztbLrqwK9Fv6188Uc5UzR07fytYZv1U3BdeNJAM
         4P5M8RA4D7YWgavcgLh4tiQ/hI2+bT0HW8hM1zCjKLR0xY0clcYjgmLKMvNM2ekXgJ2E
         WO3FiGu30XyMi0fORn0b/Ld4gloCyn9dYfKfsChFn6kHBeX04I/+EPcS1e88GE3a8404
         Dfjxk/JUkihb8m1J90/DyITrHGOujL8FhqMe77Oy0dtFMUqpZ2FOxVs5vCHxg9+boAQ1
         flp2eZTkWLlUYLjnPa6bB2rK8nADPdKdXn3bg6sXsRJTJOqoKFQPDah6Lhoqv26NSQaV
         Th/Q==
X-Gm-Message-State: AOJu0YxPApRyakir91e0LweKOS3ceKKqP9tf456d7KWcaUXhFHNjImIg
	GIjqMOO9L8rFaTdDVvrzu/LaRhMXN9/OMv3sfd8=
X-Google-Smtp-Source: AGHT+IEyAK6ZlSqyvYCxnpd8rHJLxt/6Z7/PHa2SPFAWx1Prna0IAyib7cBg+ljLD3vyaJ6QdbEsSeKcj/gC2x8gjPc=
X-Received: by 2002:a05:6000:2c6:b0:331:6bd3:3fbf with SMTP id
 o6-20020a05600002c600b003316bd33fbfmr1608051wry.60.1700654599867; Wed, 22 Nov
 2023 04:03:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGRgLy5E3cb=MS8eSMH03fa27tgFnZp0hwrrobyQMuUU_Axiag@mail.gmail.com>
 <935a3e51-ff76-d9f1-be2c-745f3b1e15b8@huaweicloud.com>
In-Reply-To: <935a3e51-ff76-d9f1-be2c-745f3b1e15b8@huaweicloud.com>
From: Alexander Lyakas <alex.bolshoy@gmail.com>
Date: Wed, 22 Nov 2023 14:03:09 +0200
Message-ID: <CAGRgLy7rghrYzUUzs98pTxy-ppF+9qsC_3jjbe9K_53GUmYBwQ@mail.gmail.com>
Subject: Re: raid6 corruption after assembling with event counter difference
 of 1
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid <linux-raid@vger.kernel.org>, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Yu Kuai,

On Wed, Nov 22, 2023 at 1:36=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/11/22 17:42, Alexander Lyakas =E5=86=99=E9=81=93:
> > Hello Song Liu,
> >
> > We had a raid6 with 6 drives, all drives marked as In_sync. At some
> > point drive in slot 5 (last drive) was marked as Faulty, due to
> > timeout IO error. Superblocks of all other drives got updated with
> > event count higher by 1. However, the Faulty drive was still not
> > ejected from the array by remove_and_add_spares(), probably because it
> > still had nr_pending. This situation was going on for 20 minutes, and
>
> I think this is important, what kind of driver are you using for the
> array? 20 minutes should be enough to let block layer timeout handle to
> finish all the IO. Did you try to remove this disk manually?
I am also not sure why the disk was not ejected from the array for 20
minutes. Removing the disk manually is not possible, as long as md
holds the disk as rdev. Only when md ejects the disk from the array
(via remove_and_add_spares()), then it is possible to remove the disk
from md (mdadm --manage --remove). Anyways, all this was happening on
a production system, without human attendance at that time.

>
> > the Faulty drive was still not being removed from the array. But array
> > continued serving writes, skipping the Faulty drive as designed.
> >
> > After about 20 minutes, the machine got rebooted due to some other reas=
on.
>
> md_new_event is called from do_md_stop(), which means if this array
> stopped, then event counter from other drives will be higher by 2, and
> this problem won't exist anymore. So, I guess you array doesn't stopped
> normally during reboot, and your case really is the same as crashes
> while updating super_block.
Correct. Array was not stopped (via madam --stop). Some of the higher
level scripts decided to hard-reboot the machine.

>
> There is a simple way to avoid your problem, just add event counter by
> 2 in md_error().
>
> Thanks,
> Kuai
> >
> > After reboot, the array got assembled, and the event counter
> > difference was 1 between the problematic drive and all other drives.
> > Even count on all drives was 2834681, but on the problematic drive it
> > was 2834680. As a result, mdadm considered the problematic drive as
> > up-to-date, due to this code in mdadm[1]. Kernel also accepted such
> > difference of 1, as can be seen in super_1_validate() [2].
> >
> > In addition, the array was marked as dirty, so RESYNC of the array
> > started. For raid6, to my understanding, resync re-calculates parity
> > blocks based on data blocks. But many data blocks on the problematic
> > drive were not up to date, because this drive was marked as Faulty for
> > 20 minutes and writes to it were skipped. As a result, REYNC made the
> > parity blocks to match the not-up-to-date data blocks from the
> > problematic drive. Data on the array became unusable.
> >
> > Many years ago, I asked Neil why event count difference of 1 was
> > allowed. He responded that this was to address the case when the
> > machine crashes in the middle of superblock writes, so some superblock
> > writes succeeded and some failed. In such case, allowing event count
> > difference of 1 is legitimate.
> >
> > Can you please comment of whether this behavior seems correct, in
> > light of the scenario above?
> >
> > Thanks,
> > Alex.
> >
> > [1]
> > int event_margin =3D 1; /* always allow a difference of '1'
> >         * like the kernel does
> >         */
> > ...
> > /* Require event counter to be same as, or just less than,
> > * most recent.  If it is bigger, it must be a stray spare and
> > * should be ignored.
> > */
> > if (devices[j].i.events+event_margin >=3D
> >      devices[most_recent].i.events &&
> >      devices[j].i.events <=3D
> >      devices[most_recent].i.events
> > ) {
> > devices[j].uptodate =3D 1;
> >
> > [2]
> > } else if (mddev->pers =3D=3D NULL) {
> > /* Insist of good event counter while assembling, except for
> > * spares (which don't need an event count) */
> > ++ev1;
> > if (rdev->desc_nr >=3D 0 &&
> >      rdev->desc_nr < le32_to_cpu(sb->max_dev) &&
> >      (le16_to_cpu(sb->dev_roles[rdev->desc_nr]) < MD_DISK_ROLE_MAX ||
> >       le16_to_cpu(sb->dev_roles[rdev->desc_nr]) =3D=3D MD_DISK_ROLE_JOU=
RNAL))
> > if (ev1 < mddev->events)
> > return -EINVAL;
> >
> >
> > .
> >
>
>
