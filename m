Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11865150997
	for <linux-raid@vger.kernel.org>; Thu,  6 Feb 2025 07:16:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738826166; cv=none; b=asbDkf12UdK+tr7J14YaNULYCUpTGsmpRCOUzijM0iral4cvJnP8Gh/FGWEdj8VIQuxGD/jsgzt4H3bctGWCKG0RPT1K4QFfGgNQcdJT2YIYz1rbhzz2ZYIROFIPp/djVUlaaFXrs0ThNAiyb6s5Z3Gn+eseuxznEEUBUbA7ZGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738826166; c=relaxed/simple;
	bh=WGSFTqaE5LqXEp7cH2mmtrxtEJ+g2EcL3GFHNqN6yEs=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=gUfTMARByqsonawXqBm5HZx+yxzj0ONT9d6U7TH87iJk3dHPDK17f++g/wPLBmW9u/bvHldpEmO1sFB8pRstAU9135mlpwrYrwQlU2LZDOJQzUusx6qujycwYBXbxN5Og2gbVe0yZQ4OpYGUWxsZ1FUcOCsS5tO6VuSwlusUvUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YpT086Lxkz4f3jMB
	for <linux-raid@vger.kernel.org>; Thu,  6 Feb 2025 15:15:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 61D681A0A54
	for <linux-raid@vger.kernel.org>; Thu,  6 Feb 2025 15:15:59 +0800 (CST)
Received: from [10.174.179.143] (unknown [10.174.179.143])
	by APP4 (Coremail) with SMTP id gCh0CgDHK2CtYaRnSYs4DA--.32358S3;
	Thu, 06 Feb 2025 15:15:59 +0800 (CST)
Subject: Re: replaced all drives in RAID-10 array with larger drives ->
 failing to correctly extend array to use new/add'l space.
To: pgnd@dev-mail.net, linux-raid@vger.kernel.org,
 "yukuai (C)" <yukuai3@huawei.com>
References: <b57aabc1-cb65-411c-b79c-ee8aa3fb849f@dev-mail.net>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <6080a9ca-0f9d-a309-9743-de98e67851f5@huaweicloud.com>
Date: Thu, 6 Feb 2025 15:15:57 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <b57aabc1-cb65-411c-b79c-ee8aa3fb849f@dev-mail.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDHK2CtYaRnSYs4DA--.32358S3
X-Coremail-Antispam: 1UD129KBjvdXoW7Gw4rCF15Ar1DZr4kCw47XFb_yoWkKFc_CF
	4DZry7W3srArZ2kr17tr4xXr4DGw1fKFWkZ3yxurnrAw48WanxArs0qFZYkr18Cr4xJry2
	qr1UWw1Sva4v9jkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUIcSsGvfJTRUUUbzxYFVCjjxCrM7AC8VAFwI0_Jr0_Gr1l1xkIjI8I6I8E6xAIw20E
	Y4v20xvaj40_Wr0E3s1l1IIY67AEw4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwV
	A0rcxSw2x7M28EF7xvwVC0I7IYx2IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x02
	67AKxVWxJr0_GcWl84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2
	j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7x
	kEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vIY487MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUXVWUAwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7IU1CPfJUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2025/01/30 0:12, pgnd 写道:
>                      Layout : far=2
>                  Chunk Size : 512K

I assume you created the array with layout=f2, and this layout doesn't
support resize. mdadm in my VM print the error message:

[root@fedora ~]# mdadm --grow /dev/md0 --size=max
mdadm: failed to write '0' to '/sys/block/md0/md//component_size' 
(Invalid argument)
mdadm: Cannot set device size for /dev/md0: Invalid argument

The error is returned from kernel:

static int raid10_resize(struct mddev *mddev, sector_t sectors)
{
         /* Resize of 'far' arrays is not supported.
         ┊* For 'near' and 'offset' arrays we can set the
         ┊* number of sectors used to be an appropriate multiple
         ┊* of the chunk size.
         ┊* For 'offset', this is far_copies*chunksize.
         ┊* For 'near' the multiplier is the LCM of
         ┊* near_copies and raid_disks.
         ┊* So if far_copies > 1 && !far_offset, fail.
         ┊* Else find LCM(raid_disks, near_copy)*far_copies and
         ┊* multiply by chunk_size.  Then round to this number.
         ┊* This is mostly done by raid10_size()
         ┊*/
         if (conf->geo.far_copies > 1 && !conf->geo.far_offset)
                 return -EINVAL;

Thanks,
Kuai

