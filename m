Received: from mail14.out.flockmail.com (mail14.out.flockmail.com [3.232.215.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D242191F68
	for <linux-raid@vger.kernel.org>; Fri,  7 Feb 2025 17:00:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=3.232.215.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738947609; cv=none; b=UN4xmEKiB0O1hKv7z1XdWKNwgpntXm98IGHKW6CoVxgMH41n3l655Il3AGjrzjd+6cLr2Bbs3r+qRdIgb1yN0oqzLzAExh2n18LOLmBDJDd+7b5JPwfZ9/oh91hJN9CckWzh4qhIWNu6H6WY/c1KFeWEar3qZMSv90iQXrDTEDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738947609; c=relaxed/simple;
	bh=VKcaw9eLXa07v0n5FfDuUlu86fFuuct6Mad4dveaybo=;
	h=Content-Type:Mime-Version:Subject:From:In-Reply-To:Date:Cc:
	 Message-Id:References:To; b=E2hX9UtbOJdQBqYq3lJ4Bz3Zitem8xVtrWz/pNQg29HfQSfyIH68bKEByOiU2jtXVxnk6IpYQUXhHFMO6ORQtlo+UIyE3xnqXdfg+WTxsWH/ZrocxbKghLvENbAWDE0e5MBe+8Ud2WKZ1bjp0rtyAs98az5LbFc5pGmJw2fRbJg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li; spf=pass smtp.mailfrom=coly.li; dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b=l7G29ErQ; arc=none smtp.client-ip=3.232.215.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=coly.li
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=coly.li
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=t12smtp-sign004.email header.i=@t12smtp-sign004.email header.b="l7G29ErQ"
DKIM-Signature: a=rsa-sha256; bh=sRmdhPAVRuZCjmd8FAVGdpUjspJ52YCDSZv+dG6AHlo=;
	c=relaxed/relaxed; d=t12smtp-sign004.email;
	h=in-reply-to:mime-version:subject:from:cc:date:references:message-id:to:from:to:cc:subject:date:message-id:in-reply-to:references:reply-to;
	q=dns/txt; s=titan1; t=1738921986; v=1;
	b=l7G29ErQ5uIcIsaG59o3Hhn2NgnMe8Xbq+UCdNZC0I8vus/jr0gaSXjM87/wvDNUyQjftqb+
	ca8AxeUE13PdCPc1ToguYACGm7DY3E+7DNuDduyqEOrLRCelSu1WL3KC6axW8NKEHSQweJbj4aP
	Pkokyz09LtJCTY1KlUSVEV1o=
Received: from smtpclient.apple (unknown [141.11.218.23])
	by smtp-out.flockmail.com (Postfix) with ESMTPA id 1C747604C1;
	Fri,  7 Feb 2025 09:53:01 +0000 (UTC)
Content-Type: text/plain;
	charset=utf-8
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.400.131.1.6\))
Subject: Re: [PATCH V3] md-linear: optimize which_dev() for small disks number
Feedback-ID: :i@coly.li:coly.li:flockmailId
From: Coly Li <i@coly.li>
In-Reply-To: <86dbb33c-c762-0987-50f1-150b5c41a348@huaweicloud.com>
Date: Fri, 7 Feb 2025 17:52:48 +0800
Cc: colyli@kernel.org,
 linux-raid@vger.kernel.org,
 Song Liu <song@kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <BB479A85-DF37-4D52-A264-D32078729092@coly.li>
References: <20250207023505.86967-1-colyli@kernel.org>
 <86dbb33c-c762-0987-50f1-150b5c41a348@huaweicloud.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
X-Mailer: Apple Mail (2.3826.400.131.1.6)
X-F-Verdict: SPFVALID
X-Titan-Src-Out: 1738921986449551540.7782.7021587124429802659@prod-use1-smtp-out1001.
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.4 cv=SLe4VPvH c=1 sm=1 tr=0 ts=67a5d802
	a=USBFZE4A2Ag4MGBBroF6Xg==:117 a=USBFZE4A2Ag4MGBBroF6Xg==:17
	a=IkcTkHD0fZMA:10 a=CEWIc4RMnpUA:10 a=AiHppB-aAAAA:8 a=VwQbUJbxAAAA:8
	a=i0EeH86SAAAA:8 a=QpyyDF2cCSZCACEl5V0A:9 a=QEXdDO2ut3YA:10



