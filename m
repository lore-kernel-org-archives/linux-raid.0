Received: from canpmsgout04.his.huawei.com (canpmsgout04.his.huawei.com [113.46.200.219])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31C67473C68;
	Fri,  9 Oct 2026 07:12:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791529972; cv=none; b=dsMNo+mI/Vbs9aiLdyUIHDZ7Wi37/MpJw34C4E2OoHcFtNKpb6PAaAgDI4ieXxhdnU6W5ynLLPd/w1tSdp5Kf5MiBq9X2XaOtM6olqiwvYYcCG7vgPmZTxzZ3jALe0iCtB5m7C9maGZPfi+2mXoTxUoDfnfh8ScJdNQsOxeEoCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791529972; c=relaxed/simple;
	bh=OHPHriyd9zE5R00jtBUeLegaMtPjxjMeS3xqgij/AL0=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=R5/EHgucuaPPZkWjedBQXIY5WrzCwNBCJA96o9VdkuBxq2OUOkRpG7LDr0FgFbGtdII6EzWdqVG2Fo5+PSabQAYCpBavuR5VuEOxja6IusgY8JID5adDGF5pQy5tkuh+zvO5gjbJL89/rN8oLW9Eb1ykl6aHrnu1RP8Ts9QzR9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=w2lnFrXz; arc=none smtp.client-ip=113.46.200.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="w2lnFrXz"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=7FME7jd+jauy53NyaIyzwYuM5cz0oA7QkLeyMHGBT/8=;
	b=w2lnFrXzCYmX+JKEtVl4rBHYzY2RLFvEISHaQ7LZqSO1JxQk6iLF96FuSH2t6p+uujcHEKePK
	sOqk6hBAPaKpPCYzszr2QeVN8ShDE+izuSAKhZh5mw03fCMXJ1IOk6CLoim4coX8BJoi2UOpXL5
	S7THvSvrieQFhJ/wGLsoK2A=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout04.his.huawei.com (SkyGuard) with ESMTPS id 4j1Hmy0J1Pz1prLV;
	Fri,  9 Oct 2026 15:00:18 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id ABA6440561;
	Fri,  9 Oct 2026 15:12:34 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Fri, 9 Oct 2026 15:12:33 +0800
Subject: Re: [PATCH v3 1/4] md/raid5: Hide the origin mddev->thread before
 takeover
To: <yukuai@fygo.io>, <song@kernel.org>, <shli@kernel.org>, <neil@brown.name>
CC: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<yangerkun@huawei.com>, <yi.zhang@huawei.com>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
 <20260923112159.94175-2-chengzhihao1@huawei.com>
 <1194977a-ef25-4ad3-9bec-df27b6adc4b4@fygo.io>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <aaa9d0ee-99ca-55d9-ced4-953d25190d97@huawei.com>
Date: Fri, 9 Oct 2026 15:12:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <1194977a-ef25-4ad3-9bec-df27b6adc4b4@fygo.io>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 whupemo200011.china.huawei.com (7.152.185.179)

在 2026/10/9 12:31, yu kuai 写道:
> Hi,
> 
> 在 2026/9/23 19:21, Zhihao Cheng 写道:
>> The raid5 takeover invokes setup_conf and allocates strip heads, but
>> it wakes up the wrong thread, which lefts strip heads in the list
>> 'conf->released_stripes' and not being processed. If raid5_run fails,
>> the strip heads won't be released, which triggers the following slab
>> warnings (CONFIG_SLUB_DEBUG):
>>    BUG raid5-md0 (Not tainted): Objects remaining on __kmem_cache_shutdown()
>>    Object 0x0000000062fad548 @offset=3968
>>    Object 0x000000007f74683c @offset=4960
>>    WARNING: mm/slub.c:1268 at __slab_err+0x31/0x40, CPU#0: bash/865
>>    RIP: 0010:__slab_err+0x31
>>    Call Trace:
>>     __kmem_cache_shutdown.cold+0x15b
>>     kmem_cache_destroy+0x71
>>     free_conf+0xf8
>>     raid5_run.cold+0x463
>>     level_store+0x64e
>>     md_attr_store+0xd7
> 
> Is this still a problem with following patch?
> 
> [PATCH] md/raid5: drain released_stripes before destroying the cache -
> Li Youhong
> <https://lore.kernel.org/all/20260929083916.50620-1-dayou5941@163.com/>
Hi,

