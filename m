Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795233646;
	b=MW/NQpcXsl28nhDQhH5ii1Eotr3K5iFlLrTmcgVlVyaPcuqHcEQCwDcCXvQ71eQ4AEZh
	 DybIot69LfUArfE+fUI74yHvmoutnXDSqvMh1WDXk0T/mPDzAXPOJZO7Q8RH7rmwhhPM2
	 LtOmmxSNm873PiZ3lxGpaANJn4E4oQfeZzRaYkZPsf0IinQLSCGm+tFPZmkKjTpdWynoc
	 xWRN5TeHDSHwq+/Dm+C2UjpehaGjZj+cNnZuteDniiPuVWgsFWXR1Jv+Xwlckef0R55RN
	 h/qjJyMsVqzITBi5zBiHlovLDpoNiGoi6Iod8+ReD4h2JgWK8TYmX9uqNghIg39RFYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795233646;
	h=DMARC-Filter:DKIM-Signature:From:Date:X-Lms-Return-Path:Reply-To:
	 Mime-Version:User-Agent:Content-Type:Received:In-Reply-To:Subject:
	 Message-Id:References:Content-Transfer-Encoding:X-Original-From:To:
	 Cc;
	bh=Ue/qTbgiiS+ZMmgtnggCZDbrFBa+GKo3ui6r8iEPkao=;
	b=BocaXQT9F0h7U5ahg/GTWJ2xIQ5nmCGKB2YQfQYXnO/yu67WQzqupEofKlC9RIzjXy/F
	 33MBM6W4w5XfRiULrT/M3ojDxm/6j3SCs045VZibh4dONlge89sCcr0tFfqb1eFGXdNeM
	 6eB8CP6CsCcP5rg3/a0r7R+ez9GWHZmK8JcJ9bepKfwOGIvUbErYsw48eBOO35WDrn0lh
	 j4DpJ1N9eo11WGANLYIP7ec3wWdbFxS+lz7z8n9sKHqWUi5ylTAxle14dCjYEKwH4mz8R
	 q+YsbD2DNYQrgZzaj7yP1WEm5Qa0tB93MekwX80ijzPkVn6BrwisQAxZ63NLxHP47Yg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=ki+HEpkA;
	arc=none smtp.remote-ip=209.127.231.48
Received: from va-2-48.ptr.blmpb.com (va-2-48.ptr.blmpb.com [209.127.231.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBAF9606A689
	for <linux-raid@vger.kernel.org>; Sat, 21 Nov 2026 04:00:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BBAF9606A689
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=ki+HEpkA
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1795233637;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=Ue/qTbgiiS+ZMmgtnggCZDbrFBa+GKo3ui6r8iEPkao=;
 b=ki+HEpkAZBa9ZinqOYpRQbDp32xiXdGm2HN27jqcU5fh8GDNelAvp9t718no/ZI4Zf9aHo
 wD0wTNGhEELLM0Rr/v858crfRDhwNYc4gCsOU1rjDXtfXDrk1Hqe+1L3SfPYLpylgMQ5Yn
 Hgo0GMi7cGas/VbAXy5jkfBkKmot2Rh/BroRR0saHi+UDwSznzDnrPHjFFBPISKn6wxTlz
 Sn6aQj07CgOl2Da7bWYGhjMhDgECT9/0My9BJE7b6a/rnp+z6exEdkVWNCfPvykXzE/2BY
 w0qGYwhOxueORlsjjQrEeIUJi351FFSaEI6Qt59DtzQIdcyCFfJ1+SbCJHLKWw==
From: "yu kuai" <yukuai@fygo.io>
Date: Sat, 21 Nov 2026 12:00:32 +0800
X-Lms-Return-Path: <lba+26b011764+a6a3e7+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.159]) by smtp.larksuite.com with ESMTPS; Sat, 21 Nov 2026 04:00:35 +0000
In-Reply-To: <20261114224636.34362-1-mc@raidlab.org>
Subject: Re: [PATCH] md/raid5: fix write stalls when a write is queued during a drain
Message-Id: <9148d522-b6cc-462a-841b-52c2a0e9a5e9@fygo.io>
References: <20261114224636.34362-1-mc@raidlab.org>
Content-Transfer-Encoding: quoted-printable
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Miroslav Cimerman" <mc@raidlab.org>, "Song Liu" <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Tejun Heo" <tj@kernel.org>, "NeilBrown" <neil@brown.name>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	"Anton Gavriliuk" <antosha20xx@gmail.com>

=E5=9C=A8 2026/11/15 6:46, Miroslav Cimerman =E5=86=99=E9=81=93:

> With continuous O_DIRECT writes to a RAID-5/6 array that uses
> read-modify-writes, a few 4k writes can take seconds to complete, up
> to the length of the run.
>
> The pre-read permission (STRIPE_PREREAD_ACTIVE) belongs to a stripe.
> A REQ_SYNC write queued while an earlier write on the same stripe is
> being drained finds the bit set and gets no count of its own in
> preread_active_stripes. handle_stripe() clears the bit when the drain
> result is handled, so the queued write gets STRIPE_DELAYED, and the
> stripe goes to delayed_list together with the completion of the
> drained write. raid5_activate_delayed() only moves it on once
> preread_active_stripes is below IO_THRESHOLD, which with other
> REQ_SYNC writes in flight may happen until the load stops.
>
> Check for writes queued on the stripe, under stripe_lock, after
> clearing the bit, and keep the bit and its count if there are any.
> A write queued later tests the bit after the clear and either takes
> the permission itself or finds it kept. Do this for any queued write:
> a queued buffered write would otherwise hold back the completion of
> the drained write the same way.
>
> md-7.4, RAM disks, 4k random writes, io_uring, QD64, 20 s, slowest
> write without -> with this patch, md defaults (1 job) and
> group_thread_cnt=3D8 (16 jobs):
>
>    RAID-6 4+2 (rmw_level=3D2) 18.0 s -> 2.0 ms  19.3 s -> 5.8 ms
>    RAID-6 8+2               13.4 s -> 2.2 ms  13.0 s -> 7.0 ms
>    RAID-5 5+1               16.9 s -> 1.8 ms  18.3 s -> 4.9 ms
>    RAID-5 9+1               17.4 s -> 2.2 ms  12.0 s -> 5.8 ms
>
> IOPS are unchanged with md defaults and within a few percent with 8
> workers. Buffered writes are not affected.
>
> Fixes: e9c7469bb4f5 ("md: implment REQ_FLUSH/FUA support")
> Cc:stable@vger.kernel.org
> Signed-off-by: Miroslav Cimerman<mc@raidlab.org>
> ---
>   drivers/md/raid5.c | 41 +++++++++++++++++++++++++++++++++++++++--
>   drivers/md/raid5.h |  4 +++-
>   2 files changed, 42 insertions(+), 3 deletions(-)
Applied

--=20
Thanks,
Kuai
