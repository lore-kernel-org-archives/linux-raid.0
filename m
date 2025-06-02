Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676BD224B05;
	Mon,  2 Jun 2025 17:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748885004; cv=none; b=DUtnxE2HbaJvwTF+vGKC6R0UlQ6XMz+gVe0NmWzApUvsxO1Lhc/8QY30z8M8sSi5tvVgFQ4TOTytaDIJ1IscWSf/ObnE3c6/eZyp8O/pO2VrzNKGfBm8sQRMJZ67G1VhxgSKvELTr9agjEozZlO+rE8fbwuGg+0Ns31IgUUhdqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748885004; c=relaxed/simple;
	bh=ga12tScn4AglgbH9jFsvtmQdSd0t5oIzNAxw0Gf5FBk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EIcQRZezCDmaZal0xjEoqY8zQ7jrg4InW0elm2TffP/+/XD+VxA+zWZTbTwRAbm+nMgUhKvdzlbJw9plovQvoFfDsFMS7YcUbSkIbu2ZFGAeRKm/Rxva8vrMRqBAzkfCCnxO5A0Xv7jYwEdQu0Gxuh6C5drGuuEai/pqpYkF290=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M+GVbc9e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M+GVbc9e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC105C4CEEB;
	Mon,  2 Jun 2025 17:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748885003;
	bh=ga12tScn4AglgbH9jFsvtmQdSd0t5oIzNAxw0Gf5FBk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=M+GVbc9ewpCrX1MAiudwe7b+vM6TGJRcKslK7oZGvfPvia/uGuyny2Je6k0paNdcw
	 0vjRsZhHf06/T8Aq/cWPYcADN7zONvQdJnLo/4Uf37M9767zs215FuMqLyXA2BijFm
	 cBO/Tp6vKB5qIAZvmNak7uTBwSWF9ArQCKbEU2s1dazPr05BaGdN8VmBQVS8InUYRS
	 7jYg92/6MOk139fWknJ+0P+f8T3vDg9NmTiQklsZ4OIvWmjhGXRgv/wODE43WAtTmx
	 DNeUMa+YzLRf11Cxi4q5ehxnondECWZ08RY7tv3xO0x0Im0Z4psU83t2I2mRMubDee
	 mZNPD5xEYvOqg==
Date: Mon, 2 Jun 2025 07:23:22 -1000
From: Tejun Heo <tj@kernel.org>
To: Ryo Takakura <ryotkkr98@gmail.com>
Cc: song@kernel.org, yukuai3@huawei.com, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid5: unset WQ_CPU_INTENSIVE for raid5 unbound
 workqueue
Message-ID: <aD3eCqdH5nwftMiu@slm.duckdns.org>
References: <20250601013702.64640-1-ryotkkr98@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250601013702.64640-1-ryotkkr98@gmail.com>

On Sun, Jun 01, 2025 at 10:37:02AM +0900, Ryo Takakura wrote:
> When specified with WQ_CPU_INTENSIVE, the workqueue doesn't
> participate in concurrency management. This behaviour is already
> accounted for WQ_UNBOUND workqueues given that they are assigned
> to their own worker threads.
> 
> Unset WQ_CPU_INTENSIVE as the use of flag has no effect when
> used with WQ_UNBOUND.
> 
> Signed-off-by: Ryo Takakura <ryotkkr98@gmail.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
