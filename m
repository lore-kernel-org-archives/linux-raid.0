Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738102E630
	for <linux-raid@vger.kernel.org>; Mon, 14 Jul 2025 01:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752457294; cv=none; b=QbsRfzSK8h39mDKNI5wQxF/+FkEL8AcRQKlD+L+ErDXz1heeISUKCoM5E9yLzmPsLQNoIckyH/ofgkv9SMJBqpc+c5ceO3WuBRe2Rzok+w8l85X9CZ7p1XEjCgN0I6mi1Het9ogUFrZXs68DWTPH9PScD+Tha5Ux4pHT2TeWDqk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752457294; c=relaxed/simple;
	bh=di9SbTkKqcnSaY3A5M3LiV9f+hroBnLVJ0G5evtJUv8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=QfLGY0rXdyvHDMaF8yoJdmT5E54P+cym3oKDhbwcNXNMLwimWuDpigV4y9iZr5k8nw7FFzkO4aHgdcCKt76mqemSgKO5OhJ2bnnwF/OCb5EhWquNHpsN7GWrSnz7JYtF7qFjOiGNq3Dr1/jPVB0w2UHLuV03i9sdC0VodlIoG3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bgQ5b2gtVzYQv82
	for <linux-raid@vger.kernel.org>; Mon, 14 Jul 2025 09:41:23 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 2A1B31A167E
	for <linux-raid@vger.kernel.org>; Mon, 14 Jul 2025 09:41:22 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAXkxM_YHRow_HCAA--.58336S3;
	Mon, 14 Jul 2025 09:41:21 +0800 (CST)
Subject: Re: [PATCH v2 11/11] md/md-llbitmap: introduce new lockless bitmap
To: Hannes Reinecke <hare@suse.de>, Yu Kuai <yukuai@kernel.org>, hch@lst.de,
 xni@redhat.com, axboe@kernel.dk, linux-raid@vger.kernel.org, song@kernel.org
Cc: yangerkun@huawei.com, yi.zhang@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250707165202.11073-1-yukuai@kernel.org>
 <20250707165202.11073-12-yukuai@kernel.org>
 <a0ae5ea4-513e-40f0-9421-2bec57e1ee89@suse.de>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <9f86f347-97ee-130b-2dce-9c8465d7baa9@huaweicloud.com>
Date: Mon, 14 Jul 2025 09:41:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a0ae5ea4-513e-40f0-9421-2bec57e1ee89@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAXkxM_YHRow_HCAA--.58336S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr4rAry8Xw45ur4kCr1Utrb_yoW5Wr1UpF
	1vyrWjkryUJr1rXr1DtFWUAFyFyrn5Ja1DJrykXFyDAa15ArsYqF18WF909w1xZr48GF1U
	AF45Xr98Z3WDWrDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU9Ib4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IE
	e2xFo4CEbIxvr21lc7CjxVAaw2AFwI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4I
	kC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWU
	WwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr
	0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWU
	JVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJb
	IYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi, Hannes!

在 2025/07/08 15:47, Hannes Reinecke 写道:
[...]

>> +        case BitUnwritten:
>> +            pctl->state[pos] = level_456 ? BitNeedSync : BitDirty;
> 
> This really looks as if we should use WRITE_ONCE() ...

Sorry for the late reply, we're just writing one byte here, either old
value or new value with be read concurrently, I think we don't need
WRITE_ONCE() here, and READ_ONCE() on the reader side to prevent reading
strange value.

[...]

>> +    if (!test_bit(LLPageDirty, &pctl->flags))
>> +        set_bit(LLPageDirty, &pctl->flags);
>> +
> 
> test_and_set_bit?

We don't need to guarantee atomicity here, so perhaps test_bit() and
set_bit() will have less overhead?

[...]

>> +    for (pos = bit * io_size; pos < (bit + 1) * io_size; pos++) {
>> +        if (pos == offset)
>> +            continue;
>> +        if (pctl->state[pos] == BitDirty ||
>> +            pctl->state[pos] == BitNeedSync) {
>> +            llbitmap_infect_dirty_bits(llbitmap, pctl, bit, offset);
>> +            return;
> 
> Hmm. That looks _so_ inefficient. A loop within a loop... Wouldn't it be
> possible to use XOR or something to flip several bits at once?

This is a good question. I was thinking this will only be executed once
for every daemon_sleep seconds, and the additional overhead is fine, and
perf results do confirm that.

For XOR, we'll have to convert the enum type llbitmap_stage to one state
per bit, and there are total 7 states already and not good for future
expansion.

[...]
 >> +static void llbitmap_pending_timer_fn(struct timer_list *t)
 >> +{
 >> +    struct llbitmap *llbitmap = from_timer(llbitmap, t, pending_timer);
 >> +
 >> +    if (work_busy(&llbitmap->daemon_work)) {
 >> +        pr_warn("daemon_work not finished\n");
 >> +        set_bit(BITMAP_DAEMON_BUSY, &llbitmap->flags);
 >> +        return;
 >> +    }
 >> +
 >
 > Do you really need to check this?
 > Wouldn't it be easier to just run the daemon, which should devolve in a
 > no-op if no work is to be done?

This is the same reason as below, if the daemon get stuck and doesn't
finish in the last daemon_sleep seconds, just print a warning message
for now, and the BITMAP_DAEMON_BUSY is used for debuging perpose.

[...]
>> +        llbitmap_suspend(llbitmap, idx);
>> +        llbitmap_state_machine(llbitmap, start, end, 
>> BitmapActionDaemon);
> 
> How do you ensure that the daemon doesn't get stuck trying to write/read
> individual pages? Shouldn't there be some sort of 'emergency exit'?

Perhaps llbitmap_suspend_timeout() and give up clearing dirty bits if
failed? If inflight writes get stuck, suspend will forbit all new
writers to be issued.

Thanks,
Kuai

