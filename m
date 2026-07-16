Received: from va-2-19.ptr.blmpb.com (va-2-19.ptr.blmpb.com [209.127.231.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25D532EDD78
	for <linux-raid@vger.kernel.org>; Thu, 16 Jul 2026 09:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784193897; cv=none; b=AY225B9rplA+X6OYJNlSRLd/Vn+7FBP+Nn+qouu5nJ5F2IdcFGU0SBhxKM5tJeERGiwZyg3vweVInu5YHVCdEJGFVztv7L9S50DSCxPfE/T24v1ocdwypO1G9GiSFCXOUzXt7VqTnkKujkQ0bgacU8XDPoOAO3fSmGX/UFIHfzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784193897; c=relaxed/simple;
	bh=sbmzNeQCIMVE8PpDxtbCRdBr2vCbYNrl2Hi9pdp1X1s=;
	h=In-Reply-To:Content-Type:Subject:Mime-Version:References:From:
	 Message-Id:Cc:Date:To; b=cFcidp4Kj3oTHhALxsbAyuIYke9VovlhQ3MXM2+CEv/DvciPCaR9vYIS9iUc5878j006ofbetn81ikRmXqlqvvhOof9ZYlOrXyTu9tl1rnETKsxEE/g/+KxCahv2tXD7i38Kcc9aStxtU8Nf9mby3dKoCYQV03jU/GSBioF0T4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=Otqth3pS; arc=none smtp.client-ip=209.127.231.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="Otqth3pS"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1784193881;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=v8C+CaYSdslOGdzpcZ6oX+8rtaxAaqdrOaMrD4zbbkA=;
 b=Otqth3pSff6zLU7kC8gLF0DOdyVyfZy+zz9JW86jdd7efzwhVtLhqYgekmD9W8VELlaiRx
 YMJqNs34UsiFpEzxUr+rhPsq1kgAyfADE4F+u7rPjSlHIMla4dPhYBB5yDpFqngNbkgT9p
 YSPTXGjYqCmquCGtImpHLUB0XM3OPhGQhFYMHfcwFv/FhU0GnQCnFWuTHkf3iJQ2GQrxZC
 8iYujhHhsF/JEVu0LmX4g8jcjvOMve+N3ZRdv/T3zb9/0zwZ5X9R6pRHqj49BFLkJwnaUC
 Z7p4PxzHRtIh6t/Hw210n0zMuSNXR2FNUt+G2nde0zCYUQqo8yP/4pyecO1Jhw==
In-Reply-To: <20260710101521.1714-5-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: yu kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Received: from [192.168.1.104] ([39.182.0.157]) by smtp.larksuite.com with ESMTPS; Thu, 16 Jul 2026 09:24:39 +0000
Subject: Re: [PATCH v4 4/7] md/raid10: remove unnecessary barrier around bio_submit_split_bioset()
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260710101521.1714-1-abd.masalkhi@gmail.com> <20260710101521.1714-5-abd.masalkhi@gmail.com>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <32266fa5-f40d-471d-9b2a-75f6e18c5ab0@fygo.io>
Cc: <linux-raid@vger.kernel.org>
Date: Thu, 16 Jul 2026 17:24:35 +0800
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a58a358+219289+vger.kernel.org+yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<magiclinan@didiglobal.com>, <xiao@kernel.org>, <axboe@kernel.dk>, 
	<vverma@digitalocean.com>, <john.g.garry@oracle.com>, 
	<martin.petersen@oracle.com>, <linux-kernel@vger.kernel.org>, 
	"yu kuai" <yukuai@fygo.io>

=E5=9C=A8 2026/7/10 18:15, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> raid10_write_request() drops the barrier before calling
> bio_submit_split_bioset() and reacquires it afterwards. This is no
> longer necessary because the split bio cannot re-enter
> raid10_write_request() while the barrier is held.
>
> The allow_barrier()/wait_barrier() pair was introduced by commit
> e820d55cb99d ("md: fix raid10 hang issue caused by barrier") when
> submit_flushes() called md_handle_request() directly, allowing re-entry
> into raid10_write_request(). Since v5.2, submit_flushes() has instead
> gone through submit_bio(), eliminating that recursion. submit_flushes()
> was later removed entirely by commit b75197e86e6d ("md: Remove flush
> handling").
>
> Currently, raid10_write_request() is only entered from the bio
> submission path, so the split bio submitted by bio_submit_split_bioset()
> cannot recurse back into wait_barrier().
>
> Remove the redundant allow_barrier()/wait_barrier() pair around
> bio_submit_split_bioset().
>
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
> Changes in v4:
>   - No changes.
>   - Link to v3:https://lore.kernel.org/linux-raid/20260708101341.473750-5=
-abd.masalkhi@gmail.com/
>
> Changes in v3:
>   - No changes.
>   - Link to v2:https://lore.kernel.org/linux-raid/20260628142420.1051027-=
5-abd.masalkhi@gmail.com/
>
> Changes in v2:
>   - Expand the commit message to explain why the
>     allow_barrier()/wait_barrier() pair is no longer needed.
>   - Link to v1:https://lore.kernel.org/linux-raid/20260623072456.333437-5=
-abd.masalkhi@gmail.com/
> ---
>   drivers/md/raid10.c | 2 --
>   1 file changed, 2 deletions(-)
Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thanks,
Kuai
