Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ECE8155759
	for <linux-raid@vger.kernel.org>; Thu, 25 Apr 2024 21:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.9
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714081764; cv=none; b=ET/g47zDk5fXo/hK1vj4cF3WQEaHXYEIJGEuCpKbDyjRnOfHpvD/6Ifa1Qtt1BsUp6e08cckCigeS/SuncsCSgyguFrF0QEIrycos6FHlqfHUFoUBkbcj0k4OxkQ3/4Zl3Y4kjA9odp0fI/dEDEvtC1CpZzWTCoFCWGtHOImGLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714081764; c=relaxed/simple;
	bh=+6kQhmUyXc4h828BWhvK6bSto0MORCK0UvrW4Vlo248=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MWEqh83nWSYWCJMDSuE5SSG1H70brDO14VnbiLlGvIpmIO+GM1r4KtYCqosIrj6nvlEj2PAUNLR8nyJIiszYnrcf7ETBxjeuGbbWNOdKv2UO1Jf5Ro8vyz9uiVBr9+XcI+6TkMI+SkO+/j0Cx3uZZJHR9z7xV2UlurfLjsmLJ5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=F2QCXSOQ; arc=none smtp.client-ip=198.175.65.9
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="F2QCXSOQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1714081763; x=1745617763;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=+6kQhmUyXc4h828BWhvK6bSto0MORCK0UvrW4Vlo248=;
  b=F2QCXSOQ5dNEzevQbcgEJ1pWHB6uBgDLUfkb+urfZZaPwoAEmaCwqiUy
   TxofbttZOtj8WONn0rYZzdsC/+mtQISDitXWIn3dgnyL8hGQySYjApuwO
   Jph835yRvaguoJIorDDvM9ur8zl3Kyg10W2GV4CK+ECIZHlpbzbaxcsv6
   mhRL2PqXv0CdJZ3DjBaAVEtLOzs3SNlQVkEXOxOJYyF/0naVyjymcPolM
   r4IS2eIp7utZ5W4VQMe+8ynrLRmIju8nqk6xIOhqHWpsyXChaRQ4OAOQw
   Ie/OCNzsAJ8LUNmTwQYDJs6jYgGz0FVqDy8oBYWi00iIldhNzmLUJ1AIV
   A==;
X-CSE-ConnectionGUID: wcJ9c0dESWynBEM79VHhDg==
X-CSE-MsgGUID: BxMtbN7HQTeLur+1/gQUIA==
X-IronPort-AV: E=McAfee;i="6600,9927,11055"; a="32298947"
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="32298947"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 14:49:22 -0700
X-CSE-ConnectionGUID: 63t8Qfo9SOiUSHYVWead2A==
X-CSE-MsgGUID: 7vBI3KaMRui2PKWFc0bEag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,230,1708416000"; 
   d="scan'208";a="25857985"
Received: from mshivarx-mobl.amr.corp.intel.com (HELO peluse-desk5) ([10.212.96.219])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Apr 2024 14:49:22 -0700
Date: Wed, 24 Apr 2024 05:27:11 -0700
From: Paul E Luse <paul.e.luse@linux.intel.com>
To: "John Stoffel" <john@stoffel.org>
Cc: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
 linux-raid@vger.kernel.org
Subject: Re: Move mdadm development to Github
Message-ID: <20240424052711.2ee0efd3@peluse-desk5>
In-Reply-To: <26154.50516.791849.109848@quad.stoffel.home>
References: <20240424084116.000030f3@linux.intel.com>
	<26154.50516.791849.109848@quad.stoffel.home>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; aarch64-redhat-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 25 Apr 2024 17:04:20 -0400
"John Stoffel" <john@stoffel.org> wrote:

> >>>>> "Mariusz" == Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> >>>>> writes:
> 
> > Hello,
> > In case you didn't notice the patchset:
> > https://lore.kernel.org/linux-raid/20240419014839.8986-1-mariusz.tkaczyk@linux.intel.com/T/#t
> 
> > For now, I didn't receive any feedback. I would love to hear you
> > before making it real.
> 
> I'm really prefer you don't move the mailing list.  I hate reading
> threads on a million different web apps.  I don't mind the
> developement being there, but keeping the mailing list is better in my
> mind.
> 

To be clear, the mailing list is not moving.  The two main changes here
as Mariusz outlined in his email:

* The GitHub repo will be the new home of the code and should be
  considered the main repo.  The other will be kept around and also be
  kept in sync
* Instead of using the mailing list to propose patches, use GitHub Pull
  Requests. Mariusz is setting up GitHub to send an email to the mailing
  list so that everyone can still be made aware of new patches in the
  same manner as before.  Just use GitHub moving forward for actual
  code reviews.

Make sense?

-Paul



> 

