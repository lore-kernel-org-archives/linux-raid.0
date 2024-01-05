Received: from mgamail.intel.com (mgamail.intel.com [192.55.52.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D444250ED
	for <linux-raid@vger.kernel.org>; Fri,  5 Jan 2024 10:48:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="Ajb01K3F"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1704451695; x=1735987695;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=w9lI8Zct2tBh0DI2mY6g8w56EiwYu3F3D1aQWzyt8Sk=;
  b=Ajb01K3FyttxdfQIaftIKiLgYSQ5oWCO41PjhaJ+jyWjNtJ0+4+JaLn8
   UIvK4LAumE1k/6q18X9Z07tjpyHVyHzxWbKs3tvLLCptxYj0ZzZlHw0i1
   879nRwRFtv257WxS2fi+8IZXR47+8W/gW8w6YnI/tj9fkm9RY/5HZLxdl
   XucK0SsLBcyYbBecJFmqBX2eoAVPMyhFhmE02jgDbCkmhTEfjs0O5LKeu
   1vdi1i4wnoVEUKSLY4ikcqTAAUH3wYVoe2lN00fzsc5vYMW87W6zRNdzU
   s/7s1RqDxIR9REZV7syd4yZIQLKLXLj7bQX0J5VagNmmqI7Zn+kqhgLSb
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="397203898"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="397203898"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 02:48:14 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10943"; a="924203802"
X-IronPort-AV: E=Sophos;i="6.04,333,1695711600"; 
   d="scan'208";a="924203802"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.149.42])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jan 2024 02:48:13 -0800
Date: Fri, 5 Jan 2024 11:48:08 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Pawel Piatkowski <pawel.piatkowski@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, colyli@suse.de
Subject: Re: [PATCH 1/1] manage: adjust checking subarray state in
 update_subarray
Message-ID: <20240105114808.0000084d@linux.intel.com>
In-Reply-To: <20231220093249.2778-2-pawel.piatkowski@intel.com>
References: <20231220093249.2778-1-pawel.piatkowski@intel.com>
	<20231220093249.2778-2-pawel.piatkowski@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Dec 2023 10:32:49 +0100
Pawel Piatkowski <pawel.piatkowski@intel.com> wrote:

> Only changing bitmap related consistency_policy requires
> subarray to be inactive.
> consistency_policy with PPL or NO_PPL value can be changed on
> active subarray.
> It fixes regression introduced in commit
> db10eab68e652f141169 ("Fix --update-subarray on active volume")
> 
> Signed-off-by: Pawel Piatkowski <pawel.piatkowski@intel.com>

Applied! 

Thanks,
Mariusz