> 2025=E5=B9=B42=E6=9C=887=E6=97=A5 17:50=EF=BC=8CYu Kuai =
<yukuai1@huaweicloud.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Hi,
>=20
> =E5=9C=A8 2025/02/07 10:35, colyli@kernel.org =E5=86=99=E9=81=93:
>> From: Coly Li <colyli@kernel.org>
>> which_dev() is a top hot function in md-linear.c, every I/O request =
will
>> call it to find out which component disk the bio should be issued to.
>> Current witch_dev() performs a standard binary search, indeed this is
>> not the fastest algorithm in practice. When the whole conf->disks =
array
>> can be stored within a single cache line, simple linear search is =
faster
>> than binary search for a small disks number.
>>> =46rom micro benchmark, around 20%~30% latency reduction can be =
observed.
>> Of course such huge optimization cannot be achieved in real workload, =
in
>> my benchmark with,
>> 1) One md linear device assembled by 2 or 4 Intel Optane memory block
>>    device on Lenovo ThinkSystem SR650 server.
>> 2) Random write I/O issued by fio, with I/O depth 1 and 512 bytes =
block
>>    size.
>=20
>> The percentage of I/O latencies completed with 750 nsec increases =
from
>> 97.186% to 99.324% in average, in a rough estimation the write =
latency
>> improves (reduces) around 2.138%.
>> This is quite ideal result, I believe on slow hard drives such small
>> code-running optimization will be overwhelmed by hardware latency and
>> hard to be recognized.
>> This patch will go back to binary search when the linear device grows
>> and conf->disks array cannot be placed within a single cache line.
>> Although the optimization result is tiny in most of cases, it is good =
to
>> have it since we don't pay any other cost.
>> Signed-off-by: Coly Li <colyli@kernel.org>
>> Cc: Song Liu <song@kernel.org>
>> Cc: Yu Kuai <yukuai3@huawei.com>
>> ---
>> Changelog,
>> v3: fix typo and email address which are reported by raid kernel ci.
>> v2: return last item of conf->disks[] if fast search missed.
>> v1: initial version.
>>  drivers/md/md-linear.c | 45 =
+++++++++++++++++++++++++++++++++++++++++-
>>  1 file changed, 44 insertions(+), 1 deletion(-)
>> diff --git a/drivers/md/md-linear.c b/drivers/md/md-linear.c
>> index a382929ce7ba..cdb59f2b2a1c 100644
>> --- a/drivers/md/md-linear.c
>> +++ b/drivers/md/md-linear.c
>> @@ -25,10 +25,12 @@ struct linear_conf {
>>   struct dev_info         disks[] __counted_by(raid_disks);
>>  };
>>  +static int prefer_linear_dev_search;
>=20
> Why using global variable instead of per linear? There are still hole =
in
> the linear_conf() that you can use.

OK, I will use space inside linear_conf.=20


>> +
>>  /*
>>   * find which device holds a particular offset
>>   */
>> -static inline struct dev_info *which_dev(struct mddev *mddev, =
sector_t sector)
>> +static inline struct dev_info *__which_dev(struct mddev *mddev, =
sector_t sector)
>>  {
>>   int lo, mid, hi;
>>   struct linear_conf *conf;
>> @@ -53,6 +55,34 @@ static inline struct dev_info *which_dev(struct =
mddev *mddev, sector_t sector)
>>   return conf->disks + lo;
>>  }
>>  +/*
>> + * If conf->disk[] can be hold within a L1 cache line,
>> + * linear search is fater than binary search.
>> + */
>> +static inline struct dev_info *which_dev(struct mddev *mddev, =
sector_t sector)
>> +{
>> + int i;
>> +
>> + if (prefer_linear_dev_search) {
>> + struct linear_conf *conf;
>> + struct dev_info *dev;
>> + int max;
>> +
>> + conf =3D mddev->private;
>> + dev =3D conf->disks;
>> + max =3D conf->raid_disks;
>> + for (i =3D 0; i < max; i++, dev++) {
>> + if (sector < dev->end_sector)
>> + return dev;
>> + }
>> + return &conf->disks[max-1];
>> + }
>> +
>> + /* slow path */
>> + return __which_dev(mddev, sector);
>> +}
>> +
>> +
>>  static sector_t linear_size(struct mddev *mddev, sector_t sectors, =
int raid_disks)
>>  {
>>   struct linear_conf *conf;
>> @@ -222,6 +252,18 @@ static int linear_add(struct mddev *mddev, =
struct md_rdev *rdev)
>>   md_set_array_sectors(mddev, linear_size(mddev, 0, 0));
>>   set_capacity_and_notify(mddev->gendisk, mddev->array_sectors);
>>   kfree_rcu(oldconf, rcu);
>> +
>> + /*
>> +  * When elements in linear_conf->disks[] becomes large enough,
>> +  * set prefer_linear_dev_search as 0 to indicate linear search
>> +  * in which_dev() is not optimized. Slow path in __which_dev()
>> +  * might be faster.
>> +  */
>> + if ((mddev->raid_disks * sizeof(struct dev_info)) >
>> +      cache_line_size() &&
>=20
> BTW, you said in the case *a single cache line*, however, the field
> disks is 32 bytes offset in linear_conf, you might want to align it to
> cacheline, or add sizeof(struct linear_conf) on the left and align
> linear_conf to the cacheline.
>=20

Yes, thanks for the hint. Let me do it in next version.



> Thanks,
> Kuai
>> +     prefer_linear_dev_search =3D=3D 1)
>> + prefer_linear_dev_search =3D 0;
>> +
>>   return 0;
>>  }
>>  @@ -337,6 +379,7 @@ static struct md_personality linear_personality =
=3D {
>>    static int __init linear_init(void)
>>  {
>> + prefer_linear_dev_search =3D 1;
>>   return register_md_personality(&linear_personality);
>>  }


