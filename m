Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F59B3F822A
	for <linux-raid@vger.kernel.org>; Mon, 27 Jul 2026 11:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785151043; cv=none; b=T+tV4MUZHmxBd32yTpy/bT8rgA8Md+Uj974YtxJiLLSCMmayFfRVUvAzTyMaNWPPr4fk05Hm6iDpjb1T2vxgziBMatl+wRXEh3s1bENKWcT2w14+iF/mlkWMtGdYy9AqlDGhxXejAOam9enDVBxVnHxXTnybItgeT9krpMyApkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785151043; c=relaxed/simple;
	bh=zHoiFjz2G6KVingpO+Q9kQy9nJ/ryQfY23LgWQFjBEg=;
	h=To:Message-Id:Content-Type:References:From:Subject:In-Reply-To:Cc:
	 Date:Mime-Version; b=esXxdnth/Dw79FXet7Y91DctWdFPcIQPJ0pC286B7plYVVvI2IOwUADu20AsmYLw5Gp85FD41SHlCx7i28hje8GmWaD7+XZQFgzQPmucB8Z2a6vgxwkYtIAuZiaFYduV46eQR91VZ2zF76Jt66IZNuE8SeLYc2OQ78BVwi2J3eQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=zo6lAKb/; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="zo6lAKb/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1785151029;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ZRCNNqNMzowla1IvyjPaOxMj52HlMpdvVj5SS8+QPQE=;
 b=zo6lAKb/Hyj0tgOuwSUsZwxEw83hplLC0VhO5bS0v/8Hw1tdMQP/HhMhOOlSTErCJh3qQK
 ktA1yaMOgGLLAWY63SgfBfIv4n3q8X8AJOvBCfwIW1lG5W55BbgL76AjMBHQIPdeERwfz1
 eUzpfs/ChdoddevRUMqeOgPKNLFNhzzTcMwet/F6J59zQr5lhHIyq/IcSdGA/zbK6+sJIz
 IJe7OUlUtTD8g7DBIy+ZHCKzCVF2IW2vUgTDeQMh27GTslxnLwd85GWzwd8kpnqhibcGXt
 Z+bsQ2lSGMO2dZWbmO/0n1ue7kJArU1jQh3S4FzAwyN0AqFjrm2sGdTHdtSM+A==
X-Original-From: Chen Cheng <chencheng@fnnas.com>
To: "Mykola Marzhan" <mykola@meshstor.io>
Message-Id: <5a09984d-3f82-4fe9-aa42-38ca99cd3a7e@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Lms-Return-Path: <lba+26a673e33+b6be85+vger.kernel.org+chencheng@fnnas.com>
References: <20260711100352.425177-1-chencheng@fnnas.com> <20260726185640.2222714-1-mykola@meshstor.io> <20260727105434.2516516-1-mykola@meshstor.io>
From: "Chen Cheng" <chencheng@fnnas.com>
Subject: Re: [PATCH v7 0/3] md/raid10: fix r10bio width mismatches across reshape
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Received: from [192.168.8.80] ([183.34.169.20]) by smtp.feishu.cn with ESMTPS; Mon, 27 Jul 2026 19:17:06 +0800
In-Reply-To: <20260727105434.2516516-1-mykola@meshstor.io>
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>, "Song Liu" <song@kernel.org>
Date: Mon, 27 Jul 2026 19:17:04 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0

On 2026/7/27 18:54, Mykola Marzhan wrote:
> Hi Cheng,
>=20
> Here are the test results I promised. v7 fixes it.
>=20
> I used one kernel tree, rebuilt incrementally between the two builds,
> so the only difference is your three patches. The array is raid10 n2
> with 4 members. The load is four fio jobs: 4k randwrite, O_DIRECT,
> iodepth 32. While the load runs, I --add two spares and then
> --grow --raid-devices=3D6. The kernel is KASAN generic with
> kasan_multi_shot. Each run is 5 cycles:
>=20
>    kernel      runs  cycles  grows completed  slab-out-of-bounds
>    base           1       5             5/5   128 (in 4 of 5 cycles)
>    base + v7      2   5 + 5           10/10     0
>=20
> All 128 base reports are in free_r10bio(): 64 reads and 64 writes,
> each of 8 bytes. There is also a second report site,
> raid10_make_request(). A warm-up run on the same base hit it too,
> with 2 slab-out-of-bounds there alongside 568 in free_r10bio(). So
> both report sites are reachable with this workload.
>=20
> Every cycle on both kernels logged "md: md0: reshape done." and the
> same capacity change, so the grow really did run 10/10 on the patched
> kernel, and fio was alive throughout each cycle.
>=20
> The bug does not fire in every cycle: per-cycle counts on the base
> were 0, 40, 8, 56, 24, so the base hit it in 4 of 5 cycles. That rate
> is what gives the patched 10/10 zero its meaning.
>=20
> Tested-by: Mykola Marzhan <mykola@meshstor.io>
>=20

Hi Mykola,

I see, really thanks for your test result!

> One practical note: v7 does not apply to mainline. Patch 2/3 carries
> context
>=20
>    static void __make_request(struct mddev *mddev, struct bio *bio, int s=
ectors)
>=20
> but e045d6ed33f8 ("md/raid10: fix writes_pending leak on write request
> failures") changed __make_request() to return bool. Applying
> 1/3..3/3 with --fuzz=3D0:
>=20
>    8e065a160251 (=3D e045d6ed33f8^)        applies clean
>    e045d6ed33f8                          fails
>    55b77337bdd0                          fails
>    v7.2-rc4                              fails
>    current mainline                      fails
>=20

Got it, I must misuse a unclean branch.

> So the numbers above are from 8e065a160251, which is the newest base v7
> applies to. A rebase would probably help it get picked up =E2=80=94 happy=
 to
> re-run the same rig on a v8 if you post one.
>=20

I don't want to waste your time, I would re-run reproducer before I send.

Reproducer Link:=20
https://github.com/chencheng-fnnas/reproducer/blob/main/repro-raid10-4to5-r=
eshape-r10bio-oob.sh

Thanks again,
Cheng.

> Thanks,
> Mykola
