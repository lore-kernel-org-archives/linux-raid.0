Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32A7D185B61;
	Mon, 30 Jun 2025 02:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751250884; cv=none; b=XWochNjOYe5wEbTYJgKg2hIcRygC2nSeg0K+yQDES0mHd6TqFzXdqfaKFcqynTR5Yt2P1UYLrwFZs58KssETCp/ib6PV1GKZk5uew1HDps07BKshdW21++f4JnD9vuAIEQP4mR+/9IXcU5p3Wte4j+Ow5T1vq8Lg+aCFwcVetBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751250884; c=relaxed/simple;
	bh=RIemBj2DXyd5P39hVlUKFpLDK1tXwVPtM1Qh6kNs7LU=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V2KMy53Sdh0G02BHCzI/OjDjcbONTcuoMMiKIgMmIuW79nSKLS8GPvmvN9BLgSTgvHcnsE15DQ6jWFFkzwCjjkjafumr/EyazN9qrKlV/dqF2pZqs9GWIAmGZzJoahKHfhaQ+/BeSQxHQ/f/XNG3VQUyfLzU/e4gGx+6tD/1Vc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bVqxY2Bk6zKHMqv;
	Mon, 30 Jun 2025 10:34:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id AC5651A115D;
	Mon, 30 Jun 2025 10:34:39 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP3 (Coremail) with SMTP id _Ch0CgBHpyS992Fo2sSrAA--.36797S3;
	Mon, 30 Jun 2025 10:34:39 +0800 (CST)
Subject: Re: [PATCH 00/23] md/llbitmap: md/md-llbitmap: introduce a new
 lockless bitmap
To: Xiao Ni <xni@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>, hch@lst.de,
 colyli@kernel.org, song@kernel.org
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 johnny.chenyi@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
References: <20250524061320.370630-1-yukuai1@huaweicloud.com>
 <808d3fb3-92a9-4a25-a70c-7408f20fb554@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <288be678-990b-86f9-1ffd-858cee18eef3@huaweicloud.com>
Date: Mon, 30 Jun 2025 10:34:37 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <808d3fb3-92a9-4a25-a70c-7408f20fb554@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgBHpyS992Fo2sSrAA--.36797S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tFy5Gr4xXFW7KF4kCF17Wrg_yoW8Gr4rpa
	n7Zw13Gws8Ga1SgrZrZ3yIyF4Ikrn3Jry2qrn5twn3CFn5GFnagFsYgFW5Za4UWr9aqF1U
	Zr4rGrZ5CF4DZFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBF14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_JrI_JrylYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2ka
	0xkIwI1lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x
	0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E
	7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcV
	C0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF
	04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7
	CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUZYFZUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/06/30 9:59, Xiao Ni 写道:
> 
> After reading other patches, I want to check if I understand right.
> 
> The first write sets the bitmap bit. The second write which hits the 
> same block (one sector, 512 bits) will call llbitmap_infect_dirty_bits 
> to set all other bits. Then the third write doesn't need to set bitmap 
> bits. If I'm right, the comments above should say only the first two 
> writes have additional overhead?

Yes, for the same bit, it's twice; For different bit in the same block,
it's third, by infect all bits in the block in the second.

  For Reload action, if the bitmap bit is
> NeedSync, the changed status will be x. It can't trigger resync/recovery.

This is not expected, see llbitmap_state_machine(), if old or new state
is need_sync, it will trigger a resync.

c = llbitmap_read(llbitmap, start);
if (c == BitNeedSync)
  need_resync = true;
-> for RELOAD case, need_resync is still set.

state = state_machine[c][action];
if (state == BitNone)
  continue
if (state == BitNeedSync)
  need_resync = true;

> 
> For example:
> 
> cat /sys/block/md127/md/llbitmap/bits
> unwritten 3480
> clean 2
> dirty 0
> need sync 510
> 
> It doesn't do resync after aseembling the array. Does it need to modify 
> the changed status from x to NeedSync?

Can you explain in detail how to reporduce this? Aseembling in my VM is
fine.

Thanks,
Kuai

