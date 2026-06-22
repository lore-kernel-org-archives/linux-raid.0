Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB14337B00F
	for <linux-raid@vger.kernel.org>; Mon, 22 Jun 2026 11:14:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782126857; cv=none; b=sE7Gan9/hzO7xGF0lSdGw6G2rX3BHer44wKdbNq1LIExWfxC0JZ/tLzcH/bK5hME9dp1cb3mZLWcocIIg3xLx0UppQdQuLeynrmIdd7z3zyrAzUojyRJ5GSugDmQl8mKXQpqyuQv8PBfEbjje2erwkx/e1pAxQMS8pF47Bz73W8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782126857; c=relaxed/simple;
	bh=2/GXJ1v/8C8jVv6tFpMOQNDAd95YcKY8D3l6Ia3jVqI=;
	h=In-Reply-To:From:Date:To:Mime-Version:Content-Type:References:Cc:
	 Subject:Message-Id; b=EBLPffvwq25tgz1hx6nw9cDw6kihD1OxsrUu7CBgAM14z7xFafzqzT0qJNiqkMhniiCyHWC1EHqaeyfjPoL3u2CThS5OQ29/GHNPcrfXtol3pJPWKmzXGGMs5ORhexC8qmgIwpK+GGPL3VGXZunkkn6qk8i0EkMUy4Ca749t3RE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=SH8JY3b6; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="SH8JY3b6"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782126838;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=0oFhcWZdkRE4pJaXLspCkDbrFDEIRc62z3kfabnzsfs=;
 b=SH8JY3b6a99+u9CnoxeCrsjotqI85PDv0uC3YiOUdPYVxYnkLwGZEjsBd+vGrlNiGTlCZ7
 me7LsC+CXVlWGYTzCvlp9eGjm6x4ip7MbOhWnQ5pbSRGP8f4h4ythNjEHqD9O6AWD3gzPz
 aykotH3TVfeohCtjJq8PZPmHAnI2olEgGcVw7lI3/ct2o43RyWN3/VWdtttdG06goeS80H
 kipLlbNq6fAJ1Nxh/kbDHJsXcuk6xAFMUcjDhGl85Ikm0Fge6s3l/yFLFCoaiLfg5KmbNV
 19jinQ7akX84t92HSYAohvO6rv2F3XnZwfJeAt2Tw2iCZxd7MQrFneoS2zYFRQ==
In-Reply-To: <a2f3a5da-71c3-4cff-ba97-db39e3ec4964@fygo.io>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Mon, 22 Jun 2026 19:13:54 +0800
X-Lms-Return-Path: <lba+26a3918f4+03c958+vger.kernel.org+chencheng@fnnas.com>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20260603035925.217847-1-chencheng@fnnas.com> <20260603035925.217847-4-chencheng@fnnas.com> <21def978-3c6e-4a9f-8c60-c213e760fb7c@fygo.io> <f877d9f4-4912-4331-8c14-e7726adf24bc@fnnas.com> <a2f3a5da-71c3-4cff-ba97-db39e3ec4964@fygo.io>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4 3/3] md/raid10: bound reused r10bio devs[] walks by used_nr_devs
Message-Id: <6b3bc982-e895-4672-9161-468a10591ebd@fnnas.com>
Received: from [192.168.8.62] ([183.34.162.92]) by smtp.feishu.cn with ESMTPS; Mon, 22 Jun 2026 19:13:55 +0800
User-Agent: Mozilla Thunderbird

=E5=9C=A8 2026/6/22 15:53, yu kuai =E5=86=99=E9=81=93:
> Hi=EF=BC=8C
>=20
> =E5=9C=A8 2026/6/22 14:34, Chen Cheng =E5=86=99=E9=81=93:
>> The true dangerous is in-flight r10bio which use old geometry.
>=20
> You didn't explain why there can be inflight r10bio when array is suspend=
ed,
> if this can happen, this is the root cause need to be fixed.
>=20

one scenario is .

CPU A (softirq, raid_end_bio_io)         CPU B (action_store)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D        =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
bio_endio(master_bio)
md_end_clone_io
         percpu_ref_put =E2=86=92 0
                                         wait_event wakeup,
						mddev_suspend return
                                         raid10_start_reshape:
                                           setup_geo(&conf->geo, new)
                                           ...
                                           mempool_destroy(old_pool)
                                           conf->r10bio_pool =3D new_pool
allow_barrier(conf)
free_r10bio(r10_bio)
put_all_bios:
for (i=3D0; i<conf->geo.raid_disks; i++)
         =3D=3D> old obj, new geo, OOB
mempool_free(r10_bio, conf->r10bio_pool)
         =3D=3D> old geo obj free into new pool




The fix,  as your advise , raid_end_bio_io:
1. put_all_bios, mempool_free
2. bio_endio if returned
3. allow_barrier



would be replace with patch 03.
