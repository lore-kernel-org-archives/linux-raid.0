Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6004AC146
	for <linux-raid@vger.kernel.org>; Wed,  2 Sep 2026 17:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788368920; cv=none; b=itrmp99eCwq9QUK+6F78Y4p1YgZwx3k/Ozg6ywg7FYLRoz/82m1p+EwpR2sWIXjM8wT4oSca06LBcmby/aQhXy4LF/BhIondn8rfJNKxFO+eKi477769hHTWnSXea5XDGpM4uyReK48lniiKDzOP58q4o1cxgMqBTRXAaTDoVYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788368920; c=relaxed/simple;
	bh=tHAFnclF4t/SZ4yrZv5WTR4IqIZjMKHxAPZ3zoylyQw=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=lY6rivRDxAeARmBermKaB7OWbHmd7YHFFQWvTJ3B3rAN8buxg9j8OWQJJIP/PpGObBCsMlPrhFa3OC3tl7cvV2M03LKaaBvo2haFI5IXcilM/eB+oYvGXVFMcvwD4uLHyPulhVhEA3KgshRs8new5acz4kE5BZfK2AF3pCWqppU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTMkl7Ga; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTMkl7Ga"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C64161F000E9;
	Wed,  2 Sep 2026 17:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788368918;
	bh=pQj5BNbm0zWgZ60niD5Yc9N46OpFrGFRMSxJtJ+1bR4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nTMkl7GaRR7rARbBo5nffqTGg+P3DoGAe18j/wXUEsrf3lk6g9ZQexrWIsiJY1ijD
	 KqHEzHr36Xn0tmepYiM+F7Tygi9k3gLQPMAdC80fUk2f6fQYZm5aU+WzkpHagi6Fje
	 TJgJMU9klDLnllfC/ACFXQO1Jw9AIp3nkE9IgEimxq30Yzc5IbPHLQ4A27qy9+G/V8
	 92/bZP3W9sUiyjZ3lDHLuzvLGJ6JZcRPoKw6LY630M7ph9DKm73RI6wUfTNdjkdTQw
	 deF2TYEyXvz5fFQW0noly/+s/PGJIJu82QpL2JKw7Iau/OczcO4NK0oCwLRFQ2l6Hp
	 H5C6iWqJq/GTA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] md/raid5: validate payload size before calculating
 payload_len
Reply-To: sashiko-reviews@lists.linux.dev
To: "Martin Wilck" <martin.wilck@suse.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260902165753.255675-1-mwilck@suse.com>
References: <20260902165753.255675-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:08:37 +0000
Message-Id: <20260902170837.C64161F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Out-of-bounds read of `payload->header.type` across page boundary
--

commit cf3844b320a187a8abab97af97eaad5cf6134ae8
Author: Martin Wilck <martin.wilck@suse.com>
md/raid5: validate payload size before calculating payload_len

This commit introduces a bounds check to verify that a payload fits into the
current metadata block. It ensures that the payload size and checksum fields
can be safely accessed without reading past the end of the metadata block.

> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 7b7546bfa21fb..4a97846e9030b 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2002,26 +2002,35 @@ r5l_recovery_verify_data_checksum_for_mb(struct r=
5l_log *log,
>  		return -ENOMEM;
> =20
>  	while (mb_offset < le32_to_cpu(mb->meta_size)) {
> +		uint32_t payload_size;
>  		sector_t payload_len;
> =20
>  		payload =3D (void *)mb + mb_offset;
>  		payload_flush =3D (void *)mb + mb_offset;
> =20
>  		if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_DATA) {

[Severity: High]
This isn't a bug introduced by this patch, but could this read of
payload->header.type cause an out-of-bounds access across a page boundary?

In r5l_recovery_verify_data_checksum_for_mb(), if a corrupted or maliciously
crafted RAID journal log configures a payload size such that mb_offset
evaluates exactly to mb->meta_size - 1 (e.g. 4095), the loop condition
mb_offset < le32_to_cpu(mb->meta_size) will evaluate to true.

The subsequent read of le16_to_cpu(payload->header.type) will try to access
2 bytes starting at offset 4095. Does this mean it would attempt to read
offset 4096, which is out-of-bounds of the meta_page?

> +			if (mb_offset + sizeof(struct r5l_payload_data_parity)
> +			    > le32_to_cpu(mb->meta_size))
> +				goto mismatch;

[ ... ]

> @@ -2106,6 +2118,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  		if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_FLUSH) {

[Severity: High]
This is also a pre-existing issue, but does the same out-of-bounds read flaw
exist here in r5c_recovery_analyze_meta_block() when analyzing payloads?

If mb_offset is just 1 byte shy of mb->meta_size, would reading the 2-byte
payload->header.type field read past the end of the metadata page before the
newly added bounds checks are reached?

>  			int i, count;
> =20
> +			if (mb_offset + sizeof(struct r5l_payload_flush) >
> +			    le32_to_cpu(mb->meta_size))
> +				return -EINVAL;
>  			payload_len =3D sizeof(struct r5l_payload_flush) +
>  				(sector_t)le32_to_cpu(payload_flush->size);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902165753.2556=
75-1-mwilck@suse.com?part=3D1
