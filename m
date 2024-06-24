Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1CF0442C
	for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 02:37:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719196674; cv=none; b=GOl4/q5w4q3aeCMQXGKG1hauQJz1p/bOlgVQbHo4ZK7+jQmZnkciyKhQIAwKEQBGlryZnkbbyHoyMQhRrWlIdHSl+hP+fS0K4CfFchs7obGGRcWPCQ7mO8+UpX0zIHSr4QfoLzHEze1sLKv8HH0XBdtuE3gO67c5xAu5IwW93QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719196674; c=relaxed/simple;
	bh=C7/BDcWEcf+0hwVa107PsRywqez7mQnVbmBxaerLdEE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=n+DYxOcI7Iu3A5SrA38OLedraRdPdUFh2OZ2/wxQtCwLq9Ki5Oc1ewRuuxttjVu6DseSeg0mjdtrMywSWqRmcDeDV/FLy/XcPTN15pYchTtHkGwajVxQQnUncNf5KLkEPWJSJzCfByIgn6WaDVNWQO4HpwK64nQSzWjF/yGS7Fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W6sZ24y20z4f3kvF
	for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 10:37:30 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id B6B8D1A016E
	for <linux-raid@vger.kernel.org>; Mon, 24 Jun 2024 10:37:42 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgCXAIby23hmEjWvAA--.19997S3;
	Mon, 24 Jun 2024 10:37:40 +0800 (CST)
Subject: Re: [PATCH 1/2] md-cluster: fix hanging issue while a new disk adding
To: Heming Zhao <heming.zhao@suse.com>, song@kernel.org,
 yukuai1@huaweicloud.com, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org, colyli@suse.de,
 "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <683d0326-c67b-4273-b19c-8cb39b28e736@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <864cf5a9-cdc6-4968-8fba-2e93a221f8de@huaweicloud.com>
Date: Mon, 24 Jun 2024 10:37:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <683d0326-c67b-4273-b19c-8cb39b28e736@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCXAIby23hmEjWvAA--.19997S3
X-Coremail-Antispam: 1UD129KBjvJXoW3JF4xuF13Jr1fXw1UJFWkWFg_yoW7Zw43pF
	1vq3s8JrW5Wr4kGr17GryDZFyrGw18t3WDJw18J3W7Ar4Dtr10qF4UXrn09F1UGr4xJr1D
	tr1UWrsxuwnrJr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/06/24 9:55, Heming Zhao 写道:
> Hello Song & Kuai,
> 
> Xiao ni told me that he has been quite busy recently and cannot review
> the code. Do you have time to review my code?
> 
> btw,
> The patches has been passed the 60 loops of clustermd_tests [1]. because
> the kernel md layer code changes, the clustermd_tests scripts also need
> to be updated. I will send the clustermd_tests patch when the kernel
> layer code passes review.

The tests will be quite important, since I'm not familiar with cluster
code here. Of coure I'll find sometime to review the code.

Thanks,
Kuai

> 
> [1]: 
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/clustermd_tests
> 
> Thanks,
> Heming
> 
> On 6/12/24 10:19, Heming Zhao wrote:
>> The commit 1bbe254e4336 ("md-cluster: check for timeout while a
>> new disk adding") is correct in terms of code syntax but not
>> suite real clustered code logic.
>>
>> When a timeout occurs while adding a new disk, if recv_daemon()
>> bypasses the unlock for ack_lockres:CR, another node will be waiting
>> to grab EX lock. This will cause the cluster to hang indefinitely.
>>
>> How to fix:
>>
>> 1. In dlm_lock_sync(), change the wait behaviour from forever to a
>>     timeout, This could avoid the hanging issue when another node
>>     fails to handle cluster msg. Another result of this change is
>>     that if another node receives an unknown msg (e.g. a new msg_type),
>>     the old code will hang, whereas the new code will timeout and fail.
>>     This could help cluster_md handle new msg_type from different
>>     nodes with different kernel/module versions (e.g. The user only
>>     updates one leg's kernel and monitors the stability of the new
>>     kernel).
>> 2. The old code for __sendmsg() always returns 0 (success) under the
>>     design (must successfully unlock ->message_lockres). This commit
>>     makes this function return an error number when an error occurs.
>>
>> Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk 
>> adding")
>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>> Reviewed-by: Su Yue <glass.su@suse.com>
>> ---
>>   drivers/md/md-cluster.c | 14 ++++++++++++--
>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>> index 8e36a0feec09..27eaaf9fef94 100644
>> --- a/drivers/md/md-cluster.c
>> +++ b/drivers/md/md-cluster.c
>> @@ -130,8 +130,13 @@ static int dlm_lock_sync(struct dlm_lock_resource 
>> *res, int mode)
>>               0, sync_ast, res, res->bast);
>>       if (ret)
>>           return ret;
>> -    wait_event(res->sync_locking, res->sync_locking_done);
>> +    ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
>> +                60 * HZ);
>>       res->sync_locking_done = false;
>> +    if (!ret) {
>> +        pr_err("locking DLM '%s' timeout!\n", res->name);
>> +        return -EBUSY;
>> +    }
>>       if (res->lksb.sb_status == 0)
>>           res->mode = mode;
>>       return res->lksb.sb_status;
>> @@ -744,12 +749,14 @@ static void unlock_comm(struct md_cluster_info 
>> *cinfo)
>>   static int __sendmsg(struct md_cluster_info *cinfo, struct 
>> cluster_msg *cmsg)
>>   {
>>       int error;
>> +    int ret = 0;
>>       int slot = cinfo->slot_number - 1;
>>       cmsg->slot = cpu_to_le32(slot);
>>       /*get EX on Message*/
>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>>       if (error) {
>> +        ret = error;
>>           pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", 
>> error);
>>           goto failed_message;
>>       }
>> @@ -759,6 +766,7 @@ static int __sendmsg(struct md_cluster_info 
>> *cinfo, struct cluster_msg *cmsg)
>>       /*down-convert EX to CW on Message*/
>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
>>       if (error) {
>> +        ret = error;
>>           pr_err("md-cluster: failed to convert EX to CW on 
>> MESSAGE(%d)\n",
>>                   error);
>>           goto failed_ack;
>> @@ -767,6 +775,7 @@ static int __sendmsg(struct md_cluster_info 
>> *cinfo, struct cluster_msg *cmsg)
>>       /*up-convert CR to EX on Ack*/
>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
>>       if (error) {
>> +        ret = error;
>>           pr_err("md-cluster: failed to convert CR to EX on ACK(%d)\n",
>>                   error);
>>           goto failed_ack;
>> @@ -775,6 +784,7 @@ static int __sendmsg(struct md_cluster_info 
>> *cinfo, struct cluster_msg *cmsg)
>>       /*down-convert EX to CR on Ack*/
>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
>>       if (error) {
>> +        ret = error;
>>           pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
>>                   error);
>>           goto failed_ack;
>> @@ -789,7 +799,7 @@ static int __sendmsg(struct md_cluster_info 
>> *cinfo, struct cluster_msg *cmsg)
>>           goto failed_ack;
>>       }
>>   failed_message:
>> -    return error;
>> +    return ret;
>>   }
>>   static int sendmsg(struct md_cluster_info *cinfo, struct cluster_msg 
>> *cmsg,
> 
> 
> .
> 

