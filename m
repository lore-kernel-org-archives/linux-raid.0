Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23CE18D649
	for <linux-raid@vger.kernel.org>; Wed,  9 Oct 2024 10:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728468588; cv=none; b=uvg+DXaeBjJ41M/xkVkEyFWLR2Lii/bTtrywZzLJOhex1aZdbofyQJLSj6zJ/qDj9xG+H6LDKc418NoUZub3xC3kqTWknJbJ8T31MHtMDeI5uTqUrgHn5No0lxo8P4SfXRSFvwkWh6Hd+kxG+GlIuCf/KqYGtLHzQDjRygoddyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728468588; c=relaxed/simple;
	bh=1aIFcv9yM5F1CmQq+McWQ6l69bDGbh29Ej7X6WqL0z8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YmzM4LHPj7cdEtg1pCF0UEYPX/2/pQnFrEjufDgm4I1qjzK/CFXjwQaVl32Ehtj3bG2yu0fk8ETVU9pgcdkp8L0A/Q0LATMiafHmG46E6HiXy+K3EFSrPKmO9m0YbLFpooKXYoW0RIj/7zgpS9jslChstOpkixCUxWXJVZs1Ms0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=i9NVKnC9; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="i9NVKnC9"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1728468587; x=1760004587;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=1aIFcv9yM5F1CmQq+McWQ6l69bDGbh29Ej7X6WqL0z8=;
  b=i9NVKnC9oXIT5LJ+IA/Yl4AbAy6h+KMNWSpZ0phTJfZO7EP4PQZ7s6MZ
   72wkwlBb9+g6KLfe0drVNO/pIKHWaWisKmFcWNg3ZbePj/nWhut32oE0S
   0qvcHSOIhKLBu+1/LXCfy/+UCUTM7/aCSlbcrQQNsSzfWfCmhToHnNTCi
   xGw58AfRYbAFA8q3v8VrVrvw8dQuBhpOpN6zwpTcTm7r9+eTMypQBba6y
   Y1b39gLbrS/dXAbaDFyULSUb3dWtft59sS/ZiwksQbVAMMSmj/lJY59r3
   7RhYcsHApDng9RiRD4UscjJPrCID6iOrDxQiLmLnT2IKF8UcY1YCILODu
   Q==;
X-CSE-ConnectionGUID: ceI7aPqXQFyPJgb1Ev2j/A==
X-CSE-MsgGUID: LHbxY2y9Rg+llCPcSv3VZA==
X-IronPort-AV: E=McAfee;i="6700,10204,11219"; a="39149374"
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="39149374"
Received: from orviesa005.jf.intel.com ([10.64.159.145])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 03:09:46 -0700
X-CSE-ConnectionGUID: 3pUrefY8SRKKH2CH2zCsUw==
X-CSE-MsgGUID: dhHqPibBTRWoFF6wmDk2kA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,189,1725346800"; 
   d="scan'208";a="81001889"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.82.157])
  by orviesa005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Oct 2024 03:09:46 -0700
Date: Wed, 9 Oct 2024 12:09:40 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: 19 Devices <19devices@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: Can't replace drive in imsm RAID 5 array, spare not shown
Message-ID: <20241009120940.000004fa@linux.intel.com>
In-Reply-To: <E656D988-48EF-4428-AEB6-2F6D8677612B@gmail.com>
References: <E656D988-48EF-4428-AEB6-2F6D8677612B@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 06 Oct 2024 07:00:18 +0100
19 Devices <19devices@gmail.com> wrote:

