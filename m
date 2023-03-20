Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBED1C7618D
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 14:36:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231207AbjCTOgs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 10:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231479AbjCTOgq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 10:36:46 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 015ED1A651
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 07:36:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679323006; x=1710859006;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9tAesx9HWsTeYikifKyBI077uBdWE88Wg18tFL6V9Kc=;
  b=kBfD1YhqBogHaYyhsrLkeWVEEtIEiZ5G1G3tZNz+F34nezhaS9EUpZv4
   i24odNjAkjec2I07L1TNIDh0DFpyKVel4PRu6ZghX0kkViP07y6CPbTLp
   rAhl9es+IcNkruE8YvFrjhCFn5G3+F664Ne+OytswnXeUEdD6KTVzv9m8
   DMpwzOSRXOLtbmy5LBI8/4B9xYBsjvBx32qbbebUaf6SYvMd6a/IlB+1t
   +i7kbsTkceiTwrgbd6Mrt2Gz+/aa53ofkDw9kcmzMl0kkWb44wIpl05UB
   N8we+0IOAPg3LPboV1RU1S3j7vcXxmFKctS8oUhdXL+Y6IrQLLSqS73us
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="338702399"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="338702399"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 07:36:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="631155006"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="631155006"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.82])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 07:36:44 -0700
Date:   Mon, 20 Mar 2023 15:36:39 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: mdadm --detail works, mdadm --stop says "does not appear to be
 an md device"
Message-ID: <20230320153639.0000238d@linux.intel.com>
In-Reply-To: <20230317173810.GW4049235@merlins.org>
References: <20230317173810.GW4049235@merlins.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 17 Mar 2023 10:38:10 -0700
Marc MERLIN <marc@merlins.org> wrote:

> gargamel:~# cat /proc/mdstat 
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> [multipath] md6 : active raid5 sdn1[3](F) sdt1[0](F) sds1[1](F) sdq1[2](F)
>       23441547264 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/0]
> [_____] gargamel:~# mdadm --stop /dev/md6
> mdadm: /dev/md6 does not appear to be an md device
> gargamel:~# mdadm --detail /dev/md6
> /dev/md6:
>            Version : 1.2
>      Creation Time : Wed Jul  8 10:09:21 2020
>         Raid Level : raid5
>         Array Size : 23441547264 (22355.60 GiB 24004.14 GB)
>      Used Dev Size : 5860386816 (5588.90 GiB 6001.04 GB)
>       Raid Devices : 5
>      Total Devices : 4
>        Persistence : Superblock is persistent
> 
>        Update Time : Fri Mar 17 09:17:28 2023
>              State : clean, FAILED 
>     Active Devices : 0
>     Failed Devices : 4
>      Spare Devices : 0
> 
>             Layout : left-symmetric
>         Chunk Size : 512K
> 
> Consistency Policy : ppl
> 
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        -       0        0        1      removed
>        -       0        0        2      removed
>        -       0        0        3      removed
>        -       0        0        4      removed
> 
> 
> How do I clear this without a reboot?
> 
> gargamel:~# uname -r
> 5.19.7
> 
> 

Hi,
mdadm is unable to complete this task because it cannot ensure that it is safe
to stop the array. It cannot open the array with O_EXCL.
If it is mounted then it may hang if filesystem needs to flush some data.

Please, try umount the array if it mounted somewhere and then try:

# echo inactive > /sys/block/md6/md/array_state
# echo clear > /sys/block/md6/md/array_state

Thanks,
Mariusz
