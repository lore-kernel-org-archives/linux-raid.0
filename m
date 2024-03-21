Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B23555A4D4
	for <linux-raid@vger.kernel.org>; Thu, 21 Mar 2024 12:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711022883; cv=none; b=PFs6aW8A+BBh8I4YQjZ5RgDE/sJzsOhdcM6yiUWNE9HUXF/scURGamG6EGqLFfG/tdCIDxLU2fVZdwr4Z2O+rguqcF26gm+AdBPY16KHdSKJfYVdiXG2ICKW5Ja31krCQoCrBF3yXXidYtlhEvVQZ9OTMcQDDFDTSslHFaE4tMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711022883; c=relaxed/simple;
	bh=qAi7Aj56RyYfGXKkA6g5uewwBFCpPyXIiX96fyMyzDc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GnlJdKSRzqLDQUJ8Y5norCxhVyhdhp1XLw852qO+yPJ/80DBGFjYHJDxXjv9XJAlK/VGRF5vjqq90poSBUuHRaHfLXskSXJwKi7NWwCU7KAL7RAJST0CCc1ucJrXWjFp8cffgEVpAtXsdK1UhajtH+pUuRmyw8EXIUPMpI+FvE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=VY4d7uuT; arc=none smtp.client-ip=192.198.163.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="VY4d7uuT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711022882; x=1742558882;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=qAi7Aj56RyYfGXKkA6g5uewwBFCpPyXIiX96fyMyzDc=;
  b=VY4d7uuTt3glfDTuqVdDq3PXqFO1bIQwZiQ83fGUiTxhV39eoDNwFlo1
   3+8ESOD5h3MaoiBpINWpQiOTbn6mHmjUwDJreXP8UFFBwkPdh8mkix21N
   GH6mi0UlzW5PXS9nRiEEghXHRVckZGwsO/nqYd9iBRtoIeRXDbXCuqG4C
   EMzefDZPUD9OPwKSFxrzy0RQ3t+ze9ajszCkv9EfHAkZGAOLb697bvkQM
   8qu1/pzQY194aIFqTjaF0OIkAMd/9+Zw9qljJGaHYHhMM1N++1pefkLCy
   3FmQ4q3bkW4HGaxqxvlJQ6LH75Sq1B2NHjSdE5r9oN2v8GT3ini0czVjk
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,11019"; a="5854625"
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="5854625"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa113.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 05:07:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,142,1708416000"; 
   d="scan'208";a="15127717"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2024 05:07:53 -0700
Date: Thu, 21 Mar 2024 13:07:48 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: d tbsky <tbskyd@gmail.com>, Xiao Ni <xni@redhat.com>
Cc: list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: md-uuid inconsistent in the future
Message-ID: <20240321130748.0000091d@linux.intel.com>
In-Reply-To: <CAC6SzH+KS2Y9QngciLrRytacMS4EvnCAigafbLO9i+DObm4CqA@mail.gmail.com>
References: <CAC6SzH+KS2Y9QngciLrRytacMS4EvnCAigafbLO9i+DObm4CqA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 20 Mar 2024 23:15:34 +0800
d tbsky <tbskyd@gmail.com> wrote:

> Hi:
>     today I want to install RHEL 9.3 with mdadm software raid1 "/boot"
> partition to a server. installation failed with message "failed to
> write boot loader configuration".
> 
>    I switched to console and "dmesg" showed a lot of errors about "rtc
> write failed with error -22". I checked the system time and found
> someone set the server to year "2223". I correct the time to year
> "2024" and reinstall RHEL 9.3 with the same disk layout (eg: I didn't
> recreate mdadm raid since it will need extra steps). and again
> installation failed with the same error message.
> 
>    I was curious so I checked what happened. I found md-uuid string is
> reversed from "/dev/disk/by-id" and mdadm itself. Below are some
> strange results. Maybe the issue is not important and people in the
> far future will fix it someday if we don't kill the bug. Just share
> the experience.
> 
> >ls -la /dev/disk/by-id | grep md-uuid  
> lrwxrwxrwx 1 root root   11 Mar 20 03:10
> md-uuid-a4e266d2:68ae1848:1a6d6a71:a419ebdb -> ../../md127
> 
> >mdadm --examine --scan  
> ARRAY /dev/md/boot  metadata=1.2
> UUID=d266e2a4:4818ae68:716a6d1a:dbeb19a4
> name=localhost.localdomain:boot
> 
> >mdadm -E /dev/sda2  (result show created at year 2223)  
> /dev/sda2:
>           Magic : a92b4efc
>         Version : 1.2
>     Feature Map : 0x1
>      Array UUID : d266e2a4:4818ae68:716a6d1a:dbeb19a4
>            Name : localhost.localdomain:boot  (local to host
> localhost.localdomain)
>   Creation Time : Fri Nov 14 07:32:22 2223
>      Raid Level : raid1
>    Raid Devices : 5
> 
>  Avail Dev Size : 1048576 sectors (512.00 MiB 536.87 MB)
>      Array Size : 524288 KiB (512.00 MiB 536.87 MB)
>     Data Offset : 2048 sectors
>    Super Offset : 8 sectors
>    Unused Space : before=1968 sectors, after=0 sectors
>           State : clean
>     Device UUID : 4007990e:44762c79:efab3543:04a55382
> 
> Internal Bitmap : 8 sectors from superblock
>     Update Time : Wed Mar 20 03:07:49 2024
>   Bad Block Log : 512 entries available at offset 16 sectors
>        Checksum : 87a9793f - correct
>          Events : 38
> 
> 
>    Device Role : Active device 3
>    Array State : AAAAA ('A' == active, '.' == missing, 'R' == replacing)
> 
> 
> >mdadm --details /dev/md127 (result show created at year 2106 which is not
> >correct)  
> /dev/md127:
>            Version : 1.2
>      Creation Time : Sun Feb  7 06:28:15 2106
>         Raid Level : raid1
>         Array Size : 524288 (512.00 MiB 536.87 MB)
>      Used Dev Size : 524288 (512.00 MiB 536.87 MB)
>       Raid Devices : 5
>      Total Devices : 5
>        Persistence : Superblock is persistent
> 
>      Intent Bitmap : Internal
> 
>        Update Time : Wed Mar 20 03:07:49 2024
>              State : clean
>     Active Devices : 5
>    Working Devices : 5
>     Failed Devices : 0
>      Spare Devices : 0
> 
> Consistency Policy : bitmap
> 
>     Number   Major   Minor   RaidDevice State
>        0       8       50        0      active sync   /dev/sdd2
>        1       8       18        1      active sync   /dev/sdb2
>        2       8       34        2      active sync   /dev/sdc2
>        3       8        2        3      active sync   /dev/sda2
>        4       8       66        4      active sync   /dev/sde2
> 

Hi,
There could be a regression in upstream for mdadm --detail --export. See
proposed fix:
https://patchwork.kernel.org/project/linux-raid/patch/20240318151930.8218-3-mariusz.tkaczyk@linux.intel.com/

There are no comments so I will merge fix soon.

Xiao, Could you please check RHEL 9.3 and eventually revert the patch in
z-stream?

Thanks,
Mariusz
