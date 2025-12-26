Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E8A824BD;
	Fri, 26 Dec 2025 04:54:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766724848; cv=none; b=PCDrtOYE8Od6CRXT3GlRvZLUX0HQnSGo2C7ztFLw/z6mgXnyC7OzROHrtnn2wIgfD3Iw9fP68tcuvrHs220JtYiew082HkuZCPWg+YpWHZLWfNBF2JqANRSVT9uSRdUsL9y8oPVNo3C7BNzg4mq3RX7bVg+paxGpPfoXc8deiw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766724848; c=relaxed/simple;
	bh=ciP0YFd1L1wkjo384DNDxr+XOJPkhl3WVvdeG3amnDw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=AiOJ9Q4DdEoSp0eL+9hy2Yc+G2/yf1A5oYk+/b+gVOZVw2PrcnrW4N9bslwwlHm1wX2PeX68prdbgUBhmOHhen3qgoT9E7H9/HWa/krs/X+g4hn0GtHmUupouUc58e3mVh1al8LEli2zVHHDCIn9mMfbIbnaKNRmZsd5bISgANE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=WxNiGNBL; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="WxNiGNBL"
Received: from [10.17.40.225] (unknown [10.17.40.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4dctNR5GNrzFcjpvJ;
	Fri, 26 Dec 2025 12:45:59 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1766724359; bh=ciP0YFd1L1wkjo384DNDxr+XOJPkhl3WVvdeG3amnDw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=WxNiGNBLG7gKTsbgHeOfwj4onzzoshthY1ZtJJmK36WZNdI3S4Z/hnMqPp1bWkZLz
	 siI9nFvywJa+OEHx55Uj8ujg6Pd7Ws754BH2NAN2Gqh39k68AfZt9TBKknnCmDsn2Q
	 3tJ05ZV18t1DptwNyFGnwqsNbNLN6aPvOYkPwql8=
Message-ID: <c8b654a5-6b50-4348-8f33-6c82c8c52bc8@synology.com>
Date: Fri, 26 Dec 2025 12:45:58 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: FengWei Shih <dannyshih@synology.com>
Subject: Re: [PATCH] md: suspend array while updating raid1 raid_disks via
 sysfs
To: yukuai@fnnas.com, song@kernel.org
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20251218090656.10278-1-dannyshih@synology.com>
 <75dd6e7d-383e-44c0-978a-42c286a3d9c3@fnnas.com>
Content-Language: en-US
In-Reply-To: <75dd6e7d-383e-44c0-978a-42c286a3d9c3@fnnas.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no

Hi Kual,

Yu Kuai 於 2025/12/25 下午 04:19 寫道:
> Hi,
>
> 在 2025/12/18 17:06, dannyshih 写道:
>> From: FengWei Shih <dannyshih@synology.com>
>>
>> When an I/O error occurs, the corresponding r1bio might be queued during
>> raid1_reshape() and not released. Leads to r1bio release with wrong
>> raid_disks.
> Please be more specific about the problem, mempool_destroy() will warn about
> object still in use, and free r1bio with updated conf->raid_disks will cause
> problem like memory oob.

In raid1_reshape(), freeze_array() is called before modifying the r1bio
memory pool (conf->r1bio_pool) and conf->raid_disks, and
unfreeze_array() is called after the update is completed.

However, freeze_array() only waits until nr_sync_pending and
(nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
occurs, nr_queued is increased and the corresponding r1bio is queued to
either retry_list or bio_end_io_list. As a result, freeze_array() may
unblock before these r1bios are released.

This can lead to a situation where conf->raid_disks and the mempool have
already been updated while queued r1bios, allocated with the old
raid_disks value, are later released. Consequently, free_r1bio() may
access memory out of bounds in put_all_bios() and release r1bios of the
wrong size to the new mempool, potentially causing issues with the
mempool as well.

>> * raid1_reshape() calls freeze_array(), which only waits for r1bios be
>>     queued or released.
>>
>> Since only normal I/O might be queued while an I/O error occurs, suspending
>> the array avoids this issue.
>>
>> Signed-off-by: FengWei Shih <dannyshih@synology.com>
>> ---
>>    drivers/md/md.c | 5 +++--
>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index e5922a682953..6424652bce6e 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4402,12 +4402,13 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
>>    {
>>    	unsigned int n;
>>    	int err;
>> +	bool need_suspend = (mddev->pers && mddev->level == 1);
> Perhaps just suspend the array unconditionally, this will make sense.
>
>>    
>>    	err = kstrtouint(buf, 10, &n);
>>    	if (err < 0)
>>    		return err;
>>    
>> -	err = mddev_lock(mddev);
>> +	err = need_suspend ? mddev_suspend_and_lock(mddev) : mddev_lock(mddev);
>>    	if (err)
>>    		return err;
>>    	if (mddev->pers)
>> @@ -4432,7 +4433,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
>>    	} else
>>    		mddev->raid_disks = n;
>>    out_unlock:
>> -	mddev_unlock(mddev);
>> +	need_suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
>>    	return err ? err : len;
>>    }
>>    static struct md_sysfs_entry md_raid_disks =

Thank you for your suggestions. I will update the commit based on your
feedback and prepare the V2 patch for submission.

FengWei Shih

Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
