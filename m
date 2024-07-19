Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8721145003
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 07:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721372555; cv=none; b=gOmgryX51Jn4MDxU/CyuUjUDHZSMlLT8v2fVbE0V/pt6KxqN6/oDFtmLH56tccgVvboNmszFR4+J+X3cDvR0jancBiFjMDWxGUuaLQ2eOdwP8L97kvtE9s3ktFwBrsOgDwY44QfDanPBp/kbuOEgJH+27eejGkJvGHJ5l4xeGt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721372555; c=relaxed/simple;
	bh=/ld20oHQ44/QHu2hCMdw0BJLpwEK6QBhmTzSiRFvWMg=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=h7MIl1qo3VNe2ZWlTmmlx4nVTYg4VD+vC84mKvctidTlsOujoUtCJuPj6x7GmxH4P+4tFfto2P9K/3VmQA31Wf8ekzSDU9avDDimw/4BEs2FT0oaac0X+ryWuLgHlvwgX5c4lkTUe96Sr0S46SypFmWCs/i4dAvQxiP7EYxFfVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WQLG05R8Mz4f3jHl
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 15:02:16 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id E22FF1A016E
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 15:02:28 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgCXyDaBD5pmaJw1Ag--.31306S3;
	Fri, 19 Jul 2024 15:02:26 +0800 (CST)
Subject: Re: IMSM: Drive removed during I/O is set to faulty but not removed
 from volume
To: Mateusz Kusiak <mateusz.kusiak@linux.intel.com>,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>,
 "yangerkun@huawei.com" <yangerkun@huawei.com>
References: <f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <f3d0f203-f9b9-04c1-e5a0-d61fc5c6c0d2@huaweicloud.com>
Date: Fri, 19 Jul 2024 15:02:25 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <f34452df-810b-48b2-a9b4-7f925699a9e7@linux.intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCXyDaBD5pmaJw1Ag--.31306S3
X-Coremail-Antispam: 1UD129KBjvJXoWxAw1fXF1fKr4kJF13JrWrKrg_yoW5Wr1fpF
	Wxt3s0kr4rJw1xG3yDAa18WFy5tw40grWUCr9xWw1rCF45GFn2vFZakan8AF9I9ay2k3ya
	vw48Kwn8WryvvaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyKb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUzsqWUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



在 2024/07/18 22:57, Mateusz Kusiak 写道:
> Hello,
> recently we discovered an issue regarding drive removal during I/O.
> 
> Description:
> Drive removed during I/O from IMSM R1D2 array is being set to faulty but 
> is not removed from a volume. I/O on the array hangs.
> 
> The scenario is as follows:
> 1. Create R1D2 IMSM array.
> 2. Create single partition, format it as ext4 and mount is somewhere.
> 3. Start multiple checksum tests processes (more on that below) and wait 
> a while.
> 4. Unplug one RAID member.
> 
> About "Checksum test":
> Checksum test creates ~3GB file and calculates it's checksum twice. It 
> basically does the following:
> # dd if=/proc/kcore bs=1024 count=3052871 status=none | tee <filename> | 
> md5sum
> ...and then recalculates checksum to verify if it matches.
> In this scenario we use it to simulate I/O, by running multiple tests.
> 
> Expected result:
> Raid member is removed from the volume and the container, array 
> continues operation on one drive.
> 
> Actual result:
> Raid member is set to faulty on volume and does not disappear (it's not 
> removed), but it is removed from a container. I\O on mounted volume hangs.
> 
> Additional notes:
> The issue reproduces on kernel-next. We bisected that potential cause of 
> the issue might be patch "md: use new apis to suspend array for 
> adding/removing rdev from state_store()" 
> (cfa078c8b80d0daf8f2fd4a2ab8e26fa8c33bca1) as it's the first one we 
> observe the issue on our reproduction setup.
> 
> Having said that, we also observed the issue for example on SLES15SP6 
> with kernel 6.4.0-150600.10-default, which might indicate that the 
> problem was here, but became apparent for some reason (race-condition or 
> something else).

Hi,

With some discussion and log collection, looks like this is a deadlock
introduced by:

https://lore.kernel.org/r/20230825031622.1530464-8-yukuai1@huaweicloud.com

Root cause is that:

1) New io is blocked because array is suspended;
2) md_start_sync suspend the array, and it's waiting for inflight IO to 
be done;
3) inflight IO is waiting for md_start_sync to be done, from
md_start_write->flush_work().

Can you give following patch a test?

Thanks!
Kuai

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 64693913ed18..10c2d816062a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8668,7 +8668,6 @@ void md_write_start(struct mddev *mddev, struct 
bio *bi)
         BUG_ON(mddev->ro == MD_RDONLY);
         if (mddev->ro == MD_AUTO_READ) {
                 /* need to switch to read/write */
-               flush_work(&mddev->sync_work);
                 mddev->ro = MD_RDWR;
                 set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
                 md_wakeup_thread(mddev->thread);

> 
> I will work on simplifying the scenario and try to provide script for 
> reproduction.
> 
> Thank,
> Mateusz
> 
> .
> 

