Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144ADDDC5
	for <linux-raid@vger.kernel.org>; Sat,  8 Jun 2024 04:21:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717820508; cv=none; b=FMYTOLoBKgngZPtBHMiIf6ckx1amBg3gem4r0fVZe8Sn5Kl//Ha8fe+nGVv9cQ5JQ9t9o+/0araacIsBTg+mBTbNK19/DEOydPTaZZZcTAzTBIMZxxncpzgFdbhEV2LVFNMI4AhdyxpfsB1hGK/PByUNruWfmBMqEwksu+VxDfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717820508; c=relaxed/simple;
	bh=GzFN+TcIvqK5OC+jXn4CvmH0/eMd8vANN4k/nNiDDQQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hcGuYBN7xYL540//UqRH5GnJVa5ouRL0naQpATXJzcow43HqYwiUbvJ32/5OY+PbbpExmCf6VwYoCBCxH2sqA14R+YiXwjZx5V0I+OI6chyCiWzVJnW08RgyY/yBBNG0iwj01vdBGFXw3j+iax4Ifp46WWFy8trEwVF6M2SV3Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ruVj+pov; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ruVj+pov"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D025C4AF08
	for <linux-raid@vger.kernel.org>; Sat,  8 Jun 2024 04:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717820507;
	bh=GzFN+TcIvqK5OC+jXn4CvmH0/eMd8vANN4k/nNiDDQQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=ruVj+pov58EG3758/ciTiSkJf3REXIoHoZTYxYI38UZbFxttpGDrATZ/XViZWxkun
	 5HIuh0VjrbGSI1FntVlXcP025ZTYgCrJxRvXksHIJ0tdszHE5HjAkO3wGcTB0UIJrI
	 UDVjbNwoeOgUSfBHJOyoYr3/aGlRTYPb6rb464Ry0yLZTZPDTWS8588pnh5wcscs90
	 pF4z856vteg2oKOUFCakh9NVtR8xvNuMJZGEGlFwYjbBJPqTiOfHMcleKd426+kPWX
	 J2jZx5WR0o5VvT6Y56cKdAVcpwt9p/jf9ctYMYabgz2NZ2MqcfiZgGMXWHcHuM0u1Y
	 JXz9FrAiPWj9g==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2eaafda3b5cso35086151fa.3
        for <linux-raid@vger.kernel.org>; Fri, 07 Jun 2024 21:21:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCW+B4Q3kfZfeg/7B5Nll/LhP8B6I5Qb/nDaFuyqIR63xrge/oeH5pkcItZ07FbvqGSJ9Eq+HRCHCoXZZ7cBt++QG52C3Jrl4cLHwg==
X-Gm-Message-State: AOJu0YztlEGmnb8+JvYb4rGcH5+R/H/e/qOA8JPkG7hOrtkprsRdACPZ
	IJsibfK+W61vSG+lAx654vLyOuNkNynnRrarM7nUhSichYLU7QuVyjCWVO4SRRix/Nmwhl/eHQB
	F9Qhzmf0BhRK/z6FbaUyXCmqnzY4=
X-Google-Smtp-Source: AGHT+IHtdcs3NO3qqQvOGFl5bx/OBMMTFxfiCuxpnkc4ajMwqSY+pRTooCC74eruD6NHvSPz0Y4BqhiRBG7sXHHvfIE=
X-Received: by 2002:a2e:97d1:0:b0:2eb:2e4e:16e4 with SMTP id
 38308e7fff4ca-2eb2e4e17a0mr8696541fa.14.1717820505914; Fri, 07 Jun 2024
 21:21:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603215558.2722969-1-aahringo@redhat.com> <20240603215558.2722969-9-aahringo@redhat.com>
 <CAK-6q+i18_oHfdh6Odfidi0y4hWiR9bn_svWf2BwPqnLwdEFGQ@mail.gmail.com>
 <41da824f-f3e5-429f-a701-5feddf8b2ed1@suse.com> <CAK-6q+j0rbQ2CZ9y9wxZBUxsgGV03nF+ahVZPJEQPoUW-Mc8nQ@mail.gmail.com>
