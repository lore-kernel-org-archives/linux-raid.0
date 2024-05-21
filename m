Received: from ale.deltatee.com (ale.deltatee.com [204.191.154.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9178E7C0A3
	for <linux-raid@vger.kernel.org>; Tue, 21 May 2024 17:26:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=204.191.154.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716312376; cv=none; b=DfjOgwNPj7pB07t3bqUUDU/G58TgI4Jhobl363DJWgs+Yh6Xuy+ByUObxylspaK/N4pguL1xt6NRkLh0rwceNQYvhPuAa3B/wVQrE3uInkRWZoODpNEGkG+CR+c2NkPLgLZAvI1uu1oTrZuvxXQa++AaTnnczPlgl3VEg/wllCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716312376; c=relaxed/simple;
	bh=3Ww+hh3Hf+UYtyEekkPZr9pq3lvGQmZ5+EmbBISJLoo=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:From:In-Reply-To:
	 Content-Type:Subject; b=ipy56CHfKsjKUQ9q7FuoA+MQiM9YHCDpbq/nPi+32W9HNohK2BG0lejHraK4XxG+mCJC9T1NYZdvbd08ezSViPa5HfVPy5Ouc7WRwNlbrfReRtmbSK05WU9/NP0NQuH/hTxcfpBpSYPKa90HYeSrYZOFRKfWc1faB18GD5U8ECI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com; spf=pass smtp.mailfrom=deltatee.com; dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b=aijizHar; arc=none smtp.client-ip=204.191.154.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=deltatee.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=deltatee.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=deltatee.com header.i=@deltatee.com header.b="aijizHar"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=deltatee.com; s=20200525; h=Subject:In-Reply-To:From:References:Cc:To:
	MIME-Version:Date:Message-ID:content-disposition;
	bh=HJ2qsk8Dm08mgQbinOfQJqD4zDana6QYBHlFI3oniw0=; b=aijizHarewTmBuq13LR+Wfufl4
	tk+2V2t6PiTAj4hrck2LW/X07VKTinNJ6cmCVTpE903sP6LUt5TSmJKHDNAo7MVIkcBcDRGjfnnH/
	e8bX+FBWolia24IB6yX+jNjWctT9gkNtl8hbzgDEWn3FhsdEMF9YgdmZ+LHrO1RnJQulh8+6GQjdE
	NqBkCm/t1Ft1dMByynvGcnCH5qvZs64lpgb1eLkkqJOYyZovwE/BJt6GkVcttQIv1NFpkUcteoprx
	DjvYuL10rbtVZI3USrf7fznW1qxNQWJ0IouFDVET8ztJaD4bqg6P+/Q6fmC1M61qRddq5dsIGOCF8
	uQ6rTygw==;
Received: from guinness.priv.deltatee.com ([172.16.1.195])
	by ale.deltatee.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <logang@deltatee.com>)
	id 1s9Smi-005CgI-22;
	Tue, 21 May 2024 10:56:21 -0600
Message-ID: <25ea3a8d-6331-476c-8fb4-8932185b3113@deltatee.com>
Date: Tue, 21 May 2024 10:56:20 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
References: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
Content-Language: en-CA
From: Logan Gunthorpe <logang@deltatee.com>
In-Reply-To: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 172.16.1.195
X-SA-Exim-Rcpt-To: xni@redhat.com, linux-raid@vger.kernel.org
X-SA-Exim-Mail-From: logang@deltatee.com
X-Spam-Level: 
Subject: Re: mdadm/Create wait_for_zero_forks is stuck
X-SA-Exim-Version: 4.2.1 (built Wed, 06 Jul 2022 17:57:39 +0000)
X-SA-Exim-Scanned: Yes (on ale.deltatee.com)

Hi Xiao,

I don't have time to dig into this myself, but my guess would be that
the signal for one of the children come too quickly, before the
sigprocmask() call in wait_for_zero_forks().

Seems like SIGCHLD should be blocked before the first call to
write_zeroes_fork(). I'm really not sure why I put in a block to SIGINT
and then a block to SIGCHLD after the processes started. I suspect
adding SIGCHLD to the sigprocmask in add_disks() and just removing the
sigprocmask in write_zeroes_fork() might fix the issue.

Thanks,

Logan



On 2024-05-21 01:05, Xiao Ni wrote:
> Hi Logan
> 
> I'm trying to fix errors of mdadm regression failures. There is a
> failure in 00raid5-zero sometimes. I added some logs:
> 
> In function write_zeroes_fork:
>                 if (fallocate(fd, FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
>                               offset_bytes, sz)) {
>                         pr_err("zeroing %s failed: %s\n", dv->devname,
>                                strerror(errno));
>                         ret = 1;
>                         break;
>                 } else
>                         printf("zeroing good\n");
> 
> In function wait_for_zero_forks:
>                 if (fdsi.ssi_signo == SIGINT) {
>                         printf("\n");
>                         pr_info("Interrupting zeroing processes,
> please wait...\n");
>                         interrupted = true;
>                         break;
>                 } else if (fdsi.ssi_signo == SIGCHLD) {
>                         printf("one child finishes, wait count %d\n",
> wait_count);
>                         if (!--wait_count)
>                                 break;
>                 }
> 
> while [ 1 ]; do
>   /usr/sbin/mdadm -CfR /dev/md0 -l 5 -n3 /dev/loop0 /dev/loop1
> /dev/loop2 --write-zeroes --auto=yes -v
>   mdadm --wait /dev/md0
>   mdadm -Ss
>   sleep 1
> done
> 
> zeroing good
> zeroing good
> zeroing good
> one child finishes, wait count 3
> one child finishes, wait count 2
> 
> It looks like the farther process misses one child signal.
> 
> root      174247  0.0  0.0   3628  2552 pts/0    S+   02:52   0:00  |
>              \_ /usr/sbin/mdadm -CfR /dev/md0 -l 5 -n3 /dev/loop0
> /dev/loop1 /dev/loop2 --write-zeroes --auto=yes -v
> root      174248  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
>                  \_ [mdadm] <defunct>
> root      174249  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
>                  \_ [mdadm] <defunct>
> root      174250  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
>                  \_ [mdadm] <defunct>
> 
> ]# cat /proc/174247/stack
> [<0>] signalfd_dequeue+0x14d/0x170
> [<0>] signalfd_read_iter+0x7b/0xd0
> [<0>] vfs_read+0x201/0x330
> [<0>] ksys_read+0x5f/0xe0
> [<0>] do_syscall_64+0x7b/0x160
> [<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e
> 
> Any ideas for this?
> 
> Best Regards
> Xiao
> 
