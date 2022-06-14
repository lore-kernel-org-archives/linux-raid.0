Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83D7EC433EF
	for <linux-raid@archiver.kernel.org>; Tue, 14 Jun 2022 14:45:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243356AbiFNOpl (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Jun 2022 10:45:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243764AbiFNOpk (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Jun 2022 10:45:40 -0400
Received: from mga01.intel.com (mga01.intel.com [192.55.52.88])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C22F1313AF
        for <linux-raid@vger.kernel.org>; Tue, 14 Jun 2022 07:45:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655217937; x=1686753937;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rCNy44w+U9q5YS8ia1l62i+5yLeDSvgJRDYeJh+REPQ=;
  b=b5RjxxATUTSDUDxMjTlhAlcYuid/551t6+Ld9f4DAIykbAVamLS4GpgV
   WxNVswR8S7wQX0CqsHo0S74lzpGfHuPbNGd7xVS4pqAY50W2nFvhDcTcQ
   1+tjjYTi293kv8vzY+bdQz6fDDeZsgw8aOLpRJ1l4UzUKCfWZ02Q9eWbF
   Oa2yd5untCbzKH3227YEHwTPzuaByOiub3BsBbvXuelku4ApXW6JeOYdp
   G7MWYbuHvW+NX8IQNaMdUmqabG+sxUe+OAw0QF/C1Z2QK87xLuKjgLP+L
   hqw0sTIG6Q5bVA7A0GIG4bCz+Qo5xzcd/lBOzCEOO3WJuSkN1UJz5S9EV
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10378"; a="304052587"
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="304052587"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 07:45:37 -0700
X-IronPort-AV: E=Sophos;i="5.91,300,1647327600"; 
   d="scan'208";a="640413146"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.60.61])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Jun 2022 07:45:36 -0700
Date:   Tue, 14 Jun 2022 16:45:31 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Roman Mamedov <rm@romanrm.net>
Cc:     linux-raid@vger.kernel.org
Subject: Re: How to enable bitmap on IMSM?
Message-ID: <20220614164531.0000654e@linux.intel.com>
In-Reply-To: <20220614141442.1971c876@nvm>
References: <20220614141442.1971c876@nvm>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 14 Jun 2022 14:14:42 +0500
Roman Mamedov <rm@romanrm.net> wrote:

> Hello,
> 
> I upgraded mdadm to 4.2 to get the bitmap support in IMSM.
> 
> I run: "mdadm --update-subarray=0 -U bitmap /dev/md127"
> However the array details stay the same, with "Consistency Policy : resync".
> No error is reported, and nothing in dmesg.
> 
> How to actually use it?
>

Hi Roman,
There is a bug in mdadm (will be fixed soon) which allows you to update
subarray on active volume. Update is successful but mdmon will overwrite
it.

To enable bitmap, you need to stop member array first:
# mdadm -S /dev/md126

then run update command:
# mdadm --update-subarray=0 -U bitmap /dev/md127

mdadm will set bitmap in metadata:
#mdadm -E /dev/md127

At the end, start member volume:
# mdadm -As

Now, you can verify array details:
# mdadm -D /dev/md126.

Hope it helps,
Mariusz

> Thanks
> 
> 
> # mdadm --detail /dev/md127
> /dev/md127:
>            Version : imsm
>         Raid Level : container
>      Total Devices : 4
> 
>    Working Devices : 4
> 
> 
>               UUID : d07837ca:804cf5e3:01c52352:f64b0524
>      Member Arrays : /dev/md/Volume0
> 
>     Number   Major   Minor   RaidDevice
> 
>        -       8       32        -        /dev/sdc
>        -       8        0        -        /dev/sda
>        -       8       48        -        /dev/sdd
>        -       8       16        -        /dev/sdb
> 
> # mdadm --detail /dev/md126
> /dev/md126:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid10
>         Array Size : 1953519616 (1863.02 GiB 2000.40 GB)
>      Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>       Raid Devices : 4
>      Total Devices : 4
> 
>              State : active 
>     Active Devices : 4
>    Working Devices : 4
>     Failed Devices : 0
> 
>             Layout : near=2
>         Chunk Size : 64K
> 
> Consistency Policy : resync
> 
> 
>               UUID : xxx
>     Number   Major   Minor   RaidDevice State
>        3       8        0        0      active sync set-A   /dev/sda
>        2       8       16        1      active sync set-B   /dev/sdb
>        1       8       32        2      active sync set-A   /dev/sdc
>        0       8       48        3      active sync set-B   /dev/sdd
> 
> # mdadm --update-subarray=0 -U bitmap /dev/md127
> 
> # mdadm --detail /dev/md127
> /dev/md127:
>            Version : imsm
>         Raid Level : container
>      Total Devices : 4
> 
>    Working Devices : 4
> 
> 
>               UUID : d07837ca:804cf5e3:01c52352:f64b0524
>      Member Arrays : /dev/md/Volume0
> 
>     Number   Major   Minor   RaidDevice
> 
>        -       8       32        -        /dev/sdc
>        -       8        0        -        /dev/sda
>        -       8       48        -        /dev/sdd
>        -       8       16        -        /dev/sdb
> 
> # mdadm --detail /dev/md126
> /dev/md126:
>          Container : /dev/md/imsm0, member 0
>         Raid Level : raid10
>         Array Size : 1953519616 (1863.02 GiB 2000.40 GB)
>      Used Dev Size : 976759808 (931.51 GiB 1000.20 GB)
>       Raid Devices : 4
>      Total Devices : 4
> 
>              State : active 
>     Active Devices : 4
>    Working Devices : 4
>     Failed Devices : 0
> 
>             Layout : near=2
>         Chunk Size : 64K
> 
> Consistency Policy : resync
> 
> 
>               UUID : xxx
>     Number   Major   Minor   RaidDevice State
>        3       8        0        0      active sync set-A   /dev/sda
>        2       8       16        1      active sync set-B   /dev/sdb
>        1       8       32        2      active sync set-A   /dev/sdc
>        0       8       48        3      active sync set-B   /dev/sdd
> 
> 
> 

