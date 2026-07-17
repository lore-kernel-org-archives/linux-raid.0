Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 741DD3C0A17
	for <linux-raid@vger.kernel.org>; Fri, 17 Jul 2026 06:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784271120; cv=none; b=Rk4+W9bNih91pXbl1cogSO14UgMH9JjuQUBJWMlygz12qbBXa3duK6ACWZS0GxPj9qLIvfCkrOYGuU2IyBMILil0uzNEZWf9yq0GapKpVYATj5Kb1kwfWCqL71Ys38907msxQt7YpbjIZu4Ly9kkmXHCTKmPKXfasppHpUKMFLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784271120; c=relaxed/simple;
	bh=43Nj//BlR4DOOHfep5NcSPzMBbhzfRJASXFtIyIRFBM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=U0iZRr05OUYH11vw+bVikp3hySX/irOynan38xq1/b9YrDvDhWRsO3kojERekx2N6JJZUKuJ1f6CawXyPGkgIkOsukKpkoS7QrsXQA1p09a1oMdvshlpwLleq7T9gFi8T/3gmqENesx5Gnu7LivLrXnL8bLqL9aPklAAV/Jyu+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GqTWPkap; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GqTWPkap"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C97AC1F000E9;
	Fri, 17 Jul 2026 06:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784271119;
	bh=0YJOIil6IqvqDt7v54lEhVyefnQECkMUrzecZ3ZAcl4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GqTWPkapdjDoK2nfpqZoid7zMw6De387PXH5wRXYvJ0clSTHK/LI0Lp3x1zpg29Yd
	 qMxR787nMRd1oKlqzUzXhA6WLjnH7L26OdgxcaOoeSUN9O/ApmeGqwE5wt4nTrOVbW
	 cW7DBsOlcQUlUil6qMSDii8v7ycwd8zwGzL0vqsVcfBrSjj45+UOR7D/8XdKPF2NZr
	 gJr1nFVmoKTZRE4vZAbWrGRWOcjVRn5ZnxkM5HrRcJbEPxn5g2S6s39KbKywgyBJeM
	 J5RmWB4/oW/wr+ublLpY1lXjQG1UeLtelyjPhTbVWRyjbfvQ8JvGxgcSANUFn5wdJj
	 PEg5ZwPMJjnqw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md: fix soft lockup during resync when sync is
 repeatedly skipped
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 06:51:58 +0000
Message-Id: <20260717065158.C97AC1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Repeatedly skipped I/O blocks cause an event storm, calling md_new=
_event() millions of times in a tight loop.
--

--- Patch [1]: [PATCH] md: fix soft lockup during resync when sync is repea=
tedly skipped ---
commit 02c063c34357030eaa8514f57d5e37328d410c0b
Author: Yunye Zhao <yunye.zhao@linux.alibaba.com>

md: fix soft lockup during resync when sync is repeatedly skipped

The md_do_sync() main loop advances io_sectors only when I/O is actually
issued. When regions are skipped, io_sectors never increases and the loop
takes the continue branch, eventually triggering a soft lockup on
non-preemptive kernels. This patch adds cond_resched() to this continue
path to prevent the soft lockup.

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c81..e7411b0334901 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9881,9 +9881,10 @@ void md_do_sync(struct md_thread *thread)
>  			 */
>  			md_new_event();
> =20
> -		if (last_check + window > io_sectors || j =3D=3D max_sectors)
> +		if (last_check + window > io_sectors || j =3D=3D max_sectors) {
> +			cond_resched();
>  			continue;

[Severity: High]
This is a pre-existing issue, but can this loop in md_do_sync() cause an ev=
ent
storm when I/O is repeatedly skipped?

During array recovery or resync with a sparse bitmap, io_sectors remains 0
when regions are skipped. Because last_check starts at 0, the check
(last_check + window > io_sectors) evaluates to true, causing the loop to
continue.

Since last_check is only updated after this continue statement, it remains 0
permanently across skipped regions. As a result, the preceding check for
(last_check =3D=3D 0) remains true, calling md_new_event() on every skipped
iteration. This repeatedly wakes up user-space processes polling /proc/mdst=
at
and causes lock contention.

> -
> +		}
>  		last_check =3D io_sectors;
>  	repeat:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260717062743.1281=
89-1-yunye.zhao@linux.alibaba.com?part=3D1
