Received: from va-2-29.ptr.blmpb.com (va-2-29.ptr.blmpb.com [209.127.231.29])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D32A13A7F52
	for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 04:29:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.29
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782188964; cv=none; b=R7pnJj3Mgog0UOAECRdmTZsrs2wgMoUz6M6WYQ7WSMDdjb1zpe14IRizDjQPD4JFmFytlMQnJ5tSO0OP1nxOH3KX7Krw62Y3VUY2UtbTW4mXI3MPyZh9tcMTJ8gMW2ocQsptOxvBOC7FVyPiAeh0wEarcEKdryz3dukuXRnpwc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782188964; c=relaxed/simple;
	bh=FKGVb9dyBE9OhzUZQQNMu40cUvmSSGYyyqBIDcQaEt4=;
	h=To:Cc:Message-Id:Content-Type:From:Date:In-Reply-To:Subject:
	 Mime-Version:References; b=KqAhKXaCJznMkX7zDaQeKs2f+ZSJga/TsMf2Y3WJBCSRdueZGtmTmlImeuqi8S9RcmQ3i2pQp2hPJxxp4xumYMWkNdKLytInQ1OVpy30GohkGiv51V7J2ktltnMPiGWjQ/BNj0PgT9WH8SOsoabIApAbmK4fLf/Sw6O3ohYatKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=jhVYyn7r; arc=none smtp.client-ip=209.127.231.29
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="jhVYyn7r"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1782188956;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=MQH/cwk3KYTUt7gVHc9EMPKlVE+/tMDmSxyTSNHnK28=;
 b=jhVYyn7rQNgonzbn6qOqOE7+1kHhnRRUd/uiVcZdDo774eW+UEDU8UquAnjNSxSVGWEZzO
 qzfwnt1OgLbZ4Y58Sc8LyYtbzkZIX28GXbVB8t1Snx0q1LctUdpoKcLC83JoyFR+GKXgIH
 RfA8oE1oNagVDGEIGgvC2mYyNZQ1mhH+9ZtRuNIPSIFOvJ3zudeKirDAW1iKrO6cbt8h8z
 iF8LB8LdCwOY6Em6s89sj7DvUJU0LQWVPh565RdGtsgPXGHYJ5mY6paQy32DmcvnwAquzS
 kokkfcGPWT5yszZoANk3IqiEnOM2PsxUu2lEUBp7TiatC0OGEzkNNB1wMbrswg==
To: <yukuai@fygo.io>, <linux-raid@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
User-Agent: Mozilla Thunderbird
Message-Id: <e0b0a9f1-cafb-46b7-b1ea-f4981abf027b@fnnas.com>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Chen Cheng <chencheng@fnnas.com>
From: "Chen Cheng" <chencheng@fnnas.com>
Date: Tue, 23 Jun 2026 12:29:12 +0800
In-Reply-To: <9919b1ec-66ca-4f91-af58-fdc34c0f8273@fygo.io>
Subject: Re: [PATCH v4 1/3] md: suspend array before raid10 reshape via sync_action
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260603035925.217847-1-chencheng@fnnas.com> <20260603035925.217847-2-chencheng@fnnas.com> <9919b1ec-66ca-4f91-af58-fdc34c0f8273@fygo.io>
Received: from [192.168.8.62] ([183.34.170.156]) by smtp.feishu.cn with ESMTPS; Tue, 23 Jun 2026 12:29:13 +0800
X-Lms-Return-Path: <lba+26a3a0b9a+d735f5+vger.kernel.org+chencheng@fnnas.com>
Content-Transfer-Encoding: quoted-printable

