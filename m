Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F46843179;
	Thu, 21 Nov 2024 08:33:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732178033; cv=none; b=ekBe3X3CnqFdkrNdk697EQ6SEybR3iP67660qKVWn+UB26Eie8igDrUzy0mCTsm2Xm+/anbBP8fVythS7CbeZV7CldbeQ8BWgqHeWfZkt8eGowH+V/1iP73V4vTNGobHrFK2cl1X3AU95NrUe6JtjdtazPA/59UAN7TGlnniP/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732178033; c=relaxed/simple;
	bh=5yazPeb8Q83EPo4BoH/qWmhZTxp3hJ/Rk4OjMw5e0+w=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=FT6tNZZ6LeRaYJASer0I+JU+gdZyVCmQ4c/An5K72B3WqeFnSmOUh3F1ecATziKBzPApQNO0wJE8VfbJmm8+h70jqWc/md0X2vmX/qMQcMffeo3hu7h6YEiE5tz+5bLMO5T+Spl6m7iyEbo91AOUMtXKoGo22+/IZTvRR8FFbwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4XvBMN613dz4f3nbh;
	Thu, 21 Nov 2024 16:33:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 4EA801A058E;
	Thu, 21 Nov 2024 16:33:40 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXc4di8D5nVvCfCQ--.28335S3;
	Thu, 21 Nov 2024 16:33:40 +0800 (CST)
Subject: Re: [PATCH md-6.13 4/5] md/raid5: implement pers->bitmap_sector()
To: Jinpu Wang <jinpu.wang@ionos.com>, yukuai1@huaweicloud.com,
 Haris Iqbal <haris.iqbal@ionos.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 song@kernel.org, xni@redhat.com, yangerkun@huawei.com, yi.zhang@huawei.com,
 =?UTF-8?Q?Florian-Ewald_M=c3=bcller?= <florian-ewald.mueller@ionos.com>,
 Christian Theune <ct@flyingcircus.io>, "yukuai (C)" <yukuai3@huawei.com>
References: <adf796b9-2443-d29a-f4ac-fb9b8a657f93@huaweicloud.com>
 <20241119152939.158819-1-jinpu.wang@ionos.com>
 <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d456368e-cff5-5476-238e-4cc97f016cfa@huaweicloud.com>
Date: Thu, 21 Nov 2024 16:33:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CAMGffEkODwo19u0EjKojQ0WaWVkvOOB8aRR8R3NXn+oC6TFQWQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXc4di8D5nVvCfCQ--.28335S3
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
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	oOJ5UUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/11/21 16:10, Jinpu Wang 写道:
> On Tue, Nov 19, 2024 at 4:29 PM Jack Wang <jinpu.wang@ionos.com> wrote:
>>
>> Hi Kuai,
>>
>> We will test on our side and report back.
> Hi Kuai,
> 
> Haris tested the new patchset, and it works fine.
> Thanks for the work.

Thanks for the test! And just to be sure, the BUG_ON() problem in the
other thread is not triggered as well, right?

+CC Christian

Are you able to test this set for lastest kernel?

Thanks,
Kuai

>>
>> Yes, I meant patch5.
>>
>> Regards!
>> Jinpu Wang @ IONOS
>>
> 
> .
> 

