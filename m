Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B142A33998
	for <linux-raid@vger.kernel.org>; Sun, 26 Jan 2025 08:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737879788; cv=none; b=Kna5hQyKKkO6OOdHhQia69IUwbntzlG7x+Y8GIENEfNIFLsP20aMzPvvALakSumpBVGJjeSaTmCUfg1cowz/+8Y5Hs+Im0Hh2HZW918tzwRxjDwLcuj2wVw1rfksIBW6GCkqMkvDClUGproDfHyz6TpzW/e2J0wS6lZJ01EmRgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737879788; c=relaxed/simple;
	bh=4zPQytZ9B0PwY1+E3R8+N5pqzpukqud/fiLIBI89Bs8=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=a0x83RSRn+AZtyv34hqDusu9Dh1cAe+truY+bJJeM916UaSGlT5/SRYnupSJ4Z8MbNlDONN/5b7ayxOuhnCTQhMdPHmhBG5lQngjvKajcI1eZ+cKOTBshk2EqwpwwZZA7X7Owd7TEN7L3X2kMOqsP9LH+jENPgg8Rp02oarNbOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Ygl0b3jN4z4f3jMj
	for <linux-raid@vger.kernel.org>; Sun, 26 Jan 2025 16:22:39 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 4961C1A084F
	for <linux-raid@vger.kernel.org>; Sun, 26 Jan 2025 16:23:00 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP3 (Coremail) with SMTP id _Ch0CgAXa8Xi8JVnWGP+Bw--.49900S3;
	Sun, 26 Jan 2025 16:23:00 +0800 (CST)
Subject: Re: [PATCH] mdadm: fix --grow with --add for linear
To: Mariusz Tkaczyk <mtkaczyk@kernel.org>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, yangerkun@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20241227060702.730184-1-yukuai1@huaweicloud.com>
 <20241231094952.1fad40bb@mtkaczyk-private-dev>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <825cd5bf-9e3c-61c1-0cf0-3b46cfb21d53@huaweicloud.com>
Date: Sun, 26 Jan 2025 16:22:58 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20241231094952.1fad40bb@mtkaczyk-private-dev>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgAXa8Xi8JVnWGP+Bw--.49900S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJryrKr4DJFyrGFy7ArWrKrg_yoW8Cr1rpF
	4S93WYyFZ7GrZrua47A3yUZa98Kr4kur1xZr93tr1FyFn8GFnavw4xKaySkF15uFs3ua4q
	gFnrA3y3CFyFvFDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvK14x267AKxVW8JVW5JwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4AK67xGY2AK02
	1l84ACjcxK6xIIjxv20xvE14v26F1j6w1UM28EF7xvwVC0I7IYx2IY6xkF7I0E14v26r4U
	JVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_Gc
	CE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E
	2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJV
	W8JwACjcxG0xvEwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lc7I2V7IY0VAS07AlzVAY
	IcxG8wCY1x0262kKe7AKxVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbV
	WUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF
	67kF1VAFwI0_JF0_Jw1lIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42
	IY6xIIjxv20xvEc7CjxVAFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF
	0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxh
	VjvjDU0xZFpf9x0JUBVbkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/



ÔÚ 2024/12/31 16:49, Mariusz Tkaczyk Ð´µÀ:
> On Fri, 27 Dec 2024 14:07:02 +0800
> Yu Kuai <yukuai1@huaweicloud.com> wrote:
> 
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> For the case mdadm --grow with --add, the s.btype should not be
>> initialized yet, hence BitmapUnknown should be checked instead of
>> BitmapNone.
> 
> Hi Kuai,
> 
> For commit extra clarity it would be nice to include command you are
> executing.
> 
> What if someone will do (not tested):
> #mdadm --grow /dev/md0 --add /dev/sdx --bitmap=none
> 
> I think that it is perfectly valid, now it may work but I expect your
> change to broke it.

Hi,

Sorry for the late reply, I forgot about this patch somehow :(

Changes from commit 581ba1341017:

@@ -1634,7 +1625,7 @@ int main(int argc, char *argv[])
                 if (devs_found > 1 && s.raiddisks == 0 && s.level == 
UnSet) {
                         /* must be '-a'. */
                         if (s.size > 0 || s.chunk ||
-                           s.layout_str || s.bitmap_file) {
+                           s.layout_str || s.btype != BitmapNone) {
                                 pr_err("--add cannot be used with other 
geometry changes in --grow mode\n");
                                 rv = 1;
                                 break;


Hence before the commit, bitmap=none is not valid in this case as well,
because s.bitmap_file will set to "none" in this case.

Thanks,
Kuai

> 
> I would say we need:
> 
> bool is_bitmap_set(struct shape *s) {
> 	if (s.layout)
> 		return true;
> 	if (s.btype == BitmapNone || s.btype != BitmapUnknown)
> 		return false;
> 
> 	return true;
> }
> 
> And respect both cases. Setting property to default should never be a
> mistake.
> 
> Has it some sense? If no, I miss some explanation in commit message (or
> better comment).
> 
>>
>> Noted that this behaviour should only support by md-linear, which is
>> removed from kernel, howerver, it turns out md-linear is used widely
>> in home NAS and we're planning to reintroduce it soon.
> 
> Wow. We get a lesson.
> 
> For the code, LGTM.
> 
> Thanks,
> Mariusz
> 
> .
> 

