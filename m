Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FCB114286;
	Wed, 28 Aug 2024 00:24:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724804662; cv=none; b=HQZ3pmihVRyugvuWNx6OtSU3d3kC63PduZdXMNy4LmetiZxrZqFQW6AACh+xcIo2KJOvmvbpniAUAFQWQ9j6QCzh+zZDexTW3R5Qmz8u/syt+RjjeUQtklxCi4nJpOElgdK93C9tbay2aSqMYIgALTh7siMatAPaLTR7oEdLgHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724804662; c=relaxed/simple;
	bh=9nyCFw0a/Prs/w5GVim5FrNOpS25x4VF38veYaZ9WRc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Wv3qFTk/8pvn4Y9DTFGuqloZOmMH/lGF1GMygvQmlRNqtkhG8mjVn10fFL+OCbWvIJbehPWOvOPxpz6d/FpmmjtO/4XaoeX8DqxZUJCK8Cw/HCYOXfoQg4SDwRElVA58NKv3/MTNtfDxtQ7NqngcXwm88xeZ5fweTHSbZCKyGqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rnNMQYRL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rnNMQYRL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FE9C4FEBF;
	Wed, 28 Aug 2024 00:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724804661;
	bh=9nyCFw0a/Prs/w5GVim5FrNOpS25x4VF38veYaZ9WRc=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rnNMQYRLhco10C+fm/wIJ18tSLiHNXSERlbviqKd2tHuKFxFHuhICx5ofi0tQkaUZ
	 JDWnlefdlC+oLbzA9irTNLJYG3aDN6WMTbcCJRQLhfz9m07TxY7pBQu+5aMKLT1+M1
	 oz/a3GJSP+vKr/uaVgWil5jru4eDKtqLSG9cAni6/6gq0hlBwM4OjwSL13SZqrkrxg
	 3L+C2s6hMFK5V73L6ghgKqasuc2a3cugydFGAU63g91ohG1O0aJDR+qeMOK6Wsj5Ge
	 Cxbf50a35nGqi81lrjd3kiL/uxju3y1/Z8cUjqK5ZJXiDqV9k/Ernr91cPyBf8X+nU
	 3XmihnNrnIzPQ==
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-39d3b31e577so27512895ab.1;
        Tue, 27 Aug 2024 17:24:21 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCUJaQ6xjYsmXOHqoRfbMgG0bWYIAtRXACc6Ea2q3392jTATtps8GUcMyavj9Lr/fyQ2Bvf2vAOOi0XQ/w==@vger.kernel.org, AJvYcCVU5RLaSl+vn2RpHuLBINGPZuvqg51YSZkBq9zrQ7LBU75ErLqshUlP+mRvUStNYgvOESD8SkH8B8c+FBE=@vger.kernel.org
X-Gm-Message-State: AOJu0YyWnJ1Q2Ru/RlmDpZqZtOpttei8V92L4U3QRFiTAOKi5YiTXq2k
	XBQhxRNZf+PyCo5PcHf8kwO7PFNK3pUzPFZNlsnD3cQSBhf+yUdTpE6xylCDDd/MmfCxuN82Gi2
	WlnCKL9etwa3liwLusE2MdPMIUnI=
X-Google-Smtp-Source: AGHT+IGGfeLA3I0nfJ3frEO4s8XEn4i2rDq5TNtF/aL34h6V2Y27yrqxd7EzXEqxCBTFMgp2gcvu/mR5blaenqSO+NQ=
X-Received: by 2002:a05:6e02:12c2:b0:39b:3894:9298 with SMTP id
 e9e14a558f8ab-39f3247cf45mr5568585ab.0.1724804660886; Tue, 27 Aug 2024
 17:24:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240827110616.3860190-1-yukuai1@huaweicloud.com>
In-Reply-To: <20240827110616.3860190-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Tue, 27 Aug 2024 17:24:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Y+mTTqNtSAFUq4cw=Y8KmhcEQeHyOMdw45ijHwFsMuA@mail.gmail.com>
Message-ID: <CAPhsuW5Y+mTTqNtSAFUq4cw=Y8KmhcEQeHyOMdw45ijHwFsMuA@mail.gmail.com>
Subject: Re: [PATCH md-6.12 v2] md: remove flush handling
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: pmenzel@molgen.mpg.de, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 27, 2024 at 4:07=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
[...]
>
> Test result: about 10 times faster:
> Before this patch: 50943374 microseconds
> After this patch:  5096347  microseconds
>
> BTW, commit 611d5cbc0b35 ("md: fix deadlock between mddev_suspend and flu=
sh
> bio") claims to fix the problem introduced by commit fa2bbff7b0b4 ("md:
> synchronize flush io with array reconfiguration"), which is wrong, the
> problem is actually indroduced by commit 409c57f38017 ("md: enable
> suspend/resume of md devices."), hence older kernels will be affected by
> CVE-2024-43855.
>
> What's worse, the CVE patch can't be backported to older kernels due to
> a lot of relied patches, and this patch can be backported to olders
> kernels to fix the CVE instead.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-next.

Thanks,
Song
