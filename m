Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FE0265CC5;
	Fri,  6 Jun 2025 08:56:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749200202; cv=none; b=kGSBnAN2n1roeudwg37DRri3QCGjWNAyrhwnFxCuBjW45L+BD1el9NxTycelXRemFeJ8HzC4xF2r99NkCmc/CB4CLm47vAr/KvhopgqqdUIcDg7j6nBKl5gcYTmac2DBKzz+Kt7h7fsOLZI2abjgcp3L7MZRajHQQfQAiafA9qk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749200202; c=relaxed/simple;
	bh=oA1jw9FL/EQacFPmNkgTSY6MfvlP3z2SAdsG0q4xTqg=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=KYcZb4JS4w0ApQlIaYq0jsq/ukbRk2MfWwyHML/d7OTH8suJDovFBt4WCeJqiKE9DTStRtlqpwE84FNvBh06It2OtDL84Cjppx5MY/0Tl1h9BHwVFQnHOgLvel0hgPh9TobeFjvPscldXJ4+UVBljtx8NVooOXLfhcfD51FOFEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bDFYJ4BKMzKHNmq;
	Fri,  6 Jun 2025 16:56:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EC1531A1A34;
	Fri,  6 Jun 2025 16:56:34 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBXu19BrUJoqv+vOg--.7485S3;
	Fri, 06 Jun 2025 16:56:34 +0800 (CST)
Subject: Re: [PATCH 15/23] md/md-llbitmap: implement llbitmap IO
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de,
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-16-yukuai1@huaweicloud.com>
 <4b1e7a50-f448-4e0f-a498-a8c6b0c7f97d@redhat.com>
 <7ef969ed-8468-5d63-a08d-886ca853f772@huaweicloud.com>
 <89b1283c-c256-4830-96dd-ef9e5a7ce355@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <54391288-57fc-ed5e-9ba6-aaf93bb71e3d@huaweicloud.com>
Date: Fri, 6 Jun 2025 16:56:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <89b1283c-c256-4830-96dd-ef9e5a7ce355@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXu19BrUJoqv+vOg--.7485S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYt7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVWxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2js
	IEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE
	5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jrv_JF1lYx0Ex4A2jsIE14v26r1j6r4UMcvjeV
	CFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxG
	xcIEc7CjxVA2Y2ka0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCF04k20xvY0x0EwIxGrw
	CF54CYxVCY1x0262kKe7AKxVWUtVW8ZwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02
	F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GF
	ylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r
	1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUp
	6wZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/06 14:24, Xiao Ni 写道:
> Maybe consider another name of bits_per_page? bits_per_page can easily 
> let people to think the bitmat bits in one page. Through the graph 
> below, maybe blocks_per_page?

Sounds good. :)

Thanks,
Kuai

