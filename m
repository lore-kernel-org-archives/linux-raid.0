Received: from sg-3-41.ptr.tlmpb.com (sg-3-41.ptr.tlmpb.com [101.45.255.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 181F01A6839
	for <linux-raid@vger.kernel.org>; Sun,  4 Oct 2026 03:53:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.45.255.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791086000; cv=none; b=jDARDyy6QQEQg0wH2z0uzNmnyCT9HnAqt5bQR6rIo7uq71qq/ZEOqXyqBeljVBH88oLj2NGX60FSzjVAXjPOaF8qEgK6xHzOsIe7ClPfcyH4IpV+2sUgCwSMZzLzYYeOXnagTTdTX2Exe9+3mq1U+OR7VLKI0nTxBR+evx3WJ9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791086000; c=relaxed/simple;
	bh=Ep7IT0ck+xBa0P5klyVmk1emoi8mxIzON6nalVuIwYs=;
	h=In-Reply-To:Cc:From:Message-Id:References:Date:To:Subject:
	 Mime-Version:Content-Type; b=GWneb3ozEfuX8CxwFskXY2/OWryJRAO13Jbspl6H+Eqz/0xCmuzeOrSzP9PN8AMv9AaWoDtBo6lKZ+BYRvrON1Hmfh5h6Mdz7fbepv90NTEOTo4hRD3C/FRAyffWtO3AQiiZX3aZJXsJ99UhrXSZ12voH0Z3uxO04TMZ7fIJFb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=oIt9bvdP; arc=none smtp.client-ip=101.45.255.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="oIt9bvdP"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791085944;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=iYuotfuky80by1yRYN0ON0JErjNwp79Y3Ap8BM7muK0=;
 b=oIt9bvdPnThgpn+eRS+M3eHgdDl78wGqEiL9RuSUNMTdHvpu5AlD46Pz6KsGadW1QzWbsr
 XHnlnuPadx9kouDwrzZIrZFmRyqZvbWPqIOyw138Nx9f5c7WUkdZagc3dde5gZ9CQrZ85a
 itvNwax7D4TXcwuYWrAX1oTzwEWWPw9Gn+U4DuGXXcWhfI9/AKYUYZYvoYFp3mv6fW63Mf
 IOsIGQa4L/4sLd0Soph8vbnag5ueJXvhz9/dEI+VTb6Yd4qtOKg5qkGApc7yOxryFQ42hF
 3lODlbFbSSK81wqWKDv5c9Rcpue4EhcV3hCNbcc8bFRg0RgieHQsJZWyPRBw6w==
Reply-To: yukuai@fygo.io
User-Agent: Mozilla Thunderbird
In-Reply-To: <20260924171345.75894-1-ngocthang2710.1999@gmail.com>
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Artur Paszkiewicz" <artur.paszkiewicz@intel.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <7a163544-d165-4d1a-9161-df82bced61b7@fygo.io>
References: <20260924171345.75894-1-ngocthang2710.1999@gmail.com>
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Sun, 04 Oct 2026 03:52:23 +0000
Date: Sun, 4 Oct 2026 11:52:20 +0800
X-Lms-Return-Path: <lba+26ac1cd78+97bcf1+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Nguyen Ngoc Thang" <ngocthang2710.1999@gmail.com>, 
	"Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: take reconfig_mutex when enabling PPL on an inactive array
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/9/25 1:13, Nguyen Ngoc Thang =E5=86=99=E9=81=93:

> consistency_policy_store() sets MD_HAS_PPL for an external-metadata array
> that is not running yet, without holding reconfig_mutex.  But ->pers is
> only assigned after pers->run() returns, so "not running" also covers an
> md_run() that is in progress under the lock.
>
> If the write lands inside raid5_run() after log_init() has decided not to
> set up PPL, or after a failed ppl_init_log() has cleared the flag, the
> flag ends up set with conf->log_private still NULL.  The next idle pass
> of raid5d() then does:
>
>    raid5d() -> handle_active_stripes() -> log_flush_stripe_to_raid()
>      -> ppl_write_stripe_run()
>
> and dereferences the NULL ppl_conf:
>
>    Oops: general protection fault, probably for non-canonical address 0xd=
ffffc0000000002
>    KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
>    RIP: 0010:ppl_write_stripe_run+0x60/0x1320 drivers/md/raid5-ppl.c:538
>
> Take reconfig_mutex around the update and refuse it with -EBUSY once the
> array is running, in which case ->change_consistency_policy() is the
> right interface.
>
> Fixes: 664aed04446c ("md: add sysfs entries for PPL")
> Reported-by:syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
> Closes:https://syzkaller.appspot.com/bug?extid=3D75d7e96ad03ac2dbbd9f
> Signed-off-by: Nguyen Ngoc Thang<ngocthang2710.1999@gmail.com>
> ---
> Notes:
>
> This differs from the NULL check in ppl_write_stripe_run() that is being
> patch-tested on the syzbot page: that hides the symptom but leaves
> MD_HAS_PPL inconsistent with conf->log_private for the other PPL entry
> points.  md_attr_store() has not taken reconfig_mutex for every store sin=
ce
> 6791875e2e53, so the store has to take it itself.
>
> Testing (QEMU, KASAN, x86_64): one loop assembles raid5/external/ram0 whi=
le
> a second loop keeps writing "ppl" to consistency_policy.  Without a delay=
 the
> window is only a few microseconds, so I used a debug-only patch in
> raid5_run() (clear MD_HAS_PPL and mdelay(50) before log_init()) that is n=
ot
> part of this submission.
>    - without the fix: the syzbot oops on the first assembly,
>      ppl_write_stripe_run+0x5d in md0_raid5;
>    - with the fix and the same delay: 100/100 assemblies, no KASAN report=
.
> The unmodified syz repro only ended with -ENOSPC ("PPL space too small") =
in
> my setup.
>
>   drivers/md/md.c | 10 +++++++++-
>   1 file changed, 9 insertions(+), 1 deletion(-)
Applied to md-7.4

--=20
Thanks,
Kuai
