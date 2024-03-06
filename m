Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CE31DA53
	for <linux-raid@vger.kernel.org>; Wed,  6 Mar 2024 14:31:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709735480; cv=none; b=BlNfT+Y+30oBUg8tBul6BqPtLHGyRQz3zRr47fwB61eMkLtbV0ZOl2daavlKfTIvIH7qRuhZOMOSGMj5KO1Ije7Vn+Hvyq/WgmTbnpqX3BxCln0HGMKJqFLloGLsQrXzRAuC1IFbSC+Sx/Pn2DMClKGJof26v9zXN4aan8mLTPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709735480; c=relaxed/simple;
	bh=dxaIbw/rIF8AR3apZVT5zovcqTGnnVRapBSJwPXZGCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MZkCs9Pg0WXU/U2sulLuNiO55McdMI+zy8G9tU68RdVqQuTWtodmWPwzSxjAZrSqO2kbourUhGOWH6fxDUr8A9Jhf5r/AtchmFhwaSQngIY/V8CXvGajQq/wBrKATNXJsr7xJFeC23lo1TsO3fqUm+lu6/GpuoVApBBb7YYCEHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=aQPqIjkQ; arc=none smtp.client-ip=192.198.163.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="aQPqIjkQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709735479; x=1741271479;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=dxaIbw/rIF8AR3apZVT5zovcqTGnnVRapBSJwPXZGCQ=;
  b=aQPqIjkQmmZfC10N8ykh7a7tA8hfzWBMib9F22P4SYwpa0PPIHh3OjCA
   SgijInK+2xr14IL0crE2qqnpZuWNcJhZbwpFOFk+Qs7rAVcxJHzboJjDm
   hf/+AQa0zOvGWpUapYMzsfJpEx9sT/l9vf32Yz1aoWCeIPI+mUex/ygGM
   wRg3EyrW+kjktWezWeX52bVDaWAfs1mpZBw/m4hnHYv+kf38OjujoDxJ5
   jrTaGc98SG7UiMM7+Fs1V/Kizu+BZfA0iHVN7nw5vm+sV4ITYDmzMADVp
   M+Lt31Uj1fnMLaAwO+pN6ebNrwjuGbE8BvbZw2L2bXEk2YIzkNuQb/1es
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,11004"; a="7291092"
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="7291092"
Received: from fmviesa002.fm.intel.com ([10.60.135.142])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:31:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,208,1705392000"; 
   d="scan'208";a="32924421"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by fmviesa002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Mar 2024 06:31:17 -0800
Date: Wed, 6 Mar 2024 15:31:13 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Kinga Tanska <kinga.tanska@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH,v2] Detail: remove duplicated code
Message-ID: <20240306153113.00005c74@linux.intel.com>
In-Reply-To: <20240227023614.32386-1-kinga.tanska@intel.com>
References: <20240227023614.32386-1-kinga.tanska@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 27 Feb 2024 03:36:14 +0100
Kinga Tanska <kinga.tanska@intel.com> wrote:

> Remove duplicated code from Detail(), where MD_UUID and MD_DEVNAME
> are being set. Superblock is no longer required to print system
> properties. Now it tries to obtain map in two ways.
> 
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

Applied! 

Thanks,
Mariusz
