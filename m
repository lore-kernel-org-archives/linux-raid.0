Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400832F4A;
	Tue, 30 Sep 2025 01:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759195664; cv=none; b=IGRtXstjyMvJNM1tWc7FxN430UeFzWEjYv+SIYYfBS/dS7yQwVaKfp16xPHuNNAL5ftNIVLXH0qawHdhP4UJkXYu4cRAE+JiNeGLxxkpwY7CKzg1jl1p6o5RcPLDzsblHf6B4c0MbRmeWXOSXlZqZsKk1hN9MMBY+twU5q9iU1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759195664; c=relaxed/simple;
	bh=crg5j1haLc7oDUqUh2tD6arKs1YW34PYR5D9SWytzmI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gXY0HEhMyQ4SnnLxa+NMsY/b6KfNysOO+A18KfwneF33N5fE9+J7GCAHHMx5bDj9d1CosolB8uNROe7cEYv+mrr6JWG45YMjvwsoOhvFyK4nwN2CUhSv8CbJXsRD8jx/hQi8BpS5EOTxLFpw2vCWFqT+LFLbDQKeUjg+OfuMv90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cbL5N5Sz6zYQtwK;
	Tue, 30 Sep 2025 09:27:20 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 9310D1A06DF;
	Tue, 30 Sep 2025 09:27:37 +0800 (CST)
Received: from [10.174.179.80] (unknown [10.174.179.80])
	by APP4 (Coremail) with SMTP id gCh0CgCXW2MHMttoTdIcBQ--.40319S3;
	Tue, 30 Sep 2025 09:27:37 +0800 (CST)
Message-ID: <f587899a-0064-4ae6-8424-bb01704b582a@huaweicloud.com>
Date: Tue, 30 Sep 2025 09:27:35 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH blktests] md/004: add unmap write zeroes tests
To: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc: "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "yi.zhang@huawei.com" <yi.zhang@huawei.com>,
 "yukuai3@huawei.com" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <20250926060847.3003653-1-yi.zhang@huaweicloud.com>
 <lkyvsmrsep4dh7tfunhplltezt64g7rvsbjdknhdk27xby7hox@j23hyvhr73m3>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <lkyvsmrsep4dh7tfunhplltezt64g7rvsbjdknhdk27xby7hox@j23hyvhr73m3>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:gCh0CgCXW2MHMttoTdIcBQ--.40319S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Ww1DWFWUJr17Jr1kJw4UCFg_yoW8tF1fpa
	yxGFWrKrn7KF17C3WfZF1j9FyrAwn3trW5Kr1xGry5Ar98Xr1SgayIgryagryxJr1fGw10
	yFs0gFyfC3WjyrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUymb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vI
	r41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8Gjc
	xK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE2Ix0
	cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8V
	AvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E
	14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UK2NtUUUUU=
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/

On 9/29/2025 9:21 PM, Shinichiro Kawasaki wrote:
> On Sep 26, 2025 / 14:08, Zhang Yi wrote:
>> From: Zhang Yi <yi.zhang@huawei.com>
>>
>> The MD linear and RAID0 drivers in the Linux kernel now support the
>> unmap write zeroes operation. Test block device unmap write zeroes sysfs
>> interface with these two stacked devices. The sysfs parameters should
>> inherit from the underlying SCSI device. We can disable write zeroes
>> support by setting /sys/block/md<X>/queue/write_zeroes_unmap_max_bytes
>> to zero.
>>
>> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> 
> Hello Zhang, thanks for the patch. Overall, it looks good to me. Please
> find a couple of nit comments below.
> 
>> ---
>>  tests/md/004     | 97 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  tests/md/004.out |  2 +
>>  2 files changed, 99 insertions(+)
>>  create mode 100755 tests/md/004
>>  create mode 100644 tests/md/004.out
>>
>> diff --git a/tests/md/004 b/tests/md/004
>> new file mode 100755
>> index 0000000..a3d7578
>> --- /dev/null
>> +++ b/tests/md/004
>> @@ -0,0 +1,97 @@
>> +#!/bin/bash
>> +# SPDX-License-Identifier: GPL-3.0+
>> +# Copyright (C) 2025 Huawei.
>> +#
>> +# Test block device unmap write zeroes sysfs interface with MD devices.
> 
> I guess this test confirms the fix by the kernel commit f0bd03832f5c ("md: init
> queue_limits->max_hw_wzeroes_unmap_sectors parameter"), right? If so, I suggest
> to add here the short description like,
> 
> # Regression test for commit f0bd03832f5c ("md: init
> # queue_limits->max_hw_wzeroes_unmap_sectors parameter")
> 
>> +
>> +. tests/dm/rc
>> +. common/scsi_debug
>> +
>> +DESCRIPTION="test unmap write zeroes sysfs interface with MD devices"
>> +QUICK=1
>> +
>> +requires() {
>> +	_have_program mdadm
> 
> This check for mdadm command is not required since it is done by
> group_requires() in tests/md/rc.
> 
> 
> If you agree with my comments, I can fold in the two changes when I apply this
> patch. Please let me know your thoughts.

Hi Shinichiro, thank you for your review and suggestions. They both looks good
to me, please apply these changes. Besides, I noticed that I referenced the
wrong rc file(tests/dm/rc). Please correct it as well. Thank you.

Regards,
Yi.

