Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A95C586330
	for <linux-raid@vger.kernel.org>; Tue,  7 Jan 2025 22:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736290750; cv=none; b=kfAdY/aw6umPAOD8qin4QyRUUIMHQzpMxmtkjdzwZ1O9G/H8R04gFnkGplyP7PQ8X76V1m/GqWvNbZ9e7owJannGHYhvYDximZxvqrkitfImZnl/MDnfFd+uEiEPxKY8xXSPDIUmwgNUgpeG+Yv0aWZtA+xfNvoWILk8uzyYFs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736290750; c=relaxed/simple;
	bh=bPiKdjxo1xXyX8aYUCWqtq0B5DatB+cXLnAGx9Gfx8Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=krko0NWT/UwbnA/1q4qi5sZneFf4IeVZtHo0eamD1MfXGGIz2OzBHL898bIt2hpRtKEELBQ1Gv3883SD7lKvOLhwalzLQKq1b8Ocu+8GO5hYDs0Od0f+p+juVyK6h0y10lS2vtIvtyjUuQrEvpKGmdSqrVAc5Z8uWc1resKtoP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WPkc+fTA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WPkc+fTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F7D7C4AF09
	for <linux-raid@vger.kernel.org>; Tue,  7 Jan 2025 22:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736290750;
	bh=bPiKdjxo1xXyX8aYUCWqtq0B5DatB+cXLnAGx9Gfx8Y=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WPkc+fTABy7PHjRttaYfXOb2JGxZXp2ohPL5NZ7RfzcDYB/LokLOUahQ12y2eTX08
	 Ia/QbbPPZ3klYY3AXrGA3Q8UGC66A5iLwFyMzIwYcIKtVFRmfMZkrw218or+RwVSJU
	 uRKr9+Khdl79CEi5gJmkN/Q4NxVzO9zYX8L5yuh9X+e4vHwTqRmQOsVdpnq8iWc+MJ
	 QVAiSpKkcZqtj7MYwEspLEJBAu/VE8oeun+2v6fQyj52cJEGYbMlkg4CcfYfzthaLh
	 5Z5tK1cbMUY9rPYR1aq8Im+TIWnaMsUwCrI/g1V4mdNr5jLSCS8LFCtRgdogZF29UI
	 0ozn9XOw0HvMg==
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3a9cb8460f7so118646605ab.2
        for <linux-raid@vger.kernel.org>; Tue, 07 Jan 2025 14:59:10 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCX9tVXytOpP/nivsnnhuCwQuGcAVStGYUUpvqZG6+ufVCvW0zZ6hQrN+0IMKohS1EHiuSKfOcibGLcY@vger.kernel.org
X-Gm-Message-State: AOJu0YzIW1N2FoBfQaNUMyssB6rq1DO90QBS48Jm+nsLrj3BlGRoCdAG
	JrgJOzgcedj7TejCr03RMxtmlD+h9MevvZ4lanKg2DFKIUWlvDPOZ6LiuLThgscZy/B+GV3IZ4L
	z0LBzKEhjQrr5+fECjzQIe1lEH7A=
X-Google-Smtp-Source: AGHT+IE8DgkrE/kFX5RgCHfSrE4gMxISVq//Q/Papg0zcPeuQLZfSBiL6anJjzSJRCiyZqj+QvR7ZcukPTzINGXDZuw=
X-Received: by 2002:a05:6e02:1f02:b0:3a7:c5b1:a55e with SMTP id
 e9e14a558f8ab-3ce3a7a8aa1mr8686595ab.0.1736290749787; Tue, 07 Jan 2025
 14:59:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250103103801.1420d5d5@mtkaczyk-private-dev> <20250103115422.20508-1-tomas.mudrunka@gmail.com>
In-Reply-To: <20250103115422.20508-1-tomas.mudrunka@gmail.com>
From: Song Liu <song@kernel.org>
Date: Tue, 7 Jan 2025 14:58:58 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4i4FfgPVzAO-+jcjNHiWUuOrg4g3FKJbzt5f6UU-GbdA@mail.gmail.com>
X-Gm-Features: AbW1kvadwzpj5z-LL9NC1ksd8BS886ZYUI2Ojkwd0vmmxnsB5CGeZuf6bbRXd3Q
Message-ID: <CAPhsuW4i4FfgPVzAO-+jcjNHiWUuOrg4g3FKJbzt5f6UU-GbdA@mail.gmail.com>
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header file
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Cc: mtkaczyk@kernel.org, linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, 
	yukuai3@huawei.com, yukuai@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Tomas,

On Fri, Jan 3, 2025 at 3:54=E2=80=AFAM Tomas Mudrunka <tomas.mudrunka@gmail=
.com> wrote:
>
> > The problem is that system service will recognize raid disks and
> > assemble the array automatically, you might what to disable them.
>
> Actualy user is forced to work with MD device from the get go.
> This is how you would typicaly use mdadm to write metadata to disk:
>
> $ truncate -s 1G test.img
> $ mdadm --create /dev/md0 --level=3D1 --bitmap=3Dinternal --raid-devices=
=3D2 test.img missing
> mdadm: must be super-user to perform this action
> mdadm: test.img is not a block device.
>
> Following is unfit for my usecase:
> * It requires me to reference /dev/md0 (i don't want to involve kernel at=
 all)
> * It requires super-user (no need, i just want to write bytes to my own f=
ile)
> * Refuses to work on regular file (once i run it as super-user)

I think I understand the use case now. One question though: Do
we really need to write the bitmap data at "mdadm --create" time?
Can we instead wait until the array is assembled by the kernel?

Thanks,
Song

[...]
