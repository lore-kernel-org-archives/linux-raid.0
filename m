Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BFDD78F29
	for <linux-raid@vger.kernel.org>; Sun,  4 Oct 2026 15:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791127838; cv=none; b=SNFt6V/w2VGblql+jNJJa7BOIfopb1Rr5O8a44I32blLz1mLSfFeZWjFF4LpnylROOixuhrjKCQwSRlD6yEWQAAMo2XWJSlmHSsPcm+VwQ/fTzTQZTQL9oEi8vp2ksS8H6ljSStw9lhw9uKkppvbUijtuTpkyTDkVjKBjQ01go4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791127838; c=relaxed/simple;
	bh=uSjxnJu2mQ2QLqZr5NVWVyHEfYFzQ/HML2joEyGTz3s=;
	h=Cc:To:Subject:Message-Id:Mime-Version:References:In-Reply-To:
	 Content-Type:Date:From; b=WpvXZLtKYTVExQ5nEIKFTkwz7cqr4PgjHtHZTw3IcbWZITetGaN2Kq4BssUyrCxTteHdvGhGriGwSFBLKGfjjVeGfmEtEEZaU5QnCpspll3dvbFKVQH4ItLUkVwC4TY9I5oq+G1AIgkRxVio2FPGYQIVataspdQJ3xbG2c/GHCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=NcMi0Rk0; arc=none smtp.client-ip=209.127.231.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="NcMi0Rk0"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791127822;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=34kQsg4BlHtdcqEeOgmNmC+w7iehK+Tyv/dML8ntEb0=;
 b=NcMi0Rk05Y5eIwrNOVAssLlqbbHDgMxQ7+fr9e6N4V9ToiTMxQJ/LvRHcwpBEcAIbH/K0X
 Nss64NdJbIOdFolx6/IyPT3zT5jNFsDQB0zBIPbM4fQmd9vy8jzBgAAZAmtFTFggmIeBth
 +50sHJnhgSkAhgXUG2r9kj9Kvrzqr/eQHn/5T0bu9bGax662dPCOz7ddn9UnO7qqjSIjWD
 wx7JLKsWIgEScbAtQcs3rVrnwSc/b7Vsz3NCBx4CWZUDUlHXs5FsxFC0raZG3ZDrGnblJe
 DfgMUrlvXroyA/yOHBkIFseQxGnFMywNwXHT4h0goixlsANZosDuV41+Nc1P/Q==
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
Cc: <linux-raid@vger.kernel.org>, "Changyul Lee" <lcy8047@gmail.com>
To: "Sang-Hoon Choi" <csh0052@gmail.com>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5: protect big_stripe_tree lookup with RCU
Message-Id: <ed8cfe0e-55c1-4280-bf03-4143322b5b8a@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Reply-To: yukuai@fygo.io
References: <179070265341.12871.12495446593114993799.idr-bug-88@gmail.com>
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Sun, 04 Oct 2026 15:30:21 +0000
In-Reply-To: <179070265341.12871.12495446593114993799.idr-bug-88@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Sun, 4 Oct 2026 23:30:18 +0800
X-Lms-Return-Path: <lba+26ac2710d+02d785+vger.kernel.org+yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>

Hi,

=E5=9C=A8 2026/9/30 1:37, Sang-Hoon Choi =E5=86=99=E9=81=93:
> big_stripe_tree is updated under tree_lock, and deleted radix-tree
> nodes are freed after an RCU grace period.  r5c_big_stripe_cached()
> used to run under an RCU read-side critical section, but that protection
> was removed together with unrelated rdev lookup protection.
>
> The lookup can now be preempted while walking the tree, allowing a
> concurrent deletion and grace period to complete before the walk
> resumes.  Protect the lookup locally with rcu_read_lock().  Only the
> presence of the entry is used after unlocking.
>
> Fixes: ad8606702f26 ("md/raid5: remove rcu protection to access rdev from=
 conf")
> Reported-by: Changyul Lee <lcy8047@gmail.com>

Checkpatch will report missing link to the bug report, and I assume there i=
s
never such a report in mail list, so apply with the reported by tag removed=
.

> Assisted-by: LLM
> Signed-off-by: Sang-Hoon Choi <csh0052@gmail.com>
> ---
> Compile-tested with x86_64 allmodconfig and W=3D1.
> I have not reproduced the race under RAID5 I/O.
>
>   drivers/md/raid5-cache.c | 2 ++
>   1 file changed, 2 insertions(+)
>
> diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
> index 7b7546bfa21fb0c4be62ac94ecf8c6da72b2edb3..ec819d56c612e2511738bf126=
e640511fff76050 100644
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -2952,7 +2952,9 @@ bool r5c_big_stripe_cached(struct r5conf *conf, sec=
tor_t sect)
>   		return false;
>  =20
>   	tree_index =3D r5c_tree_index(conf, sect);
> +	rcu_read_lock();
>   	slot =3D radix_tree_lookup(&log->big_stripe_tree, tree_index);
> +	rcu_read_unlock();
>   	return slot !=3D NULL;
>   }
>  =20

--=20
Thanks,
Kuai
