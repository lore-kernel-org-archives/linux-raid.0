Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E9102E613A;
	Tue, 25 Nov 2025 09:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764062997; cv=none; b=GwjjHWs58eALgUff8NHgzX9ztRV8B9SafkB745B63u+L6GSL45ov3hzcOVrtsMJCgGKzAR8aPXb1xb45xr1PEeO3+qEmII3KhYeELds5s05CiICNBjpMwMfkZ1XUsRGOFzxjzeFxhTYf+6wE6paDgCRxMMckSYV6qfeovmDasIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764062997; c=relaxed/simple;
	bh=NKy/zIFWyoD4WdHy+i3KxKzG5ZrXrwfJwFkWFvGtJrs=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=iynE4e+aVxjlCEF5Bo3pvgw6ksB5sbOfvG7ieWxlN5GanBcshlsxQArKuMH5A1ba8Rdup2S4PAiBVU8iwZKYLICv/SGOgQkErZwbSjzz4U1qq4gXXIPYZzPHaiWOYg8lqgjNl/PAI+p1znVH2twykhFlERsS9p3bpsjfC1ZNrRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FyjPSYV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FyjPSYV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04936C16AAE;
	Tue, 25 Nov 2025 09:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764062995;
	bh=NKy/zIFWyoD4WdHy+i3KxKzG5ZrXrwfJwFkWFvGtJrs=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=FyjPSYV6Vtt9/jriwhz4nzuLnq4mO09e4a8whVOQTZhC4M/7s5i2tBc6jrErFT7/Y
	 qLfmotNxFAruxkh4l5m86DFv3/pO/oPaZArv1tB4fs9hdJojMc9XlGPb3bDrK/x10d
	 3wukyfQ1Nztt7vEpkhQMgTPby2ykWKBVZuAawI0VOfQQsO40GPx9+5ou1nsAO9CL+N
	 dGBENDPC0u+RDwQEPp9K3PFfxGkHTKtxbbB1ng6heW7rkrE+ZzKy/KbfAO29S1XZHL
	 Z/LcZkSq8ps3AHEL+6Ph66g6QZ1jQJRCiBOz1BTM8fvW4ZvLwt//wd8jLkMoyvqFj8
	 CuUGCzBr9g1fQ==
Date: Tue, 25 Nov 2025 02:29:53 -0700 (MST)
From: Paul Walmsley <pjw@kernel.org>
To: Chunyan Zhang <zhang.lyra@gmail.com>
cc: Alexandre Ghiti <alex@ghiti.fr>, Chunyan Zhang <zhangchunyan@iscas.ac.cn>, 
    Paul Walmsley <paul.walmsley@sifive.com>, 
    Palmer Dabbelt <palmer@dabbelt.com>, Albert Ou <aou@eecs.berkeley.edu>, 
    Charlie Jenkins <charlie@rivosinc.com>, Song Liu <song@kernel.org>, 
    Yu Kuai <yukuai3@huawei.com>, linux-riscv@lists.infradead.org, 
    linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 5/5] raid6: test: Add support for RISC-V
In-Reply-To: <CAAfSe-umv64D011cjxPJEc0dBK29Xa4u6m1T=-THZ+V=a3f+JA@mail.gmail.com>
Message-ID: <2b81141c-2fcf-3083-e99f-a6205e121ab3@kernel.org>
References: <20250718072711.3865118-1-zhangchunyan@iscas.ac.cn> <20250718072711.3865118-6-zhangchunyan@iscas.ac.cn> <00a97b26-0269-4c07-99b9-33bb759067f5@ghiti.fr> <CAAfSe-umv64D011cjxPJEc0dBK29Xa4u6m1T=-THZ+V=a3f+JA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

Hi Chunyan Zhang,

On Mon, 13 Oct 2025, Chunyan Zhang wrote:

> I noticed patch 1-2 are in 6.18-rc1, patch 3-5 haven't got merged, not
> sure if there's some other plan for these patches.

Those were deferred since I wanted more time to review them.  I've queued 
them for v6.19.

thanks,

- Paul
