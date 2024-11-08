Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C49B41BD9FF;
	Fri,  8 Nov 2024 01:28:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731029335; cv=none; b=T+kZGgPyOCyAZnEPfLVNkGJK40JJj87E11Eec9H4uqYeE3dIc9v9E5svOwQ052FR1NdmHCYGWOCGRvN3sDKIN8VlsMEEtaXjSVDguiYJqAborHVHO408wf2d8GWDnnSL76QaMnKrYtd2vpAydP6j4c6EO+zOVdMbgmUw3XSvEtk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731029335; c=relaxed/simple;
	bh=orXzfModlC+h8VXuMWnwE+DTQBw5X/hVKIxqx7Bad7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MLZvYPI7ILm6nFlqm1HXmEvvXSNXbruOihwspesu0BXVNO756BKgFmPuE9bfi6y4SlqiHBdwRmC7yhD0MLy4aN5WZ5vxeH+S05mZGSOeN/fMWt1sxuIaVUeJmRZx0UsLhxV21AgIv0ZvXXRX/oB+4zLv+ZzMfVWjKdUnSDeZhOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qs2kRLz8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qs2kRLz8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B3D6C4CED3;
	Fri,  8 Nov 2024 01:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731029335;
	bh=orXzfModlC+h8VXuMWnwE+DTQBw5X/hVKIxqx7Bad7I=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=Qs2kRLz8n0tn+EhumEYCQ4J9RKwQ5cGQn00kHJjtJLDQUGWv9TLtKSs776mJXLwRA
	 aBzR8xIknDNG0sHvEUAfUEEjOMf4Ie5R7vQI1u7+Fjtky3ebN78V0NqKEOko9hC4Wf
	 99+8nIz2dCAHABIYNJRllBVjjFgS3LYItUpEvdTNwxFV7qf9XgNq6w1KGQ7Ybm9SX+
	 CU9nRsZCTYboiqQzxqdvE3AD9M7Q3wQ7A7AWEVKtWTpNY4EpEHoiNRFPcuGcgEAxjd
	 7FGoDb3nNxtAjvnc3bSefp8HAIW7Tlb/zXicoKtHKmaPKoDne7v2mH6Ldhf82LwrXA
	 vGVHrrz3egduQ==
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a6e960fa2dso5483815ab.0;
        Thu, 07 Nov 2024 17:28:55 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWCHaI+RJjRUKbBQNsj2lu20hO2h3Q7JAXN11JWuVQVbYJE3x1ANSBaTra7rctXNkZKwzYzUNwg4JE7D7w=@vger.kernel.org
X-Gm-Message-State: AOJu0YyEOqdbAaRm2YAbQ3u28byP3QgowHim9utxl5cx1lTkUHDjAnc+
	WMbEv0HidPpkbj2p5jyFcJvzrYUnQzx57wVNPbD+idDCaO8hjXO8ze+HfWXzXGymF1HCr5JYhCP
	VgfZcbItAPaSlqDyvvwDU7rIbB4k=
X-Google-Smtp-Source: AGHT+IGgh52W80CXpJXK/c0azIqLpPpL0bGERDo8/cskb2ZEUiH7+HGQ8Cf3OHlPvz3jONXeE41gBvevmpiJaMmf8h0=
X-Received: by 2002:a05:6e02:2686:b0:3a0:bd91:3842 with SMTP id
 e9e14a558f8ab-3a6f1a75a07mr15375065ab.24.1731029334738; Thu, 07 Nov 2024
 17:28:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com> <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
In-Reply-To: <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 7 Nov 2024 17:28:43 -0800
X-Gmail-Original-Message-ID: <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
Message-ID: <CAPhsuW4tcXqL3K3Pdgy_LDK9E6wnuzSkgWbmyXXqAa=qjAnv7A@mail.gmail.com>
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 7, 2024 at 5:03=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> Hi,
>
> =E5=9C=A8 2024/11/08 7:41, Song Liu =E5=86=99=E9=81=93:
> > On Thu, Nov 7, 2024 at 5:02=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com=
> wrote:
> >>
> >> From: Yu Kuai <yukuai3@huawei.com>
> >>
> >> The bitmap file has been marked as deprecated for more than a year now=
,
> >> let's remove it, and we don't need to care about this case in the new
> >> bitmap.
> >>
> >> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> >
> > What happens when an old array with bitmap file boots into a kernel
> > without bitmap file support?
>
> If mdadm is used with bitmap file support, then kenel will just ignore
> the bitmap, the same as none bitmap. Perhaps it's better to leave a
> error message?

Yes, we should print some error message before assembling the array.

> And if mdadm is updated, reassemble will fail.

I think we should ship this with 6.14 (not 6.13), so that we have
more time testing different combinations of old/new mdadm
and kernel. WDYT?

Thanks,
Song
