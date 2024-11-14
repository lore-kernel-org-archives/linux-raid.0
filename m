Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE4D31DFD8
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 12:19:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731586745; cv=none; b=dGuTl42hL2P8v4zG1Y94SNRJiCzCa6eKWDarAf+ejnHqpbyKb35UfjO9fpmgYeItHBYhzohagK+zDiwm4YvB8HibwbUytRYXaHBCk2ijVg/XfXgKDDcVQ3fTYxlv7bMaqsxnHrabTh5VxhYvqYAYOtnUJSeggxzQgMt+tGajLFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731586745; c=relaxed/simple;
	bh=swXBr95IwUpbA9YLl/heuBXeEf24Elj2UCe0fS0gseE=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=mEV78W0SQXC8JZR17ndhudLAOBN7T/jNBpUK9skxi17eH5zP79+lTdCFqPHX9Fjyu8lQO2PcdMq8qKCAI1ao4UZDvZmH0XSZcupkYHJPSRgRyFN2thJ/JxFBmJpLBTpqkFly78KBmcI0U3TP1iSQx3BoxQniisUVRZnrPHHB55Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Xpzhg0RJhz4f3jt6
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 20:18:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 42A5F1A0568
	for <linux-raid@vger.kernel.org>; Thu, 14 Nov 2024 20:18:56 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCHYoau6jVnBXANBw--.52938S3;
	Thu, 14 Nov 2024 20:18:56 +0800 (CST)
Subject: Re: Experiencing md raid5 hang and CPU lockup on kernel v6.11
To: Jinpu Wang <jinpu.wang@ionos.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: Haris Iqbal <haris.iqbal@ionos.com>, Xiao Ni <xni@redhat.com>,
 =?UTF-8?Q?Dragan_Milivojevi=c4=87?= <galileo@pkm-inc.com>,
 linux-raid@vger.kernel.org,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>,
 David Jeffery <djeffery@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
References: <CAJpMwyjmHQLvm6zg1cmQErttNNQPDAAXPKM3xgTjMhbfts986Q@mail.gmail.com>
 <CALtW_ahYbP71XPM=ZGoqyBd14wVAtUyGGgXK0gxk52KjJZUk4A@mail.gmail.com>
 <CAJpMwyjG61FjozvbG1oSej2ytRxnRpj3ga=V7zTLrjXKeDYZ_Q@mail.gmail.com>
 <4a914bc9-0d4e-e7c8-bed8-7b781f585587@huaweicloud.com>
 <CALTww297-iYB1m2Y0_ceHn1Y43nB-RZdw67QSm6zWZ3hGEtkig@mail.gmail.com>
 <CAJpMwyiR3B0ismDXXyqS-HSzyiiVDj7YYE85m91oDvB9apnB6g@mail.gmail.com>
 <8f7173c6-8847-129c-c5ed-27eb3b8a8458@huaweicloud.com>
 <CAJpMwyjPcLQ=HF5EOXgQFOy=bGHLDWZQJ5CwUV0UHMnyeSPM_g@mail.gmail.com>
 <fb9db285-dff0-681c-1dcf-7f01350ccb48@huaweicloud.com>
 <CAJpMwyi8v2LvdVG2nJ-aJOHDpw79tcwGfPbgV--4xH67NC2B3Q@mail.gmail.com>
 <3fbe69c8-375c-c397-d40d-bc26d4aeda1a@huaweicloud.com>
 <CAMGffEnSJ9KMtB8O4x7Mzyvt4X53CHDMHi9WArGecjOhjh2dTg@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6691be8d-994f-b219-213d-26557c258559@huaweicloud.com>
Date: Thu, 14 Nov 2024 20:18:54 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAMGffEnSJ9KMtB8O4x7Mzyvt4X53CHDMHi9WArGecjOhjh2dTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCHYoau6jVnBXANBw--.52938S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYK7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	oOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/14 18:27, Jinpu Wang 写道:
> Do you want us to try the following change on top of the md/md-6.13
> branch without Xiao's patch and your fixup alone, or combine them all
> together?

Combine them please, sorry that I forgot to mention it.

And for md/md-6.13 there will be conflicts. So try v6.11 is better I
think.

> 
> BTW: we hit similar hung since kernel 4.19.

Good to know, I think Xiao's patch alone is fine for 4.19, the
BUG_ON() probabaly won't be triggered.

Thanks,
Kuai


