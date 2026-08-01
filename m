Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46EEB3002CF
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:45:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606305; cv=none; b=TwFs31MJ7pFZTo1+h5oARj/JOweW6koAWX+WCPmt80/9pFrEtpWMXwfYukmomY8TvdRj3nMwqoECFJft3RWnRcMyXeyGVlozbAz5ENYSuFNwcEGPuCGS2BqS9/Yy15DJerRB8fLNEMMXFMDRCnCGSIsrq1Su0o62M92/vnBHkKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606305; c=relaxed/simple;
	bh=MK60NmyTHkIFt12xfPiGkdc0Ew23J09dcyuJQ8yY/WM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tavpkdwtaa19VspaIcGmnrcHIIxzREV9j/GXsmkoCZpP8uWqrATEtq9/RRUtqU4ZHoC33l+rSq+agMGXlA12aMAO+EFY8t24qTxRjpHspyLjXZFyqQc65touQvDbKjyiyiluWTf7Xq/prPV8l7ssKVZ1lIoBW16aNB8QwrWbXd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RAkSpATi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RAkSpATi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD39E1F00AC4;
	Sat,  1 Aug 2026 17:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606304;
	bh=7Ju78M2tVkAN3ef0zXKEG4FhXNxWBMu+8jr+SPH3Q24=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RAkSpATij587EcQ++cpEujDkZBhZ94HbfiCGw3gLq0lvcqhLh6JU0e0B8nnOchnPE
	 luR5l3ukOqFnKj5b8JzcvJGrESRPtBTDY4siXWmScYdugSwW6e97ipDcNskmw18Fzg
	 2KDF6AzHxKmpeqjk4qyUNwwS/+iQHHRqonZ68e8Wr7d6u0KRlxRyLAter/mBteqnyI
	 bKWBDqJMWqpb9KaYddTjnj+r7XjuEefEScuPPZI9/VqnyQjVCo+aFgXn5lrsj5vjD1
	 7COCY7qB4nBY3ZhPFHkcT98NRjeLPLAhSXg+h7/gjn/jT778gUhvcWv6OQPy26+iUv
	 k9KstP3ZVvRjw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 04/25] md/raid5: reject zero-sector reshape chunks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-5-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-5-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:45:03 +0000
Message-Id: <20260801174503.BD39E1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Writing large unsigned values to the `chunk_size` or `layout` sysf=
s attributes causes integer truncation to negative values, completely bypas=
sing validation and leading to arbitrary geometry corruption or kernel BUGs.
--

--- Patch [4]: [PATCH v4 04/25] md/raid5: reject zero-sector reshape chunks=
 ---
commit 6759d75e360239d90630b8d047daa1d3cb528597
Author: Yu Kuai <yukuai@fygo.io>

md/raid5: reject zero-sector reshape chunks

Sashiko reported that RAID5 can accept a reshape chunk size that becomes
zero sectors. chunk_size_store() stores the sysfs byte value as n >> 9, so
writing a value below 512 bytes sets mddev->new_chunk_sectors to zero.

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index 0c5c9fb0606ee..4276b125f94cb 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -8479,6 +8479,8 @@ static int check_reshape(struct mddev *mddev)
>  		return 0; /* nothing to do */
>  	if (has_failed(conf))
>  		return -EINVAL;
> +	if (!mddev->new_chunk_sectors)
> +		return -EINVAL;

[Severity: High]
This is a pre-existing issue, but does this check adequately protect against
negative values?

In drivers/md/md.c:chunk_size_store(), user-supplied unsigned values are
shifted and truncated into the signed int field new_chunk_sectors without
overflow checks:

    mddev->new_chunk_sectors =3D n >> 9;

If a large value is written, new_chunk_sectors can become negative. This
would bypass the !mddev->new_chunk_sectors check introduced here.

Additionally, in raid5_check_reshape(), validation is skipped for negative
values:

    if (new_chunk > 0) {
        ...
    }

Would it be better for this check to reject all values <=3D 0, to prevent
negative chunk sizes from corrupting I/O geometry?

A similar truncation issue exists for new_layout in
drivers/md/md.c:layout_store(). A negative layout value bypasses validation
in raid5_check_reshape() and eventually triggers a BUG() in
raid5_compute_sector() if it hits the default case.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D4
