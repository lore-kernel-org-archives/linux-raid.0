Received: from sg-1-17.ptr.blmpb.com (sg-1-17.ptr.blmpb.com [118.26.132.17])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ECD23AB90
	for <linux-raid@vger.kernel.org>; Sun, 18 Jan 2026 11:40:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.17
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768736442; cv=none; b=GDd0ryJD8pYLi3Bd1HRkHtIWfC5ysFnNDkBe6QdhOnJqOac5wsHW8Lze9meLAW6EDMfSx2A7OqJBFY9I1Ovs//Spr7nnzycgtgR7z3MU57CIB2uM8ymnbJD9peuD39B4JKAQPv3azifsdKx6zG5vwoevNiEqfj1qmv4cQH2yehw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768736442; c=relaxed/simple;
	bh=wrOGZWpUGfQTKsVACbOz5sxwAnQn9i7rx44tXnyKWB0=;
	h=To:From:In-Reply-To:Date:Mime-Version:Cc:Subject:Content-Type:
	 Message-Id:References; b=GwsFbDIywVzRsLysuzeLUxNKh3mYjCUWyeNWxHI0dnj3jrxubTTrq1TfDrHqjKiSqbmNq2DHDxQdmLRe4DVfiMXC93zvQJ53wEmZfKxWKlpLKt8ABdTnu2kmlnkHoi7l3eUsxCNoSsmvzAR3v7/01ja2bg7EnN+nYRKA16xndy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=IIkKnHEp; arc=none smtp.client-ip=118.26.132.17
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="IIkKnHEp"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768736427;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=o/EIkbCPLV6yDWvZvnDUjsoMBVzQbrLDF9iRNpfB2J4=;
 b=IIkKnHEpKyqs7CxTn4HHiBnVisOx7y2P/xDmM0XMkCFUg9uCFZ0Q8TQPLNMHNvTeQiGAcJ
 cMBDYR+w1+eA+hAjgYHiPqDD+NTZ8r502z/PVsUs6ySWnOI2m4ZTwE7pA/zbzHoVtViHs6
 boRc7VVy9mMJFfpDTSbOwnFV0+jDCWgL+YOigAtmwoMTNEeY9MxhWT/FhYQ+J4sgVvfidq
 bsvPGvPzG1SEc+wQNwzCKeV46Uh/R/ZR7z1fVXSpQ/qvPdsqIYPO9HKB9Jy6RPAKaPWOAw
 //vlM6TdnG5KMfAuhTPwr+Oqddw4gFG37VJdM+HykvHWfW3CoKuviM5q91Lyig==
To: "Christoph Hellwig" <hch@infradead.org>
From: "Yu Kuai" <yukuai@fnnas.com>
In-Reply-To: <aWpUYD1D1n-HJR9u@infradead.org>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+2696cc6a9+93e4ff+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
Date: Sun, 18 Jan 2026 19:40:23 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Language: en-US
Cc: <linux-raid@vger.kernel.org>, <linan122@huawei.com>, <xni@redhat.com>, 
	<dan.carpenter@linaro.org>, <yukuai@fnnas.com>
Subject: Re: [PATCH v5 07/12] md: support to align bio to limits
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Sun, 18 Jan 2026 19:40:24 +0800
Content-Type: text/plain; charset=UTF-8
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Message-Id: <df394803-b5fe-484f-a12d-dd10645d7a04@fnnas.com>
Content-Transfer-Encoding: quoted-printable
References: <20260114171241.3043364-1-yukuai@fnnas.com> <20260114171241.3043364-8-yukuai@fnnas.com> <aWpUYD1D1n-HJR9u@infradead.org>

Hi,

=E5=9C=A8 2026/1/16 23:08, Christoph Hellwig =E5=86=99=E9=81=93:
> On Thu, Jan 15, 2026 at 01:12:35AM +0800, Yu Kuai wrote:
>> For personalities that report optimal IO size, it indicates that users
>> can get the best IO bandwidth if they issue IO with this size. However
>> there is also an implicit condition that IO should also be aligned to th=
e
>> optimal IO size.
>>
>> Currently, bio will only be split by limits, if bio offset is not aligne=
d
>> to limits, then all split bio will not be aligned. This patch add a new
>> feature to align bio to limits first, and following patches will support
>> this for each personality if necessary.
> This feels a bit odd and mixes up different things as right now
> nothing in the block layer splits to the opt_io size.  If you want
> a boundary that is split on, the chunk_size limit seems to be what
> you want, and the existing code would do the work based on that.

No, the chunk_sectors and io_opt are different, and align io to io_opt
is not a general idea, for now this is the only requirement in mdraid.

Not sure if you remembered, Coly used to send a version to align IO to
io_opt separately, and we discussed and both agree align max_sectors to
io_opt and then align io to max_sectors in mdraid is better.

For now, current setting of max_sectors, and split IO to max_sectors
does not make much sense for raid0/10/456.

>
--=20
Thansk,
Kuai
