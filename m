Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D757C172BC6
	for <linux-raid@vger.kernel.org>; Tue, 28 May 2024 15:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.8
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716909395; cv=none; b=dPKAyG/ZpTuNpLuOEK483FDMFJsXRaNFV2va7TzUmO/YtOkcYbzBP2cyZWWYYQRFXkw6GRySQalyViV0UJ+nu8zGV7cbyhXStmkLsOIK+VtbDs0MSwgDCFIfNnrE6a2f+fiP7/qL7JlwszHjBA/ukmlRWordSjcejxy/VR+ttbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716909395; c=relaxed/simple;
	bh=lRsSiQ7zNfanX8FO/pmCEXEPBlGpNDPAfqqYiWTQodo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Rns2MjkyJosaQTm00cVFG+xs5uB9Dt640eRXR1MbyKfyu6X8oTob1qtnJwcw/issjp6Hh4Us6LSFq5CUSZ03ZrRse85ZihwkSUOIZtJBQeZySZ8fhOaav4yoPzTX9aBqxj8LuwqIHx65zlLFr4Th77FVtMxfQvjAltmHEoyGZ+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=geJLKUez; arc=none smtp.client-ip=192.198.163.8
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="geJLKUez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1716909394; x=1748445394;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lRsSiQ7zNfanX8FO/pmCEXEPBlGpNDPAfqqYiWTQodo=;
  b=geJLKUezth7jJITgN8520G3Ihlp5aRFC0N6OCrFTjH0g1pLzRFw2P7Ip
   vWtj4yJcLXFzfjgJxZhqK/s0thfDSeiR+5ZH76ld0ygmRp3BiJr7u5RzA
   cizvEPlOJh5FGjNehTYpp5Cybzn/sbC+l56IhcsTHgucN9a1a8XH/ybGI
   newy1XZjnrWf9R3cOmgr6LREKdYBM5XLs95eUUDXZNZCjgBhE38XBWZRr
   oGQ1arMz8+/ZpRE6XLaYiZStXboAtqbIVMxhd8Z5NjThq5hBwA8AxfclB
   XMCZ992thIbZ1Bttm/cueBP8cnqb+5qG/6ZZNwO1dT6sI1nyseCnTZK9B
   w==;
X-CSE-ConnectionGUID: h3n2fzwgQVePLHqdO0P1fA==
X-CSE-MsgGUID: uJJz6ny2TxW3ZZGDf+Zwtg==
X-IronPort-AV: E=McAfee;i="6600,9927,11085"; a="30785726"
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="30785726"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 08:16:33 -0700
X-CSE-ConnectionGUID: BrVqk8xrQlKJQZ4p3nuXEg==
X-CSE-MsgGUID: PIg8LtyzQw+fULdPNJO0ew==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.08,195,1712646000"; 
   d="scan'208";a="35047219"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.75])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 28 May 2024 08:16:32 -0700
Date: Tue, 28 May 2024 17:16:28 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: pmenzel@molgen.mpg.de, linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/1] mdadm/platform-intel: buffer overflow detected
Message-ID: <20240528171628.00006c80@linux.intel.com>
In-Reply-To: <20240528084439.23705-1-xni@redhat.com>
References: <20240528084439.23705-1-xni@redhat.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 28 May 2024 16:44:39 +0800
Xiao Ni <xni@redhat.com> wrote:

> mdadm -CR /dev/md0 -l1 -n2 /dev/nvme0n1 /dev/nvme2n1
> *** buffer overflow detected ***: terminated
> Aborted (core dumped)
> 
> It doesn't happen 100% and it depends on the building environment.
> It can be fixed by replacing sprintf with snprintf.
> 
> Fixes: d835518b6b53 ('imsm: nvme multipath support')
> Reported-by: Guang Wu <guazhang@redhat.com>
> Signed-off-by: Xiao Ni <xni@redhat.com>
> ---

Applied! 

Thanks,
Mariusz
