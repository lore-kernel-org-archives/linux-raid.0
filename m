Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A25134DCD6
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 15:22:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783783337; cv=none; b=SWngviAQYt2yJ/rmld90l6Mj7q0U6xoaLfWJtyDW3VIOc+Qvvshn8V8shtpofRQ1zmOu64RE9eO5mPLC1zAxi6AXJXxUItZt8TEsA5EFyAPp2IOvgm1B2vgo1Eg6SxbjJZFYuq4RTAXF36upDvBkbYzG0KOY3XFFaTYNSw6n2co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783783337; c=relaxed/simple;
	bh=mYv9DGaTl0UDJrUJygjDv8/4QMe1IrAUCWu3D7/FFN8=;
	h=Message-Id:Content-Type:References:In-Reply-To:To:Date:From:
	 Subject:Mime-Version; b=i/r/nwGSYLuUcqVGAtnat+h71GMH9YR4pLfHcN2EZAbogony57c84y+2WpRYzuWknuD9OgjQD/gYMi8dkfBLEywF2vjJRpKMo8beBTx2EOjqgs3faLLYS0EfOIl+ozzy4glEFNigmFHHU/RGbP5nXJ+LWoIgT4ojgagMEfjvLfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=PkCs7UZ7; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="PkCs7UZ7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1783783321;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=ciIxqgOCJdWYxajtwHTRcpafZFT1yJuHrcJ9wMmUB1o=;
 b=PkCs7UZ7uMEKGGHvjRFPpf40IgZ55NbLpi2TAcwjTnQ9o+RCBcpmj9/eY1kta/0cub3X2Q
 TZYb7iYoLTtn7Q/A2t5+Hift3+yVloy6TymVrXIza21xOBn++LhIO2dQJqYECmGvkSUxFV
 bX34C2kr74kQDJWQJnI8LD/J/12sngNiEJDAwieJksbysrCDrky1zJP0Un4yIFsdPoy6AN
 mKYov/6PluMYiwrcI276anTi5vU06QSsdr6r4dqwiXw+kCQuF555hQaqT1inLm9nD8dqf+
 t18VAC5/7YxnNxY6VDJEWcHix+L2bAm/Cbgvbis6fWf+gVzGmoOPat4P5CgmLw==
Message-Id: <e7e9052f-4817-4077-8b5b-44653629b96d@fygo.io>
Content-Type: text/plain; charset=UTF-8
References: <20260628142737.1051059-1-abd.masalkhi@gmail.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260628142737.1051059-1-abd.masalkhi@gmail.com>
Reply-To: yukuai@fygo.io
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<yukuai@fygo.io>, <magiclinan@didiglobal.com>, <xiao@kernel.org>, 
	<vverma@digitalocean.com>, <axboe@kernel.dk>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Date: Sat, 11 Jul 2026 23:21:55 +0800
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH] md: remove REQ_NOWAIT support
X-Lms-Return-Path: <lba+26a525f98+9e5b65+vger.kernel.org+yukuai@fygo.io>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.larksuite.com with ESMTPS; Sat, 11 Jul 2026 15:21:59 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird

=E5=9C=A8 2026/6/28 22:27, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> REQ_NOWAIT support in md is fundamentally incomplete. While reads can
> avoid some blocking paths, write requests can still encounter cases
> where one mirror succeeds while another returns -EAGAIN. At that point
> md cannot distinguish queue pressure from a real device failure, so it
> can neither record a bad block nor safely retry the write without
> REQ_NOWAIT, leaving mirrors with divergent data.
>
> Rather than continue advertising REQ_NOWAIT support that cannot be
> implemented correctly, remove it from md and its raid personalities.
> This simplifies the waiting paths and avoids exposing incorrect
> non-blocking semantics.
>
> Fixes: bf2c411bb1cf ("md: raid456 add nowait support")
> Fixes: c9aa889b035f ("md: raid10 add nowait support")
> Fixes: 5aa705039c4f ("md: raid1 add nowait support")
> Fixes: f51d46d0e7cb ("md: add support for REQ_NOWAIT")
> Suggested-by: Yu Kuai<yukuai@fygo.io>
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
>   drivers/md/md-bitmap.c   |  9 +---
>   drivers/md/md-bitmap.h   |  2 +-
>   drivers/md/md-llbitmap.c | 10 +----
>   drivers/md/md.c          | 15 ++-----
>   drivers/md/raid1-10.c    |  8 ++--
>   drivers/md/raid1.c       | 91 +++++++++-------------------------------
>   drivers/md/raid10.c      | 80 +++++++++--------------------------
>   drivers/md/raid5.c       | 13 ------
>   8 files changed, 51 insertions(+), 177 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
