Received: from va-2-30.ptr.blmpb.com (va-2-30.ptr.blmpb.com [209.127.231.30])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F7732470F
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 05:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.30
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776748516; cv=none; b=NYQjqmJrXW5jMnqs46tNa3mouT/px8ATweOB/Gr0YdUYomqJe1e1lhhmT1LJ8z8n0duKFdmndH3K9zHMB5bR0qcmlG3Dgsos8CDOZ79XnicEV0lHlJig8uAEpksJiwZ9zDXie3Cgo138xhP+9wHZb+61YtXf8E0UAYI74f/Vln4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776748516; c=relaxed/simple;
	bh=hE2uOr9GerH4ChcmwGo2uXpp/tv71jX8KzvSRzlX9VQ=;
	h=References:From:Subject:Mime-Version:Message-Id:To:Date:
	 In-Reply-To:Cc:Content-Type; b=GLRGEDYI0LPU/8ZS6sGVPcmK3rOyd7WKFi9R1yo6vYMJhcHiLmW/u1EP5YmfqGQpFMRHWbqVRF8MEUr8CFhmIk7k3/D99h0q6SPFG+m6ZoLRqfWnBtWei+oeWSPxG3ET5dNrNmFVn+RoBlOYv/SzaY8GkM9GoLbXSvSoGaXMqww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=2LZEqnuI; arc=none smtp.client-ip=209.127.231.30
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="2LZEqnuI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1776748508;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=zUZk3vGCqPdAMCbPCj437U7a5SOvl5JwJ0WEdJmZUu4=;
 b=2LZEqnuI5zC64RI6oafQojpee8k6tI3wJbroDX2QqP7nTSTmZnlFos4iSJBCBvG2g6OE6R
 mB5lC/sD5GhWTu90QGFUed7nFmSJokFB3eUkQModsFW93hKJNgQCSK4jPHW5AJeO7W8zQT
 TojWiwN4Ui/yCKg/1JLAmBhZtaJqN7hJQXKCzkSEskgXw/oRvRD9yWRwWdkFO9QilVQI+A
 zajh+ghc/addgI91+JY1FYAJU2dfeuJaC3kxnIQjTLtyO5bD2SLVtBUi04viRA3o0JC0Fa
 RKZH1nyvr/fcfG/QyIoLQO/R4a5aZR3n6YifKQEMspw8yL+av8nPT6Ysngn1rQ==
Content-Language: en-US
References: <20260407102625.5686-1-glass.su@suse.com>
Received: from [192.168.1.104] ([39.182.0.144]) by smtp.feishu.cn with ESMTPS; Tue, 21 Apr 2026 13:15:05 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [PATCH v2 0/5] md: bitmap grow fixes
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Message-Id: <afb84561-e7c4-4d08-b7ca-bd20e9f8dbda@fnnas.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Yu Kuai <yukuai@fnnas.com>
X-Lms-Return-Path: <lba+269e707da+387d4c+vger.kernel.org+yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com
To: "Su Yue" <glass.su@suse.com>, <linux-raid@vger.kernel.org>
Date: Tue, 21 Apr 2026 13:15:04 +0800
In-Reply-To: <20260407102625.5686-1-glass.su@suse.com>
Cc: <song@kernel.org>, <xni@redhat.com>, 
	"linan122@huawei.com >> Li Nan" <linan122@huawei.com>, 
	<yukuai@fnnas.com>, "Heming Zhao" <heming.zhao@suse.com>
Content-Type: text/plain; charset=UTF-8
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/4/7 18:26, Su Yue =E5=86=99=E9=81=93:
> Hi, This v2 series is to fixes bugs exposed by mdadm/clustermd-autotest.
> The bugs are not cluster md only but also bitmap related.
>
> The series based on v7.0-rc7 passes tests with mdadm v4.6 without regress=
ion.
>
> v2:
>      Add a dummy bitmap operations per Kuai's suggestion.
>
> To Yu Kuai:
> A NULL group can't used for internal_bitmap_group since
> the entries from internal_bitmap_attrs should be under bitmap.
> So instead of sysfs_create_groups(), sysfs_create_group() and sysfs_merge=
_group()
> are still needed /sigh.

Thanks for the set and sorry for the delay.

TBO, this set is still a bit complex than expected. It's true sysfs_create_=
groups()
can't be used for the groups with same name. However, there is still anothe=
r api
sysfs_update_groups() that can be used in this case.

I just finish a local version and confirm following 3 commits should be eno=
ugh:

1) factor out bitmap sysfs creation from mddev_set_bitmap_ops(), and create=
 sysfs entries
after bitmap is created.
2) split bitmap/location out as the common bitmap groups, and convert bitma=
p filed groups
to struct attribute_group **groups;
3) add a separate bitmap_ops for none bitmap, location_store() can be simil=
ar to
patch 3 in your set, just create/remove additional internal_bitmap_group.

> Su Yue (5):
>    md/md-bitmap: call md_bitmap_create,destroy in location_store
>    md/md-bitmap: add an extra sysfs argument to md_bitmap_create and
>      destroy
>    md/md-bitmap: add dummy bitmap ops for none to fix wrong bitmap offset
>    md: skip ID_BITMAP_NONE when show available bitmap types
>    md/md-bitmap: remove member group from bitmap_operations
>
>   drivers/md/md-bitmap.c   | 121 ++++++++++++++++++++++++++++++++++++---
>   drivers/md/md-bitmap.h   |   3 +-
>   drivers/md/md-llbitmap.c |  13 ++++-
>   drivers/md/md.c          |  55 +++++++++---------
>   drivers/md/md.h          |   2 +
>   5 files changed, 155 insertions(+), 39 deletions(-)
>
--=20
Thansk,
Kuai
