Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4AAF3611B
	for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 20:58:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718053111; cv=none; b=rLSUtqmXppwYgUvSRjtNnZYtZjFHG0o6SXDdaATbFtaofsTLlrPjXj0n9lezRQkI7JB+BNmE9irQHHj96zv+V76Ik0rUApmOTBumFotWCEDAuBRdiSDPv9YCYfCKMHw/nqBCKf2jw55HcFq7Ee8emIKmK+HpKT4Bbb6gHwpyIAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718053111; c=relaxed/simple;
	bh=SRfNyNm4CG0DMqzbrOAfIupxnOwZAmc7Btb75N6Md9w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gkEW3JIJ/4tdXJyGTIpydojbZra35uqvktv45Dr0/t9zrrNtWXI+Oab3czMQPdpcwMf0QfGZSsyrWvFmE488d0hDdx1I+qJmGvkVQA4cbP4OMqYH9Dq2UNq519aNT3MFMAyH5AD/8Y+dMDBn6+Ep09Uti2ycqHmaVa8M+lRfVSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nTrE4ZeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nTrE4ZeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2914C2BBFC
	for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 20:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718053110;
	bh=SRfNyNm4CG0DMqzbrOAfIupxnOwZAmc7Btb75N6Md9w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=nTrE4ZeEj4sKF5JWfnHYuZHMAw+qetjMtoT9OKq/VUy8VjptPsNWs+YLLwdVjrRFx
	 hAF2hITI7lD5RgHP/v17gDP6UHwAZPqz/QmMA3729iZrjZyHgwOgAFV/6idQ1rj7eN
	 uiqi32sxJrDHJcScwPlJbgCKfY/z9v+4EUEylgYIObEIZVTf+6Y7pB2wm27UNVazBz
	 xoAC0x3f4dBtCKIzQOeVb1fTS/eEa/rGwaooxKWTbIyj4cINgXMwu6mpvn9uRKdjjY
	 zdyylrtyskHV63G2GmEHYuy9P6YHkrnb8vKcKKa5ph9JZ+xW7N3BCQhVgauujjp3Ox
	 8TGOpRan1ECEg==
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-2ebf2cd19a9so574201fa.1
        for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 13:58:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCU28XX+KuhIp6sczlF0BaMgIjktIWJFiI0myJS4gY151PVCILgxFcjh7cFylCIFaIA0c6BXLZyMzY/dIajJbwb0ghd31PtKjWpvkQ==
X-Gm-Message-State: AOJu0YyKtKG+Heb62EHQZ6ZXnk60N9V/Ie9jx34/uEh6maoufOSt1coc
	gjSlszLtkL4G/XsHFBEHGj4I+ai9/jbhatFG7zPdqK/psyFKURWtLLCuwMqVpwa3RqfuK2avA6q
	BIRE+cPN5Y7L7lAsxZ+nCXLEgUnk=
X-Google-Smtp-Source: AGHT+IF4A7gG81Bwur1vC8TBxNtKf65fLrOJ3vE8gjeWMSkM8p+YfBv7260nnbdisKWWqlDHPekEGt9fFDPpo6XRdjo=
X-Received: by 2002:a05:651c:503:b0:2eb:f17a:6c14 with SMTP id
 38308e7fff4ca-2ebf17a6d04mr2516521fa.22.1718053109127; Mon, 10 Jun 2024
 13:58:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240604172607.3185916-1-hch@lst.de>
In-Reply-To: <20240604172607.3185916-1-hch@lst.de>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Jun 2024 13:58:17 -0700
X-Gmail-Original-Message-ID: <CAPhsuW7cBhbH9iQQunmVohGkwnGJNnw7PFfExXh3umL1qB=SVw@mail.gmail.com>
Message-ID: <CAPhsuW7cBhbH9iQQunmVohGkwnGJNnw7PFfExXh3umL1qB=SVw@mail.gmail.com>
Subject: Re: fix ->run failure handling
To: Christoph Hellwig <hch@lst.de>
Cc: Yu Kuai <yukuai3@huawei.com>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Christoph,

On Tue, Jun 4, 2024 at 10:26=E2=80=AFAM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> Hi Song, hi Yu,
>
> this series fixes problems I found when testing how md handles
> trying to creat an array with disks that support incompatible
> protection information or a mix of protection information and
> not protection information.
>
> Note that this only fixes the oops due to the double frees.  After the
> attempt to at the incompatible device the /dev/md0 node is still around
> with zero blocks and linked to the the previous devices in sysfs which
> is a bit confusing, but unrelated to the resource cleanup touched
> here.
>
> raid10 and raid5 also free conf on failure in their ->run handle,
> but set mddev->private to NULL which prevents the double free as well
> (but requires more code)
>
> Diffstat:
>  raid0.c |   21 +++++----------------
>  raid1.c |   14 +++-----------
>  2 files changed, 8 insertions(+), 27 deletions(-)

Thanks for the patchset. I applied it to the md-6.11 branch.

Song
