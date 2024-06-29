Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 583861859
	for <linux-raid@vger.kernel.org>; Sat, 29 Jun 2024 01:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719625387; cv=none; b=AR4mcHpB4fHwopdho+Qv8A/D4AgPHpN1PQRv3kk86dHM5w5uS8pJfFBtbUJm0kCh8iJqUgLEBOmQIXOFvwmru5L6SlQp+B6qB4NSfqM/s2QlsICOIXzmhI5/NTxoxBkhX33kt9KG5qGRnRMJvUPPcNW7uIkQP4qFYiJNr+vZMXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719625387; c=relaxed/simple;
	bh=z9RkYh39CPa695gjYA1dNbSuRKvdCJnhsOaXXtPwRvs=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=UrVP7KHAO1lbs/zjte2ghGmijQVOnq4d2jnU3Y2bonWuDIzkZDf5YvxuJcodFFJ+wwBTYKFrr1nG0giBCG7BVK1tuoC+Mg5tzYBSAxb2HsREQFvnmygH+5Yn3XJeGhSq+16RQ/xCNsY2VP62ygGmAeLWD4cxrztMcUtEUC2df48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4W9w6k0qKcz4f3jLV
	for <linux-raid@vger.kernel.org>; Sat, 29 Jun 2024 09:42:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.75])
	by mail.maildlp.com (Postfix) with ESMTP id 4E6791A0572
	for <linux-raid@vger.kernel.org>; Sat, 29 Jun 2024 09:43:01 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP2 (Coremail) with SMTP id Syh0CgCXAIajZn9mjICNAg--.22294S3;
	Sat, 29 Jun 2024 09:43:01 +0800 (CST)
Subject: Re: [PATCH 1/2] md-cluster: fix hanging issue while a new disk adding
To: Heming Zhao <heming.zhao@suse.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 song@kernel.org, xni@redhat.com
Cc: glass.su@suse.com, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240612021911.11043-1-heming.zhao@suse.com>
 <35996c3b-fe02-f745-676b-202505763306@huaweicloud.com>
 <02e5b14e-aa94-430f-8e6f-f918f79a5cfb@suse.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <72588c14-cfd0-e927-50e2-00519a9b77e0@huaweicloud.com>
Date: Sat, 29 Jun 2024 09:42:59 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <02e5b14e-aa94-430f-8e6f-f918f79a5cfb@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:Syh0CgCXAIajZn9mjICNAg--.22294S3
X-Coremail-Antispam: 1UD129KBjvJXoWxKrWfAr45JFyfCw47WrW5GFg_yoW3XrW5pF
	1vqas8JrW5Gr4kGr17GFWDZryrGw1UK3WDJw18Ja1xJF4Dtr10gF4UXrn09F15Gr4xJw1q
	qr15GFsxuwnxJr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14
	v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkG
	c2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI
	0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_
	Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjfUoOJ5UU
	UUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/06/28 20:32, Heming Zhao 写道:
