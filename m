Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 768866FE14
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 09:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713520673; cv=none; b=Luw1zd4MHcNvsxAXXps+xdgm2+KJgncCrahJgmNs/oHNQnplnRtoks3P5fGQHh37Q7w14dQpOivKKKCaKIYkBT0XcBcf9XjUmPcwmhRlaNLaWC76LYQDt9tiMCadvMwiw6Y+BI6fv8XFM3H+iSgALK2QoJ+MJIuzimWgMtrKA3w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713520673; c=relaxed/simple;
	bh=S8r0lYJHK81pIHFM6qhkO0erP23Gm5ySsBUNXOAcL2k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PQ41BaMrymomeFfJrCuU1jfmFWaxFPBJero76Jph2G/sVzMiJqRJ1XlwmXvf/hfq2hCvviiSOb4OyvGvXVNorOeSHlDOuqHonqNXTz63yZV8z16xcQ2Mu2K7htLWsGbP++Sc+7Jfm0oCr894FdrdXTodb9uFnCapSjSHdP5+WmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YEWJG87D; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YEWJG87D"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713520671; x=1745056671;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=S8r0lYJHK81pIHFM6qhkO0erP23Gm5ySsBUNXOAcL2k=;
  b=YEWJG87DlCwE/i8GUA1LjIohSzzxNou0CA0GOZ47aV0DFy9Hxq7fAAmw
   6KW32Vycp55Ifk8SfMPqrEsOf62Es7+UxWGThBkSXbtaxQO+99RTQMjph
   9t1ku6hAo+VgDB/PtubuKzHFBm377Phj6x3WPTkKA7RtDCLoIGRYs9lml
   bRoycImqmOszCgWe2OUzyRPGS1NMIvxhMFPTw35WbiVg5BUe4BKFVMwKU
   ln4d/l51wwXQuw1gFjw7l5zawzuikyA/Qg3IHZFYDGodfGcjRJnd0vPy0
   OMfMTJmFQnX6YGpqPHonqgnFq4suZ7JuXzUfNplCj8n/oowmpmSl8rCoU
   w==;
X-CSE-ConnectionGUID: e/7X6SyeSbeRW/HdAqVJ5Q==
X-CSE-MsgGUID: zM3N1LC8QNqTO78OZLAahQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11047"; a="12896905"
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="12896905"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:57:50 -0700
X-CSE-ConnectionGUID: yX5Gig0VTmiHQPHvRg96sw==
X-CSE-MsgGUID: VHFYcuJUReahIslh6YThtQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,213,1708416000"; 
   d="scan'208";a="23370753"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Apr 2024 02:57:49 -0700
Date: Fri, 19 Apr 2024 11:57:44 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org, song@kernel.org,
 yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Subject: Re: [PATCH 3/5] tests/01r5fail enhance
Message-ID: <20240419115744.0000064c@linux.intel.com>
In-Reply-To: <20240418102321.95384-4-xni@redhat.com>
References: <20240418102321.95384-1-xni@redhat.com>
	<20240418102321.95384-4-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 18 Apr 2024 18:23:19 +0800
Xiao Ni <xni@redhat.com> wrote:

> After removing dev0, the recovery starts because it already has a spare
> disk. It's good to check recovery. But it's not right to check recovery
> after adding dev3. Because the recovery may finish. It depends on the
> recovery performance of the testing machine. If the recovery finishes,
> it will fail. But dev3 is only added as a spare disk, we can't expect
> there is a recovery happens.
> 
> So remove the codes about adding dev3.
> 
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---

LGTM.

Mariusz
