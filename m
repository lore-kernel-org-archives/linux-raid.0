Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15A8191484
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 12:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724934279; cv=none; b=XuXWGczx4fir+XpJMXOfDyFw11pZRL1qcj0ECRP/p/qLCLACQ0GypbOeI4cAnTloC8/X0U+//sdhvu8FZNv0ZKFIZOlgen0mXhe0uzczNCRx+uMaeLdEoosxFkK6aQmI/WdBLDkMKiQLtIei/F1IneP8A5AMhdz3K7ez2zeA3tU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724934279; c=relaxed/simple;
	bh=v9WbZJadZNLOVF+0CjCXZMop2g2cpfF2Q2/0G845bqQ=;
	h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=bcPWI8Hd1hpQ+xoOU/HpQPD6JLwIHuMT1ghOjZeyumxJR8E+OIBG1Vq4twe3K79XO17rdjCDVaqvFasMflJIA9KmXXDSrhFjZz/UBBBG7UI4p2P4MKD40XbC2CkCkJQJH271RN4cNuPLO8Yao7PfTCfVLwKHOvXHEP9EwxjBTv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4WvgSd6V1Vz4f3jMl
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 20:24:17 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 8E0CE1A12F3
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 20:24:32 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXzIJ+aNBmoGszDA--.47585S3;
	Thu, 29 Aug 2024 20:24:32 +0800 (CST)
Subject: Re: [PATCH 1/1] [PATCH V2 md-6.12 1/1] md: add new_level sysfs
 interface
To: Xiao Ni <xni@redhat.com>, song@kernel.org
Cc: linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de,
 "yukuai (C)" <yukuai3@huawei.com>
References: <20240829100133.74242-1-xni@redhat.com>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <cafa231e-8ad8-05d2-80c0-f90c1b509bd1@huaweicloud.com>
Date: Thu, 29 Aug 2024 20:24:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <20240829100133.74242-1-xni@redhat.com>
Content-Type: text/plain; charset=gbk; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXzIJ+aNBmoGszDA--.47585S3
X-Coremail-Antispam: 1UD129KBjvJXoW7tw1fKrWkZFWrJw4fKr4fAFb_yoW5JF4fpa
	12yF45Zr4kt347XFnrXF4kCa45u3W8trWj93sxAw17A3WfXF1DGa1FkFs8JryUGryrur43
	Xr45CF48WaykKFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkEb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Cr0_Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I
	0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lc7I2V7IY0VAS07AlzVAYIcxG8wCY1x0262kKe7AK
	xVWUAVWUtwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F4
	0E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_JF0_Jw1l
	IxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxV
	AFwI0_Jr0_Gr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j
	6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jjVb
	kUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

ÔÚ 2024/08/29 18:01, Xiao Ni Ð´µÀ:
> This interface is used to update new level during reshape progress.
> Now it doesn't update new level during reshape. So it can't know the
> new level when systemd service mdadm-grow-continue runs. And it can't
> finally change to new level.

I'm not sure why updaing new level during reshape. Will this corrupt
data in the array completely?
> 
> mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> mdadm --wait /dev/md0
> mdadm /dev/md0 --grow -l5 --backup=backup
> cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]

The problem is that level is still 6 after mddev --grow -l5? I don't
understand yet why this is related to update new level during reshape.
:)

Thanks,
Kuai

> 
> The case 07changelevels in mdadm can trigger this problem. Now it can't
> run successfully. This patch is used to fix this. There is also a
> userspace patch set that work together with this patch to fix this problem.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---
> V2: add detail about test information
>   drivers/md/md.c | 29 +++++++++++++++++++++++++++++
>   1 file changed, 29 insertions(+)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index d3a837506a36..3c354e7a7825 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *buf, size_t len)
>   static struct md_sysfs_entry md_level =
>   __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
>   
> +static ssize_t
> +new_level_show(struct mddev *mddev, char *page)
> +{
> +	return sprintf(page, "%d\n", mddev->new_level);
> +}
> +
> +static ssize_t
> +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> +{
> +	unsigned int n;
> +	int err;
> +
> +	err = kstrtouint(buf, 10, &n);
> +	if (err < 0)
> +		return err;
> +	err = mddev_lock(mddev);
> +	if (err)
> +		return err;
> +
> +	mddev->new_level = n;
> +	md_update_sb(mddev, 1);
> +
> +	mddev_unlock(mddev);
> +	return len;
> +}
> +static struct md_sysfs_entry md_new_level =
> +__ATTR(new_level, 0664, new_level_show, new_level_store);
> +
>   static ssize_t
>   layout_show(struct mddev *mddev, char *page)
>   {
> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, serialize_policy_show,
>   
>   static struct attribute *md_default_attrs[] = {
>   	&md_level.attr,
> +	&md_new_level.attr,
>   	&md_layout.attr,
>   	&md_raid_disks.attr,
>   	&md_uuid.attr,
> 

