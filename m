Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E81110E0;
	Fri, 26 Sep 2025 07:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758871367; cv=none; b=QrWmBjTet2qEjGlrszZXN7k9rD+kfXfW1Fd+7SXp0Oe3W8GGqWxXi/e51MF7aaQnbDUf3MsAhDsg7CKybZvzLmFEw6ltvPh8oPXb5wAMKq3CNXn+lNOKpC7XIXL/UGm1QH94L55NVrAHjIHTdSafwvFgQs3VF8O0NMGugZEAV+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758871367; c=relaxed/simple;
	bh=wBcIScioeZKWPEcwR7sa6j0NWha6SykklKRPHiuXfmg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ctllrxrzfLJEf27yeMEUBntlCn7iJnMdospI4XDEXo7ymk9RPHDOtMvmtz0V7tvlY87uXAOjIMR9VN1uLQgd4YhXYZgqwkLCZELbUOPaA3XdmkIW9YQdgNORUTvNTx2K3XQr96s0tLiTo50Fkj9O32AqJ/AyLFUd2NfyC48bwnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cY2950PsDzKHM0X;
	Fri, 26 Sep 2025 15:22:33 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4FB951A0D4C;
	Fri, 26 Sep 2025 15:22:42 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgAn6mFAP9Zou7RzAw--.30216S3;
	Fri, 26 Sep 2025 15:22:42 +0800 (CST)
Message-ID: <4ae18bbf-3301-ac40-b422-629cefdd7b12@huaweicloud.com>
Date: Fri, 26 Sep 2025 15:22:40 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v5 2/2] md: allow configuring logical block size
To: Li Nan <linan666@huaweicloud.com>, Xiao Ni <xni@redhat.com>
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, martin.petersen@oracle.com,
 yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250918115759.334067-1-linan666@huaweicloud.com>
 <20250918115759.334067-3-linan666@huaweicloud.com>
 <CALTww2_4rEb9SojpVbwFy=ZEjUc0-4ECYZKYKgsay9XzDTs-cg@mail.gmail.com>
 <b7fc02d2-7643-4bf1-1b15-c1ecdf883c87@huaweicloud.com>
 <CALTww2_knuDVWLtVzrqcuLH5dmiyMqkAaZr2DB_ZpCYPQsYH0A@mail.gmail.com>
 <6b6acb6c-7ad8-ae71-b56a-9129d4bb4bd6@huaweicloud.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <6b6acb6c-7ad8-ae71-b56a-9129d4bb4bd6@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAn6mFAP9Zou7RzAw--.30216S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tF4rZrWrCw4fXFWfXw1rtFb_yoW8Xw1DpF
	48tF45KryUJr10yws2gr1UCa45tr47tw1DXr9xJFy7Jryqvr12qF1UWFWqgFyUJrZ5XF1U
	Zr4YqwnxZryS9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUP214x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC
	0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr
	1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIF
	xwACI402YVCY1x02628vn2kIc2xKxwCYjI0SjxkI62AI1cAE67vIY487MxkF7I0En4kS14
	v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8C
	rVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8Zw
	CIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x02
	67AKxVW8JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbQV
	y7UUUUU==
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2025/9/25 16:34, Li Nan 写道:
> 
> 
> 在 2025/9/23 22:06, Xiao Ni 写道:
>> On Tue, Sep 23, 2025 at 9:37 PM Li Nan <linan666@huaweicloud.com> wrote:
>>>
>>>
>>>
>>> 在 2025/9/23 19:36, Xiao Ni 写道:
>>>> Hi Li Nan
>>>>
>>>> On Thu, Sep 18, 2025 at 8:08 PM <linan666@huaweicloud.com> wrote:
>>>>>
>>>>> From: Li Nan <linan122@huawei.com>
>>>>>
>>>>> Previously, raid array used the maximum logical block size (LBS)
>>>>> of all member disks. Adding a larger LBS disk at runtime could
>>>>> unexpectedly increase RAID's LBS, risking corruption of existing
>>>>> partitions. This can be reproduced by:

[...]

>>>>> +static ssize_t
>>>>> +lbs_store(struct mddev *mddev, const char *buf, size_t len)
>>>>> +{
>>>>> +       unsigned int lbs;
>>>>> +       int err = -EBUSY;
>>>>> +
>>>>> +       /* Only 1.x meta supports configurable LBS */
>>>>> +       if (mddev->major_version == 0)
>>>>> +               return -EINVAL;
>>>>
>>>> It looks like it should check raid level here as doc mentioned above, 
>>>> right?
>>>
>>> Yeah, kuai suggests supporting this feature only in 1.x meta.
>>
>> I mean it should check if raid is raid0 here, right? As doc mentioned,
>> it should return error if raid is level 0.
>>
>> Regards
>> Xiao
> 
> Apologies — I misunderstood. I will add check in v6.
> 

I found that md_logical_block_size.attr is added to md_redundancy_attrs and
is is only created when pers->sync_request is present. Raid0 will not
create it. So the check is unnecessary.

-- 
Thanks,
Nan

