Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58DC0160862
	for <linux-raid@vger.kernel.org>; Tue,  7 May 2024 15:19:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715095159; cv=none; b=G17qedJ/bxIIjnWjpZs2viYOwfRJrKfGuJy+coOYhTH7w1UF9IekKe5b4O3DcrfiyXjsaevwNGEMl9Q34+i/1C60Pj6jxatCzprnA5uCxz81M9FzwRFwD7zkf8uxahXBLKH7ZCqDfmxllQ5N27EeuXXedotuwn9895LuS1/ZXVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715095159; c=relaxed/simple;
	bh=Nwqc290FgzbvbkInmt9zG4elRZksTnfdFTRwJPCDKLM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VF/KghQT3CQzmp8tCzkb76fVqUyJQbYAIsuUWZJdzPdHHMTw6P14F6tX78Bb57vGRMm67aOUJHob9B9B7jHGrDBGgaTgR57JjttVw0uFCYilvTOdPg36889Gtk+uzbPA1r2oaphRMAGyhDY6CHQCoX2khKn4a7ILAB70CGLoO2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=knoaLihx; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="knoaLihx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1715095159; x=1746631159;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Nwqc290FgzbvbkInmt9zG4elRZksTnfdFTRwJPCDKLM=;
  b=knoaLihxbCejCsnPFDVkvSEqfxaQ+JK8TM4sQGXXvZ8TN35YxOH6lfDj
   3aD7eWu+9kvpeMFC2jhqGQyqH2oHkh6aNj7lf/nP5PVEwv7PSp9c8cyHs
   3xQ+86ysYZzd9yosxIRMCe51LsUJWZqOy0DJX25+NYwwufpyHsv/tcdNg
   qlp8sEWS0aWlsgv/CmFuDOwxt/NyYwopjcyoOWLSVLnt2t5h/Dg5c4+wg
   Vqez41oVx90KFfxQDS/+ljZgnwUFu00jUVJsE55XFgwVIUNsMGyXbOgLl
   P1aB0SI6Ok9sznTGGubX1TmY3Kqr9UfEoamj8xW+iZlYww1S82YTgI01l
   w==;
X-CSE-ConnectionGUID: YZl9YtZdTAqNYwBQvQwpVQ==
X-CSE-MsgGUID: TlcbMERkQNKSZLrSmyzctg==
X-IronPort-AV: E=McAfee;i="6600,9927,11066"; a="33408718"
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="33408718"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 08:19:18 -0700
X-CSE-ConnectionGUID: SCP7hbFfQ7KMWgrSprAGcQ==
X-CSE-MsgGUID: SHYfAYFDSyiWnNi26Gy6XQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,142,1712646000"; 
   d="scan'208";a="33121771"
Received: from shoang-mobl1.amr.corp.intel.com (HELO peluse-desk5) ([10.212.51.191])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 May 2024 08:19:17 -0700
Date: Mon, 6 May 2024 21:28:59 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org,
 mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH 0/2] New timeout while waiting for mdmon
Message-ID: <20240506212859.4044771f@peluse-desk5>
In-Reply-To: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
References: <20240507033856.2195-1-kinga.stefaniuk@intel.com>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue,  7 May 2024 05:38:54 +0200
Kinga Stefaniuk <kinga.stefaniuk@intel.com> wrote:

> This series of patches contains adding new timeout
> which is needed to have mdmon started completely.
> 

Thanks Kinga!  What is the end user experience w/o this patch? (ie what
negative impact does this patch address? mystery hang?  missing events?)

-Paul

> Kinga Stefaniuk (2):
>   util.c: change devnm to const in mdmon functions
>   Wait for mdmon when it is stared via systemd
> 
>  Assemble.c |  4 ++--
>  Grow.c     |  7 ++++---
>  mdadm.h    |  6 ++++--
>  util.c     | 33 +++++++++++++++++++++++++++++++--
>  4 files changed, 41 insertions(+), 9 deletions(-)
> 

