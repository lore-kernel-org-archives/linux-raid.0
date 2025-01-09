Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6BD819047F;
	Thu,  9 Jan 2025 17:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736445104; cv=none; b=E7iik87dgdQoSTLrlAxCnY0avxXx3p6nUUphphOUlp5VjIMmKlGiWYOM6/BP0zZW19vyEixvKxa5g0fQ+bZ2f4mJgQncJCzBmByZHIC9scMR45V0ZW5spKLh5at0+ObXldGjRBKUJ8Jux6FAOI4Sjqq4QHqnWao/6KPWoZV7u8Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736445104; c=relaxed/simple;
	bh=64Isl7fQB9muSu5Ym+3SWHMSub/YxvbGUH2841oyhbw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ly4t2sBYmFep29EmErd4BSpvSRes9lhNNSwvP9lfzuYRKI8CFtJjpImjJ0eEaok4FXttz5c4qd4oX96pQz/bTkRrCd02ImD6VaDnoFpG/ijHOoI39e56ZrqJ8pe/3+YiQOoWyxIaABG6jl60nC/EZNzkz/fhe4bti2soB4IaE3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fD2fTfqh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fD2fTfqh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45E7CC4CED2;
	Thu,  9 Jan 2025 17:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736445104;
	bh=64Isl7fQB9muSu5Ym+3SWHMSub/YxvbGUH2841oyhbw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=fD2fTfqhCQwE6RmMmmffXnGdQzFk/pBTVc+c10+G+sNOc4goSMxoHQvoA/ZAfkShR
	 geprny6Abm7zy8+3LR2YxHkpPuk8A70+kbrJbVAXS8FGYGcqCeJh9/CFfToBTthfNn
	 D0yLodWMfJ34YZlgi/CilCyG1iZvJAxpNmt1cMgDL63x79uc1hsp25qNi418aDETtI
	 Y5tCEVV69qiTSVwKNaQd6UFaR9mR1LtiEOQE5gj/2InR9/dqImu9vYFh/a8Pf8UHHM
	 lebOlStIsOdo4f2TgYSpbhZhK/4Ciz6L+0/Q8G4O53hnxm2w0rJwNnXqGmqnTgmgep
	 e+Z93rxK62o1w==
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3cdce23f3e7so7119345ab.0;
        Thu, 09 Jan 2025 09:51:44 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVVqyO5ZbQlLcRTMAfsMwD2FMSjbC0wQuykCvyW9RFy1fNX+JRjTJ7EV3kpoPWF4dbTt1x5kqg+wbr5/0A=@vger.kernel.org, AJvYcCVrxxS4aZ+d+5GCZrCe3kfXX06h/OK2npz+zwOLIMUyx9umm0wHkfLxfMDAXnVQElCHdkU9e8w7KNnqRA==@vger.kernel.org
X-Gm-Message-State: AOJu0YylmPA6DXdkXgXkgXdi7+iCYCnbSzZhQVO6mhSfQ0kTK+ZfLGL2
	UUvacj8MiLIW2pjg2ZhG5/xB+50svsubL8KQ05XZhetXTQrr3m/r6mQJMipvfKkGRbZCqzIrS5g
	daXkv7VWWmn4OTlCJ/0GQD6tYnjQ=
X-Google-Smtp-Source: AGHT+IGvwz6u8v5dnCqwgWD/MFUogv6vPB879A+pMKwNVETrCRO02ZiOEjq4q8uzIncTzAuEbPgNH3Kszlb2a38MDfc=
X-Received: by 2002:a05:6e02:1445:b0:3a7:c072:c69a with SMTP id
 e9e14a558f8ab-3ce3a9a4ad1mr68157545ab.3.1736445103710; Thu, 09 Jan 2025
 09:51:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250109015704.216128-1-yukuai1@huaweicloud.com>
In-Reply-To: <20250109015704.216128-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 9 Jan 2025 09:51:32 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6UWQynVvfN2EVsT7RMb8mAJfE-1FwQJ=VbabTWE7T=JQ@mail.gmail.com>
X-Gm-Features: AbW1kvYmtq07MhRRJ0H674Oih7wL-7DFEhRxT8zwfTTLvzbqlh2O0dMdERRADRY
Message-ID: <CAPhsuW6UWQynVvfN2EVsT7RMb8mAJfE-1FwQJ=VbabTWE7T=JQ@mail.gmail.com>
Subject: Re: [PATCH v2 md-6.14 00/12] md/md-bitmap: introducet CONFIG_MD_BITMAP
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: yukuai3@huawei.com, agk@redhat.com, snitzer@kernel.org, 
	mpatocka@redhat.com, linux-raid@vger.kernel.org, dm-devel@lists.linux.dev, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 8, 2025 at 6:02=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Changes in v2:
>  - don't export apis, and don't support build md-bitmap as module

Since we do not support building md-bitmap as a module, we should
update the commit logs to reflect this change. Also, please explain
why we need an option to disable md-bitmap.

Thanks,
Song

pw-bot: cr

[...]
