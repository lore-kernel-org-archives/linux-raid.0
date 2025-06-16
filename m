Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32247E1
	for <linux-raid@vger.kernel.org>; Mon, 16 Jun 2025 01:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750036685; cv=none; b=Ew/VloQQnxROxN7j1D5hghubTz/jhc3ovkQD+bqRhltlAE5R70185XpA9/ogxmetG32+akRVIPzRFT6oB1XS3NzrOeIly04oARRzMDBDdYoCn8mE3U6Stw5FK2ES4T3UlTjlPB7ovjNXp0BLO6f4nQoxwHMeZcYMZ0QNg7TtyWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750036685; c=relaxed/simple;
	bh=efv8oDaydoXK3S94ObIoeCSejPswlPTyh1PlQ+oEdvI=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=Y8prPE+7Yje9ZiI+JaLtnoMBYwO6f5bcBTr51RljddlbaRe24imSIy/lLm/dXXvurpyetxn+lGoYKtrweMqLt1BE/tZSS5Wn5DtKrdX9UW+PHWXpBob/NQYl5lIJe+XjnHLc03GkWnmQit4WYsG1jp85sUpM5gYM9eyUnHY67mc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bLBvR0gCBzKHMlm
	for <linux-raid@vger.kernel.org>; Mon, 16 Jun 2025 09:17:55 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 72F2C1A07C0
	for <linux-raid@vger.kernel.org>; Mon, 16 Jun 2025 09:17:53 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgAni1+9cE9on2GaPg--.32454S3;
	Mon, 16 Jun 2025 09:17:51 +0800 (CST)
Subject: Re: [PATCH V6 0/3] md: call del_gendisk in sync way
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com, song@kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611073108.25463-1-xni@redhat.com>
 <b94ee45c-06ea-1d4d-8a88-7a88db1f0b6f@huaweicloud.com>
 <CALTww29pNN2QxyFZp1P+qm2=xeuBNGBH9JmJNY64vMkBjPumCw@mail.gmail.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <8ff80111-33dd-40c6-cf84-cd99090e2f0f@huaweicloud.com>
Date: Mon, 16 Jun 2025 09:17:49 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <CALTww29pNN2QxyFZp1P+qm2=xeuBNGBH9JmJNY64vMkBjPumCw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAni1+9cE9on2GaPg--.32454S3
X-Coremail-Antispam: 1UD129KBjvJXoW7ZFyrGr4xZr4fWrW7Gw4UJwb_yoW8uF1xpF
	y3XFya9r1DtFy7Ca4Sqw18GFyftwn3ZFy8Kry3Wwn2vFy0vrnF9F17Jws5CFyDXFZ7Wa1q
	93W8X3W3Wr1Fy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Jr0_GrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/15 11:21, Xiao Ni 写道:
> On Sat, Jun 14, 2025 at 4:18 PM Yu Kuai <yukuai1@huaweicloud.com> wrote:
>>
>> Hi,
>>
>> 在 2025/06/11 15:31, Xiao Ni 写道:
>>> Now del_gendisk is called in a queue work which has a small window
>>> that mdadm --stop command exits but the device node still exists.
>>> It causes trouble in regression tests. This patch set tries to resolve
>>> this problem.
>>>
>>> v1: replace MD_DELETED with MD_CLOSING
>>> v2: keep MD_CLOSING
>>> v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop path
>>> and adjust the order of patches
>>> v4: only remove the codes in stop path.
>>> v5: remove sysfs_remove in md_kobj_release and change EBUSY with ENODEV
>>> v6: don't initialize ret and add reviewed-by tag
>>>
>>> Xiao Ni (3):
>>>     md: call del_gendisk in control path
>>>     md: Don't clear MD_CLOSING until mddev is freed
>>>     md: remove/add redundancy group only in level change
>>>
>>>    drivers/md/md.c | 49 ++++++++++++++++++++++++++-----------------------
>>>    drivers/md/md.h | 26 ++++++++++++++++++++++++--
>>>    2 files changed, 50 insertions(+), 25 deletions(-)
>>>
>>
>> Just running mdadm tests with loop dev in my VM, and found this set can
>> cause many tests to fail, the first is 02r5grow:
>>
>> ++ /usr/sbin/mdadm -A /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
>> ++ rv=1
>> ++ case $* in
>> ++ cat /var/tmp/stderr
>> mdadm: Unable to initialize sysfs
>> ++ return 1
>> ++ check state UUU
>> ++ case $1 in
>> ++ grep -sq 'blocks.*\[UUU\]$' /proc/mdstat
>> ++ die 'state UUU not found!'
>> ++ echo -e '\n\tERROR: state UUU not found! \n'
>>
>>       ERROR: state UUU not found!
>>
>> ++ save_log fail
>>
>> I do not look into details yet.
>> Thanks
>>
> 
> Hi Kuai
> 
> You need to use the latest upstream mdadm code
> https://github.com/md-raid-utilities/mdadm/
> 

I use the repo from:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git

With the latest commit:
8da27191 ("mdadm: enable sync file for udev rules")

Do we not update mdadm here?

I'll run the test soon, and BTW, wahy in the above commit, test can
pass before this set?

Thanks,
Kuai

