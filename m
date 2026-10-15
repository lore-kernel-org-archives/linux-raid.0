Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8052D443E3B
	for <linux-raid@vger.kernel.org>; Thu, 15 Oct 2026 20:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792097720; cv=none; b=X5Wg01jXqCP4DgmoAREu3K1K7QITg0FxXd9q8/iO8ZoZaVIPcfpBP7fY+715HH/A/lKfcW9TRHNIb7gniJYvFQleGW3oVmqg9j8PGmna0fL7zdBgxO1OfM1wHLsdj7nJb1RBmB5TZCqGBge+H00q9rXW7KdQUstoCWl44fLt9t0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792097720; c=relaxed/simple;
	bh=QQhYA+ttub6aZn+0TITBwTbGHmMKE/MIaJZs1U3SjxA=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=AvExD/+OpipA8pxbpWrrizeHr8Q8j7PXJv560INjClRFYF1ZqzAKe5G97rt+a467AstcYm75xy3luZKEuUreo6DedA2WDH1p7H11ePPLkVBxDjlju4Pmk7D2xyRuI1y0HfM2jTzDI5eShs/IpyOwrFM2KWFMaoS//y6XYIGTGKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HS4SFTS+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HS4SFTS+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F771F000C4;
	Thu, 15 Oct 2026 20:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792097719;
	bh=t32xG39qFBHFTJpGSlgT5UzmC3D5Xzje/OJ/p/clLkY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HS4SFTS+xQrUBx9K0KxmtdtHJ4yL678NvlLNrbmHUG13uvbyDQxd67gJCRtQJ1f/n
	 Px1W6p1qV96tUZPklYZAd8lY26tWqNmjdJN1K9zgxxzaenwFKHAZwwsHPEvft5EEOi
	 zBPzqrJ09+wkkk6pyZFziB4B1z5zIv2I6YZ3d/7bZwkzDRsmyZBK/QM4n8y82ssLXL
	 C2M9Ze0kyUqvANatWklOUgZlt5vFyIbUfl/VQC5kdn5u2OJWq3zlAE8HSEEjiFgQ0a
	 S0jbSK2A08ky/r93WuxwS/fll7PBb7GHpvYN/ghUCrDZaOZkIVa6oQCV/olvY9hgKz
	 lAket4/g1fiMg==
Message-ID: <sashiko-outbox-173415@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v4 1/4] md: add uapi definitions for the md control
 device
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TWFzYWxraGksIEFiZCBBbHJobWFu?= <abd.masalkhi@gatech.edu>
Cc: =?utf-8?b?bGludXgtcmFpZEB2Z2VyLmtlcm5lbC5vcmc=?= <linux-raid@vger.kernel.org>, yukuai@fygo.io
In-Reply-To: <20261015204640.1184848-2-abd.masalkhi@gatech.edu>
References: <20261015204640.1184848-1-abd.masalkhi@gatech.edu>
 <20261015204640.1184848-2-abd.masalkhi@gatech.edu>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 15 Oct 2026 20:55:18 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] md: implicit 4096-byte buffer contract in new MD_CTL_GET_BITMAP_=
FILE UAPI
--

commit 04cabfea66def1d91136adb7afff7c1b2c70d669
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gatech.edu>

md: add uapi definitions for the md control device

Add the ioctl commands and structures for /dev/md-control, a misc device
that manages md arrays without opening the md block device. The device
itself is added in the next patch.

> diff --git a/include/uapi/linux/raid/md_u.h b/include/uapi/linux/raid/md_=
u.h
> index a893010735fba..f5a84605b6772 100644
> --- a/include/uapi/linux/raid/md_u.h
> +++ b/include/uapi/linux/raid/md_u.h
[ ... ]
> @@ -146,4 +174,90 @@ typedef struct mdu_param_s
>  	int			max_fault;	/* unused for now */
>  } mdu_param_t;
> =20
> +/* structures for the MD misc control driver */
[ ... ]
> +struct mdu_ioctl {
> +	char name[MD_NAME_LEN];
> +	char uuid[MD_UUID_LEN];
> +	__u64 dev;
> +	__u32 flags;
> +	__u32 padding;
> +	union {
> +		__u64 array;
> +		__u64 disk;
> +		__u64 param;
> +		__u64 bitmap_file;

[Severity: Medium]
Does this implicit 4096-byte buffer contract risk user-space memory
corruption?

Looking at the new UAPI struct, it defines a generic pointer for the bitmap
file path but lacks a length field or an associated typed payload structure.

When a user-space application calls the new MD_CTL_GET_BITMAP_FILE ioctl wi=
th
a standard dynamically allocated string buffer, the ioctl handler directly
passes the generic user pointer to get_bitmap_file():

drivers/md/md.c:mdctl_ioctl() {
    ...
	case MD_CTL_GET_BITMAP_FILE:
		err =3D get_bitmap_file(mddev, arg);
		goto out;
    ...
}

The kernel blindly copies sizeof(mdu_bitmap_file_t) (4096 bytes) to the user
pointer without validating the buffer's capacity:

drivers/md/md.c:get_bitmap_file() {
    ...
	if (err =3D=3D 0 &&
	    copy_to_user(arg, file, sizeof(*file)))
		err =3D -EFAULT;
    ...
}

Without an explicit size parameter or a dedicated structure to indicate the
expected 4096-byte size, callers allocating a smaller buffer could face
memory corruption.

> +		__u64 arg;
> +	};
> +};
> +
> +/*
> + * If set, MD_STOP_ARRAY will switch the array to read-only mode instead
> + * of fully stopping it.
> + */
> +#define MD_CTL_RO_FLAG              (1u << 0)
> +
>  #endif /* _UAPI_MD_U_H */

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261015204640.1184=
848-1-abd.masalkhi@gatech.edu?part=3D1