> On 6/27/24 20:52, Yu Kuai wrote:
>> Hi,
>>
>> 在 2024/06/12 10:19, Heming Zhao 写道:
>>> The commit 1bbe254e4336 ("md-cluster: check for timeout while a
>>> new disk adding") is correct in terms of code syntax but not
>>> suite real clustered code logic.
>>>
>>> When a timeout occurs while adding a new disk, if recv_daemon()
>>> bypasses the unlock for ack_lockres:CR, another node will be waiting
>>> to grab EX lock. This will cause the cluster to hang indefinitely.
>>>
>>> How to fix:
>>>
>>> 1. In dlm_lock_sync(), change the wait behaviour from forever to a
>>>     timeout, This could avoid the hanging issue when another node
>>>     fails to handle cluster msg. Another result of this change is
>>>     that if another node receives an unknown msg (e.g. a new msg_type),
>>>     the old code will hang, whereas the new code will timeout and fail.
>>>     This could help cluster_md handle new msg_type from different
>>>     nodes with different kernel/module versions (e.g. The user only
>>>     updates one leg's kernel and monitors the stability of the new
>>>     kernel).
>>> 2. The old code for __sendmsg() always returns 0 (success) under the
>>>     design (must successfully unlock ->message_lockres). This commit
>>>     makes this function return an error number when an error occurs.
>>>
>>> Fixes: 1bbe254e4336 ("md-cluster: check for timeout while a new disk 
>>> adding")
>>> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
>>> Reviewed-by: Su Yue <glass.su@suse.com>
>>> ---
>>>   drivers/md/md-cluster.c | 14 ++++++++++++--
>>>   1 file changed, 12 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
>>> index 8e36a0feec09..27eaaf9fef94 100644
>>> --- a/drivers/md/md-cluster.c
>>> +++ b/drivers/md/md-cluster.c
>>> @@ -130,8 +130,13 @@ static int dlm_lock_sync(struct 
>>> dlm_lock_resource *res, int mode)
>>>               0, sync_ast, res, res->bast);
>>>       if (ret)
>>>           return ret;
>>> -    wait_event(res->sync_locking, res->sync_locking_done);
>>> +    ret = wait_event_timeout(res->sync_locking, res->sync_locking_done,
>>> +                60 * HZ);
>>
>> Let's not use magic number directly, it's better to define a marco. BTW,
>> 60s looks too long for me.
> 
> got it, will create a define:
> #define WAIT_DLM_LOCK_TIMEOUT 30 * HZ
> 
> In my view, the shortest time should be 30s. because there is a 
> clustered env.
> Node A is waiting for node B to release the lock.
> We should consider:
> - network traffic (node A and B are not in the same build)
> - another node's udev event handling time: NEW_DEV_TIMEOUT 5000
> 
>>>       res->sync_locking_done = false;
>>
>> And I tried to find, if setting this value on failure is ok. However,
>> I'm lost and I really don't know. Can you explain this?
> 
> This code logic is the same as dlm_lock_sync_interruptible(). We can
> see that regardless of success or failure, '->sync_locking_done' is
> set to false in dlm_lock_sync_interruptible().
> 
>>> +    if (!ret) {
>>> +        pr_err("locking DLM '%s' timeout!\n", res->name);
>>> +        return -EBUSY;
>>> +    }
>>>       if (res->lksb.sb_status == 0)
>>>           res->mode = mode;
>>>       return res->lksb.sb_status;
>>> @@ -744,12 +749,14 @@ static void unlock_comm(struct md_cluster_info 
>>> *cinfo)
>>>   static int __sendmsg(struct md_cluster_info *cinfo, struct 
>>> cluster_msg *cmsg)
>>>   {
>>>       int error;
>>> +    int ret = 0;
>>>       int slot = cinfo->slot_number - 1;
>>>       cmsg->slot = cpu_to_le32(slot);
>>>       /*get EX on Message*/
>>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_EX);
>>>       if (error) {
>>> +        ret = error;
>>
>> You can return error directly in this branch.
> 
> OK
> 
>>>           pr_err("md-cluster: failed to get EX on MESSAGE (%d)\n", 
>>> error);
>>>           goto failed_message;
>>>       }
>>> @@ -759,6 +766,7 @@ static int __sendmsg(struct md_cluster_info 
>>> *cinfo, struct cluster_msg *cmsg)
>>>       /*down-convert EX to CW on Message*/
>>>       error = dlm_lock_sync(cinfo->message_lockres, DLM_LOCK_CW);
>>>       if (error) {
>>> +        ret = error;
>>>           pr_err("md-cluster: failed to convert EX to CW on 
>>> MESSAGE(%d)\n",
>>>                   error);
>>>           goto failed_ack;
>>> @@ -767,6 +775,7 @@ static int __sendmsg(struct md_cluster_info 
>>> *cinfo, struct cluster_msg *cmsg)
>>>       /*up-convert CR to EX on Ack*/
>>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_EX);
>>>       if (error) {
>>> +        ret = error;
>>>           pr_err("md-cluster: failed to convert CR to EX on ACK(%d)\n",
>>>                   error);
>>>           goto failed_ack;
>>> @@ -775,6 +784,7 @@ static int __sendmsg(struct md_cluster_info 
>>> *cinfo, struct cluster_msg *cmsg)
>>>       /*down-convert EX to CR on Ack*/
>>>       error = dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
>>>       if (error) {
>>> +        ret = error;
>>>           pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
>>>                   error);
>>>           goto failed_ack;
>>> @@ -789,7 +799,7 @@ static int __sendmsg(struct md_cluster_info 
>>> *cinfo, struct cluster_msg *cmsg)
>>>           goto failed_ack;
>>>       }
>>>   failed_message:
>>> -    return error;
>>> +    return ret;
>>
>> And I'll suggest just to change dlm_unlock_sync(), not to change all the
>> other places.
>>
> 
> I have a different viewpoint, the clustermd code has been running for 
> about 10
> years, and no bugs have been reported from SUSE customers for about 1 
> year. I am
> inclined to keep the current code style. If we change dlm_unlock_sync(), 
> many
> places will need to be rewritten, which may introduce new bugs. From the 
> callers
> of this func (__sendmsg()), which handle the return value, we know it's
> definitely wrong because the return value of __sendmsg() is always true.

That's not what I mean... Let me show you the code:

diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index eb9bbf12c8d8..11a3c9960a22 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -744,6 +744,7 @@ static void unlock_comm(struct md_cluster_info *cinfo)
  static int __sendmsg(struct md_cluster_info *cinfo, struct cluster_msg 
*cmsg)
  {
         int error;
+       int unlock_error;
         int slot = cinfo->slot_number - 1;

         cmsg->slot = cpu_to_le32(slot);
@@ -781,13 +782,9 @@ static int __sendmsg(struct md_cluster_info *cinfo, 
struct cluster_msg *cmsg)
         }

  failed_ack:
-       error = dlm_unlock_sync(cinfo->message_lockres);
-       if (unlikely(error != 0)) {
+       while ((unlock_error = dlm_unlock_sync(cinfo->message_lockres)))
                 pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
-                       error);
-               /* in case the message can't be released due to some 
reason */
-               goto failed_ack;
-       }
+                       unlock_error);
  failed_message:
         return error;

Thanks,
Kuai

> 
> -Heming
> .
> 

