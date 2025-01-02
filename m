Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C6E199237
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 11:23:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735817034; cv=none; b=COuqhFGVxUrRdziX8dy9MXfu7hDYtJsuFbRmmL5UHwijZ0l3wn1D/2bPXWkX73SYMjtjRsuO8HTvDOofchcGW1nJanA32sZ1/+RhzKCm1cW8/p4izJTGA9pkQgYbnrEgEjcJNT+CG08yOvnhxk1/ZR1of6NUYhsGEhBcRLyzAzE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735817034; c=relaxed/simple;
	bh=O2rOhMRc2NmubIWFJFuX2nm8Oefd24mgK9lcW+lNjuE=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bkvMqeJEPRWF6TRdjZQiyA5bMMjpzWZnw2ikJN00jFs8egII4/vsNOxxs81i3SqH4C3m+qpT4DpMcXyOsxXCz1D8pyq9GTPeV1WKi3GXmZpP9pbJ7oaGYUBfS9L5Pakwe9yRuL23N1DA1Fu2hjnJT7pfYHzHtCNS/QNG+UrPc1s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YP48G47l9z4f3lCm;
	Thu,  2 Jan 2025 19:23:26 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id AE7F31A09FE;
	Thu,  2 Jan 2025 19:23:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgDHo4dAd3ZnY3RXGQ--.9823S3;
	Thu, 02 Jan 2025 19:23:45 +0800 (CST)
Subject: Re: md-linear accidental(?) removal, removed significant(?) use case?
To: Allen Toureg <thetanix@gmail.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, regressions@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <CABrqrA6b2y29tC2Z-9H2vYsuP_t5c6uCw9DZrjY7DmeNcczf0w@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b3e1ab86-6f9d-44bb-8443-1a95ba3eaa85@huaweicloud.com>
Date: Thu, 2 Jan 2025 19:23:43 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CABrqrA6b2y29tC2Z-9H2vYsuP_t5c6uCw9DZrjY7DmeNcczf0w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHo4dAd3ZnY3RXGQ--.9823S3
X-Coremail-Antispam: 1UD129KBjvJXoWxZw4xWr48Aw4fJr1DCrykKrg_yoW5uw15pF
	Z5Jr4jkF4kJFyxXayDX3yxZa4a9r9rJay3XF4fGr1jyas8uFn2vr43KF48ZrZruw4S93Wa
	vrWUtryUu3s8AFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jjVb
	kUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/01/02 12:14, Allen Toureg 写道:
> Preamble: I have extensive arrays of drives and due to their irregular
> sizes, I was using md-linear as a convenient way to manually
> concatenate arrays of underlying MD (raid5/etc) to manually deal with
> redundancy.
> 
> I have probably a few thousand TB in total raw space, and hundreds of
> TB of actual data and files attached to singular systems.
> 
> In a recent OS update, I discovered my larger volumes no longer mount
> because md-linear has been removed entirely from the kernel as of 6.8.
> 
> I am trying to do rationale archaeology. I sent a note to Mr. Neil
> Brown who was responsible for the earliest change I found related to
> this and he suggested I email regressions and linux-raid along with
> the current maintainers about it.
> 
> What I've been able to find:
> 
> In 2604b703b6b3db80e3c75ce472a54dfd0b7bf9f4 (2006) Neil Brown marked a
> MODULE_ALIAS entry for md-personality-1 as deprecated but it appears
> the reason was because the form of the personality was changed (not
> that the underlying md-linear itself was deprecated.)
> 
> d9d166c2a9d5d01af34396793950aa695883eed4 (2006) reinforced this change
> via a diff algorithm that overzealously included that line in a diff
> chunk but which makes annotating prior to it a more manual process.
> 
> 608f52e30aae7dc8da836e5b7b112d50a2d00e43 (2021) marked md-linear as
> deprecated in Kconfig, using the rationale that md-linear was
> deprecated in MODULE_ALIAS—but again which doesn't explain why the
> *module* was deprecated and appears to me at least to accidentally
> misconstrue the original reason for the deprecation comment.
> 
> 849d18e27be9a1253f2318cb4549cc857219d991 (2023) eliminated md-linear
> entirely, again mostly self-referencing a deprecation notice which was
> there in actuality for basically multiple decades and seems to have
> referenced something else entirely.
> 
> I was hoping you could help me understand why this module was removed?
> I have found others who also are running into this. Functionality they
> relied on has disappeared, as per the existence of the following:
> 
> https://github.com/dougvj/md-linear
> 
> https://gitlab.archlinux.org/archlinux/packaging/packages/linux/-/issues/34
> https://bbs.archlinux.org/viewtopic.php?id=294005
> (etc)
> 
> So, it looks like there are many of us who were still using mdadm to
> manage sub-device concatenation, again in my case for 100s of TB of
> admittedly casual data storage, and I can't currently find what the
> actual actual rationale was for removing it. :(

Thanks for the report! I believe the reason md-linear is removed is that
we don't recognize real users, and it's deprecated for a long time.
> 
> For utility's sake, I would like to suggest that linear volumes lessen
> problems like substriping. I do not think for many of us that
> shuffling around a few hundred TB is easy to do at any rate. Currently
> I'm manually re-compiling a fairly heavily-modified md-linear as a
> user-built module and it seems to work okay. I am definitely not the
> only one doing this.
> 
> Please consider resurrecting md-linear. :-)

I think it's good to introduce md-linear back, I'll send a patch and see
how other people thinks. And perhaps can you give the new md-linear a
test?

Thanks,
Kuai

> 
> Thank you,
> Sincerely,
> at
> .
> 

