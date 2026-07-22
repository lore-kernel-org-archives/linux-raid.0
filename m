Received: from va-2-50.ptr.blmpb.com (va-2-50.ptr.blmpb.com [209.127.231.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D7539021F
	for <linux-raid@vger.kernel.org>; Wed, 22 Jul 2026 04:01:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784692866; cv=none; b=bUVFoe9VL9QMIpSfy7KTRlO+KNjwE4Yt/Vf79v2Z3MTaELZHvhxciHcis8NDmdOqPP5LCYYOlCXDk7WmFkpJWlFDPYDcIE8Zmlx1IbRhgi36R+K/p0oewL7w6bXEUrCCJBXcblqs73GiYPELAAcF5fWdXBV6yjSNm5rrdlEWkVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784692866; c=relaxed/simple;
	bh=xuLZs9RLdyhfXEuj+2TY+HnX47kimkyTOsFPuIbyut8=;
	h=Cc:From:In-Reply-To:Mime-Version:To:Subject:Date:Message-Id:
	 References:Content-Type; b=Ijjz994Tt8RRY9jzpPpG2te4Tvi806PyniGxupn+1Bsadjg8y00Cc41Nj/XebgfVQpsBfHOjg9Jt2dBrZzZAiEjc/i998asNoQtBIK9rj8Em0XaIkYiJ7/TmW77Qf3NUGTqRYqrIsnNTANdqqlUK/yKetWVBZKczOhGbPIlpvy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Nw8dMRkp; arc=none smtp.client-ip=209.127.231.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Nw8dMRkp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784692850;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=jKWEE8s9+N8pU9VDxNf8BM5vXkSZ6S5QYs4r2gUkeLA=;
 b=Nw8dMRkph8GQchk6YyOUnFnAEG9PVS3K4G8iF19Y7TGdOg83YcPoY97xCcd+VF50WCM4HD
 4M2UH56I+P6n+HfAcKZp9k/eb69vidhf9RAa+W4P2qXzHUsZrb+JybCtnv1VFjXeT1koWl
 ypqnYN1DP/6JQk2hsC56qJHa++GqS0/nOYx++nMmcG5T5TNUzAgST1LMPdrcKjl3WLN+vo
 Tx+Lk7xxnTXLxreKg6QZ3ZgP3HurMQ++/etwfVhGGZm8i7KpGzKfeejpxUVwX3ozj1UwZP
 X99yWJVzXFtNM8NIraZCMkB3Qpvd93RL4/dlyp+pZBAYn/G0K7dy51vitAs5+Q==
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Joseph Qi" <joseph.qi@linux.alibaba.com>, <linux-raid@vger.kernel.org>, 
	<linux-kernel@vger.kernel.org>
From: "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260720062026.19245-1-yunye.zhao@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26a604071+73df7c+vger.kernel.org+yukuai@fygo.io>
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fygo.io
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, 
	"Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: fix soft lockup during resync when sync is repeatedly skipped
Date: Wed, 22 Jul 2026 12:00:46 +0800
Message-Id: <393e0533-bac7-4721-b407-21dbed72dd1a@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
References: <20260717062743.128189-1-yunye.zhao@linux.alibaba.com> <7abeaff6-1387-4046-bea3-f1b04465addd@fygo.io> <20260720062026.19245-1-yunye.zhao@linux.alibaba.com>
Received: from [192.168.1.104] ([39.182.0.167]) by smtp.larksuite.com with ESMTPS; Wed, 22 Jul 2026 04:00:49 +0000
Content-Type: text/plain; charset=UTF-8

Hi,

=E5=9C=A8 2026/7/20 14:20, Yunye Zhao =E5=86=99=E9=81=93:
> Hi Kuai,
>
> On 2026/7/17 14:27, Yu Kuai wrote:
>>> md_do_sync()'s main loop advances io_sectors only when I/O is actually
>>> issued (skipped =3D=3D 0).  When sync_request() keeps returning skipped=
 =3D=3D 1,
>>> io_sectors never increases, [...]
>> That's not expected, io_sectors should always increase in the skip case.
> Sorry, my description was not accurate. The problem is not that io_sector=
s
> stays 0. md_do_sync()'s loop exit condition is j =3D=3D max_sectors, and =
in
> raid10_sync_request()'s recovery path sectors is always 128, so for a ver=
y
> large max_sectors the loop iterates a huge number of times.
>
> raid10_sync_request(), recovery branch:
>
>      max_sync =3D RESYNC_PAGES << (PAGE_SHIFT-9);      /* 128 */
>      must_sync =3D md_bitmap_start_sync(mddev, sect, &sync_blocks, true);
>      if (sync_blocks < max_sync)   /* sync_blocks huge, never true */
>          max_sync =3D sync_blocks;   /* so max_sync stays 128 */
>      ...
>      if (biolist =3D=3D NULL) {
>          *skipped =3D 1;
>          return max_sync;          /* 128; the large span is discarded */
>      }
>
> Back in md_do_sync()'s main loop, j then crawls forward 128 sectors per
> call until it reaches max_sectors:
>
>      while (j < max_sectors) {
>          sectors =3D mddev->pers->sync_request(mddev, j, max_sectors, &sk=
ipped);
>          if (!skipped)             /* skipped =3D=3D 1 -> io_sectors stay=
s 0 */
>              io_sectors +=3D sectors;
>          j +=3D sectors;             /* j +=3D 128 only */
>          if (last_check + window > io_sectors || j =3D=3D max_sectors)
>              continue;
>      }
>
>  From the vmcore:
>
>      sync_blocks returned =3D 0x5ED03680 (~1.59e8 sectors), clamped to 12=
8
>      recovery max_sectors =3D dev_sectors =3D 2^40
>      iterations =3D 2^40 / 128 =3D 2^33 (~8.6e9)

Please update and fix the commit message "io_sectors never increases", this
really is misleading.

>
>> What kernel version you're testing?
> 6.6.102. I also tested mainline and hit the same problem.
>
>> If this is latest kernel, bitmap_start_sync() need to be fixed. It can't
>> return skip while setting skipping sectors to 0.
> bitmap_start_sync() is actually fine -- it returns a large clean span
> (0x5ED03680 above). The recovery path just discards it: max_sync is only
> ever clamped down, so it returns 128 regardless.
>
>> And since this is dead loop, a cond_resched() will not fix anything.
> Agreed -- cond_resched() only stops the watchdog; the thread still spins
> ~8.6e9 no-op iterations and pins a CPU for ~313s.
>
> For v2 I'd fix this at the source: make the recovery path honour the clea=
n
> span reported by the bitmap instead of capping the skip at 128. Does that
> direction look right to you?

This patch is still valuable, even a 5s lockup is not acceptable.

And I think this is not a problem for llbitmap, it skips one bit at a time =
and
bits are limited to at most 4k*128. Perhaps bitmap can do this as well, it =
can
definably return much bigger skipping sectors from bitmap_start_sync().

>
> Thanks,
> Yunye

--=20
Thanks,
Kuai
