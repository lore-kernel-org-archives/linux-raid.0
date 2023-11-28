Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5607B53AB
	for <linux-raid@vger.kernel.org>; Tue, 28 Nov 2023 03:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="r2AK5R0s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2A4CC433C7;
	Tue, 28 Nov 2023 03:48:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701143338;
	bh=PVKHaxw29CXdPuv0Tdfwu+PUXQdjfm5GiOBmQ4yY6rc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=r2AK5R0s4zEPQ+xq1D2IBOnv+3ogybxvlBWJ1CstUx1dZuF3q4/hpGM6CrL/TfYSH
	 /PwMDaIJ10Dmtwpc1NogLyoIIRuVukm602uCgenlIL/ZVsm2uEkRUaQnzApNQUmI7F
	 GAUl2OMB6nWPJO7VAW92ML/HBccrBCiexCdtw2uxZMqz2xbFJ2TfnpgYM4x9hbCXlB
	 7XQXGvp0xjTIdzMEW36oHfZ+YpYp+Hr23G194i3JtodMQude7t69zHpe4WMzFiKrDq
	 lF/38RPqUugy6NtX7F2RwZ417rNmIhBo4mg736qSeCHc2DtkpTtjl+6yewhA4LKmh9
	 Lxgt7tp6kumtA==
Received: by mail-lj1-f182.google.com with SMTP id 38308e7fff4ca-2c503da4fd6so60504881fa.1;
        Mon, 27 Nov 2023 19:48:58 -0800 (PST)
X-Gm-Message-State: AOJu0YyNy0T4WgLctlAEs+lVR97jUKYcBz+2HuCP5AKZr8vzB6OQ0Jsh
	0z9EpWVOTsTnfQFHIlLyLNj4NdBvVZ5SOdKHbCM=
X-Google-Smtp-Source: AGHT+IFjsbDzfoxndySx0WSj6G80JiRs8ekfR3AVT8TuyV3YlXwFkCGch9+qwJ0dggg/WcfByATufMWFcjqvkA9ccyA=
X-Received: by 2002:a2e:8650:0:b0:2c9:acf5:18fc with SMTP id
 i16-20020a2e8650000000b002c9acf518fcmr514116ljj.1.1701143337072; Mon, 27 Nov
 2023 19:48:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231124075953.1932764-1-yukuai1@huaweicloud.com>
 <20231124075953.1932764-2-yukuai1@huaweicloud.com> <CAPhsuW5mjvpMmEN5g_-ADQgJKZ1=QyNxxSw-7kq-W2jww09Aag@mail.gmail.com>
 <e3b8298c-1154-c5ce-d025-b9346a6cd2ab@huaweicloud.com>
In-Reply-To: <e3b8298c-1154-c5ce-d025-b9346a6cd2ab@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Mon, 27 Nov 2023 19:48:45 -0800
X-Gmail-Original-Message-ID: <CAPhsuW65mcz3xLH7FH+ZceLmuMx9uLqKr7a3d9LB=nHgEJkWsg@mail.gmail.com>
Message-ID: <CAPhsuW65mcz3xLH7FH+ZceLmuMx9uLqKr7a3d9LB=nHgEJkWsg@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] md: fix missing flush of sync_work
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: xni@redhat.com, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 27, 2023 at 6:07=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2023/11/28 8:02, Song Liu =E5=86=99=E9=81=93:
> > On Fri, Nov 24, 2023 at 12:00=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.c=
om> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> Commit ac619781967b ("md: use separate work_struct for md_start_sync()=
")
> >> use a new sync_work to replace del_work, however, stop_sync_thread() a=
nd
> >> __md_stop_writes() was trying to wait for sync_thread to be done, henc=
e
> >> they should switch to use sync_work as well.
> >>
> >> Noted that md_start_sync() from sync_work will grab 'reconfig_mutex',
> >> hence other contex can't held the same lock to flush work, and this wi=
ll
> >> be fixed in later patches.
> >>
> >> Fixes: ac619781967b ("md: use separate work_struct for md_start_sync()=
")
> >
> > This fix should go via md-fixes branch. Please send it separately.
>
> This patch alone is not good, there are follow up problems to be fixed
> completely after patch 5. Can this patchset applied to md-fixes?
>
> Or I can split patch 1,4 and 5 for md-fixes, and keep others to md-next.

Yes, please split the patches into two sets.

Thanks,
Song
