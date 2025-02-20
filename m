Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C6D318E764;
	Thu, 20 Feb 2025 01:26:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740014789; cv=none; b=UZwwRq7Y4jamGQ8beMxmqhDZcGc/xGod2/06Uu+ByTnDVGgtkUDq0zti7CHfJif64cQz0YAXnPLWIcqXknPqP70o81EdWcOb4j0uIcW2/6zupU3yY+kQ9pVPFsowxK491Gc4i6bNHUEax16EZ+NUj3RhQe/IcvUo/J4fn4i4Z2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740014789; c=relaxed/simple;
	bh=qHqw7d0Dy9+Jz8Z1/WmafpVDTwsuQJqBRFoaDInvTME=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=NQHJnNpKwQLsDJwqUZsObHtMmwewQKq8eDrEb5COh1FB9OWsbOMRyStWO5EdUAOnqNO7uEewIoqeLKlUauU4sDzFBCNQ6WeFN6ePf0oHQqiphD6/qiEP39j2BTeSfW1yK4eGn6Ry2au1qzYkzmRUSZGZFQy9cszE1WB2jH0e73Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YywZQ1dKJz4f3jsy;
	Thu, 20 Feb 2025 09:26:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 847771A155D;
	Thu, 20 Feb 2025 09:26:22 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1+8hLZnMhtiEQ--.54113S3;
	Thu, 20 Feb 2025 09:26:22 +0800 (CST)
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
To: Guillaume Morin <guillaume@morinfr.org>, linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, song@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <Z7Y0SURoA8xwg7vn@bender.morinfr.org>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
Date: Thu, 20 Feb 2025 09:26:20 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <Z7Y0SURoA8xwg7vn@bender.morinfr.org>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m1+8hLZnMhtiEQ--.54113S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYI7kC6x804xWl14x267AKxVWUJVW8JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v26r126r1DMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
	nIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi

ÔÚ 2025/02/20 3:43, Guillaume Morin Ð´µÀ:
> There seems to be nothing in the code that tries to prevent this
> specific race

Did you noticed that mddev_get() is called from md_notify_reboot() while
the lock is still held, and how can mddev_free() can race here if
mddev_get() succeed?

Thanks,
Kuai

