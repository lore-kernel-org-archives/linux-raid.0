Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E48E820C461;
	Sun,  4 Jan 2026 02:06:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767492418; cv=none; b=oHjuL6dZbzBlWdouxpa/6aDuT0PSvHEwt4B0B1uRlnWBx+/2hgXIw/3TMoWLFe+DJESNJFE4qlaGz6rxyKFuj35b9XHKm3o/abuu1qF+bBgPeQEho0yV81uOe0bbFIEcUrwJqJn+QGYHN3DZSYXScjuZOPKLDfAAFP7dfzON8z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767492418; c=relaxed/simple;
	bh=wAhZQGea4ah3ek5m0cpHf4U8O+j8LRTQvGZd/w/v8wA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q7CRzKqEi/Y7UzVvab1oX4N2uJIGgTIXSsJyL7bGhIBRUKKSMUrxM/dmG78RhP2sJZaaBIMJWeECw2n8MPwo7UMSRdozSgiDJze3K7dxUsd24zTkRrAGV2oe6C7d9vOEup/1RCoWQe/NwIOE+OA+KmqMyyegXEQE1qEzuC/nyUI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dkLPd02ryzYQtwP;
	Sun,  4 Jan 2026 10:05:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 695934056D;
	Sun,  4 Jan 2026 10:06:53 +0800 (CST)
Received: from [10.174.178.72] (unknown [10.174.178.72])
	by APP4 (Coremail) with SMTP id gCh0CgBHp_c7y1lpmKY2Cg--.19312S3;
	Sun, 04 Jan 2026 10:06:53 +0800 (CST)
Message-ID: <897fa571-14df-400f-b3b4-e5da2db4edae@huaweicloud.com>
Date: Sun, 4 Jan 2026 10:06:48 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 4/5] md: introduce MAX_RAID_DISKS macro to replace
 magic number
To: John Stoffel <john@stoffel.org>
Cc: song@kernel.org, yukuai@fnnas.com, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org, yi.zhang@huawei.com, yangerkun@huawei.com,
 houtao1@huawei.com, linan122@h-partners.com, zhengqixing@huawei.com
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
 <20251231070952.1233903-5-zhengqixing@huaweicloud.com>
 <26965.25787.328101.504732@quad.stoffel.home>
From: Zheng Qixing <zhengqixing@huaweicloud.com>
In-Reply-To: <26965.25787.328101.504732@quad.stoffel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHp_c7y1lpmKY2Cg--.19312S3
X-Coremail-Antispam: 1UD129KBjvdXoW7GrW3KFyDAF4fCrW5tF4ruFg_yoWktrc_J3
	WIvFykWry8JFs7Kr4ftFs2yryS9FWxAry8Jr1fWF1v934xXa1qy3WDKF92vr98Ja98Aw1Y
	gr1FqFyI9wsxGjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbx8YFVCjjxCrM7AC8VAFwI0_Gr0_Xr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVW8Jr0_Cr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1lc7CjxVAaw2AF
	wI0_Jw0_GFyl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4
	xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r1q6r43
	MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I
	0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWU
	JVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UAwI
	DUUUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

在 2026/1/1 2:00, John Stoffel 写道:

>>   #define MaxSector (~(sector_t)0)
>> +#define MAX_RAID_DISKS ((4096-256)/2)
> Looks fine to me, except there's no explanation for the magic numbers
> here.  Sure, it's 1916 devices max, but WHY?  Other than that nit,
> looks fine.
>
In include/uapi/linux/raid/md_p.h :
/*
  * The version-1 superblock :
  * All numeric fields are little-endian.
  *
  * total size: 256 bytes plus 2 per device.
  *  1K allows 384 devices.
  */
struct mdp_superblock_1 {


1.x superblock:

Per-device state is stored as a __u16 dev_roles[] array (2 bytes per 
device) plus a fixed 256-byte header, still within a 4 KiB superblock. 
Therefore the theoretical maximum is (4096 - 256) / 2 = 1920 entries.

0.90 superblock (27 devices):

The superblock is fixed at 4 KiB (1024 32-bit words). It must store 
several fixed sections (generic + personality) and also reserves space 
for one “this_disk” descriptor in addition to the per-member disks[] 
table. Each member descriptor consumes 32 words = 128 bytes. After 
accounting for the fixed sections and the extra descriptor, the 
remaining space fits exactly 27 member descriptors.


Best regards,

Qixing

