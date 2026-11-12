Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794476133;
	b=2I5ZG86D53SuW3jDpxTJgB9sQ+Hd6AJSreCqCdCp3/G7nooh5n5WOj3zTasfTSaxRIW/
	 kNLCIv3d+YWH9Smp1ITP+IgBa6YLgq07IfzOGKghI5Cr0WFoCwbGN04GFsTva8bT+rTzJ
	 D9etKBsV07WCOidUMtvkjgEta6Nxs2ohTeXE8LC3uLCC/sBU9KFTHQU42RUwdjMCC4MNI
	 cMLrj3eHAUmzPfBaKddtQScVf1nTKSVm4I8ePbUrxVcMdD8UbkS0kzgmH6gm80ISiXU0E
	 dspokgRFLAR5ugDi9WOKRXSNzm4HMDqXD5W2ob9ikQ2M5wDSXAiv2PpGLItCcZXduig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794476133;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=EeTMa4I6noKiJNDeQgkS1+gL/tZCUdiFE8G0Og9PAb4=;
	b=Wga76DOv3FZDzGxuiyOk/Nm6+Qrv7jMdCZRP+fVwpXmzB5az7kGyj3+kaapIK6kbp7+l
	 BVUMNqqvxK7b9Xge1Ge1JYlb3TDgx348phh0XnW1WOXN/JLTbPHID9SyJYAHfuVMkzBSK
	 Vybn/owPpbutHI6jzMucsvKrW83P+xzEikpU+Q3QmRWGzzGJFDxL1HqotRzNDqP64zhJU
	 c57zib8gx7RU4R4rEqdPmbJdcOOIW53UdDYNpUwYiPxg5bDzpGpwGQNAvKkd8cm/C7YlG
	 yd2KLTycmbjs/zyOfnYbTp7OubKPix3X1h7P28cqN74rgaAvgmyrdMhRa7xyNx86ppA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FwSz8Px4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB32E606A323
	for <linux-raid@vger.kernel.org>; Thu, 12 Nov 2026 09:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FwSz8Px4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E8AE1F00A05;
	Thu, 12 Nov 2026 09:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794476133;
	bh=EeTMa4I6noKiJNDeQgkS1+gL/tZCUdiFE8G0Og9PAb4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=FwSz8Px4GbCcI3ts5rv8sS+iFEmfH/P6FIujaNlvV8U3dq1j9CjHKNCDJfneR1AIn
	 l7kpEJ8vEyGTOv4N1pMpd6x0R+WbybLUCbpwe+oq3FstNPrjH8Me449RYTE6gjFMQB
	 WUKiIRP7gr7F/9fMMasTojxvpBd+oaQgFqPt1H5ytzn8XxhPOdRRqZvPm96wn8hB1q
	 dp1bM6mIwkFxy4tXUQKl/7mgBkMPglek5nWACcgwKwbit8G0fq6/PMQAWEhTsNTB1I
	 ltP/ND8vN7jEVc48fiHmGGo6xcE8uaOTu9t5n3auRuwFI28KuU4+JVSbQRl2DYU2UB
	 gw/Es+3H4rNAA==
Message-ID: <sashiko-outbox-210890@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: fix stop_sync_thread() hang on new sync in idle
 path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Youhong" <dayou5941@163.com>
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20261112092634.1700963-1-dayou5941@163.com>
References: <20261112092634.1700963-1-dayou5941@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 09:35:32 +0000
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Low] md: Fixes trailer references stable backport SHA instead of
  mainline SHA
--

commit 5befe56f6aae61b7aa7d4c1baac50a35a4c54849
Author: Li Youhong <liyouhong@kylinos.cn>

> md: fix stop_sync_thread() hang on new sync in idle path
>
> stop_sync_thread() waits for either MD_RECOVERY_RUNNING to be cleared,
> or (when MD_RECOVERY_FROZEN is clear) for mddev->sync_seq to change.
> The sync_seq counter is only incremented when a sync thread is reaped
> in md_reap_sync_thread(), not on the md_start_sync() not_running path.
>
> If the previous sync attempt took the not_running path, sync_seq does
> not advance. If mddev->thread then queues and runs a new sync in the
> window between flush_work() and wait_event(), that new sync may start
> a real sync thread, leaving MD_RECOVERY_RUNNING set while sync_seq is
> still unchanged. md_idle_sync_thread() then waits until that new sync
> thread is reaped and sync_seq finally changes, even though it only
> needs to wait for the current sync attempt to finish.
>
> Fix this by incrementing sync_seq on the not_running path as well, so
> that the wait condition correctly observes the current sync attempt has
> completed.
>
> Fixes: a17d1bca5aba ("md: fix stopping sync thread")
> Cc: stable@vger.kernel.org
> Signed-off-by: Li Youhong <liyouhong@kylinos.cn>

[Severity: Low]
a17d1bca5aba ("md: fix stopping sync thread") is a stable-tree backport
rather than the mainline commit in the branch history.  Should the Fixes:
tag reference the upstream commit instead:

  Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112092634.1700=
963-1-dayou5941@163.com?part=3D1
