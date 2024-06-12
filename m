Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC6AF197
	for <linux-raid@vger.kernel.org>; Wed, 12 Jun 2024 00:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718151277; cv=none; b=YactxrYHq0qE+YO9byQaeeskTXyTfisZWiyFfdXPasYefJ/WRVSfSJtZ8liWEZL7c3KkNKq7RvNEB8K9Xr7CM5Yqv7wTL4r+YeFvhV0Vxr1hPjiLMj57nXw5XBYKcRLr1b/qcniV/op8OfN2VIYLPW5zJCtii1vJB07cM+JCUW0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718151277; c=relaxed/simple;
	bh=+g1rumkFv0HoMyxli7qWEBDzssyvW8XU8YWDd/QHgwE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aJk6LnvNX0oJfh9Dfu9GQNmzZHAqIR4Nc56gXz44683rA2jIB+hz3S/4UvnGQXbznZ8LJni0PivoAO7gCchhRRMDlgJDb5VpQOWoV6yTyMn1A7rdF4+qvvk/y4gp31dslIWqLxv3uDFQ2HlDEkIyyHlsKdibVCVCku2zS2SywxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=A2k9W4fi; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="A2k9W4fi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1718151276; x=1749687276;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+g1rumkFv0HoMyxli7qWEBDzssyvW8XU8YWDd/QHgwE=;
  b=A2k9W4fiR/EBjQxs0pNijYct6xABRaUW7NkUdGDGq7goKy2yFWHYhA5Q
   j37a2NslPnSuUi2stnKzr/BdHz8EqkJ+ZdHl9QNAke8kYhIlaivRsL9ab
   xsCJVAybq6opfyqz+B8MeFhSMX7W6ipmjQVV1NlB1zDdjNk++zBvVV6FB
   CImqOJM3lVYZGG14zm1OxHxaoNNoUeUJKGWzY4MQxBMVr+/Yf1MHwBhMU
   3RbfxLPaObqO8C7/Rvlr9WSEJoMx4+c5LYNdzNkw4Wds2MqjeM7VV5CL3
   ePavj9iEckQdP3tZQH+6YHLda0pzML4pm3zBrqenZ9AjwmoNAatdkIfo+
   g==;
X-CSE-ConnectionGUID: hrJQ2cnGRd2kZDm/I//ovQ==
X-CSE-MsgGUID: 01ChpFQ3T0azCaVq/52SYw==
X-IronPort-AV: E=McAfee;i="6600,9927,11100"; a="14854969"
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="14854969"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 17:14:35 -0700
X-CSE-ConnectionGUID: ndxgRPz4T86LVD6Ja9IC6Q==
X-CSE-MsgGUID: HkoHPvGhS5eiiezM73+9Pg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,231,1712646000"; 
   d="scan'208";a="40316681"
Received: from pmahaja-mobl2.amr.corp.intel.com (HELO peluse-desk5) ([10.212.44.22])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jun 2024 17:14:35 -0700
Date: Tue, 11 Jun 2024 17:14:33 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>,
 linux-raid@vger.kernel.org
Subject: Re: RAID-10 near vs. RAID-1
Message-ID: <20240611171433.375d6e25@peluse-desk5>
In-Reply-To: <cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
References: <ZmiYHFiqK33Y-_91@lazy.lzy>
	<cd3ed227-1410-478b-b86b-973d76b587df@thelounge.net>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 12 Jun 2024 01:04:18 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:

> 
> 
> Am 11.06.24 um 20:31 schrieb Piergiorgio Sartor:
> > I'm setting up a system with 2 SSD M.2 (NVME).
> > 
> > I was wondering if would it be better, performace
> > wise, to have a RAID-10 near layout or a RAID-1.
> > 
> > Looking around I found only one benchmark:
> > 
> > https://strugglers.net/~andy/blog/2019/06/02/exploring-different-linux-raid-10-layouts-with-unbalanced-devices/
> > 
> > Which uses mixed SSD, NVME and SATA.
> > 
> > Does anybody have any suggestions, links, or
> > ideas on the topic?
> > 
> > BTW, practically speaking, what's the difference,
> > between the two RAIDs?
> 
> i wouldn't even consider a RAID10 with two disks, especially with SSD 
> and practically you end with a unsupported RAID1 because there are no 
> stripes with 2 disks
> 
> 
I don't disagree but I would recommend you try each variation and
measure the performance for yourself.  It's a great learning experience
if you haven't done it before and there's nothing like trusting your
own data over on your own system/config something that someone else has
done when there are so many factors that can affect performance.

-Paul

