Received: from va-2-36.ptr.blmpb.com (va-2-36.ptr.blmpb.com [209.127.231.36])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDF02D0C89
	for <linux-raid@vger.kernel.org>; Thu, 21 May 2026 01:28:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.36
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779326914; cv=none; b=sko9yP8K85r4f1cbgfXY5NF5GcF3xFBt2oCD+BqvwvfuVAJIcsgRhh4qDzDgqMn867UIERcLk0jIrxVYauJXup/+2aMQOLa6vUbFo9VkrjmaJCs5Igy6qwVGc63JpeoaZyEYZ7yWTo5POAAnDvRF6u/fId56cg6G0TPZb77XOxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779326914; c=relaxed/simple;
	bh=r1jXqHAxFPXVVqtvI4DBitP8oZ4BpAa1NPQZPNxkO1A=;
	h=To:References:Content-Type:Message-Id:Cc:In-Reply-To:From:Subject:
	 Date:Mime-Version; b=iuKqqa9d1bIJ4Nsd2djeu/XiVJ3RkThc6jQsw0Aj2MBXpR7KTGmX11unIv/6fkuHd+aVOT5sSgQtPuVzpBTcO7omf6Wyvhrj4SrZIQAcuqMWdeOTymc3KmXS7btF2qgI7b2ueAdq4xzr/BjmewLJvBbKRab8PFoSBRnLg951CbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=HJI0he8t; arc=none smtp.client-ip=209.127.231.36
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="HJI0he8t"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1779326899;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=qFuJdayaz0Rc63OK0MVpyRuRO1dQDQj3W1wWjzTRHfk=;
 b=HJI0he8t47kiH5ATcPuuHzXysUwqRQs8VDtDcUYZKhATuJwudXlgnmkOtp+BVzsRVpV+Pn
 hP5zFgINnQuQqwsaC/wIJgLiDzptl6OZ+G1e7vTC/0UvTtge7OGd0m1O0AV1kWsPVxfONS
 Ufn4GMXYRXG5hCuZswbY6bCwWi79wz7lHcwR5EvkKLocq4JDMgjCnnoBFvJpqDMRHayHZs
 If2CDX9WlPmGBylfEL2vaNRISUZPZU/U3FZodlqBcXZLa1oQZxIRNqs/5hlWgasEB6F81T
 0Q+AeIOyYITyhUKjgGIg8nwISEQx/TUCfbNyhAN+IWA+6y4cwIOP4ttoW6CptA==
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, <song@kernel.org>, 
	<xni@redhat.com>, <neilb@suse.com>, <shli@fb.com>
References: <20260501114652.590037-1-abd.masalkhi@gmail.com> <20260501114652.590037-2-abd.masalkhi@gmail.com>
X-Lms-Return-Path: <lba+26a0e5fb1+45a6c6+vger.kernel.org+yukuai@fnnas.com>
Content-Type: text/plain; charset=UTF-8
Message-Id: <80f129b1-908b-401c-9dee-c85822b6b700@fygo.io>
Received: from [192.168.1.104] ([39.182.0.188]) by smtp.feishu.cn with ESMTPS; Thu, 21 May 2026 09:28:16 +0800
Reply-To: yukuai@fygo.io
Cc: <linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<yukuai@fygo.io>
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260501114652.590037-2-abd.masalkhi@gmail.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 1/3] md/raid1,raid10: fix deadlock in read error recovery path
Date: Thu, 21 May 2026 09:28:14 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
X-Original-From: Yu Kuai <yukuai@fygo.io>
User-Agent: Mozilla Thunderbird

=E5=9C=A8 2026/5/1 19:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:

> raid1d and raid10d may resubmit a split md cloned bio while handling
> a read error. In this case, resubmitting the bio can lead to a deadlock
> if the array is suspended before md_handle_request() acquires an
> active_io reference via percpu_ref_tryget_live().
>
> Since the cloned bio already holds an active_io reference,
> trying to acquire another reference via percpu_ref_tryget_live()
> can lead to a deadlock while the array is suspended.
>
> Fix this by using percpu_ref_get() for md cloned bios.
>
> Fixes: bb2a9acefaf9 ("md/raid1: switch to use md_account_bio() for io acc=
ounting")
> Fixes: 820455238366 ("md/raid10: switch to use md_account_bio() for io ac=
counting")
> Signed-off-by: Abd-Alrhman Masalkhi<abd.masalkhi@gmail.com>
> ---
> Changes in v2:
>   - Use md_cloned_bio() consistently to detect cloned bios.
>   - Recognize that raid10 has the same issue and fix it in this series=09
>   - Allow splitting bios.
>   - Handle md cloned bios explicitly in md_handle_request()
>   - Link v1:https://lore.kernel.org/linux-raid/20260427103446.300378-1-ab=
d.masalkhi@gmail.com/
>
> Please let me know if I should add a Suggested-by tag for Yu Kuai,
> as the solution approach was suggested during review.
>
> Link to Yu Kuai' email:https://lore.kernel.org/linux-raid/m2lde74dtw.fsf@=
gmail.com/T/#m714020a38b60fc5f84b9a24f0c46acbe5d7342d6
>
> Thanks
> Abd-alrhman
> ---
>   drivers/md/md.c | 25 ++++++++++++++++---------
>   drivers/md/md.h |  5 +++++
>   2 files changed, 21 insertions(+), 9 deletions(-)

Reviewed-by: Yu Kuai <yukuai@fygo.io>

--=20
Thansk,
Kuai
