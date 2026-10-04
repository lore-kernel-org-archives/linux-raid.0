Received: from va-2-41.ptr.blmpb.com (va-2-41.ptr.blmpb.com [209.127.231.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17CCC3E2777
	for <linux-raid@vger.kernel.org>; Sun,  4 Oct 2026 03:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791086043; cv=none; b=fDzFTwOPpPGB4iLTr9K6chNfZ0lzl8sxuNJ396xIyZ2dBGqwjDsnUileu2/6sr6KTCdo0ILCWCzBH4JuviX2qahrOPAdnIHdAgtb80v7h5XBtYRwoNBV0xVNR5l/ezqf8p8Owae0TQ8CwwHENrBeDM28mh8akWoNPhnG/Dh8h10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791086043; c=relaxed/simple;
	bh=Kjz23xee0EkCTSKLH7Jr2MiDr3Ha+F7EK9SH+wKIMoU=;
	h=References:To:Cc:Mime-Version:Content-Type:In-Reply-To:From:
	 Subject:Date:Message-Id; b=PC4I4ny/eorANCuD+NxAQYjpb0zna4ZGJJ+JKDZES25sY+P2kAza3Rc45LjI2vzmCiLkojEj8ALS8+VstKcqbsZaJR1o275BgVinYFKsYb5UZfuLGrzlYoLh6yF85YPDCuTuu2fF3qe5dqny5sg29wGvMV6m4RZMoM88AQHri18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=OvrM1k/M; arc=none smtp.client-ip=209.127.231.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="OvrM1k/M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1791086027;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=O8QbCgYQZlOQXUSpEPn47jxAv6RL0ZTxjvVmh8r/Vg0=;
 b=OvrM1k/MiFm/VMA+Gy4BBDktkK5HyzcS3DwBU4Q7RLzWOxSDa89EeDu+X7+U/EF0I5C2Pw
 ILhmZUZJJEIt18kAKE0HDJThGvlswae4gryl5zlraMlPGAHaXK+nH3CCAjvSSzL2n2/nwR
 5NWt/Ncsv2v7kWW85v3EP5R9VjfolKjcjPKc3/STeoWINfRS4daKt00RfW2NYaVKGoJoD3
 qBO+5sxxrsIerkFcFFM7yYh8rKVuPo6nqzwC5fZ4bELEPlbIYWtOVdMWaJwkdJvEw/6g1W
 FyLqIehVMfmY8dIKfHaCWjMx/JZPompF3wuWdkYtnjJ84VnFeaOPZYSIDW72sw==
References: <20260924162610.10056-1-nsvatoslav515@gmail.com>
Reply-To: yukuai@fygo.io
To: "Svyatoslav Nikolenko" <nsvatoslav515@gmail.com>, <song@kernel.org>, 
	"yu kuai" <yukuai@fygo.io>
Cc: <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Lms-Return-Path: <lba+26ac1cdcb+0c656b+vger.kernel.org+yukuai@fygo.io>
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.177]) by smtp.larksuite.com with ESMTPS; Sun, 04 Oct 2026 03:53:46 +0000
In-Reply-To: <20260924162610.10056-1-nsvatoslav515@gmail.com>
Content-Transfer-Encoding: quoted-printable
User-Agent: Mozilla Thunderbird
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md/raid5-ppl: check for NULL ppl_conf in ppl_write_stripe_run()
Date: Sun, 4 Oct 2026 11:53:43 +0800
Message-Id: <a61c9d13-4c8f-44ac-96e5-6387f4ae6765@fygo.io>

Hi,

=E5=9C=A8 2026/9/25 0:26, Svyatoslav Nikolenko =E5=86=99=E9=81=93:
> Syzbot reported a general protection fault
> due to a NULL pointer dereference in ppl_write_stripe_run().
>
> When a RAID 5 array operates without Partial Parity Log (PPL) enabled or
> before its initialization, conf->log_private remains NULL.
> ppl_write_stripe_run() assigns ppl_conf =3D conf->log_private and
> immediately attempts to access ppl_conf->count in the loop header.
> This triggers a NULL pointer dereference.
>
> Fix this by returning early
> from ppl_write_stripe_run() if ppl_conf is NULL.
>
> Tested-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
> Reported-by: syzbot+75d7e96ad03ac2dbbd9f@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D75d7e96ad03ac2dbbd9f
> Fixes: 3418d036c81d ("raid5-ppl: Partial Parity Log write logging impleme=
ntation")
> Signed-off-by: Svyatoslav Nikolenko <nsvatoslav515@gmail.com>
> ---
>   drivers/md/raid5-ppl.c | 3 +++
>   1 file changed, 3 insertions(+)

Another patch is applied for this problem, you can check the notes:

[PATCH] md: take reconfig_mutex when enabling PPL on an inactive array -=20
Nguyen Ngoc Thang <https://lore.kernel.org/linux-raid/20260924171345.75894-=
1-ngocthang2710.1999@gmail.com/>

>
> diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
> index 7f8a9d3fd578..e54ed4e44b0f 100644
> --- a/drivers/md/raid5-ppl.c
> +++ b/drivers/md/raid5-ppl.c
> @@ -535,6 +535,9 @@ void ppl_write_stripe_run(struct r5conf *conf)
>   	struct ppl_log *log;
>   	int i;
>  =20
> +	if (!ppl_conf)
> +		return;
> +
>   	for (i =3D 0; i < ppl_conf->count; i++) {
>   		log =3D &ppl_conf->child_logs[i];
>  =20

--=20
Thanks,
Kuai
