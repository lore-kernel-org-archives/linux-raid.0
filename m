Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A11DD30F543
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 06:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787811875; cv=none; b=fvEm6a5pCB6ijd6R3MWDpxOqSWk0m5DxErDsuJO/uZfvAtiSGYVfWE9HX7xCNXtB9IekDE6idOyOgHgX4Xy8eJeWn7PSEDpMDxKtoDN+GOVIVPJpBPedhgk9WFbVwcJa2uJvQ5b8nkiOFhjN3y3+45nuwhNKdFgVfJ2DqQxkiDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787811875; c=relaxed/simple;
	bh=qE3F1zmchNm9/NEWOId5WiLxuHPCo7NZITUGbzmnuxQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=N8NdUoWYjZ80XSK2M5WeTuEDNLsA0o/mgLqOXnnq+xMlnxTXNrMQElg7hLqn46ylb067sBRBvNvBupM5LAzAmiS6tvrpf0E8yJx1+mC65c7+y2z4hI4+tN+b/2mRp7zHQeqvjwU144ulvwqkz4NvfxKON8E1cZQMW+SXx/8kXp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DaW9tW7o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DaW9tW7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E551F000E9;
	Thu, 27 Aug 2026 06:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787811874;
	bh=WoPOWgLmL9D7pMsauO/SSjo7iwayVrIzSOB1+Jza58c=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DaW9tW7ouenVeehseQRtb0XH/2mw++1BcFMUethUYvRRBGf8PX2NO/01BnFB4MBlu
	 EWb5mML3UMZav5ODCGqeAsuaFDbBWP6fiZhqPJiiZOH//TK554hVJiWxJAcFjNY/e7
	 ks2j9wD9EyGezqZSHJtls5IlwyEPhT+WlFmWptnqArX1hHMmYQC7OlsCFyuIPQcnqO
	 upo18xmcwgIkDMGy25CDfbagAp1f+xV9t3RuRkhduQzFBGd8+i1GmEPjJ2EHUaju8i
	 /zDmCJppJO34EP623eN6EcYXht7ortZoo3xlG0TNa4jGejZ4K7w8f+kslYon4MwYgD
	 k2ZNdNmoEm41g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] md-cluster: fix ack_lockres leak in __sendmsg
 error path
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260827061200.79753-3-ghuicao@163.com>
References: <20260827025229.40138-1-ghuicao@163.com>
 <20260827061200.79753-1-ghuicao@163.com>
 <20260827061200.79753-3-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 06:24:33 +0000
Message-Id: <20260827062433.D2E551F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] The newly added error recovery logic silently fails if the origina=
l error was a timeout, leaving the lock leaked in EX state and defeating th=
e patch's purpose.

Pre-existing issues:
- [High] An infinite loop and CPU soft lockup occur in the `failed_ack` cle=
anup path if a previous DLM lock operation timed out.
--

commit aed4dde7a766dd41cf7dc88c61e2ae9c8fd7a612
Author: Cao Guanghui <caoguanghui@kylinos.cn>
    md-cluster: fix ack_lockres leak in __sendmsg error path

In __sendmsg(), if the down-conversion of ack_lockres from EX to CR fails, =
the
original code jumps to failed_ack and leaves ack_lockres in the EX state. T=
his
commit attempts to fix this by adding a conversion of ack_lockres to CR in =
the
failed_ack path.

> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index bc4118d8c5a9f..7c6aa759d0c23 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -801,6 +801,8 @@ static int __sendmsg(struct md_cluster_info *cinfo, s=
truct cluster_msg *cmsg)
>  	}
> =20
>  failed_ack:
> +	if (error)
> +		dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);

[Severity: High]
Will this error recovery logic silently fail if the original error was a
timeout?

If dlm_lock_sync() times out when acquiring DLM_LOCK_EX for ack_lockres
earlier in the function, it leaves a pending DLM lock request in the
background. Because of the uncancelled pending request, calling
dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR) here immediately fails with
-EBUSY and its return value is ignored.

When the background EX request eventually completes, the lock is left in th=
e EX
state, which could still lead to a cluster-wide deadlock.

>  	while ((unlock_error =3D dlm_unlock_sync(cinfo->message_lockres)))
>  		pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
>  			unlock_error);

[Severity: High]
This is a pre-existing issue, but does this create an infinite loop and CPU
soft lockup if a previous DLM lock operation timed out?

If a timeout occurs during dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_C=
W)
earlier in __sendmsg(), it leaves a pending lock conversion request in the =
DLM
lockspace.=20

Because of the pending request, dlm_unlock_sync() will immediately return
-EBUSY without blocking, causing this to become an infinite loop that floods
the kernel log and soft lockups the CPU core.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827061200.7975=
3-1-ghuicao@163.com?part=3D3