In-Reply-To: <CAK-6q+j0rbQ2CZ9y9wxZBUxsgGV03nF+ahVZPJEQPoUW-Mc8nQ@mail.gmail.com>
From: Song Liu <song@kernel.org>
Date: Fri, 7 Jun 2024 21:21:34 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6pyJ8rQ5BHG_ocJaR+ARbZwFZZm+e7bBRgTagvddr5Jg@mail.gmail.com>
Message-ID: <CAPhsuW6pyJ8rQ5BHG_ocJaR+ARbZwFZZm+e7bBRgTagvddr5Jg@mail.gmail.com>
Subject: Re: [PATCH dlm/next 8/8] md-cluster: use DLM_LSFL_SOFTIRQ for dlm_new_lockspace()
To: Alexander Aring <aahringo@redhat.com>
Cc: Heming Zhao <heming.zhao@suse.com>, yukuai3@huawei.com, teigland@redhat.com, 
	gfs2@lists.linux.dev, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 6, 2024 at 7:34=E2=80=AFAM Alexander Aring <aahringo@redhat.com=
> wrote:
>
> Hi Heming,
>
> On Wed, Jun 5, 2024 at 10:48=E2=80=AFPM Heming Zhao <heming.zhao@suse.com=
> wrote:
> >
> > On 6/6/24 02:54, Alexander Aring wrote:
> > > Hi,
> > >
> > > On Mon, Jun 3, 2024 at 5:56=E2=80=AFPM Alexander Aring <aahringo@redh=
at.com> wrote:
> > >>
> > >> Recently the DLM subsystem introduced the flag DLM_LSFL_SOFTIRQ for
> > >> dlm_new_lockspace() to signal the capability to handle DLM ast/bast
> > >> callbacks in softirq context to avoid an additional context switch d=
ue
> > >> the DLM callback workqueue.
> > >>
> > >> The md-cluster implementation only does synchronized calls above the
> > >> async DLM API. That synchronized API should may be also offered by D=
LM,
> > >> however it is very simple as md-cluster callbacks only does a comple=
te()
> > >> call for their wait_for_completion() wait that is occurred after the
> > >> async DLM API call. This patch activates the recently introduced
> > >> DLM_LSFL_SOFTIRQ flag that allows that the DLM callbacks are execute=
d in
> > >> a softirq context that md-cluster can handle. It is reducing a
> > >> unnecessary context workqueue switch and should speed up DLM in some
> > >> circumstance.
> > >>
> > >
> > > Can somebody with a md-cluster environment test it as well? All I was
> > > doing was (with a working dlm_controld cluster env):
> > >
> > > mdadm --create /dev/md0 --bitmap=3Dclustered --metadata=3D1.2
> > > --raid-devices=3D2 --level=3Dmirror /dev/sda /dev/sdb
> > >
> > > sda and sdb are shared block devices on each node.
> > >
> > > Create a /etc/mdadm.conf with the content mostly out of:
> > >
> > > mdadm --detail --scan
> > >
> > > on each node.
> > >
> > > Then call mdadm --assemble on all nodes where not "mdadm --create ...=
" happened.
> > > I hope that is the right thing to do and I had with "dlm_tool ls" a
> > > UUID as a lockspace name with some md-cluster locks being around.
> >
> > The above setup method is correct.
> > SUSE doc [1] provides more details on assembling the clustered array.
> >
>
> yea, I saw that and mostly cut it down into the necessary steps in my
> development setup.
>
> Thanks for confirming I did something right here.
>
> > [1]: https://documentation.suse.com/fr-fr/sle-ha/15-SP5/html/SLE-HA-all=
/cha-ha-cluster-md.html#sec-ha-cluster-md-create
> >
> > >
> > > To bring this new flag upstream, would it be okay to get this through
> > > dlm-tree? I am requesting here for an "Acked-by" tag from the md
> > > maintainers.
> > >
> >
> > I compiled & tested the dlm-tree [2] with SUSE CI env, and didn't see t=
hese
> > patches introduce new issue.
> >
>
> Thanks for doing that. So that means you tried the dlm-tree with this
> patch series applied?
>
> Song or Yu, can I get an "Acked-by" from you and an answer if it is
> okay that this md-cluster.c patch goes upstream via dlm-tree?

LGTM.

Acked-by: Song Liu <song@kernel.org>

Yes, let's route this via dlm-tree.

Thanks,
Song
