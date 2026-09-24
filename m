Received: from canpmsgout09.his.huawei.com (canpmsgout09.his.huawei.com [113.46.200.224])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6DB847CA79
	for <linux-raid@vger.kernel.org>; Thu, 24 Sep 2026 11:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.224
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790250846; cv=none; b=J38ZmeK1v9E2OjkGozP3EllbiSBIHcnJ6p545IKVY5MzoCKzS5fioQk6mpcSmiYobOKf7/zO5zGsg84kmJtvVCLgqBC2eYYn8H4mbYjST/AgiMG61xLyU1XBdpfNJIP/UzDa22PufIcQoqWpSnO84xykMq4T8HVJoueGxqxKBUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790250846; c=relaxed/simple;
	bh=DVNvGqK1W7NX/OKUDzKr3YR2NcERcakxgNaz1pofbqI=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=GmPxHdxNSo1Vc4Ryuzy9xNlf4f071/Qr6VpGKN1kTniIVBYULBuWZlj5oQzQKnH0Q7zo/lQtoXMPy6SN2/rjx/WS62WfaeHOgj8fMPcta3SKnpbdpEVXFG5bqASGgxgybmefp6FBPiMrH79ZQfQErrjbcGVG6lnxxNdxtNlGS1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=WZOsJC1y; arc=none smtp.client-ip=113.46.200.224
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="WZOsJC1y"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=aJZC0wxvHEAnxqz+pNpkdNnfusJneLwPLrQE9UBN0/c=;
	b=WZOsJC1ywZJYUA0zjeDNVfrZKVgssJxzgqJLTQME8YEL5WH0JCmNEODFFLaL0/r4IksNYxZKZ
	lAyTXGUoPpngFLEBGEXldP/LfzZzXBXXCVztSzYbObIo/yLxl69bYPpurwT3DZ3BhI27u+1nTrg
	Squ9s7SdvDTMiJ/8uK7df6I=
Received: from mail.maildlp.com (unknown [172.19.163.163])
	by canpmsgout09.his.huawei.com (SkyGuard) with ESMTPS id 4hrBlz1Sbbz1cyPY;
	Thu, 24 Sep 2026 19:42:55 +0800 (CST)
