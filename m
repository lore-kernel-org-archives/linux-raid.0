Received: from nt.romanrm.net (nt.romanrm.net [185.213.174.59])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B490D339879;
	Wed, 17 Dec 2025 17:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.213.174.59
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765992816; cv=none; b=iL2zi+YYt8knp2f/hCwRDqVM/BiXLx2xNx4FQ0tTewo8ZykykQe/k15DhYmg/VPzMqG4V9sYdlYCuP+6eO5nNVXw8C8zJd9VAqDE54XOFyXQBc4w7B51qya/rsSn77g4IXnFUbhFvd/EpE6yAye2CUk9zFuAQ/uhc4wZPvLTjkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765992816; c=relaxed/simple;
	bh=5XriYnOaL0perttZPwR/7zlscGu/MJlSUTp7Xy8tBJU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KbcBOzFOd2+0wWA8IcYwXZewWb7TVp6ac8KFRjiu707nmJFRhIc09xliL+1KWVl11t2txMfq71W2ugZ7b6O5K5iHgo5oLAi/RP2LYCIJMyXI+4UkrohLsTtJoCYWHhzNNk9tDPGIHdNePel8H/HFycB+FHTUkle5SLMRej/2N+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net; spf=pass smtp.mailfrom=romanrm.net; arc=none smtp.client-ip=185.213.174.59
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=romanrm.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=romanrm.net
Received: from nvm (umi.0.romanrm.net [IPv6:fd39:ade8:5a17:b555:7900:fcd:12a3:6181])
	by nt.romanrm.net (Postfix) with SMTP id A498840AA1;
	Wed, 17 Dec 2025 17:31:30 +0000 (UTC)
Date: Wed, 17 Dec 2025 22:31:30 +0500
From: Roman Mamedov <rm@romanrm.net>
To: "Yu Kuai" <yukuai@fnnas.com>
Cc: "Greg KH" <gregkh@linuxfoundation.org>, <linan666@huaweicloud.com>,
 <stable@vger.kernel.org>, <song@kernel.org>, <linux-raid@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <yangerkun@huawei.com>,
 <yi.zhang@huawei.com>
Subject: Re: [PATCH stable/6.18-6.17] md: add check_new_feature module
 parameter
Message-ID: <20251217223130.1c571fa5@nvm>
In-Reply-To: <6979cd43-d38c-477d-857c-8d211bc85474@fnnas.com>
References: <20251217130513.2706844-1-linan666@huaweicloud.com>
	<2025121700-pedicure-reckless-65b9@gregkh>
	<6979cd43-d38c-477d-857c-8d211bc85474@fnnas.com>
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.31; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Dec 2025 01:11:43 +0800
"Yu Kuai" <yukuai@fnnas.com> wrote:

> Hi,
>=20
> =E5=9C=A8 2025/12/17 22:04, Greg KH =E5=86=99=E9=81=93:
> > On Wed, Dec 17, 2025 at 09:05:13PM +0800, linan666@huaweicloud.com wrot=
e:
> >> From: Li Nan <linan122@huawei.com>
> >>
> >> commit 9c47127a807da3e36ce80f7c83a1134a291fc021 upstream.
> >>
> >> Raid checks if pad3 is zero when loading superblock from disk. Arrays
> >> created with new features may fail to assemble on old kernels as pad3
> >> is used.
> >>
> >> Add module parameter check_new_feature to bypass this check.
> > This is a new feature, why does it need to go to stable kernels?
> >
> > And a module parameter?  Ugh, this isn't the 1990's anymore, this is not
> > good and will be a mess over time (think multiple devices...)
>=20
> Nan didn't mention the background. We won't backport the new feature to s=
table
> kernels(Although this fix a data lost problem in the case array is created
> with disks in different lbs, anyone is interested can do this). However, =
this
> backport is just used to provide a possible solution for user to still as=
semble
> arrays after switching to old LTS kernels when they are using the default=
 lbs.

This is still a bad scenario. Original problem:

- Boot into a new kernel once, reboot into the old one, the existing array =
no
  longer works.

After this patch:

- Same. Unless you know how, where and which module parameter to add, to
  be passed to md module on load. Might be not convenient if the root FS
  didn't assemble and mount and is inaccessible.

Not ideal whatsoever.

Wouldn't it be possible to implement minimal *automatic* recognition (and
ignoring) of those newly utilized bits instead?

--=20
With respect,
Roman
