Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37D9A35C1B7;
	Thu, 25 Jun 2026 17:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782409844; cv=none; b=UJrXU+dObaqGkm7UMsfMsVhxv1Hh0nQIIL6EA4awu7pq13HdVC6+kaFlSlIEqg7+aeSqLxWDeE2g++4+yrJY3hygpOuErZ+bCHMaJ3U67t/J+ZhjEpucawj741chwBqxWrTuOFI24zmrmNsa4//rD7e3gmLhSRnvcznIbRNjx/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782409844; c=relaxed/simple;
	bh=T55jaUEUTlBhvMc1SpxRFxItOZUFTnH5TOAEkeHHIn0=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=fSsFpXH/z5NJRc4EUuATb5EFqGyjbAec6p7G2JChjvJWetPIU7//qgt98+ZK5U/kMhUsZyvrOoIdrWiPGsDud9zHSqhFsrj1NqXZ5QHzCQ+BXC3c3iScWUHpks4VsTYpSS0tNcaga9Q5Tur2CiSlpXsN28R7mH3XhxyJNePiJKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HX1vnsIg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HX1vnsIg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47B6D1F000E9;
	Thu, 25 Jun 2026 17:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782409842;
	bh=ogvPRLayn8DE5SVrc2dTDIbJN5Y0rcwk+c0Mk5BtyfA=;
	h=Date:From:To:cc:Subject:In-Reply-To:References;
	b=HX1vnsIgoJ7kYRaLL6ztz+9L5WVI3wZV+QE4CyqwpqmUlA9eHcoZ5a9Ut+6VD9s1e
	 p+CJNHaYvLew6rhulPgnlN05N2A1LgYgQpPcCNYzZAR7Zej0NjAy7ZVF02FqZ/ymUn
	 d0AT74dZuWe3OTB8iLAD/ZtF11RC+H/AUQxaEdTt57dlI9vXPsALBoiDPwLreINGXN
	 ig/Stt8KRw0uarlut0tcagwInwZsKlps6XcOEBvae1zu5U48PplNXA35biaeqGaZjK
	 PMvqUBSnQ6vrfXu7/601NAhDfmapwvZAuMIc5n90svZ6j7ZwQZPxGNzzFdyqDj4qAY
	 544jrsqHR+EPw==
Date: Thu, 25 Jun 2026 11:50:41 -0600 (MDT)
From: Paul Walmsley <pjw@kernel.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
cc: linux-raid@vger.kernel.org, Song Liu <song@kernel.org>, 
    Yu Kuai <yukuai@fygo.io>, linux-riscv@lists.infradead.org, 
    linux-kernel@vger.kernel.org, Paul Walmsley <pjw@kernel.org>, 
    Palmer Dabbelt <palmer@dabbelt.com>
Subject: Re: [PATCH] raid6: fix riscv symbol undeclared warnigns
In-Reply-To: <20260622135207.480540-1-ben.dooks@codethink.co.uk>
Message-ID: <e15b7b96-33f7-73f8-f5e7-47bcdf271894@kernel.org>
References: <20260622135207.480540-1-ben.dooks@codethink.co.uk>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Mon, 22 Jun 2026, Ben Dooks wrote:

> The riscv rvv.c file is missing the include of pq_arch.h
> which defines all the exported functions. Include this
> to remove the following sparse warnings:
> 
> lib/raid/raid6/riscv/rvv.c:1225:1: warning: symbol 'raid6_rvvx1' was not declared. Should it be static?
> lib/raid/raid6/riscv/rvv.c:1226:1: warning: symbol 'raid6_rvvx2' was not declared. Should it be static?
> lib/raid/raid6/riscv/rvv.c:1227:1: warning: symbol 'raid6_rvvx4' was not declared. Should it be static?
> lib/raid/raid6/riscv/rvv.c:1228:1: warning: symbol 'raid6_rvvx8' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Thanks, queued for v7.2-rc.

- Paul
