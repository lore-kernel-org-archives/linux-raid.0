Received: from mail.synology.com (mail.synology.com [211.23.38.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDBBA2B9B7;
	Tue, 30 Dec 2025 04:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.23.38.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767067694; cv=none; b=IBAdfUEIqgq7GyEERweZI5cuyrqYEJXCBtJWebf7tWRpRFI86jV0o9m602KN22FckOKOJqRZJDc8BmIux3YltpMue7v1EkiWx5Aq2Pdmxsl5u+KnoeTEl8jm9mw2OnDrqwnKSl9NZ3h2cBm8VxowgSdHZUtuYg6ksvwY2ByEspc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767067694; c=relaxed/simple;
	bh=lpF/zLmh8it0qhcCXxyicFNnHEvhEw4WSJDImuIumGw=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=S667d46S3nicX76w7HUqFzlscWj1YQ0TL2DLemR0lyuc3mWNoocwIGXad2jU+VFPOhNnsNhW5tF3IBGf5fBjf6Ac8RB3t+HbWcbkOBkUNpIGWjkxrBDL2FBAB2UIX0H7Zt+CaJS5sSc07K1CrAcxgLXuj45hgEHR+Aa8lyj7TI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com; spf=pass smtp.mailfrom=synology.com; dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b=mJnzdTg7; arc=none smtp.client-ip=211.23.38.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=synology.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=synology.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=synology.com header.i=@synology.com header.b="mJnzdTg7"
Received: from [10.17.40.225] (unknown [10.17.40.225])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.synology.com (Postfix) with ESMTPSA id 4dgKLq658KzFglk8F;
	Tue, 30 Dec 2025 12:08:03 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synology.com; s=123;
	t=1767067684; bh=lpF/zLmh8it0qhcCXxyicFNnHEvhEw4WSJDImuIumGw=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To;
	b=mJnzdTg7awrhZpW4gglVpqkyp5uuNehuBQjLBZhf0Zh+wM9RJzfWihvzk9+CUgC/1
	 l2NOEfXu9Hdq+3j9J17UJ+s0SwQHdsF4gRYKj2kxAESpV78M1vlZoOm4mTZiYBHgNg
	 sy/9atk0GJksTLQ9FRKWiGljtz+Z2X9Ci+RAN11c=
Message-ID: <589ae017-741f-4cc6-a069-13588a516465@synology.com>
Date: Tue, 30 Dec 2025 12:07:34 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: FengWei Shih <dannyshih@synology.com>
Subject: Re: [PATCH v2] md: suspend array while updating raid_disks via sysfs
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20251226101816.4506-1-dannyshih@synology.com>
 <CALTww29RPghH2+x9HwtDjCAXZfgK8gBkisXNKy0k8g9d5hiV_Q@mail.gmail.com>
Content-Language: en-US
In-Reply-To: <CALTww29RPghH2+x9HwtDjCAXZfgK8gBkisXNKy0k8g9d5hiV_Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Synology-MCP-Status: no
X-Synology-Spam-Status: score=0, required 6, WHITELIST_FROM_ADDRESS 0
X-Synology-Spam-Flag: no
X-Synology-Virus-Status: no

Hi Xiao

Xiao Ni 於 2025/12/29 下午 05:19 寫道:
> Hi FengWei and Kuai
>
> On Fri, Dec 26, 2025 at 6:27 PM dannyshih<dannyshih@synology.com> wrote:
>> From: FengWei Shih<dannyshih@synology.com>
>>
>> In raid1_reshape(), freeze_array() is called before modifying the r1bio
>> memory pool (conf->r1bio_pool) and conf->raid_disks, and
>> unfreeze_array() is called after the update is completed.
>>
>> However, freeze_array() only waits until nr_sync_pending and
>> (nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
>> occurs, nr_queued is increased and the corresponding r1bio is queued to
>> either retry_list or bio_end_io_list. As a result, freeze_array() may
>> unblock before these r1bios are released.
> Could you explain more about this? Why can't freeze_array block when
> io error occurs? If io error occurs, the nr_pending number should be
> equal with nr_queued, right?
>
> Best Regards
> Xiao

Even though nr_pending == nr_queued, the r1bio is still alive and was
allocated under the old raid_disks value. Allowing freeze_array()
to unblock at this point permits an in-flight r1bio to span across the
reshape.

Assuming raid_disks is changed from 2 to 3, the sequence is roughly:

   normal I/O                        raid1 reshape

   nr_pending++

   r1bio allocated
   (raid_disks == 2)

   /* submit I/O */
                                 echo 3 > /sys/block/mdX/md/raid_disks
                                   raid1_reshape() -> freeze_array()
                                  (waiting for nr_pending == nr_queued)

   I/O error occurs and triggers
   reschedule_retry()
   r1bio queued to retry_list
   nr_queued++       ------------>  freeze_array() unblocks
                                    conf->r1bio_pool is changed
                                    conf->raid_disks is changed
                                    unfreeze_array()

   /* r1bio retry handling */
   free r1bio
   (conf->raid_disks == 3)

Therefore, freeze_array() cannot guarantee that all r1bios allocated
under the old array layout have been fully processed and freed.

Thanks,
FengWei Shih

>> This can lead to a situation where conf->raid_disks and the mempool have
>> already been updated while queued r1bios, allocated with the old
>> raid_disks value, are later released. Consequently, free_r1bio() may
>> access memory out of bounds in put_all_bios() and release r1bios of the
>> wrong size to the new mempool, potentially causing issues with the
>> mempool as well.
>>
>> Since only normal I/O might increase nr_queued while an I/O error occurs,
>> suspending the array avoids this issue.
>>
>> Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
>> the array. Therefore, we suspend the array when updating raid_disks
>> via sysfs to avoid this issue too.
>>
>> Signed-off-by: FengWei Shih<dannyshih@synology.com>
>> ---
>> v2:
>>    * Suspend array unconditionally when updating raid_disks
>>    * Refine commit message to describe the issue more concretely
>> ---
>>   drivers/md/md.c | 4 ++--
>>   1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index e5922a682953..6bcbe1c7483c 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -4407,7 +4407,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
>>          if (err < 0)
>>                  return err;
>>
>> -       err = mddev_lock(mddev);
>> +       err = mddev_suspend_and_lock(mddev);
>>          if (err)
>>                  return err;
>>          if (mddev->pers)
>> @@ -4432,7 +4432,7 @@ raid_disks_store(struct mddev *mddev, const char *buf, size_t len)
>>          } else
>>                  mddev->raid_disks = n;
>>   out_unlock:
>> -       mddev_unlock(mddev);
>> +       mddev_unlock_and_resume(mddev);
>>          return err ? err : len;
>>   }
>>   static struct md_sysfs_entry md_raid_disks =
>> --
>> 2.17.1
>>
>>
>> Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
>>


Disclaimer: The contents of this e-mail message and any attachments are confidential and are intended solely for addressee. The information may also be legally privileged. This transmission is sent in trust, for the sole purpose of delivery to the intended recipient. If you have received this transmission in error, any use, reproduction or dissemination of this transmission is strictly prohibited. If you are not the intended recipient, please immediately notify the sender by reply e-mail or phone and delete this message and its attachments, if any.
