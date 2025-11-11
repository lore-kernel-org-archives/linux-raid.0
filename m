Received: from sg-1-19.ptr.blmpb.com (sg-1-19.ptr.blmpb.com [118.26.132.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A137313E21
	for <linux-raid@vger.kernel.org>; Tue, 11 Nov 2025 03:21:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762831296; cv=none; b=A8rFWH+anFev2YRDQ8O4LIDWRx9SiDZJa1+QlvjyiIl+n6W/L4t9n5wdTQZspe+0n8v/1a6BsLKvGJQTG+0SIpH2XrQZRidGc35LIoL/U79kobNZuHu65IZi/aNDey0yZx96PVnH9GggL80dNfI0o16yQENKzw+zMrcUTWU1BjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762831296; c=relaxed/simple;
	bh=AHB52eEjxStBQk6dZmmYcxvMe3M9shlVvPTqOYRW2C0=;
	h=Subject:Date:Message-Id:Mime-Version:From:To:Content-Type:
	 In-Reply-To:References:Cc; b=EyltpK5QkxGglICsF/ex8PK5kXynsOWyamgV+DiLax7oyM4XXXJ6X4iRg+8EuGjseDU9uHohrhJujJDUOYl7gHglqzkoa/NNurvyapgcH53t0tQUrDmneS2OcZGbQp28mK4BWoJdEJoK03hEa0VSERow3OVTGPynwm/ZVJsQFk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=none smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=TMKDQuhU; arc=none smtp.client-ip=118.26.132.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="TMKDQuhU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1762831282;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=kb27e6BRLAEUtSqm3v58wAJXfNor0uUU3QfgJ1slkZE=;
 b=TMKDQuhUxXXptVT6PpAwOZoGLBS2B5kKgucHSnI1z7MXmQW2PGHV7N9KSwHnCzOMxWWni2
 K+rDKm9CUk1fBMw0nRzaUNsz48OieSK7nhRNwcHR0kp5oyK9iBBqoJUHWPj+MS3GIl3W3I
 CFhR7BivGmIeiHtkUpCbEL3DXzKyHDUd79qmb+//VzTRrdCByLCndqtDWkUA4tlTGZbCk8
 /ykl0qg7IfsTUe/fIssXAXKeM0KzaneqnbY747UF8e20Yr+lPxdx4NC9pLve24BhdqmFz6
 zHRlKlkBDGFPxWhNiAe1sPynzckQ8HwhiFoT03hn4uZ0Vd9baC3A8K771C+2Yg==
Received: from [192.168.1.104] ([39.182.0.168]) by smtp.feishu.cn with ESMTPS; Tue, 11 Nov 2025 11:21:19 +0800
X-Lms-Return-Path: <lba+26912abb0+376742+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: [PATCH v9 0/5] make logical block size configurable
Date: Tue, 11 Nov 2025 11:21:17 +0800
Message-Id: <10606bd7-0a41-4885-be34-b72e26595816@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
From: "Yu Kuai" <yukuai@fnnas.com>
To: <linan666@huaweicloud.com>, <corbet@lwn.net>, <song@kernel.org>, 
	<linan122@huawei.com>, <xni@redhat.com>, <hare@suse.de>
User-Agent: Mozilla Thunderbird
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20251103125757.1405796-1-linan666@huaweicloud.com>
References: <20251103125757.1405796-1-linan666@huaweicloud.com>
Reply-To: yukuai@fnnas.com
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Cc: <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <yangerkun@huawei.com>, 
	<yi.zhang@huawei.com>

=E5=9C=A8 2025/11/3 20:57, linan666@huaweicloud.com =E5=86=99=E9=81=93:

> From: Li Nan <linan122@huawei.com>
>
> v9:
>   - Add new patch to intorduce check_new_feature to address forward and
>     backward compatibility
>   - Patch 5: update description of check_new_feature in md.rst
>
> v8:
>   - Path 2: remove unnecessary bioset_initialized() check.
>   - Path 3: remove the max(blksize, ...)
>   - Path 4: set MD_SB_CHANGE_DEVS instead of call md_update_sb()
>
> v7:
>   - Add three prerequisite patch to fix some config lbs related issues
>   - Update sb when lbs configuration is done
>   - This feature should support raid0, update documentation accordingly
>
> Li Nan (5):
>    md: delete md_redundancy_group when array is becoming inactive
>    md: init bioset in mddev_init
>    md/raid0: Move queue limit setup before r0conf initialization
>    md: add check_new_feature module parameter
>    md: allow configuring logical block size
>
>   Documentation/admin-guide/md.rst |  10 ++
>   drivers/md/md.h                  |   1 +
>   include/uapi/linux/raid/md_p.h   |   3 +-
>   drivers/md/md-linear.c           |   1 +
>   drivers/md/md.c                  | 162 +++++++++++++++++++++++--------
>   drivers/md/raid0.c               |  17 ++--
>   drivers/md/raid1.c               |   1 +
>   drivers/md/raid10.c              |   1 +
>   drivers/md/raid5.c               |   1 +
>   9 files changed, 148 insertions(+), 49 deletions(-)

Applied to md-6.19
Thanks
