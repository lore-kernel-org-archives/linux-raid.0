Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A85A18C03D
	for <linux-raid@vger.kernel.org>; Thu, 10 Oct 2024 10:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728556971; cv=none; b=CQk4eetZTo1abnz3oZfHITahUEkpIgLQqMyvGFp6zmEkvQvOv40HNxhZ9DUWVUIB4f1K6dc6oTQUbMPxf2Z9RoWRkCgEY122x2kCdM/wuf/cJCFhB2iSs4O14RQ0VwQL1qtj4B9eX9qfnhLnRGOpfuRPTsb5oYirvRy9sFmB+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728556971; c=relaxed/simple;
	bh=xELsNQCq8ZTfixE8pRRp2em268xJx1gjLio3Il9YwIA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XmdM1RCkT1do4YbdFaE6XB2b53ufHVqM4vii4Oa8BOjEUHAcs5J2S9Ae0EPnYUDjQmHTOtolWcTTUD3ppEJb8pBJ3ED0qLH63Ukrm/88UZzowxEk9ZPsKT873jrWSqfgT0RZpF6vbC0vj3CczvjaPN3CJLrYIhY/lcKny62abFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=G4Lk5onZ; arc=none smtp.client-ip=198.175.65.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="G4Lk5onZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728556970; x=1760092970;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xELsNQCq8ZTfixE8pRRp2em268xJx1gjLio3Il9YwIA=;
  b=G4Lk5onZ+rxE6b6YKqY62edZkd+rHowUzFLUBXJ3v2B65QeG/HhQqMdh
   +ln6FwcH1lMw9t7lDfd102is7E0DZ7vxzRlzWChnbEdCObOaqUddJ78HP
   u7QRK1o+6TMV1k7dLAin3/cGy/cIff3UhWhJTgCyBtZ87UAdNQ7sBkMdQ
   90hxfsinjheNEzhehKXMTROLS/OMJBmvOzbkA281jf0yrzfT1wADMzHQ7
   oqodmyu+JRFhcvDUNEi7J4sWkoxZ+XQdUtfWe3eOrbqsB0uGzpyFqZ6tn
   yCUC4VdI5gFkkWPenrnS/PIwbHZj2RHgnFqxbUdA1oeUNBXiqDuhqq/Sc
   A==;
X-CSE-ConnectionGUID: pFe06+sVQLq8MvKgIsAsHg==
X-CSE-MsgGUID: hzkBEcLLS+y1Tmecv54/kg==
X-IronPort-AV: E=McAfee;i="6700,10204,11220"; a="38475996"
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="38475996"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 03:42:49 -0700
X-CSE-ConnectionGUID: SWAHz4o+T7KU6RsVR5rEdQ==
X-CSE-MsgGUID: 7LwBBWUkREq0TSmN5L/zbA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,192,1725346800"; 
   d="scan'208";a="77033253"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Oct 2024 03:42:48 -0700
Date: Thu, 10 Oct 2024 12:42:44 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: 19 Devices <19devices@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Can't replace drive in imsm RAID 5 array, spare not shown
Message-ID: <20241010124244.00000b02@linux.intel.com>
In-Reply-To: <540353C4-C36F-4A89-8417-F36B6D22A20F@gmail.com>
References: <E656D988-48EF-4428-AEB6-2F6D8677612B@gmail.com>
	<20241009120940.000004fa@linux.intel.com>
	<540353C4-C36F-4A89-8417-F36B6D22A20F@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 10 Oct 2024 09:25:58 +0100
19 Devices <19devices@gmail.com> wrote:

> ps. Belated thanks too for your solution to my previous problem here on
> 2021/08/02.  That fix showed no sign it had succeeded until reboot but after
> that all was fine.


Cool. I'm glad to hear that.

Mariusz
