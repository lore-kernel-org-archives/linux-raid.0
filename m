Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22DE03C38;
	Mon, 30 Jun 2025 02:17:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751249869; cv=none; b=QLM/g7vFAfuYoUgg6HsPBdusPwn9qbvDqe3D8Kw2VBm69rpV7cZVcknejXigL+QVHPiG7I4YMhKvGjHJWirXRZjX6W+M4WfReqIQnaOSwuXdNwOgKiVHBUx//5CH2wlPDR1teocbgzA7BdeMx84p2gpKbJNZPS+DBa/ImoxYcxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751249869; c=relaxed/simple;
	bh=LbqzbrMcEiwmJYFiqq/MnQJtvZFIDnS/seI54Nz8Xi8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=M6jnhRWScOM5bmGc/8dpxeio1Ajnnvu/0zM/r7JwHU22phrY9uXgnsmDFwYfvna7/+X5YJT2+bFUxXV5Uybobf49WgCQQrcpb535be1KlX7VacoSlWgJpN/JxtqYJPSHoLrDQxfiwKc6qDDG97bgNtPLPdUUYkZkSyR8cJZeCik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bVqYw14plzKHMTx;
	Mon, 30 Jun 2025 10:17:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 86ED71A13B7;
	Mon, 30 Jun 2025 10:17:38 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgBHpyTA82For4WqAA--.36383S3;
	Mon, 30 Jun 2025 10:17:38 +0800 (CST)
Subject: Re: [PATCH 15/23] md/md-llbitmap: implement llbitmap IO
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de,
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-16-yukuai1@huaweicloud.com>
 <0bb1fb81-603d-45a9-9f23-a4f370084fd6@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <047fb193-3d9c-65d8-6379-84af1a61b283@huaweicloud.com>
Date: Mon, 30 Jun 2025 10:17:36 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <0bb1fb81-603d-45a9-9f23-a4f370084fd6@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHpyTA82For4WqAA--.36383S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYK7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
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

在 2025/06/30 10:07, Xiao Ni 写道:
> Can this for loop run? If one bit is dirty, it must set pctl->dirty. So 
> the second write comes, it finds pctl->dirty is set and 
> llbitmap_infect_dirty_bits function run and return. So it looks like it 
> will not run the for loop.

I don't quite understand what you mean ...

There are two cases:

1) write two bits int the same block twice, then test_and_set_bit() will
pass;
2) write one bit, set block dirty, after bitmap unplug and before
cleaning the bit, then test_and_set_bit() will fail, and the loop will
run.

Thanks,
Kuai

