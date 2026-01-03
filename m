Received: from sg-1-39.ptr.blmpb.com (sg-1-39.ptr.blmpb.com [118.26.132.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E3A1E231E
	for <linux-raid@vger.kernel.org>; Sat,  3 Jan 2026 11:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767438767; cv=none; b=URD8xTyA8G6UNqwaUW08jpK0mGAlcQXdT53eaT/8R7AcT/MUPU3d39MSbqJY0aiSBQcuFObOLiBKlBW8ggI70R7EkTgR5KB/QBNHYy8YnERvoaZE6GbbuljpCpraLGf33k6pY0YdETsGSt3tPwBX0/eFTXbiBNVa5uwg5AgH6Lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767438767; c=relaxed/simple;
	bh=6dEinEyoOtzEBIjQkn9XAiUBIMDLO+LYZXA3C+ZSWs0=;
	h=Cc:From:Date:Mime-Version:In-Reply-To:References:To:Message-Id:
	 Content-Type:Subject; b=NScFSVXDVC0k06mpgMRPLiwHNIMcOM+62VEW6RP16/BXE3pMIXLI803ZEf8hqWWvKC19oGS1MrL3K01MpRaiPJhqYs0iHc80w8Mr3AsiIPkMplxALcq29/PkMM/anjTR1q1tZu3DWEHkoZbAGsoPKxBTBLw2k7ulIgjp6ckUpIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=VUCH2aQB; arc=none smtp.client-ip=118.26.132.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="VUCH2aQB"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1767438759;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=6dEinEyoOtzEBIjQkn9XAiUBIMDLO+LYZXA3C+ZSWs0=;
 b=VUCH2aQBYEINL+dWeJW9VaM40ER9D/iazyuI64QJU18gx41HkDxzdwIrRyn1Gx+KbYX5JY
 Fr3VqAmFOExlOzs1CB5Vn5qw82ObWv9coWS927YdOxGOXuOLHkMZQJPoWzwjympWYFhiad
 k1Pj6VyaVVKm0lJEqlTxDWr6ljV72TVlnOZN9/W3k4nJ2welW5nLJovdQOCvBzi4J7Tqbe
 5IOUNJSS6hb53Gp/ev5x40QOetwR01DnY3H6BdgWBr+5wSDEXeJ4enDs7uKjfW6Qe5RdSC
 2qOjxbScM38sqYJs3JsqNA1kI0KbalZngDvnQwhuqm2AQdYXLPy2aybesProXQ==
Cc: <linux-kernel@vger.kernel.org>, <filippo@debian.org>, <colyli@fnnas.com>, 
	<yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.186]) by smtp.feishu.cn with ESMTPS; Sat, 03 Jan 2026 19:12:36 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Sat, 3 Jan 2026 19:12:33 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <343e3081-7d24-f783-b040-2f61aad4ea4f@huaweicloud.com>
References: <20251124063203.1692144-1-yukuai@fnnas.com> <20251124063203.1692144-5-yukuai@fnnas.com> <343e3081-7d24-f783-b040-2f61aad4ea4f@huaweicloud.com>
X-Lms-Return-Path: <lba+26958f9a5+5be909+vger.kernel.org+yukuai@fnnas.com>
To: "Li Nan" <linan666@huaweicloud.com>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>
Message-Id: <5460e6b3-9b23-49e9-a52b-57e1e6d2490a@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
Subject: Re: [PATCH v2 04/11] md/raid5: use mempool to allocate stripe_request_ctx
X-Original-From: Yu Kuai <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/12/26 16:33, Li Nan =E5=86=99=E9=81=93:
>
>
> =E5=9C=A8 2025/11/24 14:31, Yu Kuai =E5=86=99=E9=81=93:
>> On the one hand, stripe_request_ctx is 72 bytes, and it's a bit huge for
>> a stack variable.
>>
>> On the other hand, the bitmap sectors_to_do is a fixed size, result in
>> max_hw_sector_kb of raid5 array is at most 256 * 4k =3D 1Mb, and this wi=
ll
>> make full stripe IO impossible for the array that chunk_size *=20
>> data_disks
>> is bigger. Allocate ctx during runtime will make it possible to get rid
>> of this limit.
>>
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> ---
>> =C2=A0 drivers/md/md.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 4 +++
>> =C2=A0 drivers/md/raid1-10.c |=C2=A0 5 ----
>> =C2=A0 drivers/md/raid5.c=C2=A0=C2=A0=C2=A0 | 61 +++++++++++++++++++++++=
++++----------------
>> =C2=A0 drivers/md/raid5.h=C2=A0=C2=A0=C2=A0 |=C2=A0 2 ++
>> =C2=A0 4 files changed, 45 insertions(+), 27 deletions(-)
>>
>
> [...]
>
>> @@ -7374,6 +7380,10 @@ static void free_conf(struct r5conf *conf)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 bioset_exit(&conf->bio_split);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(conf->stripe_hashtbl);
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(conf->pending_data);
>> +
>> +=C2=A0=C2=A0=C2=A0 if (conf->ctx_pool)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mempool_destroy(conf->ctx_po=
ol);
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 kfree(conf);
>> =C2=A0 }
>> =C2=A0 @@ -8057,6 +8067,13 @@ static int raid5_run(struct mddev *mddev)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0 goto abort;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 +=C2=A0=C2=A0=C2=A0 conf->ctx_pool =3D mempool_create_kmalloc_poo=
l(NR_RAID_BIOS,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 sizeof(struct stripe_request_=
ctx));
>> +=C2=A0=C2=A0=C2=A0 if (!conf->ctx_pool) {
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 ret =3D -ENOMEM;
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto abort;
>> +=C2=A0=C2=A0=C2=A0 }
>> +
>
> What about moving create to setup_conf()? If so, call destroy in
> free_conf() without checks.

No, we can't, this must be done after raid5_set_limits(), which is called
at the end of raid5_run().

>
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (log_init(conf, journal_dev, raid5_has=
_ppl(conf)))
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 goto abort;
>> =C2=A0 diff --git a/drivers/md/raid5.h b/drivers/md/raid5.h
>> index eafc6e9ed6ee..6e3f07119fa4 100644
>> --- a/drivers/md/raid5.h
>> +++ b/drivers/md/raid5.h
>> @@ -690,6 +690,8 @@ struct r5conf {
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct list_head=C2=A0=C2=A0=C2=A0 pendin=
g_list;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 int=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 pending_data_cnt;
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 struct r5pending_data=C2=A0=C2=A0=C2=A0 *=
next_pending_data;
>> +
>> +=C2=A0=C2=A0=C2=A0 mempool_t=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
*ctx_pool;
>> =C2=A0 };
>> =C2=A0 =C2=A0 #if PAGE_SIZE =3D=3D DEFAULT_STRIPE_SIZE
>
--=20
Thansk,
Kuai
