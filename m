Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 292D736D;
	Mon, 25 Nov 2024 01:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732497376; cv=none; b=ZheeRxYm249oWPxrnfeGnXfojeVNvifPeW05kIvllh/HQ/3kMGO5VV1/15ZUtrRndpE6aaQSbsstCgljIKPa3JVryhZ0Ph6ADMtMcFSdvPueFx84cVK19uOdhSM93y3fNdmlvHGj4/87r/Ehe1jEptxLaFkK+vitn6Q+ZMrJhKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732497376; c=relaxed/simple;
	bh=0JUlY4EbwQb26RHDO7DZrSmTrxLydlGRAUvkrJ/UYlA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=WUSiAOMe2mXEHfGYbIm4FsDvkPaLkfMCrQUevq3Nw82S0Sff3CKyOqrTn0KTD9MrpuGmm3rvOBRP7WJmKzcQjTUty17G+sxz/rQwKaj/5Ysi3MlTHc5eojj9Vpc2ebe+OZDbpZesQb9OZDrBFHu+8pUEeb4ffPgzYJfU2HCWhYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XxSSX57r9z4f3lVg;
	Mon, 25 Nov 2024 09:15:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 51DA21A0196;
	Mon, 25 Nov 2024 09:16:00 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCngYXOz0NnFB4BCw--.25988S3;
	Mon, 25 Nov 2024 09:16:00 +0800 (CST)
Subject: Re: [PATCH md-6.13 5/5] md/md-bitmap: move bitmap_{start, end}write
 to md upper layer
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241118114157.355749-1-yukuai1@huaweicloud.com>
 <20241118114157.355749-6-yukuai1@huaweicloud.com>
 <CALTww28JrdXoNXQNPxx2Sg9L2iL20jZZ80Y-qZzqcyF780M1fg@mail.gmail.com>
 <e6843d53-c7f4-2e38-0a15-91b49afec8f1@huaweicloud.com>
 <CALTww28ZRFo6BwqzriVpoOuqbfygKrU0HuOhhUxLe9cBBDY-ZQ@mail.gmail.com>
 <e3319ea0-f9aa-6048-c620-4e72f2b10b31@huaweicloud.com>
 <CALTww28kr5TzWoeMrS-W_etfhwQGQHDQ-DeakTEALUGDE9FNVA@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <a450ec2a-03ae-7351-ca2a-8e9bf93c6e14@huaweicloud.com>
Date: Mon, 25 Nov 2024 09:15:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww28kr5TzWoeMrS-W_etfhwQGQHDQ-DeakTEALUGDE9FNVA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCngYXOz0NnFB4BCw--.25988S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYy7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
	xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4c8EcI0Ec7CjxVAaw2AFwI0_JF
	0_Jw1l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8G
	jcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2I
	x0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK
	8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I
	0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/23 11:55, Xiao Ni 写道:
> For normal io, endwrite is called in function
> handle_stripe_clean_event when sh->dev[i].written has value.
> For failed io, endwrite is called when bitmap_end has value.
> bitmap_end is set when sh->dev[i].to_write is not NULL.
> Which place does extra endwrite?

I think it's related to the sh batch list. For example, the
returnbi tag from handle_stripe_clean_event() doesn't check
the written value.

Thanks,
Kuai

