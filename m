Received: from va-2-60.ptr.blmpb.com (va-2-60.ptr.blmpb.com [209.127.231.60])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39FE53054C7
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 10:45:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.60
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784457944; cv=none; b=MEKf4zEeITbdi28hII/L5xqwTDEkgxnKnqFMgoxa5Pk8T1uCo9CdUhP0wTVTFMC2+icatdLC0BC5KYwcyh8oyxAAYrlumTBtfPeGci0DKLUtC/cUQqjic97Gwlgx+oZTw5IlrJ90AYLXneDeu+xnTa1BMjRUo2GOmHyCHqZNxHE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784457944; c=relaxed/simple;
	bh=PGT3hLnF8bRw26dYYs5i7nQU19KinFQrSOI9RUdF2lU=;
	h=To:From:In-Reply-To:References:Message-Id:Mime-Version:Cc:Subject:
	 Date:Content-Type; b=coCFDQCntMsTzTLTWK8iyg+DE7WEsuQdG/frOvTDqAo8RUlHZmh8bO1BT8FZXaia4UL/MT6bg51da4A6do1sudRMLFWHdLl1usuIIXGTVinVT8yCY17BPW9Ea+RT5hlqTCXiQIX1t/HeiRsRquEnCE4I6Zx7BvAY47Fht2WrLBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=HJ14LMRx; arc=none smtp.client-ip=209.127.231.60
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="HJ14LMRx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784457930;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=HfWlXrHBP4SDXnJREunYjMM+ZdQrbqQsxvsJyual1o4=;
 b=HJ14LMRx8iSSehC6dbG/ReWiumI35JsbKPWHZfCq/E1Ln06EDN3dfCMmbbkAnofRwUtCfi
 LRYauIvglChYlsIQ1haYKknqFmWI9qlWwQ7TiRDLk4N/ydJJVRY6Rxbl0EtIIl9KwVXQYl
 bQp0jIqca21MTtguR6H+PgkvnZ2ZGkFO4gSq8zv1Y7/KS1YyDvmWOj1BfFum8r38Noyb3+
 v66x+KRzNl/U8mOTGu+v4h6Nkk30EcKueHUpwhU07kyT9ELAFO/XAtNUZpm1STHPeBeF/a
 bed7vy6noe3ahxelc17F5lPSiRCGVAgZr2Xx3SY5HBdJVpI8aDy0SQ8zsPa+Pg==
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, 
	"Song Liu" <song@kernel.org>, "Yu Kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com>
Message-Id: <7abeaff6-1387-4046-bea3-f1b04465addd@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Sun, 19 Jul 2026 10:45:29 +0000
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a5caac9+1f79b9+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Joseph Qi" <joseph.qi@linux.alibaba.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] md: fix soft lockup during resync when sync is repeatedly skipped
Date: Sun, 19 Jul 2026 18:45:25 +0800
Reply-To: yukuai@fygo.io
X-Original-From: yu kuai <yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/17 14:27, Yunye Zhao =E5=86=99=E9=81=93:
> md_do_sync()'s main loop advances io_sectors only when I/O is actually
> issued (skipped =3D=3D 0).  When sync_request() keeps returning skipped =
=3D=3D 1,
> io_sectors never increases, the "last_check + window > io_sectors" test
> stays true, and every iteration takes the continue branch:

That's not expected, io_sectors should always increase in the skip case.

>
> 	sectors =3D mddev->pers->sync_request(mddev, j, max_sectors, &skipped);
> 	...
> 	if (!skipped)
> 		io_sectors +=3D sectors;
> 	j +=3D sectors;
> 	...
> 	if (last_check + window > io_sectors || j =3D=3D max_sectors)
> 		continue;
>
> During recovery or resync of a large array with a sparse bitmap, many
> regions that need no syncing are skipped:
>
> 	raid10_sync_request()
> 	  md_bitmap_start_sync()	-> must_sync =3D false (no bitmap page)
> 	  /* every mirror skipped */
> 	  biolist =3D=3D NULL -> *skipped =3D 1; return max_sync;
>
> j then traverses the whole skipped range while io_sectors stays
> unchanged.  On a non-preemptive kernel the resync thread (mdX_resync)
> hogs the CPU for a long time and eventually triggers a soft lockup:
>
>    watchdog: BUG: soft lockup - CPU#149 stuck for 313s! [mdX_resync]
>     md_bitmap_start_sync+0x6f/0xe0
>     raid10_sync_request+0x2c9/0x1530 [raid10]
>     md_do_sync+0x810/0x1030
>     md_thread+0xa7/0x150

What kernel version you're testing? If this is latest kernel, bitmap_start_=
sync()
need to be fixed. It can't return skip while setting skipping sectors to 0.=
 And
since this is dead loop, a cond_resched() will not fix anything.

>
> Add cond_resched() to this continue path.
>
> Signed-off-by: Yunye Zhao <yunye.zhao@linux.alibaba.com>
> ---
>   drivers/md/md.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d1465bcd86c8..e7411b033490 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9881,9 +9881,10 @@ void md_do_sync(struct md_thread *thread)
>   			 */
>   			md_new_event();
>  =20
> -		if (last_check + window > io_sectors || j =3D=3D max_sectors)
> +		if (last_check + window > io_sectors || j =3D=3D max_sectors) {
> +			cond_resched();
>   			continue;
> -
> +		}
>   		last_check =3D io_sectors;
>   	repeat:
>   		if (time_after_eq(jiffies, mark[last_mark] + SYNC_MARK_STEP )) {

--=20
Thanks,
Kuai
