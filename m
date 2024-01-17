Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0EB011199
	for <linux-raid@vger.kernel.org>; Wed, 17 Jan 2024 08:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705478554; cv=none; b=Di1uKIPv0mOddvjmhv8EbnQCxMM3qMw7ArA7XCqTn8xcEjb/6HHoz3piBUtEEBv32OrJ5rv5ZGapVFCBI9aV3vjprSReJJb32Uut3k9RQ8AYFjn2Pd2WQ7FywNY1MW4qA2fWXmJU8osvahBKhqrYQ3xZTeeY1oO8O/+Uzm+rozg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705478554; c=relaxed/simple;
	bh=NtANIBlzneqPSZ3ymtqMy7fMuMPg1/oD0zNtj7YOpEc=;
	h=DKIM-Signature:X-IronPort-AV:X-IronPort-AV:Received:X-ExtLoop1:
	 X-IronPort-AV:X-IronPort-AV:Received:Date:From:To:Cc:Subject:
	 Message-ID:In-Reply-To:References:X-Mailer:MIME-Version:
	 Content-Type:Content-Transfer-Encoding; b=txBi/MwYqXm2yy+Co7emjXuCLS2vJ8pvVh7xvbREW/zRy6ZnA7F4QKZ24mbjr1zhLCblSJs96l5dOCcDaLsBAatfy78J+/vK3SuCGLbHDRThrQ8Q9IgUZI2GbYQ2l/DVB+eec6AqzqDjEWk7Ha8Cyajd4f5jm7fG747r+44sENg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=lwHlwjD7; arc=none smtp.client-ip=198.175.65.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="lwHlwjD7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1705478553; x=1737014553;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NtANIBlzneqPSZ3ymtqMy7fMuMPg1/oD0zNtj7YOpEc=;
  b=lwHlwjD7sj06MrKgaJROvL4YWa+m0LnUvvTcon1/bcSOfuHwUXzYCZqk
   BmdbzrWuEoHfmHAYHRa+denfUS/GHUosl8zoM0JI0cU/cWqF6/zJ2akpU
   y8A6ZcwUVsFAWf8USy1t+CKT8JLXS+WYF5LXzaIF0BZ585ktaObKJU823
   N7JlHQpEw8mlyW2MjBj1d/LKcGw6qWUSFB/YXEqpoSDO0tWizqKyVxz26
   uiyqdbfSppiHY4PwfnRHIsyOn/MllWv3HGsQlqTY563n8/vPYAKt/loS3
   T8CYU/scPkWG96Z2vJX2Bj0ogDsOj0WjIyjifv3nKSPuL/aQqGMEZiQju
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="13458605"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="13458605"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orvoesa102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 00:02:32 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10955"; a="760481006"
X-IronPort-AV: E=Sophos;i="6.05,200,1701158400"; 
   d="scan'208";a="760481006"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by orsmga006-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Jan 2024 00:02:25 -0800
Date: Wed, 17 Jan 2024 09:02:19 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH 0/8] Fix checkpointing
Message-ID: <20240117090219.00004174@linux.intel.com>
In-Reply-To: <20240116112434.30705-1-mateusz.kusiak@intel.com>
References: <20240116112434.30705-1-mateusz.kusiak@intel.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Jan 2024 12:24:26 +0100
Mateusz Kusiak <mateusz.kusiak@intel.com> wrote:

> Currently there are multiple issues regarding checkpointing in mdadm.
> This patchset fixes most of them.
>=20
> Thanks,
> Mateusz
>=20

Hi Mateusz,
I would like to make a release soon, so I won't take them all for now becau=
se
risk is high.

For everyone interested in mdadm release, there are few medium risk regress=
ions
in IMSM caused by:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3D4dde420fc=
3e24077ab926f79674eaae1b71de10b
I will start considering a release after resolving them. I expected a patch=
es
on ML within 2 weeks.

=46rom this serie, I can take following patches earlier:

>   Define sysfs max buffer size
I think it is safe. I see this conflicting with another patchset I know you=
 are
working on.

>   Replace "none" with macro
>   super-intel: Remove inaccessible code
These two are rather safe too.

and eventually (if there is no dependency in other patches):
>   Add understanding output section in man

Please consider dividing it into 2 series, or sending "Define sysfs max buf=
fer
size" separately.

Thanks,
Mariusz

> Mateusz Kusiak (8):
>   Remove hardcoded checkpoint interval checking
>   monitor: refactor checkpoint update
>   Super-intel: Fix first checkpoint restart
>   Define sysfs max buffer size
>   Replace "none" with macro
>   super-intel: Remove inaccessible code
>   Grow: Move update_tail assign to Grow_reshape()
>   Add understanding output section in man
>=20
>  Assemble.c    |  3 +-
>  Build.c       |  4 +--
>  Create.c      |  2 +-
>  Grow.c        | 64 +++++++++++++++++++-------------------
>  Incremental.c |  4 +--
>  Manage.c      | 10 +++---
>  Monitor.c     |  6 ++--
>  config.c      |  2 +-
>  managemon.c   |  6 ++--
>  maps.c        |  4 +--
>  mdadm.8.in    | 21 ++++++++++++-
>  mdadm.c       |  7 ++---
>  mdadm.h       | 18 +++++++++++
>  monitor.c     | 85 ++++++++++++++++++++++-----------------------------
>  msg.c         |  4 +--
>  super-intel.c | 38 ++++++++---------------
>  sysfs.c       | 12 ++++----
>  util.c        |  2 +-
>  18 files changed, 151 insertions(+), 141 deletions(-)
>=20

