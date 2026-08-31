Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E71353A9861;
	Mon, 31 Aug 2026 22:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788214168; cv=none; b=BOXCrkdqKSDfy+vhlG6WS7au1wy/L1EZi7B/kC5rIk2zhBLN7zSQrp0fGVeZkKKOAv7th2Ba6yU+DcLYX8/tn4RAoH4APURACPbUOvDmn6B6yzmVGPXWe6HCiQ7LmnKS2KJrFawEPJuN9+sVwMnH/rwYJ5yAo9AKu1wN4tzcUKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788214168; c=relaxed/simple;
	bh=gsaCiGHwWjsNJ4Jdsu8TSc9diuCKB4rP0w9xLfqh3hc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LqS5QTsX1E3q3JdVCLB9nfvmd9A37MT+ybdF1jQoTzIxSNtZKCQBDY+pdDUwwoHHLuFYXg5mlR0ewvZ+ZST+yQA2HFmlYd91G1+z5x3NfOMAE2HGMBAhst1NW1weqXBd/OV7HrlnRxrMeU6bgI2XIg4gTbcpuHZ5erMWYIQEw7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=brAftjV9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="brAftjV9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69CC71F000E9;
	Mon, 31 Aug 2026 22:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788214167;
	bh=w+zouPJaqRZp5dJjnc8IsacOODuHuyxBj8Q0RiIoqNE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=brAftjV9T4pQGK9vatL/VskwlonhQ4IpwwBXNAM+FWEz/aNDOwOrl8+IP2uSxwZNI
	 LNn5Uj8tltlz3a6/paZu6twOkblMCG8QOYGMlA1iFIDcSGw3Gxb0/MPzpS9dbxZwSn
	 DSgnHf7Xsn3O1CJq1UiPzdsQlgnP652lJHVuAFc0iUcXlf0al0ntBayPJYhJbb5+OW
	 VxBPU3nJw8+AMOl9BPZgjT8+AnB0XHPRPJEgDQIlEGDzYNcUKAoc0XvFGR2A7UqqMX
	 X8BEnjVfh5GLamTtGjPjUo12IE3FPcaVuwlAq0ixhSCzLvd3+aTx1c0UACcWmpykOH
	 VUEzCe4o0G4VA==
Date: Mon, 31 Aug 2026 15:09:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Subject: Re: [PATCH RESEND] xor: add missing vzeroupper to AVX code
Message-ID: <20260831220926.GH86114@quark>
References: <20260831212248.213805-1-ebiggers@kernel.org>
 <20260831220658.ADAE91F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831220658.ADAE91F00A3D@smtp.kernel.org>

On Mon, Aug 31, 2026 at 10:06:58PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> 
> Pre-existing issues:
> - [High] Incomplete fix: Missing `vzeroupper` in parallel AVX2/AVX-512 RAID6 and crypto implementations causes severe AVX-to-SSE transition penalties.

Already addressed by other patches I sent.

- Eric