=E5=9C=A8 2026/6/21 03:43, yu kuai =E5=86=99=E9=81=93:
> Hi,
>=20
> =E5=9C=A8 2026/6/3 11:59, Chen Cheng =E5=86=99=E9=81=93:
>> From: Chen Cheng <chencheng@fnnas.com>
>>
>> The sync_action=3Dreshape path currently enters mddev_start_reshape() wi=
th
>> reconfig_mutex held but without suspending the array first. For raid10,
>> that means raid10_start_reshape() has to drop reconfig_mutex and reacqui=
re
>> the array through mddev_suspend_and_lock_nointr() before it can safely
>> switch geometry-dependent state.
>>
>> Use mddev_suspend_and_lock() for ACTION_RESHAPE in action_store(), so
>> the sysfs reshape path reaches mddev_start_reshape() with the array
>> already suspended and locked.
>>
>> Other sync_action operations keep using mddev_lock() unchanged.
>>
>> Signed-off-by: Chen Cheng <chencheng@fnnas.com>
>> ---
>>    drivers/md/md.c | 22 +++++++++++++++++-----
>>    1 file changed, 17 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 096bb64e87bd..5bc937e149ac 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -5256,30 +5256,39 @@ static int mddev_start_reshape(struct mddev *mdd=
ev)
>>   =20
>>    static ssize_t
>>    action_store(struct mddev *mddev, const char *page, size_t len)
>>    {
>>    	int ret;
>> +	bool suspended =3D false;
>>    	enum sync_action action;
>>   =20
>>    	if (!mddev->pers || !mddev->pers->sync_request)
>>    		return -EINVAL;
>>   =20
>> +	action =3D md_sync_action_by_name(page);
>>    retry:
>>    	if (work_busy(&mddev->sync_work))
>>    		flush_work(&mddev->sync_work);
>>   =20
>> -	ret =3D mddev_lock(mddev);
>> +	if (action =3D=3D ACTION_RESHAPE) {
>> +		ret =3D mddev_suspend_and_lock(mddev);
>=20
> suspend during retry is too heavy. Please move suspend above retry.

hi,

If we move suspend before flush_work , that would have a deadlock window=20
from sashiko-bot review comment.

code like:
  action_store(struct mddev *mddev, const char *page, size_t len)
  {
	...

+	action =3D md_sync_action_by_name(page);
+	if (action =3D=3D ACTION_RESHAPE) {
+		ret =3D mddev_suspend(mddev, true);
+		if (ret)
+			return ret;
+		suspended =3D true;
+	}
  retry:
  	if (work_busy(&mddev->sync_work))
  		flush_work(&mddev->sync_work);

  	ret =3D mddev_lock(mddev);


and the scenario is :

reshape:
action_store() -> mddev_suspend() -> flush_work()

mddev_suspend(), mark implicit GFP_NOIO allocation scope for thread#1 by=20
  memalloc_noio_save().

flush_work() call sync_work handler md_start_sync() and would call=20
kzalloc_obj by flag GFP_KERNEL.

So.. when memory reclaim issue I/O to array and it's suspended,
md_handle_request() wait in !is_suspended(mddev, bio) by sleep , cause=20
deadlock.

Seems both way is unacceptable ?

>=20
>> +		suspended =3D true;
>> +	} else {
>> +		ret =3D mddev_lock(mddev);
>> +		suspended =3D false;
>> +	}
>>    	if (ret)
>>    		return ret;
>>   =20
>>    	if (work_busy(&mddev->sync_work)) {
>> -		mddev_unlock(mddev);
>> +		if (suspended)
>> +			mddev_unlock_and_resume(mddev);
>> +		else
>> +			mddev_unlock(mddev);
>>    		goto retry;
>>    	}
>>   =20
>> -	action =3D md_sync_action_by_name(page);
>> -
>>    	/* TODO: mdadm rely on "idle" to start sync_thread. */
>>    	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
>>    		switch (action) {
>>    		case ACTION_FROZEN:
>>    			md_frozen_sync_thread(mddev);
>> @@ -5344,11 +5353,14 @@ action_store(struct mddev *mddev, const char *pa=
ge, size_t len)
>>    	md_wakeup_thread(mddev->thread);
>>    	sysfs_notify_dirent_safe(mddev->sysfs_action);
>>    	ret =3D len;
>>   =20
>>    out:
>> -	mddev_unlock(mddev);
>> +	if (suspended)
>> +		mddev_unlock_and_resume(mddev);
>> +	else
>> +		mddev_unlock(mddev);
>>    	return ret;
>>    }
>>   =20
>>    static struct md_sysfs_entry md_scan_mode =3D
>>    __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_sto=
re);
>
