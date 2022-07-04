Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FEC4C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  4 Jul 2022 08:43:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbiGDInb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 4 Jul 2022 04:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231996AbiGDIna (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 4 Jul 2022 04:43:30 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D88426D3
        for <linux-raid@vger.kernel.org>; Mon,  4 Jul 2022 01:43:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656924209; x=1688460209;
  h=message-id:date:from:to:cc:subject:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Ord0W/HuSaN+5VbNTBLL8rIyOmBJLFxwaHd9Q6HL2a4=;
  b=PuLQ8RWtghHGEnCXgH94xo7V48QrM6oiW9GAH5WMo7FJf09TqmHoj7uT
   R2pprbGcyJ0r4rb42kKxcBpU+lSei09tRleE1GkmUdbFl8L9xDlTIgZMO
   RmrUJ/VvEsgJKFMGNlLTRILWJ1okwv/4YAwRt4h8jokbDWU+vaVwQq5d3
   3TYpbwINXLyqzHxOmzK/xkW7HVsCzs89yxgXdJr3eOmd+MIoh7Ros6ANo
   cP28gJbJny+kEfo5ghIQA+mVuaMfkQNQjidlT7JvGLNSqJa9XxG9xKdf0
   Lo7ZF3HT97jqkG34GQrpNUG4JN3ocR1ksalmOxURofcc7AKfZpQe09CRG
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="262866933"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="262866933"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 01:43:28 -0700
Message-Id: <b72376$g5buij@orsmga003-auth.jf.intel.com>
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="542505555"
Received: from lflorcza-mobl.ger.corp.intel.com (HELO intel.linux.com) ([10.237.140.88])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Jul 2022 01:43:27 -0700
Date:   Mon, 4 Jul 2022 10:43:23 +0200
From:   Lukasz Florczak <lukasz.florczak@linux.intel.com>
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Is it correct that raid5 cannot be converted from Consistency
 Policy: bitmap to ppl?
In-Reply-To: <20220703200741.GA3138296@merlins.org>
References: <20220703200741.GA3138296@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, 3 Jul 2022 13:07:41 -0700, Marc MERLIN <marc@merlins.org> wrote:

> Is there any way around this, or not without a full reformat/rebuild?
> 
Hi,
I've been able to change the consistency using mdadm v4.2 on a imsm
container. I don't know if it will work for native metadata. Hope this
helps you a little.

The steps I did it:
1. Stop the volume
# mdadm -S /dev/md/<volume_name>
2. Update to ppl
# mdadm --update-subarray=0 --update=ppl /dev/md/<container_name>
3. Assemble incrementally
# mdadm --incremental /dev/md/<container_name>

Thanks,
Lukasz

> gargamel:~# mdadm --query --detail /dev/md5
> /dev/md5:
>            Version : 1.2
>      Creation Time : Tue Jan 21 10:35:52 2014
>         Raid Level : raid5
>         Array Size : 15627542528 (14903.59 GiB 16002.60 GB)
>      Used Dev Size : 3906885632 (3725.90 GiB 4000.65 GB)
>       Raid Devices : 5
>      Total Devices : 5
>        Persistence : Superblock is persistent
> 
>      Intent Bitmap : Internal
> 
>        Update Time : Sun Jul  3 03:02:01 2022
>              State : active, checking 
>     Active Devices : 5
>    Working Devices : 5
>     Failed Devices : 0
>      Spare Devices : 0
> 
>             Layout : left-symmetric
>         Chunk Size : 512K
> 
> Consistency Policy : bitmap
> 
>       Check Status : 99% complete
> 
>               Name : gargamel.svh.merlins.org:5  (local to host
> gargamel.svh.merlins.org) UUID : ec672af7:a66d9557:2f00d76c:38c9f705
>             Events : 642977
> 
>     Number   Major   Minor   RaidDevice State
>        0       8      193        0      active sync   /dev/sdm1
>        6       8      177        1      active sync   /dev/sdl1
>        2       8      209        2      active sync   /dev/sdn1
>        3       8        1        3      active sync   /dev/sda1
>        5       8       17        4      active sync   /dev/sdb1
> gargamel:~# mdadm --grow --consistency-policy=ppl /dev/md5
> mdadm: Current consistency policy is bitmap, cannot change to ppl
> 
> Kernel 5.16.
> 
> Thanks,
> Marc
> -- 
> "A mouse is a device used to point at the xterm you want to type in"
> - A.S.R. 
> Home page: http://marc.merlins.org/                       | PGP
> 7F55D5F27AAF9D08