Youhong's patch could fix the problem, please take it, his solution is 
better.
> 
>>
>> The detailed triggering process is as follows:
>>    mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
>>    --force --assume-clean # create raid1, mddev->thread is raid1d
>>    echo 5 > /sys/block/md0/md/level
>>     level_store
>>      raid5_takeover_raid1
>>        setup_conf
>>         grow_stripes
>>          grow_one_stripe
>>           sh = alloc_stripe
>>           raid5_release_stripe
>>             md_wakeup_thread(conf->mddev->thread) // wakeup raid1d
>>        raid5_run
>>         ENOMEM = raid5_create_ctx_pool
>>         free_conf
>>          shrink_stripes
>>           drop_one_stripe // no strips found from the conf->inactive_list
>>           kmem_cache_destroy(conf->slab_cache)
>> 	 __kmem_cache_shutdown
>> 	  free_partial
>> 	   list_slab_objects // some entries are not released !
>>
>> Fix it by hiding the origin mddev->thread before takeover, so that
>> new allocating strip heads can be put into 'conf->inactive_list',
>> which can be found by drop_one_stripe().
>>
>> Fixes: 773ca82fa1ee ("raid5: make release_stripe lockless")
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>> ---
>>    drivers/md/raid5.c | 37 ++++++++++++++++++++++++++++---------
>>    1 file changed, 28 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
>> index c091bba95c31..7e87e8a60f5f 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -9039,19 +9039,38 @@ static void *raid5_takeover(struct mddev *mddev)
>>    	 *  raid4 - trivial - just use a raid4 layout.
>>    	 *  raid6 - Providing it is a *_6 layout
>>    	 */
>> -	if (mddev->level == 0)
>> -		return raid45_takeover_raid0(mddev, 5);
>> -	if (mddev->level == 1)
>> -		return raid5_takeover_raid1(mddev);
>> -	if (mddev->level == 4) {
>> +	void *ret = ERR_PTR(-EINVAL);
>> +	struct md_thread *thread;
>> +
>> +	thread = rcu_dereference_protected(mddev->thread,
>> +				lockdep_is_held(&mddev->reconfig_mutex));
>> +	/*
>> +	 * Set mddev->thread to NULL before setup_conf() to avoid waking up
>> +	 * wrong thread(eg. raid1), which can prevent the strips from being
>> +	 * left unreleased in the error handling path(free_conf) of raid5_run.
>> +	 */
>> +	rcu_assign_pointer(mddev->thread, NULL);
>> +
>> +	switch (mddev->level) {
>> +	case 0:
>> +		ret = raid45_takeover_raid0(mddev, 5);
>> +		break;
>> +	case 1:
>> +		ret = raid5_takeover_raid1(mddev);
>> +		break;
>> +	case 4:
>>    		mddev->new_layout = ALGORITHM_PARITY_N;
>>    		mddev->new_level = 5;
>> -		return setup_conf(mddev);
>> +		ret = setup_conf(mddev);
>> +		break;
>> +	case 6:
>> +		ret = raid5_takeover_raid6(mddev);
>> +		break;
>>    	}
>> -	if (mddev->level == 6)
>> -		return raid5_takeover_raid6(mddev);
>>    
>> -	return ERR_PTR(-EINVAL);
>> +	rcu_assign_pointer(mddev->thread, thread);
>> +
>> +	return ret;
>>    }
>>    
>>    static void *raid4_takeover(struct mddev *mddev)
> 

