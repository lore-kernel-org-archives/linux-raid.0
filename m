Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C375410F2
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 06:18:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787811495; cv=none; b=SZ8WOQ0ecA+jhKYs5mnvSTvd50P1VseWCX+mW8mc+hrQNE/rAnf0X9Sh6qoKwooMAAZkkMG6eD4LOjIBLgWhLuAlZeF5Dgf8oh+JreIGCsSkspIFd+gJ9W6sJ0ckJMZUsSeZ8yogMhX+AlmGWOrBBt1YqJpY3yLKJJAGCxBZQ18=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787811495; c=relaxed/simple;
	bh=8TZv4xe38hsJp2t5YR8qxf5DkdoPSnLd5cJ61Rtr73w=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=E7IemlUxIATDnnNGrm4ZA7zFmjQiqlTuUpm9OFyE2uiEG+QRzZqBlKPiikqkKjlGE3klxQ/XeZvoc+BYWq5aqdOouc9KD5tkQ0rZk+kxCHsJr2nTp2F/OOYf4TqC/ZEPQoCbHm50jtTJL5LnE9sXBCtJwzynaltIjL2AaY70xKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DAQjGDuS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DAQjGDuS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B5671F00A3D;
	Thu, 27 Aug 2026 06:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787811490;
	bh=7BAcYrxFjqfLOlvShoD2rNsqn8WMBPiWjsyHm5QJfPQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DAQjGDuSHaRJECvdjLl4B33mJGDxNpYwv+CPnP69NcWJpxJJoy/SCnIqnpbx/FgLv
	 xihO62+4uAOXPby/GjsvuRPq9L7shvY479wBFdFT89oRXFdYW9+9hq6rCfxU0w6aVe
	 TTzbaK0OtYT5+3thUPlb1agR2oM6AktEDdtWFoinY0CndiUW/j25YitU6lB8S8sHmx
	 CmBtxyLp4IAzfuBMZYqXVeg4h3cBHZz/CbnImy66jN+TRasfMSndZFUFI9O0+aUsqj
	 9svnIZa0EIzRNzqH8PcsT1FuJ2mFYExkKpPKT6WExG4FLgTVYqKrTrJTLRPH3wxlKH
	 Takdc3Z68UvIg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] md/raid5: fix NULL pointer dereference in
 raid5_free_percpu
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260827060554.77849-3-ghuicao@163.com>
References: <20260827023803.36602-1-ghuicao@163.com>
 <20260827060554.77849-1-ghuicao@163.com>
 <20260827060554.77849-3-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 06:18:09 +0000
Message-Id: <20260827061810.6B5671F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] Data race when checking hlist_unhashed(&conf->node) locklessly.
--

commit f000e30dfd8bae5a7346baf7add33f6d2b5316e6
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md/raid5: fix NULL pointer dereference in raid5_free_percpu

This commit adds a check in raid5_free_percpu() to only remove the CPU
hotplug instance if conf->node is hashed, preventing a NULL pointer
dereference on its pprev pointer during error teardown when cpuhp
registration fails.

Cc: stable@vger.kernel.org

> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> index e481c48b45093..537225c14a236 100644
> --- a/drivers/md/raid5.c
> +++ b/drivers/md/raid5.c
> @@ -7548,7 +7548,8 @@ static void raid5_free_percpu(struct r5conf *conf)
>  	if (!conf->percpu)
>  		return;
> =20
> -	cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
> +	if (!hlist_unhashed(&conf->node))

[Severity: Medium]
Does checking hlist_unhashed() locklessly here introduce a data race?

If one RAID array is being destroyed, it calls raid5_free_percpu() and
evaluates !hlist_unhashed(&conf->node) without holding the
cpuhp_state_mutex.

Concurrently, if another array is being created, it might take the lock
and call hlist_add_head() on the shared CPUHP_MD_RAID5_PREPARE list.
If the destroying array happens to be at the head, hlist_add_head()
updates its pprev pointer via WRITE_ONCE().

This concurrent modification can violate the kernel memory model and
trigger KCSAN load-tearing warnings. Could hlist_unhashed_lockless(),
which uses READ_ONCE(), be used here instead to safely handle concurrent
list operations?

> +		cpuhp_state_remove_instance(CPUHP_MD_RAID5_PREPARE, &conf->node);
>  	free_percpu(conf->percpu);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827060554.7784=
9-1-ghuicao@163.com?part=3D3
