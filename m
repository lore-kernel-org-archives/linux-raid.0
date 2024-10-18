Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091C51F947;
	Fri, 18 Oct 2024 12:56:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729256213; cv=none; b=k7jRu+OE3rorQJK+zVrsP/tD0bi4nuBfJgBA76nzCJGwgqaLLJWnVRGzFEVckIqw7p1YUQHc+V4FCTeytsnXkninlavcClT/L9SkQkY3qkoNd5Yi314aWUSfhuw4QhRZjm7o5950KSFjPieKsxwo2PDsjSkR3aOgjDuMDHv4C3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729256213; c=relaxed/simple;
	bh=DxqYJ/nTng3w2f1t+3UAEknjhB6pQTrD7nwB3Lljcz0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2q4283l/vwJKRmcd5trk/w0tbG6bKIwM3dgRv875xpZAKopqwltIIsPm3Vy/ZN/osKUFe8b4wb4wDrTZtmzMOeC7E9yKf9rVH79O1QURJ6ZlV4OOwepey5Mz2v0VG1gAntD5Zo2fjG7lWLDbJgkBHhonNiSQtYFaxS/L2h7jk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=jz8TlxkF; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="jz8TlxkF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729256212; x=1760792212;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DxqYJ/nTng3w2f1t+3UAEknjhB6pQTrD7nwB3Lljcz0=;
  b=jz8TlxkFVQooT1b6nhokYPffexhUJb0wLu554Hu9v2c0Z9MKqGwFk5j0
   SrgMjqsx2hHNBFBnm4YcsDa+R6XEfPAzjC2ZvMxOXINY+Ewny8p84+kSJ
   Of5hwO+u6+uT7bQZ+MbeyXtqGQruPteDRNu+G7h7G4We2i4sc0NcvJ4bb
   vpoar9LossEWjUpVclpK+iucT0u0pnDlvcsjsA9f1PGP35gUzgWDHW+2/
   v5FpLi4MerBZlsZIO1gyrxGKYAXIPgYnf8y3O6lwH30l4YZGOmFoj0XQ+
   RsCznk6+Tu2rK3LPB8nL4Ur3BXVx/wRK6Ze3NPT2l1Yr2o4cELOs3DUHf
   A==;
X-CSE-ConnectionGUID: BdQPLZMDQGKzteZP1PcBqQ==
X-CSE-MsgGUID: OqgJy87DTKiqNZS2Iq0bLA==
X-IronPort-AV: E=McAfee;i="6700,10204,11229"; a="39412685"
X-IronPort-AV: E=Sophos;i="6.11,213,1725346800"; 
   d="scan'208";a="39412685"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 05:56:51 -0700
X-CSE-ConnectionGUID: S0ik5VSmSfG9J8KkcsPGvg==
X-CSE-MsgGUID: PcQ7Ih13RrWYT7YC6SgkXg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,213,1725346800"; 
   d="scan'208";a="79283539"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Oct 2024 05:56:49 -0700
Date: Fri, 18 Oct 2024 14:56:43 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Song Liu <song@kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, mariusz.tkaczyk@intel.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yukuai3@huawei.com, yi.zhang@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v2 0/7] md: enhance faulty checking for blocked handling
Message-ID: <20241018145643.0000788f@linux.intel.com>
In-Reply-To: <CAPhsuW4UCFbtrxXVfCaXFvCWYhb8He0tGSHq8UZ_4dWX=ZMs3A@mail.gmail.com>
References: <20241011011630.2002803-1-yukuai1@huaweicloud.com>
	<CAPhsuW4UCFbtrxXVfCaXFvCWYhb8He0tGSHq8UZ_4dWX=ZMs3A@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 17 Oct 2024 23:46:58 -0700
Song Liu <song@kernel.org> wrote:

> Mariusz, you have run some tests on v1, but didn't give your
> Tested-by tag. Would you mind rerun the test and reply with
> the tag?
> 
> Thanks,
> Song

Hi Song,
I see no functional difference between v1 and v2 feel free to add it.
I will be hard to rerun these tests right now.

Tested-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks,
Mariusz
