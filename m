Received: from sg-1-37.ptr.blmpb.com (sg-1-37.ptr.blmpb.com [118.26.132.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BA819CD0A
	for <linux-raid@vger.kernel.org>; Wed,  4 Mar 2026 02:37:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772591829; cv=none; b=LD5vJyVyPlaNUaHsEZnGAcyXz+367j8vejM0Df/50tbVbxmj/ezGaNYpup2dzgNTagUfNfV8ITWsGCIXG7MpcuGI4S/H15Ivap/jRJ32Gh5GMeCrN6UrQn4+SZaLWPDI+PSypl6TWDwDbI2gMirD0a22Uye2RXr6XXXr+Ni7fJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772591829; c=relaxed/simple;
	bh=N7uJI9h/ayf/1zaOu7k6XZKBA+4mqtpUxAhp0WCYBOw=;
	h=Mime-Version:Cc:From:Subject:In-Reply-To:Date:References:
	 Content-Type:To:Message-Id; b=YYUFv2HpIPl91pq4YB+X1JqomYG1I9rhFjvsKW6A7w1lkYSj2S9DEfD15e2+Lk3luvih8xbTibLCj04BuHAha6d2JDvJLCgdF2Qi5wbg0paOWR9XOPaoSk1R+SJYG2TrGFYREtAmg3ntWFhxxbb75R1PnmLtx6TWWeZGm4f1RZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=jHLe5baj; arc=none smtp.client-ip=118.26.132.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="jHLe5baj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1772591822;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=3lh/D+x3po1rbPw9choV5EkOODX6vfmMRJqmYB4v6G0=;
 b=jHLe5bajalUIHI05K/ANiYLnJVE4faKjABfqq3wFa5AuZj0n/a+FFXvAHzo+o5v9bspei6
 wH95/J05+OaZu/Du95hyCwOMNQ28GND6GpwamZB+VqR91yTjYXyG3G4mpJrdNcJybCKada
 Kb70J7S+37iQ+JO21MFb2+sV5PvB8QY+SPwV/O13vgLfTnrJOVHfaFq6VwmMOUipNIyvpJ
 /wLcoGgjnfVq8JN9IxyCt71f1H4A1YpIC9do2wPP5hDXdX51gNgbPt8E1I8UuQdTAwKFLu
 /SvSW1m5uh9s84B0wtEJOcevalN6xt+EeTZRT+Y/89ufRLKdcw/AsXUNc8F+ZA==
Reply-To: yukuai@fnnas.com
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.182]) by smtp.feishu.cn with ESMTPS; Wed, 04 Mar 2026 10:36:58 +0800
Content-Language: en-US
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linan122@huawei.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] md/raid5: set chunk_sectors to enable full stripe I/O splitting
In-Reply-To: <20260223035834.3132498-1-yukuai@fnnas.com>
Date: Wed, 4 Mar 2026 10:36:57 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20260223035834.3132498-1-yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
To: <hch@infradead.org>, <song@kernel.org>, <yukuai@fnnas.com>
Message-Id: <006cdd15-cd4e-48bc-8f7d-010299b84b53@fnnas.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269a79acc+4c3b57+vger.kernel.org+yukuai@fnnas.com>

=E5=9C=A8 2026/2/23 11:58, Yu Kuai =E5=86=99=E9=81=93:

> Set chunk_sectors to the full stripe width (io_opt) so that the block
> layer splits I/O at full stripe boundaries. This ensures that large
> writes are aligned to full stripes, avoiding the read-modify-write
> overhead that occurs with partial stripe writes in RAID-5/6.
>
> When chunk_sectors is set, the block layer's bio splitting logic in
> get_max_io_size() uses blk_boundary_sectors_left() to limit I/O size
> to the boundary. This naturally aligns split bios to full stripe
> boundaries, enabling more efficient full stripe writes.
>
> Test results with 24-disk RAID5 (chunk_size=3D64k):
>    dd if=3D/dev/zero of=3D/dev/md0 bs=3D10M oflag=3Ddirect
>    Before: 461 MB/s
>    After:  520 MB/s  (+12.8%)
>
> Suggested-by: Christoph Hellwig<hch@infradead.org>
> Signed-off-by: Yu Kuai<yukuai@fnnas.com>
> ---
>   drivers/md/raid5.c | 1 +
>   1 file changed, 1 insertion(+)

Applied to md-7.0

--=20
Thansk,
Kuai
