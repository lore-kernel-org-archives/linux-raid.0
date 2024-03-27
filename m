Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.13])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 160FC47F54
	for <linux-raid@vger.kernel.org>; Wed, 27 Mar 2024 11:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.13
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711537838; cv=none; b=sVI5TFONoOj7Fx2800zMuPuuI9aF2IZkx6Ilx+2gZBLOUAM3gbGwjf/MTRwN71mXp4oUhAuvip3Al6eaFiYqwmo5j1HpD/CoGz2kULp/VSTfb9aUCk1c7W7QPJZU8KLvGBwdpDK6o1oRDeK1OH4pYqSzJ/5OfwXFDpB55THGGg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711537838; c=relaxed/simple;
	bh=H2Oy57Q0+yqsoOVM045Fp6Du6TJ3ClKpyO1h8NMC/uo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NLFAx8mSTIS/mcPUsi1lO8y4YabT4HVKY6woyEjsFP0vplX0R3L0GCCPNqcOUyWZTn5Uw1QDNoECWJUsQkbsCrnvuybCBhKBugC+r1QVRdmFCK9uIqnSVuDEZjyIgkpG8RqpGp7nUQT3VseXe7wpmrnQHbKnoRpVYG3cdMxXcR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=JZf6M2Yf; arc=none smtp.client-ip=198.175.65.13
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="JZf6M2Yf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1711537837; x=1743073837;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=H2Oy57Q0+yqsoOVM045Fp6Du6TJ3ClKpyO1h8NMC/uo=;
  b=JZf6M2YfuhigAXV0LGymoaPs9vBg89lT9ajoNSrepDiiMVhsHd122DOD
   q/KQcDYT4dID9HEiNL2jUIRQRU2FasPIQhKbRtCl+7Wx8DD4QQzloAQhi
   blxJ/xO3ZHFg+KYpdv2qp/X9Dl6i7I01SGPWG5LO+QBz7zZtOrhUJzGUO
   D2P+dp6NM1wbZvJu7UXPz6IdKCOLyxlhWH47csPIt9QRXt6HeNCtadpcQ
   4Andp7rGbT1q4Mu6ipumreAEMcU6mgi2wGzl5H7fHfTpHlqxedZynHhvs
   nTRtyzqi1zTJREDYIVIbLeLhMhuZS8tE/DC0Qx7OUNibKUDJhgBGy6fS1
   w==;
X-CSE-ConnectionGUID: 15TMwrvYSTSmx3AUseVqlg==
X-CSE-MsgGUID: 1bADoni5S3mMXBdZ8Gyiug==
X-IronPort-AV: E=McAfee;i="6600,9927,11025"; a="17772904"
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="17772904"
Received: from fmviesa004.fm.intel.com ([10.60.135.144])
  by orvoesa105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 04:10:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,158,1708416000"; 
   d="scan'208";a="20923248"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.245.112.252])
  by fmviesa004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Mar 2024 04:10:28 -0700
Date: Wed, 27 Mar 2024 12:10:23 +0100
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Khem Raj <raj.khem@gmail.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH] include libgen.h for basename API
Message-ID: <20240327121023.000017e9@linux.intel.com>
In-Reply-To: <20240325061537.275811-1-raj.khem@gmail.com>
References: <20240325061537.275811-1-raj.khem@gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 24 Mar 2024 23:15:37 -0700
Khem Raj <raj.khem@gmail.com> wrote:

> Musl does no more provide it via string.h therefore builds with newer
> compilers e.g. clang-18 fails due to missing prototype for basename
> therefore add libgen.h to included headers list
> 
> Signed-off-by: Khem Raj <raj.khem@gmail.com>
> ---
>  Monitor.c        | 1 +
>  platform-intel.c | 1 +
>  super-intel.c    | 1 +
>  3 files changed, 3 insertions(+)
> 
> diff --git a/Monitor.c b/Monitor.c
> index 824a69f..e3942e1 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -26,6 +26,7 @@
>  #include	"udev.h"
>  #include	"md_p.h"
>  #include	"md_u.h"
> +#include  <libgen.h>
>  #include	<sys/wait.h>
>  #include	<limits.h>
>  #include	<syslog.h>

Please stick to style around.

> diff --git a/platform-intel.c b/platform-intel.c
> index ac282bc..5d6687d 100644
> --- a/platform-intel.c
> +++ b/platform-intel.c
> @@ -19,6 +19,7 @@
>  #include "mdadm.h"
>  #include "platform-intel.h"
>  #include "probe_roms.h"
> +#include <libgen.h>
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <string.h>
> diff --git a/super-intel.c b/super-intel.c
> index dbea235..881dbda 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -23,6 +23,7 @@
>  #include "dlink.h"
>  #include "sha1.h"
>  #include "platform-intel.h"
> +#include <libgen.h>
>  #include <values.h>
>  #include <scsi/sg.h>
>  #include <ctype.h>

https://man7.org/linux/man-pages/man3/basename.3.html

       There are two different versions of basename() - the POSIX
       version described above, and the GNU version [...]

       In the glibc implementation, the POSIX versions of these
       functions modify the path argument, and segfault when called with
       a static string such as "/usr/".

I checked my string.h header (opensuse 15 sp4) and there is:

/* Return the file name within directory of FILENAME.  We don't
   declare the function if the `basename' macro is available (defined
   in <libgen.h>) which makes the XPG version of this function
   available.  */

It means that with libgen.h header we will switch to XPG/POSIX basename
everywhere, even if that is not wanted.

Eventually, you can try to minimize impact, by adding it only if it is
absolutely necessary i.e. basename() is not available:

#ifndef basename
   #include <libgen.h>
#endif
(not tested, partially copied from string.h)

Please analyze all usages to determine if POSIX version of basename usages are
safe- I would like to have that documented in commit message.

Thanks,
Mariusz
