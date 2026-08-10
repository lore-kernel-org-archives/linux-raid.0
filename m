Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B4742D2487
	for <linux-raid@vger.kernel.org>; Mon, 10 Aug 2026 14:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786371138; cv=none; b=NcyXXr1W8MkAuW/7V6VRby+VGJkfm6997IpY/aSvoFEXQ5FYmfcFFINDXNY6lVXLyVU4G9Hn2UUm1AjqhLwoZb32CD1t2vhKAIfja2892H36WNkWLzLag8NUwvKSQ4XqBf6+9NKiyTRUa7mL0y/7WbGP3PDcrZ2gLmxk5lb+A3s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786371138; c=relaxed/simple;
	bh=BEXg08D66cGoHiKXJpPXp/uX4mTXCBJYU9fmNuWZ7Mk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=o7wTqAoRJKJnD18kk9E2/iRt8oW0KWP7Lb7sPMGvKYjpc0VHhJV8Ws2V7pSmRGWmUaAOQPmwo5Cs6s5GZQc1zC9ojsVMXl2sARcM2I+ZRkPp5mjujsSLmcTkE50oGVazQ02/VRjLXDuwgg55DtZzX1yqYRte37CBEbvMQ1PDAlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AwOFzj8D; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AwOFzj8D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AE7F1F000E9;
	Mon, 10 Aug 2026 14:12:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786371136;
	bh=kyN+ljemX4TpCfLpWWCxOzMWpPytLXYvhtmPdvmDrlo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=AwOFzj8Dw6hhZEmZ76wKkkD49Tqz4Tl+I4Z1hWclWScaNgJxQtvi8qdmTAkx7e0a6
	 ML/jNRt4R9+By7p9kOn+dXLeJHGsv5FviBeUincAgNYfGAfbdCaDaBWTOZmwJbVKND
	 nzz8nvEBAFtqpSpdcICd26IeD8RcXmyg8J6F+WcMN77afooqF9Q6IvNbHDxhH8V+YM
	 es/k22dAgTOMmgK2+zSB+j4HZrHHcDFoFiTWkc7PAp42maqypdwtdxY00ghkE8qttT
	 UIrDx2cH+poQc9vkLbf4q32dNcUqX05HNmTO6wu8gmc1ddmIzi10vPG7lcEqfYPx7b
	 47zykGs94CV5Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md/raid10: fix missing wakeup in wait_barrier_nolock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zizhi Wo" <wozizhi@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260810135521.3470422-1-wozizhi@huaweicloud.com>
References: <20260810135521.3470422-1-wozizhi@huaweicloud.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 10 Aug 2026 14:12:15 +0000
Message-Id: <20260810141216.3AE7F1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Low] Lockless read of `conf->array_freeze_pending` lacks `READ_ONCE()`, =
violating kernel concurrency guidelines and potentially triggering KCSAN wa=
rnings.
--

--- Patch [1]: [PATCH] md/raid10: fix missing wakeup in wait_barrier_nolock=
 ---
commit 3470079c0f4271a77d161b3a70575176ea1d322b
Author: Zizhi Wo <wozizhi@huawei.com>

md/raid10: fix missing wakeup in wait_barrier_nolock

This commit fixes a hung task issue in RAID10 by ensuring that
wait_barrier_nolock() properly wakes up a pending freeze_array(). It adds a
wake-up condition for conf->array_freeze_pending when the pending counter is
decremented.

> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df8..fad634a444f89 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
[ ... ]
> @@ -996,7 +996,8 @@ static bool wait_barrier_nolock(struct r10conf *conf)
>  	if (!read_seqretry(&conf->resync_lock, seq))
>  		return true;
> =20
> -	if (atomic_dec_and_test(&conf->nr_pending))
> +	if (atomic_dec_and_test(&conf->nr_pending) ||
> +	    conf->array_freeze_pending)

[Severity: Low]
Does this lockless read of conf->array_freeze_pending need a READ_ONCE()
wrapper?

Since freeze_array() modifies this variable under the resync_lock seqlock,
reading it here locklessly might trigger KCSAN data race warnings or be
subject to compiler optimizations.=20

While atomic_dec_and_test() provides a memory barrier, kernel concurrency
guidelines generally require READ_ONCE() for plain lockless reads of shared
variables to prevent compiler optimizations.

It looks like this pattern was copied from allow_barrier(), which also has a
lockless read without READ_ONCE():

drivers/md/raid10.c:allow_barrier() {
    ...
    if ((atomic_dec_and_test(&conf->nr_pending)) ||
        (conf->array_freeze_pending))
        wake_up_barrier(conf);
    ...
}

Should both of these locations be updated to use
READ_ONCE(conf->array_freeze_pending)?

>  		wake_up_barrier(conf);
> =20
>  	return false;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260810135521.3470=
422-1-wozizhi@huaweicloud.com?part=3D1
