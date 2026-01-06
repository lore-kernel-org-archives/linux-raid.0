Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1B5C220F37;
	Tue,  6 Jan 2026 02:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767668243; cv=none; b=RkZ7ZCoVJ6M0XE8sFiNlfLIcca2iGWda/94Jwi5vT7ElRdfQWsybhUnN6tupATw2Zh4G8ZBZRjKkSEPpVEOVSWS3YT80Lz0Io1FRdXQDPdou+k1vhgTxHahaVFivP/RPvanM5QTUm9m0YHW/xbNstlZ1luHGUtIyvFbFUBE2Z4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767668243; c=relaxed/simple;
	bh=jJilJFxWI8+ACuwUTLgAl8/axHdnBFUq8RX+EOi00K8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Gnzz3pQRUGQZzic9VGiTNPFav54eUVJbm/ItXQoUxJan5YW+kVZPvdH1fw5FZ7bb0TYR0IxW7YObSWU0v98hNI4sPpoGFT88N6WtpTL6N6u/XgzSd0lFroE1N+gtmGd/NFy6A4tqvgdV6BTtXghIPbnSGkFJV1BDM8PBYTw6ud8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4dlbR974k7zKHMWy;
	Tue,  6 Jan 2026 10:56:37 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 1FF384056C;
	Tue,  6 Jan 2026 10:57:17 +0800 (CST)
Received: from [10.174.178.129] (unknown [10.174.178.129])
	by APP4 (Coremail) with SMTP id gCh0CgAHZ_cLelxpa9EpCw--.61682S3;
	Tue, 06 Jan 2026 10:57:16 +0800 (CST)
Message-ID: <7944a042-2e1e-1487-1b42-529768afbbd0@huaweicloud.com>
Date: Tue, 6 Jan 2026 10:57:15 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v6 1/2] md: Don't set MD_BROKEN for RAID1 and RAID10 when
 using FailFast
To: Kenta Akagi <k@mgml.me>, Song Liu <song@kernel.org>,
 Yu Kuai <yukuai@fnnas.com>, Shaohua Li <shli@fb.com>,
 Mariusz Tkaczyk <mtkaczyk@kernel.org>, Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260105144025.12478-1-k@mgml.me>
 <20260105144025.12478-2-k@mgml.me>
From: Li Nan <linan666@huaweicloud.com>
In-Reply-To: <20260105144025.12478-2-k@mgml.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAHZ_cLelxpa9EpCw--.61682S3
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4rCw43JrWrtry3Kr4DArb_yoW8AFyDpF
	4fXanIkFn8tryFka1UGry0ga4avrWfGa9xGF18C3sFvw1rCr1Igrs0gw1S934jvw18ZFy7
	Jw4Fgrn09ayDZaDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUU90b4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAac4AC62xK8xCEY4vEwIxC4wAS0I0E0xvYzxvE52x082IY62kv0487
	Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aV
	AFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxk0xIA0c2IEe2xF
	o4CEbIxvr21lc7CjxVAaw2AFwI0_JF0_Jw1l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x
	0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2
	zVAF1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF
	4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r1j6r4UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWU
	CwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
	VFxhVjvjDU0xZFpf9x07UMnQUUUUUU=
X-CM-SenderInfo: polqt0awwwqx5xdzvxpfor3voofrz/



在 2026/1/5 22:40, Kenta Akagi 写道:
> After commit 9631abdbf406 ("md: Set MD_BROKEN for RAID1 and RAID10"),
> if the error handler is called on the last rdev in RAID1 or RAID10,
> the MD_BROKEN flag will be set on that mddev.
> When MD_BROKEN is set, write bios to the md will result in an I/O error.
> 
> This causes a problem when using FailFast.
> The current implementation of FailFast expects the array to continue
> functioning without issues even after calling md_error for the last
> rdev.  Furthermore, due to the nature of its functionality, FailFast may
> call md_error on all rdevs of the md. Even if retrying I/O on an rdev
> would succeed, it first calls md_error before retrying.
> 
> To fix this issue, this commit ensures that for RAID1 and RAID10, if the
> last In_sync rdev has the FailFast flag set and the mddev's fail_last_dev
> is off, the MD_BROKEN flag will not be set on that mddev.
> 
> This change impacts userspace. After this commit, If the rdev has the
> FailFast flag, the mddev never broken even if the failing bio is not
> FailFast. However, it's unlikely that any setup using FailFast expects
> the array to halt when md_error is called on the last rdev.
> 

In the current RAID design, when an IO error occurs, RAID ensures faulty
data is not read via the following actions:
1. Mark the badblocks (no FailFast flag); if this fails,
2. Mark the disk as Faulty.

If neither action is taken, and BROKEN is not set to prevent continued RAID
use, errors on the last remaining disk will be ignored. Subsequent reads
may return incorrect data. This seems like a more serious issue in my opinion.

In scenarios with a large number of transient IO errors, is FailFast not a
suitable configuration? As you mentioned: "retrying I/O on an rdev would
succeed".

-- 
Thanks,
Nan

