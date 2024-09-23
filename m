Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5F1C19412A
	for <linux-raid@vger.kernel.org>; Mon, 23 Sep 2024 08:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727081478; cv=none; b=pxzqbk00AjC0woCvuwtN+oc6Z9yYdkQ8oCKxlp/Mim3rCAJuv+bK5yDf2rcRepQhqXfESzt7A1sNcl2xHp4qRPQ00F8zI5pzZU/LlQDBGhTvqDNT5dhYvgRU5zidOEmPHERTbo7v4PfSXTlTtG/8QKwlSeMZxuVySRo4n2f9EzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727081478; c=relaxed/simple;
	bh=qqCHZVtZRrK6sZrFh2tXWTbnQYKtDJJM4xP9FLzUJTo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VPUzG1kkTvRhd2z1W/UGHPxzHzPlOFt33TZiX9lAWDpN89w50SNJnHobryeaeQoIRsq7BlKZ/AT/2UnaPLiMzP2ehzEJVCkKzUwBXUHcvWMqYvlT9mHnamZiZrX5k30ZSrbpXCQNI+nb7dwDUS2HGQzyfvFDx54X8hbX+C9Bv50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F6qW3DJW; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F6qW3DJW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1727081477; x=1758617477;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qqCHZVtZRrK6sZrFh2tXWTbnQYKtDJJM4xP9FLzUJTo=;
  b=F6qW3DJWkCeDQ3pPFNsy9+3kW601z4fvD3c2FETWaXg6WUHDUHWzSDCR
   GxMU4JpvJGN/I05EzHnOR72x2bN/wvl1tWViVtO8k9TdWl3j5JFrHpAD+
   XZ+gbiB6D6WmDCF5EIO9MuYXcKl/Gv2mpXer+qWck88vhBtAGOn9O9tlY
   ZK0GjS+c36KHumCr/NWEYA2G1GqUZMVYY37hP3n3Z52lZ7CMhpvaAH0kC
   pgBIV4oCY1YcAnyNZE3HpzfA2l7VCXkxf9fftEuJosHBcPsmBnqmFhEFU
   O1oocgTmrX/KD8axtIFCHMfo65cLUo22kBGizDayydibksPt8vI8hCX0r
   g==;
X-CSE-ConnectionGUID: 9XMsRMlHRSyOIYO2zpCX1Q==
X-CSE-MsgGUID: QTKNXDXSQpiwxQ0cwzefIw==
X-IronPort-AV: E=McAfee;i="6700,10204,11202"; a="26210330"
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="26210330"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 01:51:16 -0700
X-CSE-ConnectionGUID: UF2i8nMlSJCNBxuU7BvGdQ==
X-CSE-MsgGUID: povkavKgS0K2txvMdsMLSA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,250,1719903600"; 
   d="scan'208";a="71450927"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Sep 2024 01:51:14 -0700
Date: Mon, 23 Sep 2024 10:51:09 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, ncroxon@redhat.com
Subject: Re: [PATCH 00/10] mdadm tests fix
Message-ID: <20240923105109.00005914@linux.intel.com>
In-Reply-To: <20240911085432.37828-1-xni@redhat.com>
References: <20240911085432.37828-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Sep 2024 16:54:22 +0800
Xiao Ni <xni@redhat.com> wrote:

> This is the fourth patch set which enhance/fix mdadm regression tests.
> 
> v2: fix problems for the first patches
> 
> Xiao Ni (10):
>   mdadm/Grow: Update new level when starting reshape
>   mdadm/Grow: Update reshape_progress to need_back after reshape
>     finishes
>   mdadm/Grow: Can't open raid when running --grow --continue
>   mdadm/Grow: sleep a while after removing disk in impose_level
>   mdadm/tests: wait until level changes
>   mdadm/tests: 07changelevels fix
>   mdadm/tests: Remove 07reshape5intr.broken
>   mdadm/tests: 07testreshape5 fix
>   mdadm/tests: remove 09imsm-assemble.broken
>   mdadm/Manage: record errno
> 
>  Grow.c                       | 39 +++++++++++++++++++++++++------
>  Manage.c                     |  8 ++++---
>  dev/null                     |  0
>  tests/05r6tor0               |  4 ++++
>  tests/07changelevels         | 27 ++++++++++------------
>  tests/07changelevels.broken  |  9 --------
>  tests/07reshape5intr.broken  | 45 ------------------------------------
>  tests/07testreshape5         |  1 +
>  tests/07testreshape5.broken  | 12 ----------
>  tests/09imsm-assemble.broken |  6 -----
>  tests/func.sh                |  4 ++++
>  11 files changed, 58 insertions(+), 97 deletions(-)
>  create mode 100644 dev/null
>  delete mode 100644 tests/07changelevels.broken
>  delete mode 100644 tests/07reshape5intr.broken
>  delete mode 100644 tests/07testreshape5.broken
>  delete mode 100644 tests/09imsm-assemble.broken
> 

Applied all! We are working on enabling mdadm tests on Github so we will see if
it helps. I'm also aware of dependency to new prop md/new_level.

Sorry for the delay, I had holidays.

Thanks,
Mariusz
