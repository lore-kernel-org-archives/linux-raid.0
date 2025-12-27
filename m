Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF7531DA55
	for <linux-raid@vger.kernel.org>; Sat, 27 Dec 2025 01:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766800570; cv=none; b=mctLO8fKuDTnwyA69UmvCdAJ3JMj8eTjJX5es5Gfxyf9pVqx21EEToMMZRyicbOubshj+udOj0M5Oo1KfP2jrwQYfUNs+gKp4LbYxL/f3uehbiSpgc5E3m1gByv3E8KVYHipcSw73EqHvrSl5giCj6N4OMwaez7aOu7KpwHzHzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766800570; c=relaxed/simple;
	bh=Jgmr2J+CoB6FsfihUaRbJCvIJoSRnAXXeZkcIWOVQ60=;
	h=To:Date:References:In-Reply-To:Cc:Subject:Mime-Version:
	 Content-Type:From:Message-Id; b=ZccNkzp7JXbfgM7Y9vM1a0Ik7g2cs7ceOMB0zhIQfNN+jZUyvQSB5uUyy/Jf5ETy0q79Va8u7rH5KlFuXqBAMgl4UgcjZvs5Wm6FdhoXbjQD+3kj2nPI7LXeEz3v6v/TzC08eIBX0PWR/WYk4CiXpOpMfPTEgrISBZcJ5rSaid0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=qBe3vO8B; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="qBe3vO8B"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1766800562;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=brLO8zUrSXdEdS63B4zmD5YdStIknYKNIZwBm2IjXGE=;
 b=qBe3vO8Bfn4giWi5peoZ5JZTQB2Si+p0kDfts3vO25GOXbn20kp8dFcHgEX59BXWw0BB7O
 uASBCmldvAMaXvLosdKpTKjZltrxaw4YiHcEXx/cwAcNGVYUxlGiZJ35M4/Y484aagTb3R
 6TVfAygbedyvgpG3RRDkyL3ct6dB/3Y3oQVAYLKQg+tU4eJGGGYHX7ZAtTHkSxuorku75z
 6/3PXG5rDkdV9monwwbLM/Z8Ib/Cbdo6mGkQERWDmsd6EegDwBsY/oB4erlDgQzfr28k8/
 hn3bbn4dk+8CFAhlBVKykAVuTE0J/aVwVwoyVvH+/3YbrNlXWmYtBUJ+QanfQw==
X-Lms-Return-Path: <lba+2694f3cb0+bfd36e+vger.kernel.org+yukuai@fnnas.com>
To: "dannyshih" <dannyshih@synology.com>, <song@kernel.org>, 
	<yukuai@fnnas.com>
Content-Language: en-US
User-Agent: Mozilla Thunderbird
Date: Sat, 27 Dec 2025 09:55:57 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
References: <20251226101816.4506-1-dannyshih@synology.com>
In-Reply-To: <20251226101816.4506-1-dannyshih@synology.com>
Received: from [192.168.1.104] ([39.182.0.136]) by smtp.feishu.cn with ESMTPS; Sat, 27 Dec 2025 09:55:59 +0800
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] md: suspend array while updating raid_disks via sysfs
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <1a102c5e-bf53-4419-ae8b-9d49127281f2@fnnas.com>

=E5=9C=A8 2025/12/26 18:18, dannyshih =E5=86=99=E9=81=93:

> From: FengWei Shih<dannyshih@synology.com>
>
> In raid1_reshape(), freeze_array() is called before modifying the r1bio
> memory pool (conf->r1bio_pool) and conf->raid_disks, and
> unfreeze_array() is called after the update is completed.
>
> However, freeze_array() only waits until nr_sync_pending and
> (nr_pending - nr_queued) of all buckets reaches zero. When an I/O error
> occurs, nr_queued is increased and the corresponding r1bio is queued to
> either retry_list or bio_end_io_list. As a result, freeze_array() may
> unblock before these r1bios are released.
>
> This can lead to a situation where conf->raid_disks and the mempool have
> already been updated while queued r1bios, allocated with the old
> raid_disks value, are later released. Consequently, free_r1bio() may
> access memory out of bounds in put_all_bios() and release r1bios of the
> wrong size to the new mempool, potentially causing issues with the
> mempool as well.
>
> Since only normal I/O might increase nr_queued while an I/O error occurs,
> suspending the array avoids this issue.
>
> Note: Updating raid_disks via ioctl SET_ARRAY_INFO already suspends
> the array. Therefore, we suspend the array when updating raid_disks
> via sysfs to avoid this issue too.
>
> Signed-off-by: FengWei Shih<dannyshih@synology.com>
> ---
> v2:
>    * Suspend array unconditionally when updating raid_disks
>    * Refine commit message to describe the issue more concretely
> ---
>   drivers/md/md.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)

Applied to md-6.19

--=20
Thansk,
Kuai
