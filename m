Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F9922CBD9
	for <linux-raid@vger.kernel.org>; Sun,  2 Aug 2026 20:49:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785703748; cv=none; b=JP2XNHI6zqjI42+6WFvJbECALDJfmHmX9LReelgalYv6agC77VIIC3h7KkS91EuFXfQhQkwOrZ2KvbcwMwkrYmQQEH3K9+u2aBTmEp4bnmZM30Ei+atbNLtbFMoNkQUfnbYGZLWVs0B/4yMnOragtd2r3J5e7E1E44zn2FuGb80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785703748; c=relaxed/simple;
	bh=K5Lce37E95w8UomaSi22a9FoCxNVsVoXWtd3U/Sqocs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=OXS+u4Dw+ho992k4J8GDTTrUKjgQ0Troo497nYRsCidDdOI4ZhcJ+R2rd5BGPc8CM7ph6SgDLpHzq+qbXBzBRHy1DgyDbf8CRJ9bi8ms/WacanwbPgabJ4Mj8KnW5H/uu6X1zKhK6yOpYKQI1DZcCnk7HXL682A7jeZ/GNUfTXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GH4cUpIy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GH4cUpIy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C11C1F00A3A;
	Sun,  2 Aug 2026 20:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785703746;
	bh=2rGpKbOE9yymAKgpaUU5kwoDV0WjG+kLnkjb73Ph2s0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GH4cUpIyIsixrq5RcU2OKqHA0BT0aKFbFjAaod0FfotpKdHWjPplrBM6JvJnmouug
	 pqkARJ/B+znhBjVp5QfGuxTOKTof9I1YLsMQeGuRBXwy7GVneMnAJEPnSHuff7lfgn
	 tBbNVFdNWHoMYlDfwzaRVMt5hzPAx0hknh1HF+fgb3cwZer1cPWJpxxcEo95IkOLnP
	 n0IUENIeLh4/arbwjwt4VvD/g302Bkv+hOXQGYjIbPtSKN2IcZnV6MzHfTZknagtvp
	 4sKSTLgvDvpOpjHdn9IsAPkf0OBEIdAySxlZboH3hvx2vIr6YLLiIunziAoiLosu4P
	 sUsyM1pnW/23w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 24/29] md/raid10: wire llbitmap reshape lifecycle
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260802195038.164272-25-yukuai@kernel.org>
References: <20260802195038.164272-1-yukuai@kernel.org>
 <20260802195038.164272-25-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 02 Aug 2026 20:49:05 +0000
Message-Id: <20260802204906.2C11C1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Hardcoded check for `ID_LLBITMAP` in `raid10_finish_reshape()` viol=
ates the `bitmap_ops` vtable abstraction.
--

--- Patch [24]: [PATCH v5 24/29] md/raid10: wire llbitmap reshape lifecycle=
 ---
commit 2a0099dd424ef7b25245673edf0ef62577007cc4
Author: Yu Kuai <yukuai@fygo.io>

md/raid10: wire llbitmap reshape lifecycle

This commit wires up the llbitmap reshape lifecycle in the RAID10 subsystem.
It prepares the bitmap before the array starts growing, checkpoints it
during the reshape process, and finalizes the geometry update upon completi=
on.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 1c3393467667b..bac9edd28c974 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -5011,10 +5034,15 @@ static void end_reshape_request(struct r10bio *r1=
0_bio)
>  static void raid10_finish_reshape(struct mddev *mddev)
>  {
>  	struct r10conf *conf =3D mddev->private;
> +	bool llbitmap =3D mddev->bitmap_id =3D=3D ID_LLBITMAP &&
> +		md_bitmap_enabled(mddev, false);
> =20
>  	if (test_bit(MD_RECOVERY_INTR, &mddev->recovery))
>  		return;
> =20
> +	if (llbitmap && mddev->bitmap_ops->reshape_finish)
> +		mddev->bitmap_ops->reshape_finish(mddev);
> +

[Severity: Low]
Does this explicit check for ID_LLBITMAP defeat the purpose of the bitmap_o=
ps
vtable abstraction?

Earlier in the file during raid10_start_reshape() and end_reshape(), the co=
de
relies entirely on checking if the virtual function pointers like
reshape_can_start or reshape_mark are set. By hardcoding a check for
mddev->bitmap_id =3D=3D ID_LLBITMAP here, it leaks internal knowledge of wh=
ich
specific bitmap type supports reshape_finish.

Would it be better to just rely on mddev->bitmap_ops->reshape_finish being
non-NULL, so that any future bitmap type implementing this hook won't be
silently bypassed?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260802195038.1642=
72-1-yukuai@kernel.org?part=3D24
