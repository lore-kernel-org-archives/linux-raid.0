Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 315B7208CA;
	Mon, 30 Jun 2025 02:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751250350; cv=none; b=KTHld3YiiKxvh0Ae6yJsBH5dMxHnVVsPpF2s22QLZEgTTh9i9aFAvjVfN0DGDempBnsTycm/MEVUr9lkgokoBiUQoIQYHW3pdXSaaW1VFvwILc0cUOChswEzL32ajLiCfJNQ8iYPEmNOBT1lhmx2lDySwdcamnJWTTH2zT3iDhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751250350; c=relaxed/simple;
	bh=ErF81TCjGCGVqMh8Fd4KAmWoyGhITyp7N04uBQ5N5tA=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=n9MXlE896dzlAiynOcGZjQ7axCOeZKb0B7iA9L67BqxG4LkhTUmyzA9MY9eIefTPuYhmZhuCCNq7TcRUS0OqbLrBuCKjLl9G+hf2/rIryya6MUDnIWP0fc30XIW9Aoj4fR3setPVlzQzfmNDE8O9yZS5EasMRCxUmXMd0A95Enw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bVql85dF8zYQv5V;
	Mon, 30 Jun 2025 10:25:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A83281A1915;
	Mon, 30 Jun 2025 10:25:39 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgB32Sai9WFo7x6rAA--.46414S3;
	Mon, 30 Jun 2025 10:25:39 +0800 (CST)
Subject: Re: [PATCH 16/23] md/md-llbitmap: implement bit state machine
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de,
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <20250524061320.370630-17-yukuai1@huaweicloud.com>
 <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cf6d7be1-af73-216c-b2ab-b34a8890450d@huaweicloud.com>
Date: Mon, 30 Jun 2025 10:25:38 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <c76f44c0-fc61-41da-a16b-5a3510141487@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgB32Sai9WFo7x6rAA--.46414S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYK7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E
	6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28Cjx
	kF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8I
	cVCY1x0267AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87
	Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE
	6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r106r15McIj6I8E87Iv67AKxVWUJVW8JwAm72
	CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4II
	rI8v6xkF7I0E8cxan2IY04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr4
	1l4c8EcI0Ec7CjxVAaw2AFwI0_Jw0_GFyl4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAq
	x4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r
	43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF
	7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxV
	WUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfU
	F9a9DUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/30 10:14, Xiao Ni 写道:
> For reload action, it runs continue here.

No one can concurent with reload.

> 
> And doesn't it need a lock when reading the state?

Notice that from IO path, all concurrent context are doing the same
thing, it doesn't matter if old state or new state are read. If old
state is read, it will write new state in memory again; if new state is
read, it just do nothing.

Thanks,
Kuai

