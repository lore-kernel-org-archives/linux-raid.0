Received: from mail.bonnevilleinformatics.com (mail.bn-i.net [69.92.154.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 660B47E1;
	Tue, 18 Feb 2025 07:29:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=69.92.154.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739863770; cv=none; b=gq7LxvPnLpwM+WyAw5eENOWdRiCDG5oXKDL9N3uUL5/XDI7VrYUGJe/+I7ypB+8hmbJxD4CEtSXkS8AVqMvfcY8m7++jgf1X+s2accNx6f+0d9ttRUmKYtDhHfIBM3UdlMr+IiH57I8YCESpTm5mqbJ0MA2jCAYC3FDwZSmrqbw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739863770; c=relaxed/simple;
	bh=ZT6m4LN4rdzOKJn7CF5HMnNI+JWqbiC4JzlTjPit0XE=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=YleVy3CQFi8XYzFrAA7/Ax/hOKhxWjpcaverjklGpXgBM8DmiWPMwgjopIMIdppD4KGLGQ46fGOWAIUaMT5SHxT86EIqMd7hsXNn6f8fFl7ZbzjH5QFK+Lc9XVpJQ2c6/WPxNpc5qlEKvRKqxvwX93iqcM5j4xJ2JYN2uYTeQXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net; spf=pass smtp.mailfrom=dougvj.net; dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b=JGKVQAuN; arc=none smtp.client-ip=69.92.154.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dougvj.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dougvj.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dougvj.net header.i=@dougvj.net header.b="JGKVQAuN"
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dougvj.net; s=dkim;
	t=1739863202;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kRSGAu2PiYF/Kw678JHj2g8VvkSCTr84mcy+hWx6iwE=;
	b=JGKVQAuN/HLrwz9ivuCgEtXqlKm141l6nxAsQSJ6qFTuDogkEuDn98pwSEd7CFSNbkArow
	vhLqg8TreqY6l3sks9Da9Mi1aQZhTpuHdhqlRarDirYO6VkBZ8nhC9UWKUSXYOM+KOvsap
	1b2emr9oc22yT6KtJkYFeRyXf6phYbQ=
Authentication-Results: mail.bonnevilleinformatics.com;
	auth=pass smtp.mailfrom=dougvj@dougvj.net
Date: Tue, 18 Feb 2025 07:20:01 +0000
From: Doug V Johnson <dougvj@dougvj.net>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Doug Johnson <dougvj@gmail.com>, Song Liu <song@kernel.org>, "open
 list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>,
 open list <linux-kernel@vger.kernel.org>, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH v2 1/2] md/raid5: freeze reshape when encountering a bad
 read
In-Reply-To: <21f250f9-04b5-76f6-84c9-1fd245b748c6@huaweicloud.com>
References: <9c3420a9-8f6a-1102-37d2-8f32787b2f9a@huaweicloud.com>
 <20250127090049.7952-1-dougvj@dougvj.net>
 <21f250f9-04b5-76f6-84c9-1fd245b748c6@huaweicloud.com>
Message-ID: <9d878dea7b1afa2472f8f583fd116e31@dougvj.net>
X-Sender: dougvj@dougvj.net
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Bar: ---

> Perhaps, check badblocks before starting reshape in the first place can
> solve most problems in this case? We can keep this patch just in case
> new badblocks are set while performing reshape.
> 
> Thanks,
> Kuai
> 
This is a really good idea and should mitigate the risk of getting into 
these weird states. I started work on a patch that seems to work, I will 
submit it after I have done some testing.

Thanks for your feedback,
Doug
