Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF9371F756A
	for <linux-raid@vger.kernel.org>; Tue,  3 Dec 2024 14:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237789; cv=none; b=lymksrdm7l8edY5S4k7VnM0M+gdLPzqWINNRvmAmHl/fK+GisK0S5L98PjchoMPXBD/4/pQDp/68RJEhLpyldhXYslFF8SBNbSDxB0xtMQ5dUBH3QohHNoUvfgYOQdv/Jx5TDJs+sDNDuS0afgiMVj/flmVRCg/aBIH+Z2HTzxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237789; c=relaxed/simple;
	bh=/0lb05bgm8rXfmjcF+VNFeH5LvwseAthtlDScWW+rKU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PhJqCYjwgpeUHjGuCioJbLhfaJLS4uy0r8nwlNGgemwJR2zt4suJwSkTGbEABUoYVv6F3Lr9HPJy5tFRKPSMlpx51A1F+DBbVexN66voEQLF1qkKeZaUMOTBeNDOUHyqpjff5wrglt/51wvmcmfjkF7EnSjl1chQlxUKoZnge+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=HXkwKj/d; arc=none smtp.client-ip=198.175.65.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="HXkwKj/d"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1733237788; x=1764773788;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/0lb05bgm8rXfmjcF+VNFeH5LvwseAthtlDScWW+rKU=;
  b=HXkwKj/dAYuH7QUCWoC55RqkltMAs9NuSmBjzy/twBsdSVCn4tSUVZ5j
   XBlc4bCet91INjLOPN3gCcilppN68jOkxeeRjuEqlLgp51rER/MC5mHNU
   /RRs0kj/5sO1UNI8/3pswwaG5Uoy2rk9ZTPXqr4ilVMsvQPgW2I70WovQ
   2duRwklCgkqRY0qy85W3NVGtcvp7tt39IMw5zIz7/FEJjsCYyh++pbw/R
   ibZ6JLmPQ2ylaTZggRZP+YTuLiZ7EiyQfAB2GANYi0IigoPMTveqc22oI
   /7m1I3/Vrlj2PsVXWaOON8dKK7XnXnQ+j1HEmV6/B5mxWrm+YEXxqyPPv
   Q==;
X-CSE-ConnectionGUID: 2gfRSbq9Q0id4vGuzecKxQ==
X-CSE-MsgGUID: sUqUUs1WSA+7T+hWDVDVMA==
X-IronPort-AV: E=McAfee;i="6700,10204,11275"; a="33332984"
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="33332984"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 06:56:27 -0800
X-CSE-ConnectionGUID: OmKnHctZTbqIdzQJTWngGg==
X-CSE-MsgGUID: wwLd2RAyTLOf1f+lv9rjNA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.12,205,1728975600"; 
   d="scan'208";a="130915900"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Dec 2024 06:56:26 -0800
Date: Tue, 3 Dec 2024 15:56:21 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com, yangerkun@huawei.com
Subject: Re: [PATCH v4 mdadm 0/5] mdadm: remove bitmap file support
Message-ID: <20241203155621.00005225@linux.intel.com>
In-Reply-To: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
References: <20241202015913.3815936-1-yukuai1@huaweicloud.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon,  2 Dec 2024 09:59:08 +0800
Yu Kuai <yukuai1@huaweicloud.com> wrote:

> From: Yu Kuai <yukuai3@huawei.com>
> 
> Changes in v2:
>  - remove patch to support lockless bitmap;
> 
> Changes in v3:
>  - add patch 4;
> 
> Changes in v4:
>  - add patch 4 to change behaviour if user doesn't set bitmap;
>  - add commit message about external metadata for patch 3;
> 

Applied! 

Thanks,
Mariusz
