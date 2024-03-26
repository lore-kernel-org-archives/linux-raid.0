Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527FE136E0A
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 14:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711462169; cv=none; b=X35K4yMFlxQJkI0R4ALd7NziAcGyASGv9KJcWvYIZE9KQwEC90UcTm1pM3kUs7mACYCBfksPlkx/SIviM412Cb29jjgIui9Oc3sxUvADtYq46ae/GhnFt4Gg/9YbnNMcQ+qjX9+IHhFL29TrF793VkxqtB4Qj8et2B077YPf8kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711462169; c=relaxed/simple;
	bh=owZtzOUWfUHpDIMu437S8Bpv2Hry/70pZMA9bYz/UOI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=r6W+f+B5mlSXfvWRa/VoYxzx4eEepPm8PsSrd3tajja0fdVGbk4FwGkhZct8SeEkSNVuNEHVqDJrH/r23+f6+eVZX3XNWofbJQmynM3jJQ+K0YsmjTkKxYzp/BiYkJPWJiGEXSwGvJcUrWn6maxs/tNBrqvIubzOHZWxl6lZJ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4V3s9l2jcYz4f3mHN
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 22:09:15 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 7C83C1A0172
	for <linux-raid@vger.kernel.org>; Tue, 26 Mar 2024 22:09:23 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxAS1wJmPfSTIA--.45477S3;
	Tue, 26 Mar 2024 22:09:23 +0800 (CST)
Subject: Re: [PATCHv3] md: Replace md_thread's wait queue with the swait
 variant
To: Jinpu Wang <jinpu.wang@ionos.com>, song@kernel.org,
 linux-raid@vger.kernel.org
Cc: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>,
 Paul Menzel <pmenzel@molgen.mpg.de>, "yukuai (C)" <yukuai3@huawei.com>
References: <20240307120835.87390-1-jinpu.wang@ionos.com>
 <CAMGffEm8hhg=C1BayDxRhGSTT2b0DBzopr3RWB7aM+XG3yTYNg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <551949c9-c6ff-1ae6-fa05-660f1bd76249@huaweicloud.com>
Date: Tue, 26 Mar 2024 22:09:22 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAMGffEm8hhg=C1BayDxRhGSTT2b0DBzopr3RWB7aM+XG3yTYNg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxAS1wJmPfSTIA--.45477S3
X-Coremail-Antispam: 1UD129KBjvJXoWruFWrGFW7Ar4rury8JrW7XFb_yoW8JrWUpF
	W5KF90yrWkArn0yan2yan7X34UCr4fWr13GFyUWryUJr15X3s0gryxKry5Cas0krn7Gw4j
	va1qga1fAa1Iy37anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
	6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUOyCJDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/03/26 13:22, Jinpu Wang 写道:
> Hi Song, hi Kuai,
> 
> ping, Any comments?
> 
> Thx!
> 
> On Thu, Mar 7, 2024 at 1:08 PM Jack Wang <jinpu.wang@ionos.com> wrote:
>>
>> From: Florian-Ewald Mueller <florian-ewald.mueller@ionos.com>
>>
>> Replace md_thread's wait_event()/wake_up() related calls with their
>> simple swait~ variants to improve performance as well as memory and
>> stack footprint.
>>
>> Use the IDLE state for the worker thread put to sleep instead of
>> misusing the INTERRUPTIBLE state combined with flushing signals
>> just for not contributing to system's cpu load-average stats.
>>
>> Also check for sleeping thread before attempting its wake_up in
>> md_wakeup_thread() for avoiding unnecessary spinlock contention.

I think it'll be better to split this into a seperate patch.
And can you check if we just add wq_has_sleeper(), will there be
performance improvement?

>>
>> With this patch (backported) on a kernel 6.1, the IOPS improved
>> by around 4% with raid1 and/or raid5, in high IO load scenarios.

Can you be more specifical about your test? because from what I know,
IO fast path doesn't involved with daemon thread, and I don't understand
yet where the 4% improvement is from.

Thanks,
Kuai

