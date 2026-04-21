Received: from mail-108-mta58.mxroute.com (mail-108-mta58.mxroute.com [136.175.108.58])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE7371624D5
	for <linux-raid@vger.kernel.org>; Tue, 21 Apr 2026 05:45:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.58
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776750313; cv=none; b=Vv7O1hihdN6Ws007aOHWyXUc1tP0BaUXTEdB9Mb5g4uKDJ574IRJmSB96aVHthd1bgympBNQKm3YphupgT26L+vthxuAb3VeUjJDWPVFb2yJ02MvWb620UGvgf1J+mpmM0LM1mcwLFNePhKOTMq72gVzyD4ITJ01mqKkfGhAMMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776750313; c=relaxed/simple;
	bh=PFDm1l3zhtlQVyUri7oXvQhWktzsXItKwsK+dWL3bf8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=J3gyobt5/vJoSansvunIMvNz7VmGVdVjfKFOfZaZ5xjnjWsJkFAV+68d+jdV49LRcp7tjrkzBSs5kMC1rn6KKldWPrzk3ao7YQzmDq9adFyne6mc6LGO1HcMDoc1bIdFIb9es9AcUzbgYQ6tca1ACClAsRQkBDscsAYyYrQjelA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=su5rISeY; arc=none smtp.client-ip=136.175.108.58
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="su5rISeY"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta58.mxroute.com (ZoneMTA) with ESMTPSA id 19dae8d800700032bf.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 21 Apr 2026 05:40:02 +0000
X-Zone-Loop: cf55e34f4a553f4c37d8e176f0baeda773625590f550
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:Date:
	References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=9ymBqQzgNxdfYyAMYkS2hE/UDM6Z4PZqnR6BNPKk6Hs=; b=su5rISeYIj0VydZjakEUyaPQjV
	jakfYYYrotoaAohutTpQzo3L5AfkpiGirM0tBGcxTivvKnvl1aHXY98Dww+3ZQkXTC/Ho2nn4r3NJ
	/FEg805GMJUEwwbTVh4yg2vu2+jfq4DhtVX240Fe41c+E1dYHh/+WMVJ6XOScyjTgbojuEbferfsq
	CfXJatPA9tSvs0z/n0eMiO0K/NeLJFQRCtTFV6ux7rPawLrM5ADTZ/QKgpVzFo+wwFp764gmn9F5l
	3ImNUjfrC1JWRj4aHua2yVZ63vYMREGx3FfB3E0YVl7PJD9wJ+kQXHxEmo/VKNWQ9YDryWGt8PHvc
	m9kjV+XA==;
From: Su Yue <l@damenly.org>
To: "Yu Kuai" <yukuai@fnnas.com>
Cc: "Su Yue" <glass.su@suse.com>,  <linux-raid@vger.kernel.org>,
  <song@kernel.org>,  <xni@redhat.com>,  "linan122@huawei.com >> Li Nan"
 <linan122@huawei.com>,  "Heming Zhao" <heming.zhao@suse.com>
Subject: Re: [PATCH v2 0/5] md: bitmap grow fixes
In-Reply-To: <afb84561-e7c4-4d08-b7ca-bd20e9f8dbda@fnnas.com> (Yu Kuai's
	message of "Tue, 21 Apr 2026 13:15:04 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
	<afb84561-e7c4-4d08-b7ca-bd20e9f8dbda@fnnas.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 21 Apr 2026 13:39:50 +0800
Message-ID: <v7dk7ty1.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Authenticated-Id: l@damenly.org

On Tue 21 Apr 2026 at 13:15, "Yu Kuai" <yukuai@fnnas.com> wrote:

> Hi,
>
> =E5=9C=A8 2026/4/7 18:26, Su Yue =E5=86=99=E9=81=93:
>> Hi, This v2 series is to fixes bugs exposed by=20
>> mdadm/clustermd-autotest.
>> The bugs are not cluster md only but also bitmap related.
>>
>> The series based on v7.0-rc7 passes tests with mdadm v4.6=20
>> without regression.
>>
>> v2:
>>      Add a dummy bitmap operations per Kuai's suggestion.
>>
>> To Yu Kuai:
>> A NULL group can't used for internal_bitmap_group since
>> the entries from internal_bitmap_attrs should be under bitmap.
>> So instead of sysfs_create_groups(), sysfs_create_group() and=20
>> sysfs_merge_group()
>> are still needed /sigh.
>
> Thanks for the set and sorry for the delay.
>
> TBO, this set is still a bit complex than expected. It's true=20
> sysfs_create_groups()
> can't be used for the groups with same name. However, there is=20
> still another api
> sysfs_update_groups() that can be used in this case.
>

IIUC, sysfs_update_groups() can't be used because it first removes=20
then re-add files
see linux/fs/sysfs/group.c:create_files() for details.
>
> I just finish a local version and confirm following 3 commits=20
> should be enough:
>
If you would like to send your own patchset.  I am happy to give=20
up my patchset then
review yours :) The only thing I want to fix the issue. Thanks.

--
Su

> 1) factor out bitmap sysfs creation from mddev_set_bitmap_ops(),=20
> and create sysfs entries
> after bitmap is created.
> 2) split bitmap/location out as the common bitmap groups, and=20
> convert bitmap filed groups
> to struct attribute_group **groups;
> 3) add a separate bitmap_ops for none bitmap, location_store()=20
> can be similar to
> patch 3 in your set, just create/remove additional=20
> internal_bitmap_group.
>
>> Su Yue (5):
>>    md/md-bitmap: call md_bitmap_create,destroy in=20
>>    location_store
>>    md/md-bitmap: add an extra sysfs argument to=20
>>    md_bitmap_create and
>>      destroy
>>    md/md-bitmap: add dummy bitmap ops for none to fix wrong=20
>>    bitmap offset
>>    md: skip ID_BITMAP_NONE when show available bitmap types
>>    md/md-bitmap: remove member group from bitmap_operations
>>
>>   drivers/md/md-bitmap.c   | 121=20
>>   ++++++++++++++++++++++++++++++++++++---
>>   drivers/md/md-bitmap.h   |   3 +-
>>   drivers/md/md-llbitmap.c |  13 ++++-
>>   drivers/md/md.c          |  55 +++++++++---------
>>   drivers/md/md.h          |   2 +
>>   5 files changed, 155 insertions(+), 39 deletions(-)
>>
