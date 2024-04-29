Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B040B15E97
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 07:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714377157; cv=none; b=cUVNrwgeoPZJpmVu8PM6FvJ87XMV2R01wPyEARYkZYdpjarU7MA0vwVzQHEgPKAiInAPFacivcWDbgpFMQSOe0VkfXCfxxat9jHG9wSkY9h5a0TRozWtX/WS+Bg0BBGuZhwGJ4HFPUjcggii713AhOi9L5PQvJIAuXX9YDKaCQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714377157; c=relaxed/simple;
	bh=Ww/u8AtlMYPjZtsgNq8OcYvsYrJlHu3H6falRzJJHkM=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=r/uzUKY9x3QDoQgjfL1LAh5Jt/J5tar9AknrCfqxTcEUNW3uSbS+Y5kiR5Rtvb2lfOr611Wf/actE52Thx4qTQBSs9ZrzJH0y6wE3rmARUVn/CUF8LQ7I93P/MhD6a48d+I8Nh6WNXWynG9NEXfniZoX2XaAwW8KhFvay2FTgS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4VSbCB33HMz4f3kjK
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 15:52:22 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 3D9D51A09F2
	for <linux-raid@vger.kernel.org>; Mon, 29 Apr 2024 15:52:30 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgCXaBG8US9m+1MPLQ--.15738S3;
	Mon, 29 Apr 2024 15:52:30 +0800 (CST)
Subject: Re: General Protection Fault in md raid10
To: Colgate Minuette <rabbit@minuette.net>, linux-raid@vger.kernel.org,
 Yu Kuai <yukuai1@huaweicloud.com>
Cc: "yangerkun@huawei.com" <yangerkun@huawei.com>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <8365123.T7Z3S40VBb@sparkler>
 <90f685e1-9c55-d9c5-79d4-9ef354b3b703@huawei.com>
 <2932875.e9J7NaK4W3@sparkler> <12425339.O9o76ZdvQC@sparkler>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <06b81e94-1e23-dd16-89d6-12eb7013d865@huaweicloud.com>
Date: Mon, 29 Apr 2024 15:52:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <12425339.O9o76ZdvQC@sparkler>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgCXaBG8US9m+1MPLQ--.15738S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYw7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0
	xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr
	1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE
	14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7
	IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0DMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x0JUywZ7UUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi!

在 2024/04/29 15:06, Colgate Minuette 写道:
> Following up, the raid10 with the Samsung drives builds and starts syncing
> correctly on 4.19.307, 5.10.211, and 5.15.154, but does not work on 6.1.85 or
> newer.

That's good news, perhaps can you bisect between 5.15 and 6.1?

Thanks,
Kuai