Received: from whupemo200011.china.huawei.com (unknown [7.152.185.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 3BCDE4057A;
	Thu, 24 Sep 2026 19:53:58 +0800 (CST)
Received: from [10.174.178.46] (10.174.178.46) by
 whupemo200011.china.huawei.com (7.152.185.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Thu, 24 Sep 2026 19:53:57 +0800
Subject: Re: [PATCH v3 2/4] md: Handle pers->run failure in level_store
To: Bruce Johnston <bjohnsto@redhat.com>
CC: <linux-raid@vger.kernel.org>
References: <20260923112159.94175-1-chengzhihao1@huawei.com>
 <20260923112159.94175-3-chengzhihao1@huawei.com>
 <arQdkcalhtK5ySUz@vdo-obuilder-bjohnston.permabit.com>
From: Zhihao Cheng <chengzhihao1@huawei.com>
Message-ID: <8f71a698-d073-105e-ab19-2fc2a196faf0@huawei.com>
Date: Thu, 24 Sep 2026 19:53:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <arQdkcalhtK5ySUz@vdo-obuilder-bjohnston.permabit.com>
Content-Type: text/plain; charset="gbk"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 whupemo200011.china.huawei.com (7.152.185.179)

ÔÚ 2026/9/24 2:42, Bruce Johnston Ð´µÀ:
Hi Bruce,
> Hi. I've been looking into takeover for a little while as well. I was
> planning to write up something to post into the mailing list about it
> but say your submission and figured I would mention it here. I believe
> just handling a failure in pers->run is insufficient to fixing takeover
> errors.
> 
> IMO the contract for level_store should be that if something fails, we
> end up where we were before the function was called. So if we try to go
> from 1->5 and something fails, we are back at a working valid level 1.
Indeed, this is the most correct implementation for users, the 
level_store operation should be atomic, and my patch is just a simple 
workaround implementation.
> 
> The current level_store function roughly does the following:
> 1. Suspend & Validate: Suspends the mddev device and performs initial
>     validation checks.
> 2. Takeover: Invokes pers->takeover().
> 3. Swap Personality: Swaps the array to the new RAID personality.
> 4. Free Old State: Frees the old personality configuration and internal
>     information.
> 5. Update sysfs fields from old to new
> 6. Run Personality: Calls pers->run to initialize the new RAID
>     personality.
> 7. Resume Device: Resumes the mddev device.
> 
> By the time we get to run, we have swapped and free'd the old
> personality.
> 
> The code in md_run around pers->run cleanup is reasonable because if
> something fails, the array isn't started. You can't really do anything
> after that. But in takeover, on a failed run, we're now in a state where
> we have a half swapped personality. How do we recover from that? Are we
> just going to stop the array?
> 
> There are also additional issues in level_store where the personality
> functions like pers->takeover do things like remove unsupported flags
> from the mddev based on the new personality but never repair them on
> failures.
> 
> I've been investigating possible takeover failure solutions but none of
> them are easy. For example, we could try creating a new mddev at the
> start of level_store and using that for the pers->foo calls but there
> are a lot of shared resources so it becomes tricky.

Separating shared resources (eg. private, thread, bitmap, all_mddevs, 
etc.) is a trivial and error-prone task, and we need to have a clear 
understanding of the lifecycle of these shared resources.

> We could try
> something like an undo log (each change tell how to undo itself) but
> that would need to be passed into the personality functions or attached
> to the mddev.

The undo log solution will also bring significant changes, and 
maintaining the newly added level_store process in the future will be 
relatively difficult.

So far, I cannot find a more suitable solution.
> 
> Should we have a discussion on this issue? I feel like we have
> some holes here that need fixing.
> 
> On Wed, Sep 23, 2026 at 07:21:56PM +0800, Zhihao Cheng wrote:
>> Set 'raid_disks' after raid5_run() failure will trigger an
>> null-ptr-deref problem:
>>   BUG: kernel NULL pointer dereference, address: 0000000000000038
>>   RIP: 0010:raid5_check_reshape+0xad
>>   Call Trace:
>>    update_raid_disks+0x124
>>    raid_disks_store+0x145
>>    md_attr_store+0xd7
>>    sysfs_kf_write+0x7c
>>
>> The trigger process is simple:
>>   mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda /dev/sdb
>>   --force --assume-clean # create raid1
>>   echo 5 > /sys/block/md0/md/level
>>    level_store
>>     mddev->pers = pers
>>     mddev->private = priv
>>     raid5_run
>>      fail to abort (eg. raid5_create_ctx_pool fails)
>>      mddev->private = NULL
>>   echo 10 > /sys/block/md0/md/raid_disks
>>    raid_disks_store
>>     if (mddev->pers) // true
>>      update_raid_disks
>>       raid5_check_reshape
>>        conf = mddev->private
>>         conf->algorithm = mddev->new_layout // null-ptr-deref !
>>
>> Similar process exists in do_md_stop->__md_stop_writes->raid5_quiesce.
>> Similar process exists in raid10 too.
>>
>> Fix it by handling the error from pers->run, next active-type order will
>> restart the mddev.
>>
>> Fixes: 245f46c2c221e ("md: add ->takeover method to support changing the personality managing an array")
>> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
>> ---
>>   drivers/md/md.c | 29 ++++++++++++++++++++++++++++-
>>   1 file changed, 28 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 02798f2dbf0e..ff78bf8656ff 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -97,6 +97,7 @@ static struct workqueue_struct *md_misc_wq;
>>   static int remove_and_add_spares(struct mddev *mddev,
>>   				 struct md_rdev *this);
>>   static void mddev_detach(struct mddev *mddev);
>> +static void __md_stop(struct mddev *mddev);
>>   static void export_rdev(struct md_rdev *rdev);
>>   static void md_wakeup_thread_directly(struct md_thread __rcu **thread);
>>   
>> @@ -4243,7 +4244,33 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>>   		mddev->in_sync = 1;
>>   		timer_delete_sync(&mddev->safemode_timer);
>>   	}
>> -	pers->run(mddev);
>> +	rv = pers->run(mddev);
>> +	if (rv) {
>> +		/*
>> +		 * ->run() has released the private data of the new personality,
>> +		 * while the old one has already been released as well. There is
>> +		 * nothing to fall back to, so stop the array to avoid leaving
>> +		 * 'mddev->pers' pointing to a personality which has no private
>> +		 * data, and reminds user to try to active the mddev again.
>> +		 */
>> +		pr_warn("md: %s: failed to run %s after takeover, please try to active\n",
>> +			mdname(mddev), pers->head.name);
>> +		if (mddev->pers->sync_request && mddev->to_remove == NULL)
>> +			mddev->to_remove = &md_redundancy_group;
>> +		if (md_bitmap_enabled(mddev, true))
>> +			mddev->bitmap_ops->flush(mddev);
>> +		clear_bit(MD_SERIALIZE_POLICY, &mddev->flags);
>> +		mddev_destroy_serial_pool(mddev, NULL);
>> +		__md_stop(mddev);
>> +		rdev_for_each(rdev, mddev)
>> +			if (rdev->raid_disk >= 0)
>> +				sysfs_unlink_rdev(mddev, rdev);
>> +		set_capacity_and_notify(mddev->gendisk, 0);
>> +		mddev->changed = 1;
>> +		md_new_event();
>> +		sysfs_notify_dirent_safe(mddev->sysfs_state);
>> +		goto out_unlock;
>> +	}
>>   	set_bit(MD_SB_CHANGE_DEVS, &mddev->sb_flags);
>>   	if (!mddev->thread)
>>   		md_update_sb(mddev, 1);
>> -- 
>> 2.52.0
>>
>>
> 
> 
> .
> 

