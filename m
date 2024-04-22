Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22379139D
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 01:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713748233; cv=none; b=jWmaHQR7qkb0IMztbCEycmia20Z0xbE2P7WUK6SGMI82Oe/w70f1JFrhOSI/Ib7oa41SajIkW20x7WCqZWfn+rLhU8solD5CMt5nsBTqtsTc2Gq6Q9YsBSwqe2m736DSNd7g9T6aKt/tjYRXySkky9o9nan0r2/BvO26/eihhxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713748233; c=relaxed/simple;
	bh=HWHIu89eKrsTfxUSJPgdeZc/xVa5k66mh08xypGTEL8=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Z8bL/lUIm5XyLYe6iOZS6+w6eIcNrLhEAjKnYe+SzxwBQmFcq1tl7EHedFiTymwexIhxrIU7qyK9aszhV7IAr9Na5FFmzN7LFXHUJTMEXG/E43LjdMxZz9zatllIjMYX5iZJBzoLucKGRsEIUM+oO0hIRY5eRg8iPni7kY4xfOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VN6cS523wz4f3jq8
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 09:10:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 788C31A0572
	for <linux-raid@vger.kernel.org>; Mon, 22 Apr 2024 09:10:21 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHGBH7uCVmVfx6Kg--.40268S3;
	Mon, 22 Apr 2024 09:10:21 +0800 (CST)
Subject: Re: regression: CPU soft lockup with raid10: check slab-out-of-bounds
 in md_bitmap_get_counter
To: Nigel Croxon <ncroxon@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 linux-raid@vger.kernel.org, Heinz Mauelshagen <heinzm@redhat.com>,
 Xiao Ni <xni@redhat.com>, song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
References: <71ba5272-ab07-43ba-8232-d2da642acb4e@redhat.com>
 <a86ab399-ab3c-946c-0c2d-0f38bbde382a@huaweicloud.com>
 <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <7994d3dc-af43-c895-f3e5-ac17ecd28f73@huaweicloud.com>
Date: Mon, 22 Apr 2024 09:10:19 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6f5d60a3-a7b1-4103-a944-7a6b575f32a4@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgBHGBH7uCVmVfx6Kg--.40268S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYF7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
	xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2KfnxnU
	UI43ZEXa7VUbXdbUUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/04/21 20:30, Nigel Croxon 写道:
> Hello Kuai,
> 
> I tested your patch under this failing environment and it works.
> 

That's greate, thanks for the test!

Kuai
> -Nigel

