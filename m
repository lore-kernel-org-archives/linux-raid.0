Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E407812B8B
	for <linux-raid@vger.kernel.org>; Mon,  5 Feb 2024 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707126347; cv=none; b=cZfGiQsLjpPz2ysHlVTWbJNQZSo1GRH0vIw4QYeVfoDVvt80ctWT+NqOkg3Ns4SPBbNBpNvaOhoGiKlFVWBOGaaDlB9o2UANApgJaKBIkywCK1W1/SnHliTZfcNxEFyLqqpiwe5mF3Q7KS7HDyxAYt+MajlrVtOVWyd1OslMMp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707126347; c=relaxed/simple;
	bh=vUGIMvydmIhU0V8lXjoCfQ8ne5NPA/loRJpQy8hd0L4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nKIbTosihZIbOu7r9eH19MgOxKtr6+ku7rXWzvhjNI+bLt2sS10sWclcXEMaRDEN5/9ZGoAoRcbtoaQ4Gy4nNpB8hZneaP5Pn8mP0UXXJHVedRjm5eVz3zgKFitTfuEJEZj8+K9qNEbYe+NXlznwS+wK1zISVb2HEXPRMfhVuW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=IyNWTcj0; arc=none smtp.client-ip=192.198.163.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="IyNWTcj0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1707126346; x=1738662346;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=vUGIMvydmIhU0V8lXjoCfQ8ne5NPA/loRJpQy8hd0L4=;
  b=IyNWTcj0jQqLTXsO0TTXWtUzA4ObLvMBbj1jVPg5YoptOECeVanMZSTP
   61gSFdYSeh3derFTwp8XdbneK9UfAyzry6w9I/xPX2LoZLTFk6nQYQMz2
   rT8v2EmnMxIjsgw0MfjImlmo8xrXarAb2MFlp7FYMfJCiDSUgsWKO9+PU
   Gs/WdczSNik5vc9GPsYyZSsN6XUkRqTiHmeGxxAivr8e8q8grauobH2gd
   ZL3MhEMzrUzQAYi9QLx1R1nrYLDk4F7CaMwDJFi4Hrzx8IJM51Ag6M/cW
   bCYCM3Pq/p92XU5At0NcAdLwLPquz65/tAAFR+UzxzkOE3FGo9tZj9NRa
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10974"; a="4282693"
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="4282693"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 01:45:45 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.05,242,1701158400"; 
   d="scan'208";a="998978"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.68])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Feb 2024 01:45:44 -0800
Date: Mon, 5 Feb 2024 10:45:39 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH 1/2] Revert "Fix assembling RAID volume by using
 incremental"
Message-ID: <20240205104539.00007300@linux.intel.com>
In-Reply-To: <a4644fb9-17a8-4868-b9d0-11e58707d363@molgen.mpg.de>
References: <20240202163835.9652-1-mariusz.tkaczyk@linux.intel.com>
	<20240202163835.9652-2-mariusz.tkaczyk@linux.intel.com>
	<a4644fb9-17a8-4868-b9d0-11e58707d363@molgen.mpg.de>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 2 Feb 2024 18:27:04 +0100
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Mariusz,
>=20
>=20
> Thank you for the patch.
>=20
> Am 02.02.24 um 17:38 schrieb Mariusz Tkaczyk:
> > This reverts commit d8d09c1633b2f06f88633ab960aa02b41a6bdfb6. =20
>=20
> It=E2=80=99d be great if you elaborated. What regressed, and how can it b=
e=20
> reproduced?
>=20

Thanks, for comment.
After analysis I see that only second one needs to be reverted.
I will submit v2 with explanation and reproduction steps.

Thanks,
Mariusz
