Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACDF31C3D
	for <linux-raid@vger.kernel.org>; Wed,  7 Aug 2024 02:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722999368; cv=none; b=LjNYxbem0vJORc6wyjzL7mUIuzvmLr+VeFJDqRgZlcnsjt9McwE+F4vJ2o8GgEV7rCilYqCLZgQTw9uztckevYNRto+JRpZC2svGUKllWMk32iMV/zXpmFpy7Ixh/xkFRNrniGDAeit7YC5tAbLbbcLdr0MJmkKpi3EybAAe3VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722999368; c=relaxed/simple;
	bh=txm45UuZ7OsNCs8nSAzgbNCKmQmeQDhttHHDoqqpzP8=;
	h=Subject:To:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=V+CD1JkQonAj41EUqj22yCIAyqieZV50clyIpLL5p7sdXTOdsH/bUWkD+WW9h1SXuYMputoczMeuAgvhMcEZOFcVilJKfoEjmrpY6RoBxiafUK5LkkgXyjL//4zNzjpLqqnCnGTnB2+hMbGlzhzYpJ3vIuczRWuYOxFmY5z432A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Wdvtj2ZsCz4f3kv7
	for <linux-raid@vger.kernel.org>; Wed,  7 Aug 2024 10:55:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id A8FA71A0568
	for <linux-raid@vger.kernel.org>; Wed,  7 Aug 2024 10:55:55 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
	by APP4 (Coremail) with SMTP id gCh0CgBXfoQ64rJmkzX0Aw--.9091S3;
	Wed, 07 Aug 2024 10:55:55 +0800 (CST)
Subject: Re: PROBLEM: repeatable lockup on RAID-6 with LUKS dm-crypt on NVMe
 devices when rsyncing many files
To: Christian Theune <ct@flyingcircus.io>,
 "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
 "dm-devel@redhat.com" <dm-devel@redhat.com>, "yukuai (C)"
 <yukuai3@huawei.com>
References: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
From: Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <316050c6-fac2-b022-6350-eaedcc7d953a@huaweicloud.com>
Date: Wed, 7 Aug 2024 10:55:53 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <ADF7D720-5764-4AF3-B68E-1845988737AA@flyingcircus.io>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBXfoQ64rJmkzX0Aw--.9091S3
X-Coremail-Antispam: 1UD129KBjvJXoW7CFyDGw4UCr4rJFyxuFWkXrb_yoW8JFyxpF
	W3GF42kw4DJF1xWrWkur17ua4ayw1a9F45trykCryrGa98GFyIqry7KFs0qF4qkr4rGa1j
	9rWrJw17uF1kCaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUyCb4IE77IF4wAFF20E14v26r1j6r4UM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r126r1DMIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF
	7I0E14v26r1j6r4UYxBIdaVFxhVjvjDU0xZFpf9x07UE-erUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

Hi,

在 2024/08/06 22:10, Christian Theune 写道:
> we are seeing an issue that can be triggered with relative ease on a 
> server that has been working fine for a few weeks. The regular workload 
> is a backup utility that copies off data from virtual disk images in 
> 4MiB (compressed) chunks from Ceph onto a local NVME-based RAID-6 array 
> that is encrypted using LUKS.
> 
> Today I started a larger rsync job from another server (that has a 
> couple of million files with around 200-300 gib in total) to migrate 
> data and we’ve seen the server suddenly lock up twice. Any IO that 
> interacts with the mountpoint (/srv/backy) will hang indefinitely. A 
> reset is required to get out of this as the machine will hang trying to 
> unmount the affected filesystem. No other messages than the hung tasks 
> are being presented - I have no indicator for hardware faults at the moment.
> 
> I’m messaging both dm-devel and linux-raid as I’m suspecting either one 
> or both (or an interaction) might be the cause.
> 
> Kernel:
> 
> Linux version 5.15.138 (nixbld@localhost) (gcc (GCC) 12.2.0, GNU ld (GNU 
> Binutils) 2.40) #1-NixOS SMP Wed Nov 8 16:26:52 UTC 2023

Since you can trigger this easily, I'll suggest you to try the latest
kernel release first.

Thanks,
Kuai

> 
> See the kernel config attached.

