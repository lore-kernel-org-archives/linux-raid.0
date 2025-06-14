Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 144487462
	for <linux-raid@vger.kernel.org>; Sat, 14 Jun 2025 08:18:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749889088; cv=none; b=fq850SRUmrxq+lHGhkmenMyRLOL1Fnw+3/lxNJfwh/cTwoiI7SIIEAs5ykf4kUng5w2ntTvmE3dGtsitnHmREpSq01szpc7OZRVfgYyaBnzmpkzTic92jxreJkGm9p6iQpeKNNV9Xjvq+tMmUdkir2+vv8QWnW594coeg4/Gv3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749889088; c=relaxed/simple;
	bh=DQYmtoRc1mNNCgYg5TdW5p8G9zvbW8gUz79GS3wpaqw=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=qhi+8GAcxu68mLuk4t6gh/yHLBizY9T4TCQ4OKVNbZZStLD5at+xPd1MbafnQq/VFX1Vwt6n5RjujK1ICYDeF/N6+rMvuL0OF+40kehQU1W3mr2ifp7Qaa03p04APzVzgH2dzVujO+5QZ3t6qJhAIgPB8OksVt8jvsn+ChxltM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bK8K84jV0zKHMs9
	for <linux-raid@vger.kernel.org>; Sat, 14 Jun 2025 16:18:04 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0969D1A1684
	for <linux-raid@vger.kernel.org>; Sat, 14 Jun 2025 16:18:03 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgBHrGA5ME1oL9fpPQ--.64743S3;
	Sat, 14 Jun 2025 16:18:02 +0800 (CST)
Subject: Re: [PATCH V6 0/3] md: call del_gendisk in sync way
To: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org
Cc: ncroxon@redhat.com, song@kernel.org, yukuai1@huaweicloud.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20250611073108.25463-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <b94ee45c-06ea-1d4d-8a88-7a88db1f0b6f@huaweicloud.com>
Date: Sat, 14 Jun 2025 16:18:01 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20250611073108.25463-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHrGA5ME1oL9fpPQ--.64743S3
X-Coremail-Antispam: 1UD129KBjvJXoW7WFyftFWrKrWrGFWxXr4kXrb_yoW8Xr43pF
	9xGFya9ryUta1akFyfXw4xGa43Jw1xZFy8Kry3Wr97ZF1Fvr1kur9rt3Wv9FyDGFZrWa1j
	gw18XF15uF18taDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvC14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26F4j
	6r4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oV
	Cq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0
	I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r
	4UM4x0Y48IcVAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwCYjI0SjxkI62AI1cAE67vI
	Y487MxkF7I0En4kS14v26r126r1DMxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r
	1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CE
	b7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0x
	vE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAI
	cVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2Kf
	nxnUUI43ZEXa7VUbSfO7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2025/06/11 15:31, Xiao Ni Ð´µÀ:
> Now del_gendisk is called in a queue work which has a small window
> that mdadm --stop command exits but the device node still exists.
> It causes trouble in regression tests. This patch set tries to resolve
> this problem.
> 
> v1: replace MD_DELETED with MD_CLOSING
> v2: keep MD_CLOSING
> v3: call den_gendisk in mddev_unlock, and remove ->to_remove in stop path
> and adjust the order of patches
> v4: only remove the codes in stop path.
> v5: remove sysfs_remove in md_kobj_release and change EBUSY with ENODEV
> v6: don't initialize ret and add reviewed-by tag
> 
> Xiao Ni (3):
>    md: call del_gendisk in control path
>    md: Don't clear MD_CLOSING until mddev is freed
>    md: remove/add redundancy group only in level change
> 
>   drivers/md/md.c | 49 ++++++++++++++++++++++++++-----------------------
>   drivers/md/md.h | 26 ++++++++++++++++++++++++--
>   2 files changed, 50 insertions(+), 25 deletions(-)
> 

Just running mdadm tests with loop dev in my VM, and found this set can
cause many tests to fail, the first is 02r5grow:

++ /usr/sbin/mdadm -A /dev/md0 /dev/loop1 /dev/loop2 /dev/loop3
++ rv=1
++ case $* in
++ cat /var/tmp/stderr
mdadm: Unable to initialize sysfs
++ return 1
++ check state UUU
++ case $1 in
++ grep -sq 'blocks.*\[UUU\]$' /proc/mdstat
++ die 'state UUU not found!'
++ echo -e '\n\tERROR: state UUU not found! \n'

     ERROR: state UUU not found!

++ save_log fail

I do not look into details yet.
Thanks

