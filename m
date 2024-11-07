Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB89D1EC015
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 23:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731022675; cv=none; b=UM1h1KvdREzALcUi+5ULkb4oeDEOSM3bh9Gxba1B+WLb2+/5HrVVbktC0e1FA4Cya18p2d72sbzBh5cA6xeMWnsgYz9TIyn+9KxCdKrGE+8KGP+qHkwDT/+oJGMODoAaEEy6FkTSMH+xqDlBaF1/t1pNVQPULXLk/AhkWzE/Ssw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731022675; c=relaxed/simple;
	bh=wlZ6FFwsZfsrHClbranTZPrrrUIzrmDDsu0qwlPx7ZY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=erV6RSnZM3BVR87tAlXpvRWUIK83AQ7To8oHk0NSYpmCUMKNo8nETVKLER8sQBFPU7SKUhHuOuje4D2K/RuYTrcPCcgTAjzlGOo8JPgqpnZNGL0K/x0fgL9W9I8vNi2fpq7eB1x6WlbV3g+1q+gaLchGtwLejPKKXenXyGUcvOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uqkzZ49b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uqkzZ49b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70849C4CECC
	for <linux-raid@vger.kernel.org>; Thu,  7 Nov 2024 23:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731022674;
	bh=wlZ6FFwsZfsrHClbranTZPrrrUIzrmDDsu0qwlPx7ZY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=uqkzZ49b+mHRZPWmvcTsUg2G42Sy4FzTJC8tpECDS2x9oYtFk3FRP8KftxykRbkzd
	 cxFmwOwvubQyOOM//DcBSRejYx7dhBCax46hQhwFEosBYiRBQs+JI+5NeJoNaIuzvv
	 y+dQOJpzv3xTlFnqa+GIQNKGY8ZnbDC+Cb4a4cIldn+gbJKBPSjgmgOdsh/N7zFyCz
	 imFfL+ZwUpEE3VuHSx2YBi9Nte6kmmpZYQG2QScHU+7EEh93RC37jt0UhoZDKGvLDj
	 zJwbq7Z9iLodyL3Qz+xhaStYRUOAjMBW/MKvQZcc/FtnH6SbH5j7KENzyrF2D1j71u
	 bduy2HxT4UqNQ==
Received: by mail-il1-f180.google.com with SMTP id e9e14a558f8ab-3a6c1cfcb91so6042385ab.0
        for <linux-raid@vger.kernel.org>; Thu, 07 Nov 2024 15:37:54 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVQQSTcgqrk/wnndU/gYrYt2+4M7573slgaMiFA17UYG9Ym900iP3bQ+4L1OnLvk0UK2AXMj4gu1eW1@vger.kernel.org
X-Gm-Message-State: AOJu0YwSx2gH8zADP8w0ttdhziCgWUHctJwnbBObcxFH1/ziRndGPwWA
	AmJeLbuuBT6bBQSBamg5TpsBFyAT9IepgUdhH6v1nzpjsMOoqoaZhoOShyLNxfE5P8Fe5UlnaJV
	Sw7lBzIutgoEe2qeVNIAw8+qCyco=
X-Google-Smtp-Source: AGHT+IHorfH5EGJeV+VyQ/hqAmy3XFcJfn/mu580QZszNWgyFyYvhnCZ+n7D+yfGKXCYtkDWc4+sEpWsqc6/fr98n5I=
X-Received: by 2002:a05:6e02:2148:b0:3a6:c651:3dad with SMTP id
 e9e14a558f8ab-3a6f19c5ef5mr14622035ab.11.1731022673938; Thu, 07 Nov 2024
 15:37:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241106095124.74577-1-xni@redhat.com> <888e7aeb-ca42-792c-5616-5cbaf0f0a952@huaweicloud.com>
In-Reply-To: <888e7aeb-ca42-792c-5616-5cbaf0f0a952@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 7 Nov 2024 15:37:42 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5hgr7qUN4aEWTF3bQa5Zr8bJq=DLW7sRtD2ku1gQsWeA@mail.gmail.com>
Message-ID: <CAPhsuW5hgr7qUN4aEWTF3bQa5Zr8bJq=DLW7sRtD2ku1gQsWeA@mail.gmail.com>
Subject: Re: [PATCH 1/1] md/raid5: Wait sync io to finish before changing
 group cnt
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 5:20=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> =E5=9C=A8 2024/11/06 17:51, Xiao Ni =E5=86=99=E9=81=93:
> > One customer reports a bug: raid5 is hung when changing thread cnt
> > while resync is running. The stripes are all in conf->handle_list
> > and new threads can't handle them.
> >
> > Commit b39f35ebe86d ("md: don't quiesce in mddev_suspend()") removes
> > pers->quiesce from mddev_suspend/resume. Before this patch, mddev_suspe=
nd
> > needs to wait for all ios including sync io to finish. Now it's used
> > to only wait normal io.
> >
> > In this patch, it calls raid5_quiesce in raid5_store_group_thread_cnt
> > directly to wait all sync requests to finish before changing the group
> > cnt.
> >
> > Fixes: b39f35ebe86d ("md: don't quiesce in mddev_suspend()")
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> >   drivers/md/raid5.c | 4 ++++
> >   1 file changed, 4 insertions(+)
> >
> LGTM
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.13. Thanks for the fix!

Song
