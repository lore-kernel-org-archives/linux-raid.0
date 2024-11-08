Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F17FB8BEA;
	Fri,  8 Nov 2024 01:03:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731027814; cv=none; b=qxpN2gALu4v+u9NNIZA4O0lTxEXs0IHmLoraGN00i3NupJcWRZMECtdIiwHpKke3HDIvs4k1KTnXrkWR7fOf7pvX9dR3mi4r8w0M//3Yuk7YfEcoyRkpmUxGKybbPSlRf/Zx/IPjnOj+SDgYbEUfywqtajBEod/bTw7UdyXROO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731027814; c=relaxed/simple;
	bh=C8s5Zk0CHKy/1CLCU2x8zls0uB773wC98JA5fh843s0=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=TVagQWVkLrFTf9uYDkhyXKDc7hupku7VipGjFHXAqaTxtFUCAElAiQvKiklC1yntS4aSegJoP1YMxAUtUaHTb4KEt3OZjXUsHSZXFdGbul0yD7LxMwUYCoxRlw7mTzGXZ4sftKmnm7o1eN4X+ssA6uvKR0lp+IdrPskyN0QrIp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Xl0zx2BJ5z4f3jJ1;
	Fri,  8 Nov 2024 09:03:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 58BC91A0359;
	Fri,  8 Nov 2024 09:03:27 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBHI4ddYy1nni+jBA--.29522S3;
	Fri, 08 Nov 2024 09:03:27 +0800 (CST)
Subject: Re: [PATCH md-6.13] md: remove bitmap file support
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20241107125911.311347-1-yukuai1@huaweicloud.com>
 <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ef4dcb9e-a2fa-d9dc-70c1-e58af6e71227@huaweicloud.com>
Date: Fri, 8 Nov 2024 09:03:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7Ry0iUs6X7P4jL5CX3+8EGfb5uL=g-q_8jVR-g19ummQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHI4ddYy1nni+jBA--.29522S3
X-Coremail-Antispam: 1UD129KBjvdXoWrtF15GryrGF1xur13tr1xuFg_yoWxtrgE9w
	1vkr1xW3y7Jr9akFsxXrn0vrsrCw15JFWq9ayDJFyvqw18Xa4rtF40k392qr13JFZFvr93
	ury0qr48JFW3XjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUYCJmUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/08 7:41, Song Liu 写道:
> On Thu, Nov 7, 2024 at 5:02 AM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> The bitmap file has been marked as deprecated for more than a year now,
>> let's remove it, and we don't need to care about this case in the new
>> bitmap.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> 
> What happens when an old array with bitmap file boots into a kernel
> without bitmap file support?

If mdadm is used with bitmap file support, then kenel will just ignore
the bitmap, the same as none bitmap. Perhaps it's better to leave a
error message?

And if mdadm is updated, reassemble will fail.

Thanks,
Kuai

> 
> Thanks,
> Song
> .
> 

