Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 279182E283E;
	Fri, 12 Sep 2025 09:20:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757668856; cv=none; b=Ic9zKI10/ROiYKr3DMFQfx9cSNyyYH8woIJnnW0kuP3Rh9J5eHWTAfAAjIytNhmzqoJkSJNZDg7RMeOGfcSGhPCs8jgwfzS3WgAwr2eVOdNaLppR/20p/AOrfbpBXeZsHE1f+eZHoei+ExjFbxa9EOXQMtgxdxkw47aMpfnCWlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757668856; c=relaxed/simple;
	bh=fdWq7jU/r+YPyJLFYj+oQNcMiUGHgVPoVaERQllpVTE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T5bVjoug3SGISzpoq/G839PPXnxLDSJzmHKBHy8DS00qlDoNu3/gAL+1CeakqLzDpFgeMsmjmf7JCLV3GlG3ToCkV9ZPbLZVXgtDBJurqcdq2jb2n4urdCLRU7XB4tfLt9PBtcqwT+ZoiZzpyWxZnEeqYd/QN9V5r7lhnMj9sCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4cNTS213rGzKHNq6;
	Fri, 12 Sep 2025 17:20:50 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 7CD351A0D2B;
	Fri, 12 Sep 2025 17:20:50 +0800 (CST)
Received: from [10.174.179.247] (unknown [10.174.179.247])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY3t5cNovJT6CA--.44667S3;
	Fri, 12 Sep 2025 17:20:48 +0800 (CST)
Message-ID: <028c1184-a114-d814-cf11-ef6d9408502b@huaweicloud.com>
Date: Fri, 12 Sep 2025 17:20:45 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v4 1/2] md: prevent adding disks with larger
 logical_block_size to active arrays
To: Xiao Ni <xni@redhat.com>, linan666@huaweicloud.com
Cc: corbet@lwn.net, song@kernel.org, yukuai3@huawei.com, hare@suse.de,
 martin.petersen@oracle.com, bvanassche@acm.org, filipe.c.maia@gmail.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yangerkun@huawei.com, yi.zhang@huawei.com
References: <20250911073144.42160-1-linan666@huaweicloud.com>
 <20250911073144.42160-2-linan666@huaweicloud.com>
 <CALTww2-rbwtJTm+yyX6mar_eybLCbpFoWQWdOM9j4_hgW0=4Hg@mail.gmail.com>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <CALTww2-rbwtJTm+yyX6mar_eybLCbpFoWQWdOM9j4_hgW0=4Hg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY3t5cNovJT6CA--.44667S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GF4UCr1kWFW3Ary7XrWUArb_yoWktFg_CF
	4Yywn7Ww1DZwn29a1DKrs29Fn8Gw1xGFyqq348JFW3Wa48JFs5JFnagry2v3Z3J3WkGF9I
	9rn5XwsYvrZ7CjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbqxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
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



在 2025/9/12 11:18, Xiao Ni 写道:
> On Thu, Sep 11, 2025 at 3:41 PM <linan666@huaweicloud.com> wrote:
>>
>> From: Li Nan <linan122@huawei.com>
>>
>> When adding a disk to a md array, avoid updating the array's
>> logical_block_size to match the new disk. This prevents accidental
>> partition table loss that renders the array unusable.
>>
>> The later patch will introduce a way to configure the array's
>> logical_block_size.
>>
>> The issue was introduced before Linux 2.6.12-rc2.
>>
>> Fixes: d2e45eace8 ("[PATCH] Fix raid "bio too big" failures")
> 
> Hi Li Nan
> 
> I can't find the commit in
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> 
> git show d2e45eace8
> fatal: ambiguous argument 'd2e45eace8': unknown revision or path not
> in the working tree.
> Use '--' to separate paths from revisions, like this:
> 'git <command> [<revision>...] -- [<file>...]'
> 
> Regards
> Xiao

Thank you for your reply.

As mentioned in the commit message, the issue was introduced before Linux
2.6.12-rc2, and needs to be get it in the history repository.

https://kernel.googlesource.com/pub/scm/linux/kernel/git/tglx/history.git

-- 
Thanks,
Nan

