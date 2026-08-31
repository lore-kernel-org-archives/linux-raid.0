Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFD437DEBB;
	Mon, 31 Aug 2026 22:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214192; cv=none; b=QzzADkQ0wZ38pUhrM3X2rAbTtl8UIAOtZmqsg0oxc7MKW2CFom9g0hnVUHC1a1anr/1pJSsDwk4XAgaZ/Nm3ECPhSLq1eqo8wtmqXesgWqvrnnfqoeMfOwsePd7kWMKLt7V9y2SVZGlUiiQY64Vxn1ECJiN4QOwlBsi8qoVJKNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214192; c=relaxed/simple;
	bh=/iC6xJJUIQpfixwHpH/e8GK63KK0JkBeM0VC2ufMo7U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SLuuwH7OIuBs+htyk9Ft5Lf9DdetEGM3NINWUe7AlFhXW25CHIwz+0d4OmBhbw3FzOzxAoNnIMCfXmgZAgQ2bGtxhQCyxwMCn/egzJZ8vo3pEl4OmV46zbdbkcbHkKP0wgBynlkM/4KUBKtvONtDdHrLmiZpeBL0SI8c7uHQzPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l2UioUEu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l2UioUEu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99FB01F000E9;
	Mon, 31 Aug 2026 22:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214191;
	bh=PzWWnr0hiy9peB+s9jyKzukHRtZJ6bRxbLzBUNXAu08=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=l2UioUEu30O9vSijgHY9Ls4ZtLZd8dYtj8hBJTytWSmXTysWW34NwXZATF3cFea0M
	 Ir/AIkz+L5Aa8OfYoxcNjENvwz56q5iozRw+xdGjt275tc/pWlGFVseuC66vXnL7Vr
	 RViANhetW8wUNDEtLAZot2g6mW/ymJqRCMNKqZpkWOpsH3J9q6xN1eQ9402gPjDudy
	 wMQ3/xJh3nuTH4JxXGF3t4XHncSwoNW9NPdwYdvho5jRM98TPtkRxj3Fx+3vu08UTD
	 bMVwdk3mL44NgCtV55raLCEcb4Iv+pIz+7dIkaFAzLxxQASWX3PsUnLx4ulp0BmZMd
	 AKRa2+qNCuD9Q==
Date: Mon, 31 Aug 2026 15:09:50 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
Subject: Re: [PATCH RESEND] raid6: add missing vzeroupper to AVX-512 code
Message-ID: <20260831220950.GI86114@quark>
References: <20260831212316.213896-1-ebiggers@kernel.org>
 <20260831220754.8CD601F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831220754.8CD601F000E9@smtp.kernel.org>

On Mon, Aug 31, 2026 at 10:07:54PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Missing `vzeroupper` in AVX and AVX2 RAID6 and XOR implementations
> - [High] Missing `vzeroupper` in ARIA GFNI AVX512 crypto routines

Already addressed by other patches I sent.

- Eric
