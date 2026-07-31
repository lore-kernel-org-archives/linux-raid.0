Received: from va-2-58.ptr.blmpb.com (va-2-58.ptr.blmpb.com [209.127.231.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2056B3C1411
	for <linux-raid@vger.kernel.org>; Fri, 31 Jul 2026 08:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785486486; cv=none; b=mtOl2tk8PQqxe10ycYz9MDsxtnP87+ZeEMD2w7hajEWY43SKbqh8f3OC8ZdRpYGAJTh4oTBuu1gX0P3FIaDmQrg0Tt/fbxQM0PjofQNVdL8q9NGy/f0+SsbOWO1qwK3aU1cfAAks9AKFbc6w2cX45s2Zms5kKn/U+P7JH3iG7+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785486486; c=relaxed/simple;
	bh=4ZGFELos/Z0Tun8c2141QOU+TQJlI5f7swsIQow06UU=;
	h=Subject:Mime-Version:From:Date:Content-Type:To:References:
	 In-Reply-To:Cc:Message-Id; b=CI1UP0B5Gicsd4jly7+egpUb8q43Ene1YhUpWvzVJrd+TIFNMuSuHmCKvy5sgnduOhZP2H8YoXaouDalKD4lAIz3VtLI2vDme0252jzDk5leaOl8rcTlWn9kOYjCpY+NFVGsIlATp2FlQ2TythqX/Ix81x86zHOU3BKSg5Czdm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=h/qsyCH/; arc=none smtp.client-ip=209.127.231.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="h/qsyCH/"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785486473;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=QNoMuQqQ3kw+M94Vwu+1cunVX0sw21fNcptDEZowzd0=;
 b=h/qsyCH/nALoEuRcG63ptt5iGLaiyNuBykvEyBr9gOwLQX2LIyB22qBWU0xmKz1YIIhEcw
 93o4ET0TIizvom9uORR+RSE7AUNblgEF+S0HZZjkTwfLtz6BqQ/l3unw/45YS5QpPMcw0q
 iJpv9QWO0GuBYxcKhzpbEtS6Jy5s266JqKtZV03fTK1SHnkqThiwM5uqdi7jeTBwG25q6g
 pt+mM8nGdGimqs6cg6+xpUwXT2H/zcTNTGh3opzvkLohol/9jV81OyxGtugSn0wAUwX9aI
 uiY5UdgUeELjvgVpi4h7FuveYwnrrcLRARg8YYzH2LOFDNp5C0FqSdeIkpNj0w==
Subject: Re: [PATCH] md/raid1: create serial pool adding rdev to array with serialize_policy=1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
From: "yu kuai" <yukuai@fygo.io>
Date: Fri, 31 Jul 2026 16:27:48 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: "Martin Wilck" <martin.wilck@suse.com>, 
	"Song Liu" <songliubraving@fb.com>, "yu kuai" <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26a6c5c89+090719+vger.kernel.org+yukuai@fygo.io>
References: <20260723112741.1206836-1-mwilck@suse.com>
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Fri, 31 Jul 2026 08:27:52 +0000
In-Reply-To: <20260723112741.1206836-1-mwilck@suse.com>
Cc: "Xiao Ni" <xni@redhat.com>, "Li Nan" <linan122@huawei.com>, 
	<linux-raid@vger.kernel.org>, "Martin Wilck" <mwilck@suse.com>
Message-Id: <2840598b-a4af-4a2e-a5f3-538213509e22@fygo.io>

=E5=9C=A8 2026/7/23 19:27, Martin Wilck =E5=86=99=E9=81=93:

> The following bug has been observed with kernel 7.1.3 after adding a new
> rdev to an existing RAID1 array that had enabled serialize_policy:
>
> [ 1754.091836][T19639] Oops: Oops: 0002 [#1] SMP NOPTI
> [ 1754.092679][T19639] CPU: 0 UID: 0 PID: 19639 Comm: ext4lazyinit Not ta=
inted 7.1.3-1-default #1 PREEMPT(full) openSUSE Tumbleweed  b041a6527f6e584=
24f4cd3de0fade8d408b378fd
> [ 1754.095245][T19639] Hardware name: QEMU Standard PC (i440FX + PIIX, 19=
96), BIOS unknown 02/02/2022
> [ 1754.096772][T19639] RIP: 0010:_raw_spin_lock_irqsave+0x27/0x50
> [ 1754.097769][T19639] Code: 90 90 90 f3 0f 1e fa 0f 1f 44 00 00 53 9c 58=
 0f 1f 40 00 48 89 c3 fa 0f 1f 44 00 00 65 ff 05 c0 bc d8 01 31 c0 ba 01 00=
 00 00 <3e> 0f b1 17 75 09 48 89 d8 5b e9 85 8d fc fe 89 c6 e8 c3 08 00 00
> [ 1754.100996][T19639] RSP: 0018:ffffcfbbc0a5bab8 EFLAGS: 00010046
> [ 1754.102037][T19639] RAX: 0000000000000000 RBX: 0000000000000212 RCX: 6=
1c8864680b583eb
> [ 1754.103367][T19639] RDX: 0000000000000001 RSI: 000000000000092a RDI: 0=
000000000004960
> [ 1754.104723][T19639] RBP: ffff8efae2b12700 R08: 00000000ffffffff R09: 0=
000000000000000
> [ 1754.106038][T19639] R10: ffffffffa0605ac0 R11: 0000000000000001 R12: f=
fff8efad4199400
> [ 1754.107343][T19639] R13: 0000000000004950 R14: ffff8efaf9164600 R15: 0=
00000000004043e
> [ 1754.108697][T19639] FS:  0000000000000000(0000) GS:ffff8efbdc754000(00=
00) knlGS:0000000000000000
> [ 1754.110190][T19639] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 1754.111280][T19639] CR2: 0000000000004960 CR3: 000000000d830001 CR4: 0=
000000000770ef0
> [ 1754.112580][T19639] PKRU: 55555554
> [ 1754.113182][T19639] Call Trace:
> [ 1754.113754][T19639]  <TASK>
> [ 1754.114256][T19639]  wait_for_serialization+0xb9/0x260 [raid1 9ad4618e=
4becc97c5a7140f7aa35cc4730d97dd9]
> [ 1754.115869][T19639]  raid1_make_request+0x762/0xaff [raid1 9ad4618e4be=
cc97c5a7140f7aa35cc4730d97dd9]
> [ 1754.118368][T19639]  md_handle_request+0x1c9/0x2e0 [md_mod a261f96e3d6=
1eb9d00ceb34dc9439cf6487db185]
>
> The raid1.c code calls wait_for_serialization() if the MD_SERIALIZE_POLIC=
Y
> is set, and wait_for_serialization assumes that rdev->serial is
> initialized. Normally this will be the case for arrays that have
> the serialize_policy sysfs attribute set to 1.
>
> But when a new rdev is added to an existing array in bind_rdev_to_array()=
,
> the condition at mddev_create_serial_pool() causes creation of rdev->seri=
al
> to be skipped. Fix it.
>
> Fixes: 69b00b5bb235 ("md: introduce a new struct for IO serialization")
> Signed-off-by: Martin Wilck<mwilck@suse.com>
> ---
>   drivers/md/md.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)

Update the commit message to only save necessary info for kernel log.

Applied to md-7.3

--=20
Thanks,
Kuai
