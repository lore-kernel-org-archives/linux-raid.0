Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30A64762DA;
	Tue, 26 Mar 2024 14:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711461715; cv=none; b=SQlhDaJ0TzojfzIFsA4lqJRuYY4eTFCcyFsKfFdljyAITamtcgr1/puQD0uagA/TxtOP7pSH/xaE5ozeJMe70ZLYPfsR2GuWvp2qte71avGW6XSPoxtlAjZPzVk23N9p5F+IuIHvXgKq33Ifp+fGRvRwTbMT5k7lB27Hj2bvLBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711461715; c=relaxed/simple;
	bh=CQPzmrmIC9p3Xew9lnpRqlyPip57uhVVQNN8AMBn96A=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=PRlvShRjIiM9G2rr39vdITxlq636bgAjUBn+pIaZbqphSgH59WkNlZD8GoG171ND+bWTefYD4XnoothXDjrK54hvys8k8xEPcvvN4fqY8rcmp2FniRYHXp8URg1HSjTtW8tXRqIWWaUmNulLDjrcHJ5RrIgBi2XIx6yDWhG1U4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4V3s112czyz4f3jHt;
	Tue, 26 Mar 2024 22:01:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 8C3C41A0CB1;
	Tue, 26 Mar 2024 22:01:47 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP1 (Coremail) with SMTP id cCh0CgBHZQ5J1QJmq2uTIA--.18997S3;
	Tue, 26 Mar 2024 22:01:47 +0800 (CST)
Subject: Re: [PATCH 00/11] md: avoid counter operation conflicts
To: tada keisuke <keisuke1.tada@kioxia.com>, "song@kernel.org"
 <song@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "yukuai (C)" <yukuai3@huawei.com>
References: <a022f547c43e40e2b9f0aebb2bd0bfa8@kioxia.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <140c7f16-4c2a-390a-7021-53d3723626ec@huaweicloud.com>
Date: Tue, 26 Mar 2024 22:01:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <a022f547c43e40e2b9f0aebb2bd0bfa8@kioxia.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:cCh0CgBHZQ5J1QJmq2uTIA--.18997S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUU5i7kC6x804xWl14x267AKxVWUJVW8JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r4j6ryUM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjc
	xK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVAC
	Y4xI64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJV
	W8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG
	8wCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r
	1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1lIxkGc2Ij
	64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Jr
	0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6rW3Jr0E3s1lIxAIcVC2z280aVAFwI0_Jr0_Gr1l
	IxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUU
	U==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/03/26 18:29, tada keisuke 写道:
> Currently, active_aligned_reads and nr_pending used as counters are atomic types.
> Therefore, when inc/dec in a multi-core results in conflicts.

I don't uderstand what's the problem here, what's wrong with atomic
types in a multi-core system?

Thanks,
Kuai

