Received: from va-2-59.ptr.blmpb.com (va-2-59.ptr.blmpb.com [209.127.231.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8DC7296BD2
	for <linux-raid@vger.kernel.org>; Mon, 20 Jul 2026 02:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784513674; cv=none; b=b2NyxODFsifjRV+BLm8j01zLOtVtjrxLQxXSR383zoIYOeIlDQ4+EF9fLCc+qhEccLGz9/E7vADaWXuB+4uUnLQFIM1FCQQtFaKpoUYFkGCubVh6u/urC+MnUZY0tvFAWlzophTpp8J3W1JZUj2uHkNsOBcZ7qP2cwtRcGznmRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784513674; c=relaxed/simple;
	bh=M4TgcBPe3Z30dLa/4BB7450eAUzd4+RpvxaH3OMCNbs=;
	h=Message-Id:Mime-Version:References:From:Date:Content-Type:
	 In-Reply-To:To:Cc:Subject; b=trNtY2R3BFttLa1PSVzZLGWZg1Fl13c1/ywwmWkA64Af+tVLNVEKg+XOHOOTKTAELw61yEo/JxSwEwHb8z9A6n0FNaAXXQ7EhJ05tU0DtUUBeoPPGWeulDSm0SY4JfiL8GHMu6QEb1HA0h4a25hDHpUIzYW9ZnDRYeuCLwB8lzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=gwbzP9aT; arc=none smtp.client-ip=209.127.231.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="gwbzP9aT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784513664;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=CLeWNEBG5YoIGpJff8b6+Q1H22MYvvqlFwBXFhR8z48=;
 b=gwbzP9aTzWz7Dy9wZfu+VAtFT9lzDZ1FKGPTCcGyR8KorVVVz0FT/0qBzUYqOVIDnqI/1H
 4Xe+CBLV3jeHnsF3uoDwdTH+IhfL/UW2uTB1JOVcnRPpHDPlnJn5sdtU0vsryWapP0kQ9s
 1gbxndMQza6bPs554zfRmIVJ+CT1EuvqNgiprEYQF4+gZoEUhRe36Tdb9ybxLSfEC9MfGA
 4X97UkW6af1MZSQO8/q03rv2J2jwMDM1BaPMKJDiE8C522pZ906GrYOGJRhnX3XQExiZKC
 b+ElEW/qI893wf0RL7LQ/U/p0C+2lpl4BIPqLr6jhu7DSfnDieB0R1bMmP2kRg==
Reply-To: yukuai@fygo.io
Message-Id: <62a37894-c752-42b2-a54e-92b6247af3df@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26a5d847f+1676e1+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
References: <20260719144409.940492-1-mykola@meshstor.io> <20260719144409.940492-5-mykola@meshstor.io>
X-Original-From: yu kuai <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Date: Mon, 20 Jul 2026 10:14:19 +0800
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Mon, 20 Jul 2026 02:14:22 +0000
In-Reply-To: <20260719144409.940492-5-mykola@meshstor.io>
To: "Mykola Marzhan" <mykola@meshstor.io>, "Song Liu" <song@kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] md: include events counters when kicking non-fresh device
Content-Transfer-Encoding: quoted-printable

Hi,

=E5=9C=A8 2026/7/19 22:44, Mykola Marzhan =E5=86=99=E9=81=93:
> When analyze_sbs() kicks a member with a stale events counter, the
> warning names the device but not the divergence that caused the
> kick, so judging whether the kicked member is salvageable means
> running mdadm --examine on every member.  Print the member's on-disk
> events counter and the freshest events counter in the warning
> itself.

If user space tools can do this already, then user space tools should be
considered preferred.

>
> rdev->sb_events cannot be used here: it is only assigned when a
> superblock is written and still reads 0 during assemble.  Read the
> counter from the superblock page instead -- md_event() for 0.90
> metadata, the little-endian events field for 1.x.
>
> The legacy substring "kicking non-fresh %pg from array!" is
> unchanged, so existing log parsers continue to match.
>
> Assisted-by: Claude-Code:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
> ---
>   drivers/md/md.c | 25 +++++++++++++++++++++++--
>   1 file changed, 23 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d60ea7aaca3a..9ec87375a717 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -3934,8 +3934,29 @@ static int analyze_sbs(struct mddev *mddev)
>   		if (rdev !=3D freshest) {
>   			if (super_types[mddev->major_version].
>   			    validate_super(mddev, freshest, rdev)) {
> -				pr_warn("md: kicking non-fresh %pg from array!\n",
> -					rdev->bdev);
> +				u64 rdev_events =3D 0;
> +
> +				/*
> +				 * rdev->sb_events is only assigned when
> +				 * writing a superblock and reads 0 during
> +				 * assemble; read events from the on-disk
> +				 * superblock instead.
> +				 */
> +				if (rdev->sb_page) {
> +					if (mddev->major_version =3D=3D 1) {
> +						struct mdp_superblock_1 *sb =3D
> +							page_address(rdev->sb_page);
> +						rdev_events =3D le64_to_cpu(sb->events);
> +					} else if (mddev->major_version =3D=3D 0) {
> +						mdp_super_t *sb =3D
> +							page_address(rdev->sb_page);
> +						rdev_events =3D md_event(sb);
> +					}
> +				}
> +				pr_warn("md: kicking non-fresh %pg from array! (events=3D%llu, fresh=
est=3D%llu)\n",
> +					rdev->bdev,
> +					(unsigned long long)rdev_events,
> +					(unsigned long long)mddev->events);

And I don't like the above changes. If you really want such log, please add
it inside validate_super() methods.

>   				md_kick_rdev_from_array(rdev);
>   				continue;
>   			}

--=20
Thanks,
Kuai
