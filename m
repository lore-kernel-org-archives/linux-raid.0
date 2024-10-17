Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE201D7999;
	Thu, 17 Oct 2024 22:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729203976; cv=none; b=Nr03vm3xhhPWP2TUb+s68nWVJrn1YupfuEphX8c4xoWGjGlISYinKV8rVFGGqn2Ud+Z6zMMdfBAH2K8hbC3UOnQEpooKzats98XgJAerG8h2lbLC/s6hMQ5/2BO2y+X0SSB9JKHIn5unaCBuv4e/w6Prcl2Rgz9OlWq7AlEYI/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729203976; c=relaxed/simple;
	bh=mTZrV4roL/x6zvinf7zSbxeYW9kJZeJYMk6tWasVHS0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Yhj9/JFbn3YO3wBi4gQsvY9GYHILaWZEanYloCXwcUhiC8Hm/58tHC6sWMzs2GZ8fp0YrwKwdUTje1sMoaHlhDMJdKSf7wyq2lPkkwQeHwmRrlHCNk3qVd3wZE+AB9OkCtpfSRutY2o0uOdN4NgK3vdAbMAmP1x5CWPfQRpj78Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VuQaOB4f; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VuQaOB4f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1A88C4AF0B;
	Thu, 17 Oct 2024 22:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729203976;
	bh=mTZrV4roL/x6zvinf7zSbxeYW9kJZeJYMk6tWasVHS0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VuQaOB4fDOPfD1/PkhjUy3yqBKwt8pf2Hj246+YRrV/69vpVtLm4LFq8LjWIE3ySc
	 Ffgdactz4LjQLG8075RmUVGGcn3A0gpfpGsr+y5qiDItgj6TAVuJ5UUbCO6yBmEm9A
	 1kXRu/muh9eZ64tQDJzjn/oEyWot516hGCVCpTutifB59NVvGicsEzemRu70hi12f2
	 wNABxjdfI2AfhwNSJTgOeMJytvIb3bZO0p0ImOuTmy9dDCtIdoAMDk8SHQ2uJzn370
	 oiQIWLYBR4T2GPStEExliNb9xWucAQt03Myyz/pzWbH+cb0xipYfmTgTdk2jjf8fyM
	 zed/8nx3DfJ5Q==
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-83ab52ca5a9so35487139f.1;
        Thu, 17 Oct 2024 15:26:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVGIC8PU57uWhSOys5MnnF/T+BuapoS3gISBR1xDj+zJOeb3giErwbUqjVDN2w//+9aOQAoeW8GGCFJd6c=@vger.kernel.org, AJvYcCWuAq5tKYJ+GRr8TDGsHQAriDDHRXP9NsH8pPAawhkp1OOiOgcAsr+dfypkeWYDS+VFpapPge0JeUQsSA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwCQ6GvWpQFFyp11p4epOuo206TM6qeADbkOL45DOS8eMTVNB/a
	Frd9hWVWz14Cdx+OgQOHFxp4Blz2kGSATc6mUbN1db/qFuUr6QeytfnWzThHDllDzj3yjM60flb
	GuSTpRAqN6ass2MfLzCeqaVJ+nHs=
X-Google-Smtp-Source: AGHT+IEcNMKUkyKI+orKjpnGpsc3Z4VF1GQA84XGoaJiTI+m2ypEAA5qD1gWQ458jr+92+DxeyQuC5079DCHIHgIt/Y=
X-Received: by 2002:a05:6e02:214b:b0:3a3:9471:8967 with SMTP id
 e9e14a558f8ab-3a3f4073b82mr4357335ab.11.1729203975406; Thu, 17 Oct 2024
 15:26:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241009014914.1682037-1-yukuai1@huaweicloud.com>
In-Reply-To: <20241009014914.1682037-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 17 Oct 2024 15:26:04 -0700
X-Gmail-Original-Message-ID: <CAPhsuW72021iJDQp1HnJycpkp2GQOFvL9MGWGQ1LvMbr9-bWoQ@mail.gmail.com>
Message-ID: <CAPhsuW72021iJDQp1HnJycpkp2GQOFvL9MGWGQ1LvMbr9-bWoQ@mail.gmail.com>
Subject: Re: [PATCH] md/raid10: fix null ptr dereference in raid10_size()
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: hch@lst.de, iam@valdikss.org.ru, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 8, 2024 at 6:51=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> wr=
ote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> In raid10_run() if raid10_set_queue_limits() succeed, the return value
> is set to zero, and if following procedures failed raid10_run() will
> return zero while mddev->private is still NULL, causing null ptr
> dereference in raid10_size().
>
> Fix the problem by only overwrite the return value if
> raid10_set_queue_limits() failed.
>
> Fixes: 3d8466ba68d4 ("md/raid10: use the atomic queue limit update APIs")
> Reported-and-tested-by: ValdikSS <iam@valdikss.org.ru>
> Closes: https://lore.kernel.org/all/0dd96820-fe52-4841-bc58-dbf14d6bfcc8@=
valdikss.org.ru/
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>

Applied to md-6.12.

Thanks for the fix!
Song
