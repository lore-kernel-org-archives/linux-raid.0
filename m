Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2257F128816
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 09:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714469232; cv=none; b=nisFxIuLYxMVpaHyQvaxatWGyxWWLorZyvb29JkP6Z5O4RqigrQKydSgYYn6DNIBjYjA3QFi9037Xv4LcB44LZ2ueTU01GCOQ0HPXveCEIPpsjW2FkxOMg4CAFoxIY/JBAnx/5jJOYda4qhjJt1n3q1BV8KYbK1DuRxUkyAUoew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714469232; c=relaxed/simple;
	bh=U+FloJhR/7Pi5ZETkBJ3mj3SW+JKfngx+cZyTgwWO7A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=p+FtveMgzLJSPVLjWXDHQ4gJ2v7sbEXge4fiUIYBlteamqt4/gzPJW6/XdpHRdKk9WX7yVOf12kCNU6jRuYsWS/IiMWJanzesfkgGQ0hiJR8wX+SzvRC+lvFYKkrY3DJYGZ2EIuizzlrWKWYnxzZX/HboRmD1WyYOktUKJ/us/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VTFFm2XSsz4f3jdP
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 17:26:52 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3A05F1A016E
	for <linux-raid@vger.kernel.org>; Tue, 30 Apr 2024 17:27:00 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgAX5g5iuTBmw8dxLQ--.55660S3;
	Tue, 30 Apr 2024 17:27:00 +0800 (CST)
Subject: Re: Move mdadm development to Github
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 Wols Lists <antlists@youngman.org.uk>
Cc: Paul E Luse <paul.e.luse@linux.intel.com>, John Stoffel
 <john@stoffel.org>, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240424084116.000030f3@linux.intel.com>
 <26154.50516.791849.109848@quad.stoffel.home>
 <20240424052711.2ee0efd3@peluse-desk5>
 <3ba48a44-07fd-40dc-b091-720b59b7c734@youngman.org.uk>
 <20240426102239.00006eba@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <38770f23-92da-09a6-227f-11f1176294e2@huaweicloud.com>
Date: Tue, 30 Apr 2024 17:26:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240426102239.00006eba@linux.intel.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgAX5g5iuTBmw8dxLQ--.55660S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ar4DCFW3AF17GFy7KrWxZwb_yoW8Gw1xpa
	1rKayYkrsFqrs5Cw4fKan7Xa10qws3A345Ja4UJrsFvrs8X3sIyrWIkF4YkFyfZr97Grnx
	Z3WruFykZa45WaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UWE__UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/04/26 16:22, Mariusz Tkaczyk Ð´µÀ:
> On Fri, 26 Apr 2024 08:27:44 +0100
> Wols Lists <antlists@youngman.org.uk> wrote:
> 
>> On 24/04/2024 13:27, Paul E Luse wrote:
>>> * Instead of using the mailing list to propose patches, use GitHub Pull
>>>     Requests. Mariusz is setting up GitHub to send an email to the mailing
>>>     list so that everyone can still be made aware of new patches in the
>>>     same manner as before.  Just use GitHub moving forward for actual
>>>     code reviews.
>>
>> Does that mean contributors now need a github account? That won't go
>> down well with some people I expect ...
>>
>> Cheers,
>> Wol
> 
> Hi Wol,
> 
> There are thousands repositories on Github you have to register to participate
> and I don't believe that Linux developers may don't have Github account. It is
> almost impossible to not have a need to sent something to Github.

Will it still be able to send and apply patches through maillist? It's
important for us because I just can't create pr at GitHub in my
company, already tried with Paul, due to our company policy. :(
Although I can do this at home...

Thanks,
Kuai

> 
> Here some examples:
> https://github.com/iovisor/bcc
> https://github.com/axboe/fio
> https://github.com/dracutdevs/dracut
> https://github.com/util-linux/util-linux
> https://github.com/bpftrace/bpftrace
> https://github.com/systemd/systemd
> 
> I see this as not a problem.
> 
> Thanks,
> Mariusz
> 
> .
> 