> Hi, I have a 4 drive imsm RAID 5 array which is working fine.  I want to
> remove one of the drives, sda, and replace it with a spare, sdc.  From man
> mdadm I understand that add - fail - remove is the way to go but this does
> not work.
> 
> Before:
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md124 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>       2831155200 blocks super external:/md126/0 level 5,
>  128k chunk, algorithm 0 [4/4] [UUUU]
> 
> md125 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>       99116032 blocks super external:/md126/1 level 5, 1
> 28k chunk, algorithm 0 [4/4] [UUUU]
> 
> md126 : inactive sda[3](S) sdb[2](S) sdd[1](S) sde[0](S)
>       14681 blocks super external:imsm
> 
> unused devices: <none>
> 
> 
> I can add (or add-spare) which increases the size of the container and though
> I can't see any spare drives listed by mdadm, it appears as SPARE DISK in the
> Intel option ROM after a reboot.
> 
> $ sudo mdadm --zero-superblock /dev/sdc
> 
> $ sudo mdadm /dev/md/imsm1 --add-spare /de
> v/sdc
> mdadm: added /dev/sdc
> 
> $ cat /proc/mdstat
> Personalities : [raid6] [raid5] [raid4]
> md124 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>       2831155200 blocks super external:/md126/0 level 5,
>  128k chunk, algorithm 0 [4/4] [UUUU]
> 
> md125 : active raid5 sdd[3] sdb[2] sda[1] sde[0]
>       99116032 blocks super external:/md126/1 level 5, 1
> 28k chunk, algorithm 0 [4/4] [UUUU]
> 
> md126 : inactive sdc[4](S) sda[3](S) sdb[2](S) sdd[1](S) sde[0](S)
>       15786 blocks super external:imsm
> 
> unused devices: <none>
> $
> 
> 
> No spare devices listed here:
> 
> $ sudo mdadm -D /dev/md/imsm1
> /dev/md/imsm1:
>            Version : imsm
>         Raid Level : container
>      Total Devices : 5
> 
>    Working Devices : 5
> 
> 
>               UUID : bdb7f495:21b8c189:e496c216:6f2d6c4c
>      Member Arrays : /dev/md/md1_0 /dev/md/md0_0
> 
>     Number   Major   Minor   RaidDevice
> 
>        -       8       64        -        /dev/sde
>        -       8       32        -        /dev/sdc
>        -       8        0        -        /dev/sda
>        -       8       48        -        /dev/sdd
>        -       8       16        -        /dev/sdb
> $
> 
Hello,

I know. It is fine. From container point of view these all are spares.
Nobody ever complained about that so we did not fixed it :)
The most important is that all drives are here.

To detect spares you must compare this list with list from #mdadm --detail
/dev/md124 (member array). Drives that are not used in member array are spares.
> 
> Trying to remove sda fails.
> 
> $ sudo mdadm --fail /dev/md126 /dev/sda
> mdadm: Cannot remove /dev/sda from /dev/md126, array will be failed.

It might be an issue in mdadm, we added this and later we added fixes:

Commit:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=fc6fd4063769f4194c3fb8f77b32b2819e140fb9

Fixes:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=b3e7b7eb1dfedd7cbd9a3800e884941f67d94c96
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=461fae7e7809670d286cc19aac5bfa861c29f93a

but your release is mdadm-4.3, all fixes should be there. It might be a new bug.

Try:
#mdadm -If sda
but please do not abuse it (just use it one time because it may fail your
array). According to mdstat it should be safe in this case.

If you can do some investigation, I would be tankful, I expect issues
in enough() function.

Thanks,
Mariusz

> 
> sda is 2TB, the others are 1TB - is that a problem?
> 
> smartctl shows 2 drives don't support  SCT and it's disabled on the other 3.
> 
> There's a very similar question here from Edwin in 2017:
> https://unix.stackexchange.com/questions/372908/add-hot-spare-drive-to-intel-rst-onboard-raid#372920
> 
> The only reply points to an Intel doc which uses the standard command to add
> a drive but doesn't show the result.
> 
> $ uname -a
> Linux Intel 6.9.2-arch1-1 #1 SMP PREEMPT_DYNAMIC Sun, 26
>  May 2024 01:30:29 +0000 x86_64 GNU/Linux
> 
> $ mdadm --version
> mdadm - v4.3 - 2024-02-15
> 

