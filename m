Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F8685D8E0
	for <linux-raid@vger.kernel.org>; Tue, 20 Feb 2024 13:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708434216; cv=none; b=d7s+V3pfJ+4dr0y+1YPL+JeCeXkHiMtPKvInsAeW9LprzpdgnpkXQ+BX+1PlQPkvhjGtc99/qkebRezqSYLWHwHSG5HfVwVWKTon6VJ1hYoLTaDfuOyn/QjOH0sFl6sc1J9TMOa+8o/TNlOj/+hT/DAmGm54l+hIVYpU8v4FwhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708434216; c=relaxed/simple;
	bh=pDgJdFGN5OE9eUKihl9/GERuu/5oUlwWfICXrNBev+w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=K0LeCcJeJrl/VcDfI7G5rNi/AQdtTD0S3HU8uC7ebRHdlIeZM/1HSL9XSR4YcEQqcOUYGMsBHQCkyAfwCtxNcVPj+w9i0aX4cLXLW/rekOi2PApZQRadYMtmG5wynw0naHe/mO8+34r3zw8Kkv59A9hlPPXBdoudhrAU12iob3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AqLIyIBJ; arc=none smtp.client-ip=192.198.163.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AqLIyIBJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708434214; x=1739970214;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=pDgJdFGN5OE9eUKihl9/GERuu/5oUlwWfICXrNBev+w=;
  b=AqLIyIBJona7AOyPK9E89OEOF1ibVNszz2BWrj7I2vsv54VZTKeSskN/
   5kClzgpzxTzUu/rhgDvocbrcI+uTK+dM1Mvg4kXkeFGOkrKa3OM5VSqfh
   3Rr98zIobFbg+sE+0nw6tTZ1GsVPRXQzTCII1bl5qrC4uyuTkaYWTCA8n
   hHbSAJDNogJUGHJROZ/LwFCoa6qCOtrZ8rjmN6h+5LM6QwMKrO3AyqOUk
   iwH2YgqjB/sy2hVIYvHF2d5guk9AvH3C/n4pb1ktW1cYjmzxx5dv4qZUD
   gposuZY3Bh/oUr4Hf3f4LhiIlZt+hf/hxCTqsob8dwLeOe3lwkUIRWaGv
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10989"; a="13241850"
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="13241850"
Received: from orviesa001.jf.intel.com ([10.64.159.141])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 05:03:33 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,172,1705392000"; 
   d="scan'208";a="42264841"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2024 05:03:32 -0800
Date: Tue, 20 Feb 2024 14:02:50 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] restripe.c: Use _FILE_OFFSET_BITS to enable largefile
 support
Message-ID: <20240220140250.00007040@linux.intel.com>
In-Reply-To: <20230823145256.00001103@linux.intel.com>
References: <20221110225546.337164-1-raj.khem@gmail.com>
	<20230823145256.00001103@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 23 Aug 2023 14:52:56 +0200
Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com> wrote:

> On Thu, 10 Nov 2022 14:55:46 -0800
> Khem Raj <raj.khem@gmail.com> wrote:
> 
> > Instead of using the lseek64 and friends, its better to enable it via
> > the feature macro _FILE_OFFSET_BITS = 64 and let the C library deal with
> > the width of types
> > 
> 
> LGTM. There are several style issues but you are not an author of them so I
> see this as good to go.
> 
> Sorry, for long response time, I totally lost this one.
> 
> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> 

Hello Khem,
I found this on patchwork, it has been omitted. The patch format is broken, it
cannot be applied. Could you please resend it?

Thanks,
Mariusz
