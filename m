Received: from mail-108-mta6.mxroute.com (mail-108-mta6.mxroute.com [136.175.108.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50DE13890E9
	for <linux-raid@vger.kernel.org>; Thu, 16 Apr 2026 14:15:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776348930; cv=none; b=AOeVSn2sP/K6pqbiCiHz90uE2J57lcGpJ7MfUKlF6uTBRXAncaxI58Gd0FBYvqs8UB3X9orPEbQE/cefXMCk4pO52qalMub98yqTw8QS9WuMjdAj1v6EtzHHRO9WeXDA+qFyYuV2TvtKmJ7nZO5FTTT3fm19Lo/vFOZ3w/b7aXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776348930; c=relaxed/simple;
	bh=8peAxsyq1As1UDvxjxU8y9FJdrt9WCtG7JHlCx48X1o=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Y7dioKA4EGn3pCBrY3ADHHpGtIkNch9HiIrQHF1VAMrx9FuGcUY6OiA/8iBKjGxZgVRkj3y3X2E1HqCi65f3CiBJi+LRzKxiCmbyhYJ8Am75h7RY9DR5ZBeofjnQbCZuj8J0tAXFMN04LXc0BBP+JxYgvveRSBTaIg1j3cgRahs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=ZfqdXDmx; arc=none smtp.client-ip=136.175.108.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="ZfqdXDmx"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta6.mxroute.com (ZoneMTA) with ESMTPSA id 19d96a0df2300032bf.007
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Thu, 16 Apr 2026 14:10:18 +0000
X-Zone-Loop: 10c739bdcf216eaafaa1c8db673396e7231e58220f28
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=0iNmrtsGFEZf57SMSMQrxzYpJkckvRCQByhE42bjGTg=; b=ZfqdXDmx/jh6W+ARDVSPlIBlEp
	su+KgXgHRTfU+CWT4rpKEZM5JDdB+XUXcDgAzdpst8PdaYXRsls5TUpmaYe0UhCCPrFD48NCKz8h7
	wwQVxqLM6/mqFyJH6eLjOk2cbpiP/sog8VQhT1sVq3PbWKunuD1KxINswisvUf/6iHCqzkPttaTYH
	z0VeT5Pr5PXIWTR58YDayOVielx+teb76D2PixOM7YM6rl5LKFSivCqILZ0/ChSL6IWh9S2oZ0HCd
	hvFH0pvAnFcJ4bP2qq0MASV1WicpKt4pKXLi/JoxlINbQY8AVDbkSNB4vA9+9ZC6j3qslMZsxJ4Fo
	Xcpjg5Uw==;
From: Su Yue <l@damenly.org>
To: Su Yue <glass.su@suse.com>
Cc: linux-raid@vger.kernel.org,  song@kernel.org,  xni@redhat.com,
  linan122@huawei.com,  yukuai@fnnas.com,  heming.zhao@suse.com
Subject: Re: [PATCH v2 0/5] md: bitmap grow fixes
In-Reply-To: <20260407102625.5686-1-glass.su@suse.com> (Su Yue's message of
	"Tue, 7 Apr 2026 18:26:20 +0800")
References: <20260407102625.5686-1-glass.su@suse.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Thu, 16 Apr 2026 22:10:08 +0800
Message-ID: <bjfj6lof.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Tue 07 Apr 2026 at 18:26, Su Yue <glass.su@suse.com> wrote:

> Hi, This v2 series is to fixes bugs exposed by 
> mdadm/clustermd-autotest.
> The bugs are not cluster md only but also bitmap related.
>
> The series based on v7.0-rc7 passes tests with mdadm v4.6 
> without regression.
>
> v2:
>     Add a dummy bitmap operations per Kuai's suggestion.
>
> To Yu Kuai:
> A NULL group can't used for internal_bitmap_group since
> the entries from internal_bitmap_attrs should be under bitmap.
> So instead of sysfs_create_groups(), sysfs_create_group() and 
> sysfs_merge_group()
> are still needed /sigh.
>
> Su Yue (5):
>   md/md-bitmap: call md_bitmap_create,destroy in location_store
>   md/md-bitmap: add an extra sysfs argument to md_bitmap_create 
>   and
>     destroy
>   md/md-bitmap: add dummy bitmap ops for none to fix wrong 
>   bitmap offset
>   md: skip ID_BITMAP_NONE when show available bitmap types
>   md/md-bitmap: remove member group from bitmap_operations
>
Missing part should be added in v3:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 20a953676319..453b89941db2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6450,9 +6450,6 @@ static int start_dirty_degraded;

 int md_bitmap_create(struct mddev *mddev, bool create_sysfs)
  {
  -       if (mddev->bitmap_id == ID_BITMAP_NONE)
  -               return -EINVAL;
  -
}
>  drivers/md/md-bitmap.c   | 121 
>  ++++++++++++++++++++++++++++++++++++---
>  drivers/md/md-bitmap.h   |   3 +-
>  drivers/md/md-llbitmap.c |  13 ++++-
>  drivers/md/md.c          |  55 +++++++++---------
>  drivers/md/md.h          |   2 +
>  5 files changed, 155 insertions(+), 39 deletions(-)
