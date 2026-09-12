Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47279479880
	for <linux-raid@vger.kernel.org>; Sat, 12 Sep 2026 11:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213542; cv=none; b=I8bkxGzu7AnGZqC3Yhc5+CtppEVCACxjnMG9ot0+78DYEeVL9lNfqCy34XWeN9umEAvWWVintaUI/22rENZ9pmvSn+yJGOBfXhWAvK8zAiDfW2UpAM33NSP2hrMZQ4CDSs58TlTG1y78sXsOzxiRzerlIVDqQwPw8xIAv1JmP88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213542; c=relaxed/simple;
	bh=sliQ3PW7OuM+APGfCLd12WBbMv5+TXHCkpmoQedJqZw=;
	h=To:Message-Id:Date:Content-Type:From:Cc:Subject:Mime-Version:
	 References:In-Reply-To; b=mhIT/elkKHNxSvkM8/a0IkzVVmEp0jKc/764wZ2Xb3m4GjzbB90tL0RxN8waA3q75zWeiHgGA7IWzAZQwzhm9KWP3ZZhT1swx0VsdpvngowzLdc88oCoGqKNV+uzmo7obFABNU62VjieUH5gzA4Y9hiWADFl7UfJT98SRHpWv5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=ga6xD6Yo; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="ga6xD6Yo"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789213526;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=S4VTqOFfwwacEpTdW73keR5QVuHY0miPMcXtW76hUHw=;
 b=ga6xD6YoOCmqyAHjnCaPYyaQ7ztxqU1R3/d2psoKT908b24HLEl+foUzc5Wf/FKyiwM+7J
 0Pwb6eX3pFLWcGcf/ZZVoFcIEzQ5JVNed9tLgM1ypXQcM1lOHj+J89cSRl77Q4bJuxQoPX
 1Ygdrl9yIW709SyQbq/eMlbwgJ5B14+PNmsDS5lPeHYfUJcXpeRSEHT+zZGmaZrDtEmJ0Q
 Q//m+oRHufGG1P+BK1VT9Ggksh1xF5O6YsoMgwx3Pxp4oQBZ5X5gN3QSBWKXXLAuUGYjwG
 3JpKyAW7jTfP3M36y2+UoNLDlzMeHxFlvdu6IJ54nZbDcdICktZUFPn5Z5xpZA==
To: <sashiko-reviews@lists.linux.dev>, "Chen Cheng" <chencheng@fnnas.com>, 
	"yu kuai" <yukuai@fygo.io>
Message-Id: <0bbda44a-3d5f-43b0-a1f5-51ee57469902@fygo.io>
X-Lms-Return-Path: <lba+26aa53b55+b4b9f4+vger.kernel.org+yukuai@fygo.io>
X-Original-From: yu kuai <yukuai@fygo.io>
Date: Sat, 12 Sep 2026 19:45:21 +0800
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
From: "yu kuai" <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>
Subject: Re: [PATCH v3] md/raid5: reject raid4/5 arrays with too few disks
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Received: from [192.168.1.104] ([39.182.0.161]) by smtp.larksuite.com with ESMTPS; Sat, 12 Sep 2026 11:45:25 +0000
References: <20260911041521.2433222-1-chencheng@fnnas.com> <20260911042717.487AC1F00898@smtp.kernel.org>
In-Reply-To: <20260911042717.487AC1F00898@smtp.kernel.org>

Hi,

=E5=9C=A8 2026/9/11 12:27, sashiko-bot@kernel.org =E5=86=99=E9=81=93:
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
>
> Pre-existing issues:
> - [High] Division by zero in `raid5_run()` when assembling an array with =
an active reshape and insufficient data disks.
> --
>
> commit e2bb0701d8414cbf17eed6287965f8022ffe5eab
> Author: Chen Cheng <chencheng@fnnas.com>
>
> md/raid5: reject raid4/5 arrays with too few disks
>
> raid4 and raid5 require at least two disks, while raid6 requires at least
> four disks. setup_conf() only rejects raid6 arrays with fewer than four
> disks. As a result, an invalid raid4 or raid5 array can be assembled with
> no data disks and later reach raid5_set_limits().
>
> Reported-by: syzbot+de94ddbfff0c9e6fe030@syzkaller.appspotmail.com
> Closes: https://lore.kernel.org/r/6a778c82.01d0871a.3a0d52.006a.GAE@googl=
e.com/
> Fixes: f63f17350e53 ("md/raid5: use the atomic queue limit update APIs")
>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index b91545ce090de..e1f20035703ba 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -7657,9 +7657,11 @@ static struct r5conf *setup_conf(struct mddev *md=
dev)
>>   			mdname(mddev), mddev->new_layout);
>>   		return ERR_PTR(-EIO);
>>   	}
>> -	if (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4) {
>> -		pr_warn("md/raid:%s: not enough configured devices (%d, minimum 4)\n"=
,
>> -			mdname(mddev), mddev->raid_disks);
>> +	if ((mddev->new_level !=3D 6 && mddev->raid_disks < 2) ||
>> +	    (mddev->new_level =3D=3D 6 && mddev->raid_disks < 4)) {
>> +		pr_warn("md/raid:%s: not enough configured devices (%d, minimum %d)\n=
",
>> +			mdname(mddev), mddev->raid_disks,
>> +			mddev->new_level =3D=3D 6 ? 4 : 2);
> [Severity: High]
> This isn't a bug introduced by this patch, but does this fully prevent
> invalid array geometries from causing panics during array assembly?
>
> In raid5_run(), if there is an active reshape and the array is assembled =
with
> insufficient data disks, we calculate new_data_disks and divide by it bef=
ore
> setup_conf() is called to validate the array geometry:
>
> drivers/md/raid5.c:raid5_run() {
>      if (mddev->reshape_position !=3D MaxSector) {
>          ...
>          new_data_disks =3D mddev->raid_disks - max_degraded;
>          if (sector_div(here_new, chunk_sectors * new_data_disks)) {
>              ...
>          }
>          ...
>          sector_div(here_old, chunk_sectors * (old_disks-max_degraded));
>      }
>      ...
>      if (mddev->private =3D=3D NULL)
>          conf =3D setup_conf(mddev);
> }
This looks like a valid problem as well.
>
> If a crafted superblock sets raid_disks <=3D max_degraded and reshape_pos=
ition
> is not MaxSector, these divisions by zero are reached before the new chec=
ks
> in setup_conf() can reject the array.
>
> Could these checks be moved earlier in the assembly path to prevent the
> divide-by-zero panics?
>
>>   		return ERR_PTR(-EINVAL);
>>   	}
>>
--=20
Thanks,
Kuai
