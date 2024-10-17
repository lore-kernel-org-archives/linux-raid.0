Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D368E1D7E30;
	Thu, 17 Oct 2024 22:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729203917; cv=none; b=hj7qNoT8JhFTBC4VHLTeNMb0vyt1Kn3jXRxaF0jXj07NkffFpHHKUJEsoYQMBi2vWcVxjk4LS39HzEIeViAjbSMDDlsO9zlOZovIhE/89iUTUWCTyY0xty+s3ai2qbVShJYDX4Ty+X4g3lCm7dtBajt69cHeqkza1idy2vkUp8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729203917; c=relaxed/simple;
	bh=nvQBQGQo04fXOFkrBcDRcbvCCqQvbJoPEPGXbyMPVEg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d/IT1pNrrKUrVxuYORVonlPUilxgZgQ4Uod9cFPnH7Sx2fNIZWg9KXlSiPyzkx7hjA68pFyzpeEJ9Kh1UWssbwem9ajsVgXZxrDcztDBnjxtC17JEiNaQ9Vz7P1GtfS2A/e/8Cfg+13v63Q7VuAvAM93tdV6si303trSoXTNuHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IP723RXT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IP723RXT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A1ACC4CEC3;
	Thu, 17 Oct 2024 22:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729203917;
	bh=nvQBQGQo04fXOFkrBcDRcbvCCqQvbJoPEPGXbyMPVEg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=IP723RXTzymv9PWnMp3v7dRcEB5gj6t86GRlyyiQcLeqzzdKI5m0ZJH+jhDB/in6i
	 pFoCVAb97QCw0JyuNjgnN/R1Yyhsx+UG8m37Qvj2oanJKpdHtpAXfghAY3A8YTjqIU
	 gvsibyLcsBgxX1bAWN1HLm7gnACbViSGD+JZVt5k1Mvjut6zQDJBUetoG2+PN3Gjem
	 YWmkazcm3TYNy+BWUJOzImLmeddEXqMWsIg1FSH8o3+vbM+gmHtukiEaT5ZTA6qQ3g
	 y7NaCdUsUb+LV/RSkt6BDA4UjT6ohsD650A8U+qdM9HD+px/6cK4/44r8x29FIep3X
	 oLG3nO4K3Ikkw==
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-83493f2dda4so86377539f.1;
        Thu, 17 Oct 2024 15:25:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVRxq7iI04uRjzVL44mD0ONx9Sz0aZn0qP8rriST5XcqX8pMxx1kxpBj6h3LRwl2wJGvYtGRRSyFseA5Es=@vger.kernel.org, AJvYcCXPALmLRexO5lQ+lRLBCbD9hDRofjhuj8kCiNCzzoSLLsBXamiTcqVUE61p+v1Xb9V8Ben497zuE0bzFA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTFSoBkav7nhxZPZ7RjZpMongEZZ6NW0jGkxDWM/j6AvRmncdH
	lvPfHHMXYeAcB7E8YPpA70o2HgPlYo+KutyDhBYuBVDojw6+0GVNfzkRh7nQvDKeZ5jLC9YcLTU
	2W7mzVCUGD+7NmVuD0Au80QfgSPc=
X-Google-Smtp-Source: AGHT+IEn+Hwu7V+p527CRGeOxJr8iubRG/Kxm+vQk7J9jg0AncgaEzcbhTFx0Ar2KxQTvDJim7iRe9IVeVTiqr9XikQ=
X-Received: by 2002:a05:6e02:b49:b0:3a0:abd0:122 with SMTP id
 e9e14a558f8ab-3a3e5306a8emr32869565ab.8.1729203916868; Thu, 17 Oct 2024
 15:25:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240919063048.2887579-1-linan666@huaweicloud.com>
In-Reply-To: <20240919063048.2887579-1-linan666@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Thu, 17 Oct 2024 15:25:05 -0700
X-Gmail-Original-Message-ID: <CAPhsuW60RP7B59i7t5fY6vTTpfe4UwQJ+c7HtugCteOH0uzyaw@mail.gmail.com>
Message-ID: <CAPhsuW60RP7B59i7t5fY6vTTpfe4UwQJ+c7HtugCteOH0uzyaw@mail.gmail.com>
Subject: Re: [PATCH] md: ensure child flush IO does not affect origin bio->bi_status
To: linan666@huaweicloud.com
Cc: yukuai3@huawei.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yi.zhang@huawei.com, houtao1@huawei.com, 
	yangerkun@huawei.com, zhangxiaoxu5@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024 at 11:33=E2=80=AFPM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> When a flush is issued to an RAID array, a child flush IO is created and
> issued for each member disk in the RAID array. Since commit b75197e86e6d
> ("md: Remove flush handling"), each child flush IO has been chained with
> the original bio. As a result, the failure of any child IO could modify
> the bi_status of the original bio, potentially impacting the upper-layer
> filesystem.
>
> Fix the issue by preventing child flush IO from altering the original
> bio->bi_status as before. However, this design introduces a known
> issue: in the event of a power failure, if a flush IO on a member
> disk fails, the upper layers may not be informed. This issue is not easy
> to fix and will not be addressed for the time being in this issue.
>
> Fixes: b75197e86e6d ("md: Remove flush handling")
> Signed-off-by: Li Nan <linan122@huawei.com>

Applied to md-6.12.

Thanks for the fix!
Song
