Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311C720F3
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 03:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="otkDSzKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A534FC433C8
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 03:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701143468;
	bh=/YzIWnJqUgOIxQHJnNiBqkKvOhhQbCUg/qEa2uYbgjA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=otkDSzKhHLzT9KkvXcheoXq+jCW0phh+m/gxy8E9A7NfV2fcggkyOVitAT4qTEi46
	 asTqgdtGzT56KzuYI8XEVye3Q89GrUXZN9Wpm63VCzIcYVTrIk+AG5G3hmlb8EaJvj
	 MLFimqMKTwg8WSSD5NHz7mP5ECbdA1T7hVH5/zIXxiBWeDjBBHdgZMUtsHeZumFjDR
	 /x99FJPmt076ldGxqQ6gpR9SKledZBzebJfzdadQrt4Tke3bMfjKaDRR1ZHeFLtjF3
	 txa8nyHOkExFYXbSssSSgnz6/K3IyCqPE5Y6wz1+c8hFwo+kAG6dHphZJPQ1zQUI92
	 mDwONA76Qszvw==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-50baa1ca01cso3724790e87.2
        for <linux-raid@vger.kernel.org>; Mon, 27 Nov 2023 19:51:08 -0800 (PST)
X-Gm-Message-State: AOJu0YzjatvbpbCXpL+DthVRGwE33RFMIvFqAfO/Tv9Qf4YlVR02J4sM
	PwGPChZZwspv3Hm4k6eqywH0jPaEosxw79suisI=
X-Google-Smtp-Source: AGHT+IH0oAK1zx37c6YU2hsdCyTyFtG/RTvCy0z1SLOhhiL2D7+CH6bEb1XMQLiUpbhEg9p9ZL8xS6UOswORIZDcLoM=
X-Received: by 2002:a2e:934f:0:b0:2c5:32b:28ea with SMTP id
 m15-20020a2e934f000000b002c5032b28eamr9172172ljh.32.1701143466875; Mon, 27
 Nov 2023 19:51:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231108182216.73611-1-junxiao.bi@oracle.com> <20231108182216.73611-2-junxiao.bi@oracle.com>
 <CAPhsuW5HCEbxTciUDiBJ-RkNBbmf76RSZZWvc88ABX172CCsOw@mail.gmail.com> <33b81c46-4d82-4bf1-9892-2c213c0b3d64@oracle.com>
In-Reply-To: <33b81c46-4d82-4bf1-9892-2c213c0b3d64@oracle.com>
From: Song Liu <song@kernel.org>
Date: Mon, 27 Nov 2023 19:50:54 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5kxfjHw_R6uhvqhSh7d_J0p89__u59kWXK1xTiPda4Wg@mail.gmail.com>
Message-ID: <CAPhsuW5kxfjHw_R6uhvqhSh7d_J0p89__u59kWXK1xTiPda4Wg@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] Revert "md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5d"
To: junxiao.bi@oracle.com
Cc: linux-raid@vger.kernel.org, logang@deltatee.com, yukuai1@huaweicloud.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 24, 2023 at 3:18=E2=80=AFPM <junxiao.bi@oracle.com> wrote:
>
> On 11/24/23 9:29 AM, Song Liu wrote:
>
> > On Wed, Nov 8, 2023 at 10:22=E2=80=AFAM Junxiao Bi <junxiao.bi@oracle.c=
om> wrote:
> >> This reverts commit 5e2cf333b7bd5d3e62595a44d598a254c697cd74.
> >>
> >> That commit introduced the following race and can cause system hung.
> >>
> >>   md_write_start:             raid5d:
> >>   // mddev->in_sync =3D=3D 1
> >>   set "MD_SB_CHANGE_PENDING"
> >>                              // running before md_write_start wakeup i=
t
> >>                               waiting "MD_SB_CHANGE_PENDING" cleared
> >>                               >>>>>>>>> hung
> >>   wakeup mddev->thread
> >>   ...
> >>   waiting "MD_SB_CHANGE_PENDING" cleared
> >>   >>>> hung, raid5d should clear this flag
> >>   but get hung by same flag.
> >>
> >> The issue reverted commit fixing is fixed by last patch in a new way.
> >>
> >> Fixes: 5e2cf333b7bd ("md/raid5: Wait for MD_SB_CHANGE_PENDING in raid5=
d")
> >> Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
> > The set looks good to me. Thanks!
> Thanks for the review.
> >
> > Quick question: from the earlier thread, the issue was observed in
> > production. Have you reproduced the issue and thus verified the fix
> > works as expected?
>
> I didn't try reproducing this since the system hung on the code where
> the bad commit added, after revert it, this issue will not reproduce any
> more.

Thanks for the information. I applied the set to md-next.

Song
