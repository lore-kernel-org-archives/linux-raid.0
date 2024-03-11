Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50BB2C69A
	for <linux-raid@vger.kernel.org>; Mon, 11 Mar 2024 10:05:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710151540; cv=none; b=iEdhI/VK1U8DcsaZbCjSX4URJTQx5M67s3sd8UK7L9/1iAp/xvFJcUj7Y8hIrScqBVYzSAs39N+TdMo0zxzPeyxpu0BNb4drFSYT4a0sQZILihOry/OJgAFO+p8LvM9bnAQSOYJtdU3gbM+WntuigIhpZclIsk8eVVOilywMfBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710151540; c=relaxed/simple;
	bh=RVO77LhdVW6mpZhgI3jN73yzPYU+eN3xSivaKCySjUk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YOXprr7WVRsWhCB/yMFZFIY2dtChfVaogoIkfAXNG4ZwIZfFaFtZsbCZl25yuCaEWUIAW5qm9ewz0OVkMP2XxNI6xxZu7piRBPtWM7JPrV2O03OUIUnuGlHMqRheDOgfu95ze5iOSOwNf0AZxDg67ADRkl0ngMycksHYFWBg1sY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A69icoF4; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A69icoF4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1710151539; x=1741687539;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=RVO77LhdVW6mpZhgI3jN73yzPYU+eN3xSivaKCySjUk=;
  b=A69icoF4PmPgxnIcHsXjw74Smi7UAdqvJV1kLpcen7U4Zb+hI7TGYpto
   UzK6mTYll7lx2QCxwuxYcD180LyYoxPBV04nBYoFpFBiursZ6zT5nCrA/
   Ck7QtL5d8i5wLK20t7PigMZSgRQpsa7fhEo8yxV8V8C8DwZ90rRvckyxf
   SAEH/jJhwqDZAlUAjQFPOITCBdainGqMnhNE9yyS57APsnn38zbOGR5hs
   8bW6m9tJ6Pjiu9YnSfb2sRYDBB6W16Mn7Fy2LexPu8t4agZbXHmHrR1EV
   woFrpdbPfoy9z5oSuFCT0BFr/D2XGfnEMMfXIlgTtb3Iaekht/N5GyfDr
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,11009"; a="16244668"
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="16244668"
Received: from orviesa009.jf.intel.com ([10.64.159.149])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 03:05:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,116,1708416000"; 
   d="scan'208";a="11193912"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.118])
  by orviesa009-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2024 03:05:37 -0700
Date: Mon, 11 Mar 2024 11:05:33 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: jes@trained-monkey.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH 00/13] Custom drives policies verification
Message-ID: <20240311110533.00001b02@linux.intel.com>
In-Reply-To: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
References: <20240229115217.26543-1-mariusz.tkaczyk@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 29 Feb 2024 12:52:04 +0100
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> validate_geometry_imsm() over the years became huge and complicated.
> It is extremely hard to develop or optimize this code now. What the
> most important, it doesn't address all scenarios. For example if
> container contains disks under different controllers (spare container),
> "autolayout" feature allows to create raid array. This code has a lot
> of dependencies and it is almost impossible to add support of this
> scenario without breaking something else.
> 
> There is also get_disk_controller_domain() which in my understating is a
> part of validate_geometry_imsm() functionality moved outside, fit ideally
> to mdmonitor needs.
> 
> Drive encryption determining will be added to IMSM soon. The encryption
> status of the drive will be determined for every drive. There is no
> simple way to add it.
> 
> The solution added in this serie addresses those problems by making one
> easily extendable api to analyze every disk separately, outside
> validate_geometry().
> 
> First five patches are optimizations with no functional changes. New
> functionality replaces get_disk_controller_domain(). It should also
> cover some verifications done in validate_geometry_imsm() and
> add_to_super_imsm() but to lower regression risk these parts are
> not removed yet.
> 
> Mariusz Tkaczyk (13):
>   mdadm: Add functions for spare criteria verification
>   mdadm: drop get_required_spare_criteria()
>   Manage: fix check after dereference issue
>   Manage: implement manage_add_external()
>   mdadm: introduce sysfs_get_container_devnm()
>   mdadm.h: Introduce custom device policies
>   mdadm: test_and_add device policies implementation
>   Create: Use device policies
>   Manage: check device policies in manage_add_external()
>   Monitor, Incremental: use device policies
>   imsm: test_and_add_device_policies() implementation
>   mdadm: drop get_disk_controller_domain()
>   Revert "policy.c: Avoid to take spare without defined domain by imsm"
> 
>  Create.c         |  48 +++++++---
>  Incremental.c    |  77 ++++++++++-----
>  Manage.c         | 195 +++++++++++++++++++++----------------
>  Monitor.c        |  50 ++--------
>  mdadm.h          |  90 +++++++++--------
>  platform-intel.h |   1 -
>  policy.c         | 110 +++++++++++++++++----
>  super-intel.c    | 245 ++++++++++++++++++++++++++++++++---------------
>  sysfs.c          |  23 +++++
>  util.c           | 117 ++++++++++++----------
>  10 files changed, 606 insertions(+), 350 deletions(-)
> 

No comments..

Applied! 

Thanks,
Mariusz
