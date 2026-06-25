Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D652130566D;
	Thu, 25 Jun 2026 17:52:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782409943; cv=none; b=IDXZKiA5gd9WOt+VhZ0DAS3Qu7WjYaEILYnkYQwj2CjI8gIYT1qz83M2AWaDgmZKUHSCdvHU3Y4Zoxc5d+5/aTEDv03jp0aB/ID50A3yHpEN/hElkSgRlYMIXr1sr4VJJO5gDN9hUxM/a3xzFdwrMzNGYcTQUbuGS783naw4LlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782409943; c=relaxed/simple;
	bh=ZEUPcnrxwB596h8iHROwLFkRuZt3+WiceDSNklFC0rM=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=bcFfeXKH9tYn8J1Av6CUBWH4eWTlfzfVS+M25eja3OG3ZkJf0GyZEtQ9UkgBYmy5xbhdAD6bk3UGtJlVFT+1pk5pXcYbRZc5COTrnmclmw3yFQ2ogzvHdcZLcmk9DtniDyMXI92apUxAPLVSVhYQxDPIAL+a9aqeMukjNtr9nJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wq/w/ZI6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wq/w/ZI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C1E1F000E9;
	Thu, 25 Jun 2026 17:52:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782409942;
	bh=JU0P9IYNNvAPoItpTvJHJtYjPEJqeL7pK8Tyomn1UOQ=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=Wq/w/ZI6K0nWiROJ/bxhRAEOG93VNpkW+CQBn+fSe8iCZF3P1/GCyPEI/1RAnTYkf
	 q5Udt8l62Zab3hFH7HY7CjSt3JLHgpAKh31z92w5RK+/3cBi+nI21IirmCfTBSMSdZ
	 CZE5+2V9SffoWZJVmDNi/HlUGBiAd0Gk2c6SWND8e8h+XLF4TEh4r6txsJC+SHsms4
	 NSjl07U34iYJSERsFkZwvOw8LPOy5ZjIC9gcJgA9t0weTSyeOeoMjhfIfb0sZkTmIe
	 8tQFR0YR9oFi2Uxxe1YbO2noIPvmcLC9753MQQg1O5UmM+Ghk5Sci1a1JaSaXoo2vl
	 kgQ+fsNAT3lPA==
Date: Thu, 25 Jun 2026 11:52:21 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, 
    Yu Kuai <yukuai@fygo.io>, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, Paul Walmsley <pjw@kernel.org>, 
    Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH] raid6: fix raid6_recov_rvv symbol undeclared warning
In-Reply-To: <20260622135535.481534-1-ben.dooks@codethink.co.uk>
Message-ID: <0fda7943-d1ec-3bc6-d383-82b2aa9b4743@kernel.org>
References: <20260622135535.481534-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 22 Jun 2026, Ben Dooks wrote:

> The riscv recov_rvv.c should have included pq_arch.h for
> the definition of raid6_recov_rvv. Add the include to
> fix the following sparse warning:
> 
> lib/raid/raid6/riscv/recov_rvv.c:218:32: warning: symbol 'raid6_recov_rvv' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Thanks, queued for v7.2-rc.


- Paul
