Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 070CD202F6F;
	Fri, 18 Oct 2024 15:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729266230; cv=none; b=iy02ugNp8xRPtfszRn5dbnpNWZkyEw06PV7HA+AUfSiyl06iQdyvGT35euwoJTIWyaGF9WUMP3d5WNWS61DbS3t2cFksPoqFBK6YWyLBfHAXvzGc6ny2Gi7Kix09D3bINej5upp6uTQeeWqXi619+z15U+/5VPMBaT3LJKwqeRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729266230; c=relaxed/simple;
	bh=yLPhDrjBa2PQrXV7feG71oQYsfM5y4GsTMKAIF+feNQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dDa9Gb31bisWJcLbHU3M0Wt87naXemBGlNf7N+2h1s3gVbAfmX178d1Gb7aTk2cezKav9GgToBbfX3mRlkLvB/V6fMwLL2RNCn+u6YFknTYByhb3J25RQw9xmyRBPTcC/ay80gXdM57UMsj3fZvQwffcSSGtzBeoiOXd0lQz2As=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cmMpoP8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cmMpoP8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0279C4CEC3;
	Fri, 18 Oct 2024 15:43:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729266229;
	bh=yLPhDrjBa2PQrXV7feG71oQYsfM5y4GsTMKAIF+feNQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=cmMpoP8LpHqTg8oXYmjZHh6P6jurnTomJ71eAHiVJwKfXcrVZcQpoKFR59NmRQSAz
	 zfSj3QHof0Nz5sHGh8OEGPcHG1vk2jl7891yLEtvXElp8K2abyEaRdEd1NEZz99r6y
	 W2+4sv08w3hWlXMcdxtwZqDPTPMMY08wmG7XSVgheBxA0oyi1UFG2JKkw1uDHhAsUg
	 yPqepPGQcT2B/sjcv44G1X0k0RXnlM9fHdvn5Hkfh9wTRNz6bWmI8O5k6AxDmox11L
	 mJ0fw+0vkzVJ3U7ZyCz+Gak9qcurIZ7n3nM5BgK/DE9f15hk0mXoKNkzht22aaAeJZ
	 oGtRxaRef+u4A==
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3a3b8964134so8322035ab.1;
        Fri, 18 Oct 2024 08:43:49 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVlMLbQAourLoOeyrIpAZHiyoSBn7b0AZe+Py0vJIwRMvOts/A88ESzz3Kun2S4mntLd/XlrJyho5LHZq4=@vger.kernel.org, AJvYcCXVgJRMwmMdJCLmsFqHZc18HgtSgQEJ44P4OnmZ84HwSUmYZHQv/UHsO4SgEvRNyaKdmB9yJQofyLeNTQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxhsACEQnfJ5ygF1YDn1b8rk0iH8oEFpSnMtxYOV9D5FV+bjKHe
	PfjAc188Lf6bAUIwACUloedn+JjP6kwF6k4DYbYg5N9bp7at98T21/XKSEVkKXaaFkeAsi+FH0s
	ABVLlvB4yVHvpKQbxNll7Ebv7OJA=
X-Google-Smtp-Source: AGHT+IHFpFE0Kj6PFo9ccLnygl6SCDirXvAqzWYKtnyFJVnnBEv7qjSm/Jq4mj50pU5cvvMfRbhMvUxgsKTOObQJi0M=
X-Received: by 2002:a05:6e02:12c6:b0:3a0:4a91:224f with SMTP id
 e9e14a558f8ab-3a3f40474d0mr26290395ab.1.1729266229026; Fri, 18 Oct 2024
 08:43:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
 <CAPhsuW4UCFbtrxXVfCaXFvCWYhb8He0tGSHq8UZ_4dWX=ZMs3A@mail.gmail.com> <20241018145643.0000788f@linux.intel.com>
In-Reply-To: <20241018145643.0000788f@linux.intel.com>
From: Song Liu <song@kernel.org>
Date: Fri, 18 Oct 2024 08:43:38 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4VLYdbrXP5y1x-bi4UW-Rh24nQafRktnx3csgewdCc8A@mail.gmail.com>
Message-ID: <CAPhsuW4VLYdbrXP5y1x-bi4UW-Rh24nQafRktnx3csgewdCc8A@mail.gmail.com>
Subject: Re: [PATCH v2 0/7] md: enhance faulty checking for blocked handling
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, mariusz.tkaczyk@intel.com, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, yukuai3@huawei.com, 
	yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 18, 2024 at 5:56=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Thu, 17 Oct 2024 23:46:58 -0700
> Song Liu <song@kernel.org> wrote:
>
> > Mariusz, you have run some tests on v1, but didn't give your
> > Tested-by tag. Would you mind rerun the test and reply with
> > the tag?
> >
> > Thanks,
> > Song
>
> Hi Song,
> I see no functional difference between v1 and v2 feel free to add it.
> I will be hard to rerun these tests right now.
>
> Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Applied to md-6.13 branch.

Thanks,
Song
