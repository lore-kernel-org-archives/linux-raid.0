Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3369747FAE3
	for <linux-raid@vger.kernel.org>; Wed,  2 Sep 2026 16:18:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788365897; cv=none; b=XYGpQoJt9rPUp8t6vAvax4k2UjBYSLmqM5q85OFAVr/AJsgSucJRZneok7hcuXLMi6lpU0VHdu7S+4UGqnNzKWTkgilGNyyNHpHLxrgUqBjGh069Mfc36RGRqvqjUGgDqlDEspiYNSp8cnDVWKJHQjKeqx4kwTkaxmuDvKXwSqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788365897; c=relaxed/simple;
	bh=HoLZRYotaTzZpagp1TCgMMG+Hcg1A5YWI1dwWnBVPTo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=diQeuWawAazhtXvOQevQFsmH4CFNZ4XoKyH46LfOCCe+8XYcN5/QL537bwcJv2+wwhVhGUdnsPgqKP+GK1+JTAZf4c0fMGsHZG0PGtVlcU+KPDTODFrb2MTihL5Ue4n3/KxsFhzx2FWzdQ1W23JpJ38QyiCf3m95UxHMUZDWpJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V2CfLazR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V2CfLazR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AF991F000E9;
	Wed,  2 Sep 2026 16:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788365895;
	bh=SGS6k7nFIbagK6otRa9Tkzs1xJYHbPMI5PN4pXzqEIU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=V2CfLazRij16YWzKS3IyrTeIb5/ebc4nXRVk85XwpmmB2Xv42ESJ6mlqzYV5hXISK
	 emiBx75Q3SEtDpw7UvvmP5EO8WeyzOVO1FrewgumBo3wdff/gG8pY2M3NYstB5sW+y
	 Eqd5jrCHpEP17PJfSuSAGE2epWkIu0ojYgdEtUIJrAUbqWLtlDjQvSEx6hWmXL6H0p
	 LY7w5Dgkb2ffIkC2/EQdWpxaoyE0eIGaIKCPAMuf7LFqfBjPBErDvIP9JRGZGHd/Nm
	 vgjIDRsKLo1HV//8xRlmQ0g53IUE9oTlGVWJqXgc/Z/QDimMZbLibj5kNaiHdfozV6
	 2p5RJqlGbZHHg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid5: validate payload size before calculating
 payload_len
Reply-To: sashiko-reviews@lists.linux.dev
To: "Martin Wilck" <martin.wilck@suse.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260902160603.218621-1-mwilck@suse.com>
References: <20260902160603.218621-1-mwilck@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 16:18:15 +0000
Message-Id: <20260902161815.7AF991F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Uninitialized stack variable used in metadata bounds check

Pre-existing issues:
- [High] Out-of-bounds read when accessing flexible array members without s=
ufficient payload size
--

commit b4a013d747a0232b449bf5e128c73f08e565db4a
Author: Martin Wilck <martin.wilck@suse.com>
Subject: md/raid5: validate payload size before calculating payload_len

This patch introduces additional bounds checks in the journal recovery logic
to ensure that metadata block bounds are respected before accessing variable
length payload sizes. It adds safety checks before accessing payload->size
to prevent out-of-bounds reads on corrupted metadata.

> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 7b7546bfa21fb..accf8b472082c 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2008,6 +2008,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l=
_log *log,
>  		payload_flush =3D (void *)mb + mb_offset;
> =20
>  		if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_DATA) {
> +			if (mb_offset + sizeof(struct r5l_payload_data_parity)
> +			    > le32_to_cpu(mb->meta_size))
> +				goto mismatch;
>  			payload_len =3D sizeof(struct r5l_payload_data_parity) +
>  				(sector_t)sizeof(__le32) *
>  				(le32_to_cpu(payload->size) >> (PAGE_SHIFT - 9));
> @@ -2018,6 +2021,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l=
_log *log,
>  				    payload->checksum[0]) < 0)

[Severity: High]
This is a pre-existing issue, but is it possible that this access to
checksum[0] could result in an out-of-bounds memory read?

If payload->size is 0, payload_len could correctly match the base structure
size without errors. However, reading the flexible array member checksum[0]
without validating that payload->size > 0 could read outside the allocated
meta_page.

>  				goto mismatch;
>  		} else if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_PARI=
TY) {

[ ... ]

> @@ -2035,6 +2041,9 @@ r5l_recovery_verify_data_checksum_for_mb(struct r5l=
_log *log,
>  				    payload->checksum[1]) < 0)

[Severity: High]
This is also a pre-existing issue, but does this similarly read out of boun=
ds
if payload->size is not large enough to hold a second parity checksum?

Like the data payload case, this might read past the bounds of the=20
allocated meta_page if the flexible array member size isn't validated
for RAID6 parity requirements.

>  				goto mismatch;
>  		} else if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_FLUS=
H) {

[ ... ]

> @@ -2106,6 +2115,9 @@ r5c_recovery_analyze_meta_block(struct r5l_log *log,
>  		if (le16_to_cpu(payload->header.type) =3D=3D R5LOG_PAYLOAD_FLUSH) {
>  			int i, count;
> =20
> +			if (payload_len + sizeof(struct r5l_payload_flush) >
> +			    le32_to_cpu(mb->meta_size))
> +				return -EINVAL;

[Severity: High]
Does this code use payload_len before it is initialized?

In r5c_recovery_analyze_meta_block(), payload_len is declared as a local
variable at the start of the while loop, but it is not initialized before
this check.

Should this evaluate mb_offset instead of payload_len? Using an
uninitialized stack variable here could result in rejecting valid metadata
and aborting RAID journal recovery.

>  			payload_len =3D sizeof(struct r5l_payload_flush) +
>  				(sector_t)le32_to_cpu(payload_flush->size);
>  			if (mb_offset + payload_len >

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902160603.2186=
21-1-mwilck@suse.com?part=3D1
