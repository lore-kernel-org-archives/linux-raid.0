Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01BA415E97;
	Mon,  8 Sep 2025 01:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757294469; cv=none; b=RheXOyyj26bKZ2UAmlDU/+F28c+hnZgNY6fFSsDH+G3Rbw00m0dpxK4ajJwNOTK9vROurlQhojKmEV8Hfl5aSRvkEW8RibOHsWregegwjLrW0Uac8oAEZtr4GtPoS/GwreWHF0+e3OWu3/eoEQLRs3/fenDBrtzJrMGN7Jbz50o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757294469; c=relaxed/simple;
	bh=bmH0wdfQC+ymwiNTkR+u5wQ2Di3e+Zo/OWqapnTykZQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Nqxww30ZJCQXWHorXKTqj+vEI5QwgG6h8t9Zk9krDi84WAjhisZnqKE1uyXZjdHiCs25VRevyielppUoVKF2RiWGI/d8MNpAXvUl3TN7jrucMYi8j2KBBd3vSusfDemKlyBwntKMV7zP6TPDdTTeJiiggnZfQA7v0ASEetyhPrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cKq0C1pcSzYQv12;
	Mon,  8 Sep 2025 09:20:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id B82021A0E1C;
	Mon,  8 Sep 2025 09:20:57 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgB3wY13L75oZAYLBw--.55217S3;
	Mon, 08 Sep 2025 09:20:57 +0800 (CST)
Subject: Re: [PATCH v3 1/3] md/raid1,raid10: Do not set MD_BROKEN on failfast
 io failure
To: Kenta Akagi <k@mgml.me>, Yu Kuai <yukuai1@huaweicloud.com>,
 Li Nan <linan666@huaweicloud.com>, Song Liu <song@kernel.org>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Guoqing Jiang <jgq516@gmail.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250828163216.4225-1-k@mgml.me>
 <20250828163216.4225-2-k@mgml.me>
 <dcb72e23-d0ea-c8b3-24db-5dd515f619a8@huaweicloud.com>
 <6b3119f1-486e-4361-b04d-5e3c67a52a91@mgml.me>
 <3ea67e48-ce8a-9d70-a128-edf5eddf15f0@huaweicloud.com>
 <29e337bc-9eee-4794-ae1e-184ef91b9d24@mgml.me>
 <6edb5e2c-3f36-dc2c-3b41-9bf0e8ebb263@huaweicloud.com>
 <7e268dff-4f29-4155-8644-45be74d4c465@mgml.me>
 <48902d38-c2a1-b74d-d5fb-3d1cdc0b05dc@huaweicloud.com>
 <34ebcc5b-db67-49e0-a304-4882fa82e830@mgml.me>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ae39d3a6-86a2-b90d-b5d6-887b7fc28106@huaweicloud.com>
Date: Mon, 8 Sep 2025 09:20:55 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <34ebcc5b-db67-49e0-a304-4882fa82e830@mgml.me>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgB3wY13L75oZAYLBw--.55217S3
X-Coremail-Antispam: 1UD129KBjvdXoWrZF4ftr45GF1kZry7CF4DJwb_yoW3urcE93
	Wv9w4DJwnIvFnak3yfXF1avr93CFnYgFyfJFWxt3ZxK3s3ZF9a9r1Dtr97ur10qFy2qr47
	GFnrGw4akrnakjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbVxFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
	6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
	A2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j
	6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCTnIWIevJa
	73UjIFyTuYvjfUonmRUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



在 2025/09/02 0:48, Kenta Akagi 写道:
> In the current raid1_end_write_request implementation,
> - md_error is called only in the Failfast case.
> - Afterwards, if the rdev is not Faulty (that is, not Failfast,
>    or Failfast but the last rdev — which originally was not expected
>    MD_BROKEN in RAID1), R1BIO_WriteError is set.
> In the suggested implementation, it seems that a non-Failfast write
> failure will immediately mark the rdev as Faulty, without retries.

I still prefer a common helper to unify the code, not sure if I still
missing something ...

In general, if bio failed, for read/write/metadata/resync should be the
same:

1) failfast is set, and not last rdev, md_error();
2) otherwise, we should always retry;

And I do believe it's the best to unify this by a common helper.

Thanks,
Kuai

