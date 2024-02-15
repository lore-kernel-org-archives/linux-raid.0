Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A94366341F
	for <linux-raid@vger.kernel.org>; Thu, 15 Feb 2024 17:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708018736; cv=none; b=NXsp5bo2JPkXQeaU+q5iTnfmB0wmIWM/yWO9AoPgvJs24oQL7wOsDUeZn3emJ5RthDyDLPpzsuOkZ2mVYxyMtfxMVY8OTeFVhbsaMqKWQwv/g4UqJJADcypTdJKf2/BirlOzL8+KD0bxl4Gd/CBtcoRXJ8akCRP3KX0fF3+44TE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708018736; c=relaxed/simple;
	bh=Mtivv7nUBvBuy7KLRYkuU4+rn5YjVyasXMY04++C2wY=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type; b=Hk4yt5SRZ5KAQ3f3mznrZvwqWMNCS3gCSOL/XtKiDXroZDuci55CZciHr8J6C7j+9Zf9/kmmhRJXpnosWKAHMFogdlPcGS7iEYMCLLIV5m7NZr6T20zvzyxkrNI9O5RtrUyb/zjSOdM3lwY2HfCKUogrWTkgtc8KbiFpsjed0qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=iYKo3L23; arc=none smtp.client-ip=192.198.163.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="iYKo3L23"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1708018735; x=1739554735;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=Mtivv7nUBvBuy7KLRYkuU4+rn5YjVyasXMY04++C2wY=;
  b=iYKo3L23LvQwCs4ug+uBWGMz4hq1V2niteYH69KKLf4f4SM8OjYowxvW
   CchDj6b0IeOXVe5lc1bsXuE2Rn1trDHzaW3eLSDUM0WwFnmU6YVM+/ZvA
   qxDTE9ClJvo/JyQ3Nhe3SWOmx8PXS+PQYqMkEdIWL0oqEOfonMbAdKYDg
   3gRSCLZZ1ZxDH8oSmxTHBhqw2tfL9+fMkT3n7gdlh9pR40bBfjDXz0hTD
   wUWikB0k+0HrQ864V1rFQjsRZh4dxsRKzkt4HhnvnoyhVj8HEOF9dJcLA
   7gCW+iYkkdVqkRtbQBz+2fp8gYf0C7CasI4i7n83MlQ4Sg7Or7wtAUMOz
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10985"; a="13512947"
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="13512947"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 09:38:52 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,162,1705392000"; 
   d="scan'208";a="3562312"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.98.108])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Feb 2024 09:38:49 -0800
Date: Thu, 15 Feb 2024 18:38:44 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: linux-raid@vger.kernel.org
Cc: Song Liu <song@kernel.org>, Jes Sorensen <jes@trained-monkey.org>, Xiao
 Ni <xni@redhat.com>, Coly Li <colyli@suse.de>, "yukuai (C)"
 <yukuai3@huawei.com>, Nigel Croxon <ncroxon@redhat.com>
Subject: ANNOUNCE: mdadm 4.3 - A tool for managing MD Software RAID under
 Linux
Message-ID: <20240215183844.00003735@linux.intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

I am pleased to announce the availability of mdadm-4.3.

It is tagged in git repository available under:
    git://git.kernel.org/pub/scm/utils/mdadm/mdadm.git
    https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git

Signed source package can be found here:
    http://www.kernel.org/pub/linux/utils/raid/mdadm/

The release includes more than two years of development and bugfixes.
It is impossible to list them all, so this is a short list of features
and bigger bugfixes.

Features:
- IMSM_NO_PLATFORM boot parameter support from Neil Brown,
- --write-zeros option support by Logan Gunthorpe,
- IMSM monetization by VMD register from Mateusz Grzonka,
- RST SATA under VMD support from Kevin Friedberg,
- Strong name rules from Mariusz Tkaczyk.

Fixes:
- Unify failed raid behavior from Coly Li.
- Rework of --update options from Mateusz Kusiak.
- Add mdmon-initrd service from Neil Brown.
- IMSM expand functionality rework from Mariusz Tkaczyk,
- Mdmonitor improvements from Mateusz Grzonka,
- Failed state verification from Mateusz Kusiak and Kinga Tanska.

Thank you everyone who contributed to this release!

It is my first release, I tried my best to avoid mistakes but if you
noticed something please do not hesitate to inform me.
I will upload signed archive soon!

Mariusz Tkaczyk, 2024-02-15
