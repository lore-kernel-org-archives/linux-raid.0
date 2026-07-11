Received: from va-2-26.ptr.blmpb.com (va-2-26.ptr.blmpb.com [209.127.231.26])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 277823BB9ED
	for <linux-raid@vger.kernel.org>; Sat, 11 Jul 2026 10:56:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.26
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783767385; cv=none; b=Oic6iLoU1Ty541WweYWF5XoJuh3DbFe3WPO7/SZ2kd5dByGZLplNH3nsVE+crZ35A/gSCn+QxAHvvBz4DJfnlVu8Qs5bnSPpzzo6Xf0Q5ll/2woNM94lSSd41ms9Kd0G2u3MfNie9UR1PCk843xltnc2DzGajmQE7gUtep2kz6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783767385; c=relaxed/simple;
	bh=AK+ACzT5VBcWQgKhvoERK4+tQo95s41v/e90QAoYcIM=;
	h=Mime-Version:Content-Type:In-Reply-To:Cc:From:Message-Id:Subject:
	 Date:References:To; b=Md2KE0V36ixxgoob5tu/qRtLdRzkifWcqztUN6RLZmzoRXV0E2qqDF640+95cHXcFT6z0N18TOxnQhMtli3a4oo0Pi2nUQJzMADVKYmODv5x+6yxDyALUchVkr4SpRr6z/m4QzseaePCWWbuK9BoSCt4miwm8ML9AocKxWGCQZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=1YmW9Hpf; arc=none smtp.client-ip=209.127.231.26
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="1YmW9Hpf"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1783767374;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=f+q1M/OVRm/yFwpj4sF79wEdDC1fsuvgdteYp8P9T3E=;
 b=1YmW9HpfX6aqK2hSqiHiH9HlnvnRzV+4q38o3XNPHvdgS1FEMgmWHdcSUTd7A9JnZ01SgV
 Icg2ZBukN03USsd1EgsLdVFrlfL3zeJU1kVqM9JHyBQcjU+ueQWHTRXkkUwX4X4LhTGbx9
 32iMsA2ha3uxpJppvWEhZSBdEvbUmMef+w9AUpkrf6iMnMis/MOMqXsNu+561Pz31QhItZ
 +CDBaPy0HM+A2zYXwCclwFjjyCTHEWjeRFMaKlS2Pb02yhLTUq8zD4i/m5SVQnBtW7dEbh
 NiKxKVeF3tyOFrmf5Luqbxo9UKlrWkAf1NwECt/YYtLURXrEJvo/wVC1lccpMw==
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <m2y0g0z0ll.fsf@gmail.com>
X-Lms-Return-Path: <lba+26a52214c+973f30+vger.kernel.org+chencheng@fnnas.com>
User-Agent: Mozilla Thunderbird
Cc: <linux-kernel@vger.kernel.org>
X-Original-From: Chen Cheng <chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Message-Id: <2fcb6a64-25d7-4759-af6e-701a78f57e72@fnnas.com>
Received: from [192.168.8.91] ([183.34.162.102]) by smtp.feishu.cn with ESMTPS; Sat, 11 Jul 2026 18:56:12 +0800
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH] md: protect read mddev->recovery in md_sync_action()
Date: Sat, 11 Jul 2026 18:56:10 +0800
References: <20260627102909.141036-1-chencheng@fnnas.com> <m25x341cro.fsf@gmail.com> <da95c106-6416-4abd-8fef-3b71986c17f8@gmail.com> <m2y0g0z0ll.fsf@gmail.com>
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>, 
	"Chen Cheng" <chenchneg33@gmail.com>, <linux-raid@vger.kernel.org>, 
	<yukuai@fygo.io>

=E5=9C=A8 2026/6/27 19:25, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>=20
> Hi Chen,
>=20
> On Sat, Jun 27, 2026 at 18:52 +0800, Chen Cheng wrote:
>> =E5=9C=A8 2026/6/27 18:46, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>>> On Sat, Jun 27, 2026 at 18:29 +0800, Chen Cheng wrote:
>>>> From: Chen Cheng <chencheng@fnnas.com>
>>>>
>>>> md_sync_action() read mddev->recovery in lockless path, use READ_ONCE(=
)
>>>> instead of u64 plain read.
>>>>
>>> unisgned long is not always u64...
>>> I can not see what it fixes, is this just to silence KCSAN? If so,
>>> please say so in the commit message.
>>
>> I need to find KCSAN report , I lost this one, but I think it's easy to
>> find locklessly path to call md_sync_action(), so. READ_ONCE is need.
>>
> Thanks. Adding the KCSAN report would be helpful.
>=20

hi Abd-Alrhman

Uh... a apologize for my mislead . it's truelly report by review-bot ,=20
and after double check ,  I think it wouldn't be reproduce in my x86-64=20
machine , because 8B in x64-arch load is atomic +align..

thanks,
cheng.

>>>
>>>> Fixes: e792a4c2156a3 ("md: add new helpers for sync_action")
>>>>
>>>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>>>> ---
>>>>    drivers/md/md.c | 2 +-
>>>>    1 file changed, 1 insertion(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index c5c50640b684..f4415c1a79d9 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -5074,11 +5074,11 @@ static enum sync_action md_get_active_sync_act=
ion(struct mddev *mddev)
>>>>    	return is_recover ? ACTION_RECOVER : ACTION_IDLE;
>>>>    }
>>>>   =20
>>>>    enum sync_action md_sync_action(struct mddev *mddev)
>>>>    {
>>>> -	unsigned long recovery =3D mddev->recovery;
>>>> +	unsigned long recovery =3D READ_ONCE(mddev->recovery);
>>>>    	enum sync_action active_action;
>>>>   =20
>>>>    	/*
>>>>    	 * frozen has the highest priority, means running sync_thread will=
 be
>>>>    	 * stopped immediately, and no new sync_thread can start.
>>>> --=20
>>>> 2.54.0
>>>>
>>>
>>
>
