Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5BC56FC5
	for <linux-raid@vger.kernel.org>; Tue,  7 Apr 2026 05:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775540020; cv=none; b=ip4kHLj3Y59ohhk2Ty1UJugbQA5Cnk/ed2LKpAhKJvFsFnZ2tHbDmu5y3+XoPvryZrT4gHBVPIa52EElvjG/dU/xn7CbQcBBB4yT9PXxloC8eud/H/Awna1o7csdYpdDZl7gvQFN9pBhgJr2n3ZL/VZgpbA7iL116O12W1AsV0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775540020; c=relaxed/simple;
	bh=zpZELzSBy5845zntXjujbBTw+GsbiNXjCqOa5zQjw6M=;
	h=To:Date:Content-Type:Cc:In-Reply-To:Mime-Version:From:Subject:
	 Message-Id:References; b=WEkfJBrOGtfg4Iul8GkcquPSohIaYE9gaFskYH+xHdpAZBQERN245LAGLvwE4B4vu1Og9tXgjNYqKUd/TvrwtqLhV2gKCyXB+dc1fziikLGQQvfVsA+Bm+y8XSY1HUt6JIRsNjoyxTxzGUXFgs7251SLhJJynH1e+q1A79iW4e4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=NrlCcmRW; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="NrlCcmRW"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1775540014;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=zpZELzSBy5845zntXjujbBTw+GsbiNXjCqOa5zQjw6M=;
 b=NrlCcmRW3FAM5Q2QT3EFZ4R6P/7NHNTALGYG9oedPdIcW+krC5nv0gIiZ1cAXksZ4FVd+7
 S7fKiBRGD+jZQ4R+a5/goxQf4KRq3kQtnfd/3Kx1B2JkYDn0lTY5m0nLdxQuNcJuJ+qqlB
 oYg7rO1gGSQc05fEieZzIkNNHkV2oNCgDtyweWIBypLop7h7U9ReSTGQvbW+e0mZfKa8MD
 3UkiTMSTpgEkaWqgnfd5r0aLhPTYLgOe3p0FFBqbMim8zUUymeVsaiaPZYETRFEhkgjOUg
 SEKUOl/EsdNZiYtKLE+t0iIUEAcX2zaffhcs/j5ZCIyhFyo35VO7brIssoe3bw==
Content-Language: en-US
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.129]) by smtp.feishu.cn with ESMTPS; Tue, 07 Apr 2026 13:33:31 +0800
User-Agent: Mozilla Thunderbird
To: "Li Nan" <linan666@huaweicloud.com>, <song@kernel.org>, 
	<linux-raid@vger.kernel.org>
Date: Tue, 7 Apr 2026 13:33:29 +0800
Content-Type: text/plain; charset=UTF-8
Cc: <linux-kernel@vger.kernel.org>, 
	"yangerkun@huawei.com" <yangerkun@huawei.com>, <yukuai@fnnas.com>
In-Reply-To: <3f930776-20e7-f74b-067b-bfb348291a50@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH] md: wake raid456 reshape waiters before suspend
Message-Id: <ba76b132-4bf9-445f-9a77-6194c0fc437b@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+269d4972c+ca29b6+vger.kernel.org+yukuai@fnnas.com>
References: <20260327140729.2030564-1-yukuai@fnnas.com> <3f930776-20e7-f74b-067b-bfb348291a50@huaweicloud.com>
Reply-To: yukuai@fnnas.com

Hi,

=E5=9C=A8 2026/4/2 10:53, Li Nan =E5=86=99=E9=81=93:
>
>
> =E5=9C=A8 2026/3/27 22:07, Yu Kuai =E5=86=99=E9=81=93:
>> During raid456 reshape, direct IO across the reshape position can sleep
>> in raid5_make_request() waiting for reshape progress while still
>> holding an active_io reference. If userspace then freezes reshape and
>> writes md/suspend_lo or md/suspend_hi, mddev_suspend() kills active_io
>> and waits for all in-flight IO to drain.
>>
>> This can deadlock: the IO needs reshape progress to continue, but the
>> reshape thread is already frozen, so the active_io reference is never
>> dropped and suspend never completes.
>>
>> raid5_prepare_suspend() already wakes wait_for_reshape for dm-raid. Do
>> the same for normal md suspend when reshape is already interrupted, so
>> waiting raid456 IO can abort, drop its reference, and let suspend
>> finish.
>>
>> The mdadm test tests/25raid456-reshape-deadlock reproduces the hang.
>>
>> Fixes: 714d20150ed8 ("md: add new helpers to suspend/resume array")
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> ---
>> =C2=A0 drivers/md/md.c | 11 +++++++++++
>> =C2=A0 1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 65c85973092a..3ae5f36b5baf 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -489,6 +489,17 @@ int mddev_suspend(struct mddev *mddev, bool=20
>> interruptible)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
>> =C2=A0 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 percpu_ref_kill(&mddev->active_io)=
;
>> +
>> +=C2=A0=C2=A0=C2=A0 /*
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * RAID456 IO can sleep in wait_for_reshape whi=
le still holding an
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * active_io reference. If reshape is already i=
nterrupted or=20
>> frozen,
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * wake those waiters so they can abort and dro=
p the reference=20
>> instead
>> +=C2=A0=C2=A0=C2=A0=C2=A0 * of deadlocking suspend.
>> +=C2=A0=C2=A0=C2=A0=C2=A0 */
>> +=C2=A0=C2=A0=C2=A0 if (mddev->pers && mddev->pers->prepare_suspend &&
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 reshape_interrupted(mddev))
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 mddev->pers->prepare_suspend=
(mddev);
>> +
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (interruptible)
>> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 err =3D wait_even=
t_interruptible(mddev->sb_wait,
>> percpu_ref_is_zero(&mddev->active_io));
>
> If I only freeze raid5 without suspend, the IO still hangs and cannot
> complete. Should we fix this scenario?
Yes, for other path can freeze raid5 directly, we should fix it as well.
>
> --=20
> Thanks,
> Nan
>
--=20
Thansk,
Kuai
