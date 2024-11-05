Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F5F1D1748;
	Tue,  5 Nov 2024 23:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730850661; cv=none; b=T4gQGRdUlivJVe3DkSh8aBj3JdZNgYUhpTjqXevALqDa9Xfte42yxtJY2v0ReyEU0cMmvpv436YCDk2jk/qk9nIK21CNzV1+2w0WKMLqWgNR/nZ0xL/cStVj6AEcWokkTLBqT8YbgoJs7yMiC0mui+Ebj/O3vxLWHDmHH2AZv8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730850661; c=relaxed/simple;
	bh=OPO1yTXECQWsGZggWo9SfTv9ya4ac6dTnocqFqdbdfI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WCqJfNTgsDbR9ybFE3n0e8aXFRjMvE18PZUvA0Vaz7A9ZnADiq1z3wpFX5Ahot5beCqodjb0sqSfEk0re1eLUPWzYvYtFIj27767Pc9E6bmGIqfQMkeKemmN0IwUgIBU2DC9kiLpJHXQI9GRt5/dyfxx5nftdhoVfPptKz9CoNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=og/KMys6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="og/KMys6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ECA9C4CED1;
	Tue,  5 Nov 2024 23:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1730850661;
	bh=OPO1yTXECQWsGZggWo9SfTv9ya4ac6dTnocqFqdbdfI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=og/KMys6CfnPuXiPtZHnkMUi3TcYRwT67ys1DvXc/7p72kvxEuRRi+qhb1OFzug59
	 84Nde4GaNq7cDsDNrDDPstl68WTnn79xNUF7irV6SvHFkoxmnnU4v6HmbdNS2F0mvr
	 y7AGGUmmaJVfTo7paRLBg9gMW9vUYbZRz53NWYrR3gmVJfWA9GXxlsbLKpTkzcb8zF
	 rXb+CQE5RAl8aJHxVik08o4XrykMLa9iJUumrCz2yVWZ4PY9Gg72uyqF5n1J9cwVUB
	 ZKr/imwfRsFU0IW5hw4amJKL1Yl3p4N5gUH0BkfeKYywfq9vW9paFO8iOzRcyX08M5
	 6JV7qkzrDCUQQ==
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3a3aeb19ea2so22545085ab.0;
        Tue, 05 Nov 2024 15:51:01 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVTUlh7rucl6XH9f/B7lBuAvv2b4tM+JiiWeOBq5o8GDNw9BDUSxJHEGA5QnzAmet+3sr8rHGCR2WEjluo=@vger.kernel.org, AJvYcCVhH2spA3Cd1SUoXMC2DfVsW6NtgQpq+8M6q0zOwmWWtK20XOoZc+y/bbuIwHEOLRAEgxSVgkLHb7ezHQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCErgVhht0lT0Q+eHweREKk50noud3dakbERiF1dzb5DWfW2rD
	08P69uYAako/hTu+a4KJt7SMFHyPyc1H2fQG5MFAhuEiqLXwzSAmDRrBdUeVMFsCJU8sqt7Vjd5
	BO1rXOZDqPw6vnyuEsi203EXX+ck=
X-Google-Smtp-Source: AGHT+IFLXgpj+Wnq5NKz2FkJgxIWuKfKb4zYsCWA+wM5btLp0AW/So+5GmGSZyH+PGdVQmwwF7qtlERqKoAzXTpLxjU=
X-Received: by 2002:a05:6e02:1a25:b0:3a6:c023:7e35 with SMTP id
 e9e14a558f8ab-3a6c0237f0amr112682925ab.8.1730850660678; Tue, 05 Nov 2024
 15:51:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
In-Reply-To: <20241031033114.3845582-1-yukuai1@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Tue, 5 Nov 2024 15:50:49 -0800
X-Gmail-Original-Message-ID: <CAPhsuW5jEycXAxad5xLWEpT7-+nAqE_pZWM60ewESiHTPqb7VA@mail.gmail.com>
Message-ID: <CAPhsuW5jEycXAxad5xLWEpT7-+nAqE_pZWM60ewESiHTPqb7VA@mail.gmail.com>
Subject: Re: [PATCH RESEND 0/7] md: enhance faulty checking for blocked handling
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: mariusz.tkaczyk@intel.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 30, 2024 at 8:34=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Why resend?
>  - fix a wrong condition in patch 2;
>  - the md-6.13 branch will have to update;

Applied to md-6.13. Thanks!

Song
