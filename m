Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62EA33997
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 18:15:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731521714; cv=none; b=p3a5mX8WebLlLe5f3kcLQk+JHlV/c3hlCjaAE15VyeM0ieAK7I5IDwm+3BmA/Wods2/fy0MdBnubtktrZWcks7kxAEZYYtzMq8OK7iyIknOVtkz1wbSX1hTB33N91y1XZlxmS9nLU8e5n+zrPLSm+0mfO+VBTyOiC7xGN95gMFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731521714; c=relaxed/simple;
	bh=rL7KyFI5cRjOjZKhB7qmCrja2V7+Pm2gyXHbeOvLZYQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g/1BgXHtSwxbD9Fh+3CT0ALtY6PTOm3y3wscDvy6RXREUI+9Y/iJyxk0bcNWiCpKChz+9ER8dwGAUF2vll6Ddib+vvqUI8UWRYgmtSdfHh+NFYIZhaT5MomXH6vehh12JKdggu1H98CgPBmXaj9KArhpavIQUM4KP2gj7dNJMD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N3rPh0sY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N3rPh0sY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A0E8C4CED2
	for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731521714;
	bh=rL7KyFI5cRjOjZKhB7qmCrja2V7+Pm2gyXHbeOvLZYQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=N3rPh0sYwFC239/tYYEcD9NXRZ11DAu9fsm+mDY9jq310KkZFqWrfS+gG9hH/r90M
	 nXcl9toPxc8j1NymUsnriSDxoGTpyaTEWW1v87MMcK1SsUUpJYYxiYjQqFo969PM0/
	 bMdVqlbgHGS6RRrDXtTGa16W3mNpV25YAFenrU+WXtBzVADx0rFoKL1mLKSQ7AaH0Q
	 9hksmYq94c5idVd/eJssPrSj7c0A7y0+OA37GCffCg3SUFnrfwonXtITjOS3w5lbDe
	 fkVDBTd6TlPNJ+/GIOpTYNibjeSBlUsgJC6I4UT6ztkspXlPQmN3idyJc2WraazNmH
	 h5hwuXzigVyAg==
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a3b4663e40so26133735ab.2
        for <linux-raid@vger.kernel.org>; Wed, 13 Nov 2024 10:15:14 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXdWYUJTq/hq3B51C7qUG/I7f7KZR1rWyRxg9fNBVOJcNA40Z6juYcdA0QuVi82m3W9P74TgZlIZXLr@vger.kernel.org
X-Gm-Message-State: AOJu0YwWgtXKyGdeIP5hAqydvzKnVbzq7lUbMx4GJ/1sc9ldR4F8FLUR
	sKTAeejLHeCd+4ronlcOE2866XxOLtmAzJgRl15euMJ/d/o972oa2thh0jC4HQHPhpn4nAx5JoB
	D9NJuPvvJBcLDaG/V7AVSVMRSINo=
X-Google-Smtp-Source: AGHT+IHI93qXJL0lw6u/pnTqSOGDJhkKmq2+WVDg66TSxeCHYspdTaAydpDyb90fB81FJF9uB9g04CBYyxpejP2/sC8=
X-Received: by 2002:a05:6e02:3f0e:b0:3a7:1b59:a06b with SMTP id
 e9e14a558f8ab-3a71b59a42dmr25473105ab.8.1731521713821; Wed, 13 Nov 2024
 10:15:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241112161019.4154616-1-john.g.garry@oracle.com>
 <20241112161019.4154616-2-john.g.garry@oracle.com> <CAPhsuW4JstsuyDnXfWuDocr+uVfq72SnmF82f-6KBy2tu3-XOQ@mail.gmail.com>
 <fcb1399d-d28b-4e89-be9e-d260f05d6c8a@oracle.com> <CAPhsuW5DC3aP8p3gMWgS0H9eGBzfNwSWOJyNCBK9Syf5Ym2nJg@mail.gmail.com>
 <46c9b171-25bb-45a6-ab4c-990815f5c68b@oracle.com>
In-Reply-To: <46c9b171-25bb-45a6-ab4c-990815f5c68b@oracle.com>
From: Song Liu <song@kernel.org>
Date: Wed, 13 Nov 2024 10:15:02 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6SXTQeh0AESqk_E7c3FceQgQyPwRFUce64sFAmHeVQcA@mail.gmail.com>
Message-ID: <CAPhsuW6SXTQeh0AESqk_E7c3FceQgQyPwRFUce64sFAmHeVQcA@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid5: Increase r5conf.cache_name size
To: John Garry <john.g.garry@oracle.com>
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 13, 2024 at 2:18=E2=80=AFAM John Garry <john.g.garry@oracle.com=
> wrote:
>
> On 12/11/2024 23:05, Song Liu wrote:
> >>> WDYT?
> >> Indeed it is confusing...
> >> So the string is "raid%d-%s", which is
> >> 4B for "raid"
> >> 10B for max int (right?)
> >> 1B for '-'
> >> 32B for DISK_NAME_LEN
> >> 1B for NUL
> >>
> >> which totals 48
> >>
> >> So I don't know why/how 38 is ok. Maybe there is some auto-padding goi=
ng
> >> on, like you hint at.
> >>
> >> Maybe just using 48 is better.
> > Makes sense. I will update the patch to use 48, and apply it to md-6.13=
.
>
> ok, thanks.
>
> And let me know what you think of 2/2, I am even less happy about the
> solution there.

2/2 will go through the device mapper side. Please refer to the following
(from MAINTAINERS).

DEVICE-MAPPER  (LVM)
M:      Alasdair Kergon <agk@redhat.com>
M:      Mike Snitzer <snitzer@kernel.org>
M:      Mikulas Patocka <mpatocka@redhat.com>
L:      dm-devel@lists.linux.dev
S:      Maintained
Q:      http://patchwork.kernel.org/project/dm-devel/list/
T:      git git://git.kernel.org/pub/scm/linux/kernel/git/device-mapper/lin=
ux-dm.git

Thanks,
Song
