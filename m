Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C38D22119
	for <linux-raid@vger.kernel.org>; Thu,  2 Jan 2025 13:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735823139; cv=none; b=dAirGnTCIpkTP/hurmY0Nzm5nK4QBUsZNsKKNdsNoCwIPfGf3U5lsZRhQsWz047Ypyf5NE9NAPfa9BicMNnFR7of1MtQYXNt8eFwS/awxMbPwbGSMWL/Z+C8DX/8zh3+5yD4q50to0b4NMk9uO/RheAJ9AO5KyTAu8TfCtXYZuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735823139; c=relaxed/simple;
	bh=V79hIYCNTauNqHWOPi56TUQ4Gbaxc6YHu/XjMjw6il4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YMfdtRm/ZzoZ0+QSaklAF1p9ydiBa73U5OOWzjgWx+O1EgvFrMTbiy3/OPFEOShgFhtxTs67sSgEjP+b13YVDE9lrWId7bk6ZuPCLPb4iwP2Bp6QDcVerapNQmr0Epla6aRjkbjVgBZjm3iGzcCyeu80/pg5XtH8DmftgKHzOfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.2.romanrm.net [IPv6:fd39:a37d:999f:7e35:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id 68C3C40446;
	Thu,  2 Jan 2025 13:05:33 +0000 (UTC)
Date: Thu, 2 Jan 2025 18:05:32 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Allen Toureg <thetanix@gmail.com>, Song Liu <song@kernel.org>,
 linux-raid@vger.kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: md-linear accidental(?) removal, removed significant(?) use
 case?
Message-ID: <20250102180532.3140fec2@nvm>
In-Reply-To: <3925f2f0-37c0-d526-08e2-cb9ee6f6dc93@huaweicloud.com>
References: <CABrqrA6b2y29tC2Z-9H2vYsuP_t5c6uCw9DZrjY7DmeNcczf0w@mail.gmail.com>
	<20250102171637.15bdb26f@nvm>
	<3925f2f0-37c0-d526-08e2-cb9ee6f6dc93@huaweicloud.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 2 Jan 2025 20:58:36 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> First of all, an exist md-linear can't switch to raid0, data will be
> lost.

Yes, I did not mean to switch in place, but try out for new setups.

> Then, for the case that disk with different size, for example:
> 
> sda 10T, sdb and sdc 12T.
> 
> Currently, in order to
> most home NAS solution will create partition for sdb and sdc,
> split it to 10T + 2T, then assemble two raid first:
> 
> md0:	sda + sdb1 + sdc1
> md1:	sdb2 + sdc2
> 
> md0 can be 20T raid5, and md1 can be 2T raid1, and finially, assemble
> new md-linear:
> 
> md2: md0 + md1
> 
> I agree that md-linear is better than raid0 in this case, user will
> prefer to use the md0 first, and use md1 when md0 is exhausted.

Oh yes, in case this is made of the same physical devices under the hood,
raid0 of their partitions will bring only harm, not benefits.

-- 
With respect,
Roman
