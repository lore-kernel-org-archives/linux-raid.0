Received: from va-2-35.ptr.blmpb.com (va-2-35.ptr.blmpb.com [209.127.231.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A56BD35A3A9
	for <linux-raid@vger.kernel.org>; Mon, 27 Jul 2026 03:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785121685; cv=none; b=t8ypDvMZpXsfo7NdGDJpO55ALu7CaA1fF5l0z/cEPbu9e61RGqTYlth6iyLR2A4F83VphQja9CDU1J2Tl3/zFv2hmhn7ZnJsMqMqP1+3YlN2XmanN6iG6qkTZ/5qSuspt7RJSBqKGjKz3XuACdaJEx2NcYLqX1rmW0VffEgzRy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785121685; c=relaxed/simple;
	bh=v6TCFX5vQTg5Be2YWkM9MW3GwTDU0y5p0CvsuvWIqC0=;
	h=Date:In-Reply-To:Content-Type:To:Subject:Message-Id:Mime-Version:
	 Cc:References:From; b=gaH43QjtS0ItJ2hTASNFl+h2EeiL1WvHrVRPNJN9PHVE5+QfFZI51kVLUPeVCK2jOAh02yY3XuknBcPdYp62g4PumiO+WEnPXVSaHMylbO8W2rWs2Suh07hfb/tP3joeQTnKqhoiyZUSS+tBh3WS1+tEeMmlhJS0qI4o0paMMsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=GtxTmJFz; arc=none smtp.client-ip=209.127.231.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="GtxTmJFz"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1785121678;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=2ZeeXXnxFXCOI5JTt/7J/yxSkqIrDzdjS4zB/M/O+Fw=;
 b=GtxTmJFzQm3/g2tazN62+Q6PZzvnfsf2lOhmBU7wgK3retRrgOp1y/t09SRMiy7YYtCHKh
 /y3FImf6v3Ec6ZpKMO03ACx8ZgjzP47lignNuQaZmaeiRYvCY7daa0Kdvs+8fNo06PIXuK
 17E2WMvQbyRw5He+51myvok3eISyGsIk2vMZZKF6kfhUoo/pb7yHy92aaGaZmAQjiOE6dy
 d8zbGMGqIuD1CTcSnxbQ/6bEjFNX0IKMt2KaCT2gFLTbmQe+ZL7fR6ifqCystyGnWVLfKB
 JVVv0Bs5mMMClqySC+vU2gB5jT8D2fTnau+iB/Cb+kS57VdyH/00P5dDDM7dMQ==
Date: Mon, 27 Jul 2026 11:07:53 +0800
X-Original-From: Chen Cheng <chencheng@fnnas.com>
In-Reply-To: <20260726185640.2222714-1-mykola@meshstor.io>
Received: from [192.168.8.80] ([183.34.169.20]) by smtp.feishu.cn with ESMTPS; Mon, 27 Jul 2026 11:07:55 +0800
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
To: "Mykola Marzhan" <mykola@meshstor.io>
Subject: Re: [PATCH v7 0/3] md/raid10: fix r10bio width mismatches across reshape
Message-Id: <ef9d9628-430d-48e5-8ee4-c02626c7995a@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Yu Kuai" <yukuai@fygo.io>, "Song Liu" <song@kernel.org>
References: <20260711100352.425177-1-chencheng@fnnas.com> <20260726185640.2222714-1-mykola@meshstor.io>
From: "Chen Cheng" <chencheng@fnnas.com>
X-Lms-Return-Path: <lba+26a66cb8c+8f54f8+vger.kernel.org+chencheng@fnnas.com>

=E5=9C=A8 2026/7/27 02:56, Mykola Marzhan =E5=86=99=E9=81=93:
> Hi Cheng,
>=20
> Independent confirmation of the bug this series fixes, in case more
> evidence helps it land.
>=20
> While running a KASAN campaign against the llbitmap reshape v2 series
> (base 55b77337 =E2=80=94 unrelated to your fix) every raid10 grow under I=
O hit
> both faces of the width mismatch:
>=20
>    BUG: KASAN: slab-out-of-bounds in free_r10bio+0x97/0x110
>    Read of size 8 at addr ffff888149044ec8 by task ksoftirqd/2/28
>     free_r10bio+0x97/0x110
>     raid10_end_write_request+0x260/0x500
>     blk_update_request+0x18b/0x6b0
>    Allocated by task 232:
>     mempool_alloc_noprof+0x108/0x1d0
>     raid10_make_request+0x18b/0x1100
>=20
>    BUG: KASAN: slab-out-of-bounds in raid10_make_request+0x214/0x1100
>    Write of size 192 at addr ffff88814da7aa48 by task fio/460
>     __asan_memset+0x23/0x50
>     raid10_make_request+0x214/0x1100
>=20
> (192 bytes =3D 6 x sizeof(struct r10dev) memset into a 4-disk
> allocation.)
>=20
> 456 reports across 5 grow cycles (n2, 4->6 disks, four fio randwrite
> jobs) on the plain base kernel. The mempool face matches your 2/3
> exactly: the 256 preallocated r10bios keep the old width, so any
> allocation that dips into the reserve after the grow is a guaranteed
> OOB write, not just a read.
>=20
> The storm is dense enough that raid10 grow under IO is not testable
> under KASAN at all right now =E2=80=94 which is how we ran into it, and w=
hy
> we would like to see this land.
>=20
> We plan to run v7 through the same rig and will follow up with the
> result.
>=20

Hi Mykola:

Thanks to let me know that, and welcome to report the result and if you=20
have any idea, welcome to discuss.

thanks,
Cheng.

> Thanks,
> Mykola
