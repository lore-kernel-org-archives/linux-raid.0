Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=113.46.200.222
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795683658;
	b=j0JU9pg67ygK4XqdwBGPnPuDTjhQlmYUN9Q6fWfKJKNkf2wY7UOpJaBZHSqRQuL8rSAv
	 yrexxMkapTbuiF2m7x/DEWHlT6WvC+cseM3fOEaoU8CNnpXG6tgKkCjJdVSgC53Sbzl+r
	 Vuvf6FUHmPaVU4M/PTHeOYdEV0QCCBjoMW+9FG861MBOmFXhm/VO863+UiD8keGdw/zju
	 nMx5n1ajIG+YKbU5W8xQw1E7qqMCC0AAPrmvxkw2E/b57O29YNmRAFv8CmSccHG/BezMK
	 XPnswFD5gl2swGZfgXsVIdByIIx8AD7QXwfMs8/o2gn/GXeztcj2w/AvXwnP56owPzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795683658;
	h=DMARC-Filter:dkim-signature:Received:Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding:X-Originating-IP:
	 X-ClientProxiedBy;
	bh=/YNFWvrRx5X0CHYpDCHMceX/qTfoad6xQ8rtAaG4DEQ=;
	b=1Te8Vp0CW4W01yIpWuy1y2ClG3rMxESOtntRJvQUqq4ren0EvNBcVb0lnMCat6cqnlXU
	 qwSaTdgdwLmzQFVliEPQfJUmJtHZC4vbxwSgUNloxOpxdT44KE7wKnG/vAaomy9NX64Yi
	 5sqXSO4/rDmnmfrquXK2WrG4+7VQV//cUwT6m7fSGrBO4Hp+1qCkL2F972Qt588FXbml+
	 upfkCF2fwqxO3B6ZsXbNvV4itYACcHgoEfrZL7KrZQLsAzVdioZB8bAfykagLONod4UwX
	 IKsEYCAdz/alZzPgeG+cBo6UuOvaQZgdl6PSa9RtSGoJe30Pu4Mql4VvMOcf7UbESHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=huawei.com;
	spf=pass smtp.mailfrom=huawei.com;
	dkim=pass header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oCg64jvb;
	arc=none smtp.remote-ip=113.46.200.222
Received: from canpmsgout07.his.huawei.com (canpmsgout07.his.huawei.com [113.46.200.222])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82523606A321
	for <linux-raid@vger.kernel.org>; Thu, 26 Nov 2026 09:00:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 82523606A321
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.a=rsa-sha256 header.s=dkim header.b=oCg64jvb
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/YNFWvrRx5X0CHYpDCHMceX/qTfoad6xQ8rtAaG4DEQ=;
	b=oCg64jvbFYkvSJ6jEHCOdMIlhiV6yjFSDSTp4nn2hBwNXBYqbm2GADgdrC8dAT1VPTEkYHtyh
	+G3WnyQT/be0mUSEFiZpxP1ZENT6NYHrl+PIjPzujeFkQQxIdsP0ggJmh+Vbspe6pLZlm1AvY7B
	PVJ1RQIpDRZhAzi0fWPkROQ=
Received: from mail.maildlp.com (unknown [172.19.163.15])
	by canpmsgout07.his.huawei.com (SkyGuard) with ESMTPS id 4jZr9M1CcTzLlX5;
	Thu, 26 Nov 2026 17:00:23 +0800 (CST)
Received: from dggpemr100018.china.huawei.com (unknown [7.185.36.64])
	by mail.maildlp.com (Postfix) with ESMTPS id AD8AE40586;
	Thu, 26 Nov 2026 17:00:47 +0800 (CST)
Received: from [10.174.179.156] (10.174.179.156) by
 dggpemr100018.china.huawei.com (7.185.36.64) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 26 Nov 2026 17:00:46 +0800
Message-ID: <8888a9f6-8f8a-4c3f-a91d-e130fbb84d53@huawei.com>
Date: Thu, 26 Nov 2026 17:00:45 +0800
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/raid10: reset bi_offset in sync_request_write()
To: Christoph Hellwig <hch@infradead.org>
CC: <song@kernel.org>, <yukuai@fygo.io>, <neilb@suse.com>,
	<artur.paszkiewicz@intel.com>, <shli@kernel.org>, <axboe@kernel.dk>,
	<linux-raid@vger.kernel.org>, <chengzhihao1@huawei.com>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
References: <20261124060856.559865-1-zhouminqiang2@huawei.com>
 <awZsJ5H6uEH4so8D@infradead.org>
From: zhouminqiang <zhouminqiang2@huawei.com>
In-Reply-To: <awZsJ5H6uEH4so8D@infradead.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemr100018.china.huawei.com (7.185.36.64)

Hi,
bio_reuse() is indeed the right helper. v2 has been sent: 
https://lore.kernel.org/all/20261126080632.1598653-1-zhouminqiang2@huawei.com/

在 2026/11/25 13:03, Christoph Hellwig 写道:
> On Tue, Nov 24, 2026 at 02:08:56PM +0800, Zhou Minqiang wrote:
>> +++ b/drivers/md/raid10.c
>> @@ -2330,6 +2330,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
>>   	fbio = r10_bio->devs[i].bio;
>>   	fbio->bi_iter.bi_size = r10_bio->sectors << 9;
>>   	fbio->bi_iter.bi_idx = 0;
>> +	fbio->bi_iter.bi_offset = 0;
>>   	fpages = get_resync_pages(fbio)->pages;
> 
> Directly messing with the iterator is a really bad idea.  This needs to
> use bio_reuse or bio_reset.

Thanks.
