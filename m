Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0A6CC433EF
	for <linux-raid@archiver.kernel.org>; Thu,  3 Mar 2022 16:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234940AbiCCQWT (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Mar 2022 11:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234939AbiCCQWR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Mar 2022 11:22:17 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32ACA199E18
        for <linux-raid@vger.kernel.org>; Thu,  3 Mar 2022 08:21:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646324492; x=1677860492;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=R2pEOSAiFF9NHcMMA0z2vLtdobKb8lj3feXC+wbx/sk=;
  b=bXeQ4rnM4AaQZEmwXuHgABDZ5Ynm4+zprCK5dv9mzJ1yDjhXlomoTF15
   fAVzmDY6hm7znkG5Q4Syz+Lf4F6Mjr5hWpJhjhGNaUkJrmWYs//4zY21m
   bzPr7o/h62VhyA6Y9utahz94/sEHx87axB2vJHcTxrmNHFM9y/y4/u6V8
   S9O8YydzrmtjoS+eFkRzxT7KdqNYyRX/P+Zf42KyGRqkPS2IG727WJtsK
   EhXN6uKdzJndB7eUtnSBM+SOP2mBMO6WY/s3zygVlrVWsm0wNrYiRNJzt
   dA3xEAYYvWkAlczFmsPUz/CwwDusJnA8F0khwtwtIOfcU/SUlSz/3rSN8
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10275"; a="241137609"
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="241137609"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 08:21:30 -0800
X-IronPort-AV: E=Sophos;i="5.90,151,1643702400"; 
   d="scan'208";a="551808167"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.23.199])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Mar 2022 08:21:28 -0800
Date:   Thu, 3 Mar 2022 17:21:23 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     song@kernel.org, linux-raid@vger.kernel.org
Subject: Re: [PATCH 3/3] raid5: introduce MD_BROKEN
Message-ID: <20220303172123.00000daa@linux.intel.com>
In-Reply-To: <8b918c2a-5b68-6ddc-0a23-69af70f28d7d@linux.dev>
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
        <20220127153912.26856-4-mariusz.tkaczyk@linux.intel.com>
        <fbe1ec39-acee-8226-adb2-6c61e3d7fdd0@linux.dev>
        <20220222151851.0000089a@linux.intel.com>
        <8b918c2a-5b68-6ddc-0a23-69af70f28d7d@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 25 Feb 2022 15:22:00 +0800
Guoqing Jiang <guoqing.jiang@linux.dev> wrote:

> >> If one member disk was set Faulty which caused BROKEN was set, is
> >> it possible to re-add the same member disk again?
> >> =20
> > Is possible to re-add drive to failed raid5 array now? From my
> > understanding of raid5_add_disk it is not possible. =20
>=20
> I mean the below steps, it works as you can see.
>=20
> >> [root@vm ~]# echo faulty > /sys/block/md0/md/dev-loop1/state
> >> [root@vm ~]# cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4]
> >> md0 : active raid5 loop2[2] loop1[0](F)
> >>   =A0=A0=A0=A0=A0 1046528 blocks super 1.2 level 5, 512k chunk, algori=
thm 2
> >> [2/1] [_U] bitmap: 0/1 pages [0KB], 65536KB chunk
> >>
> >> unused devices: <none>
> >> [root@vm ~]# echo re-add > /sys/block/md0/md/dev-loop1/state
> >> [root@vm ~]# cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4]
> >> md0 : active raid5 loop2[2] loop1[0]
> >>   =A0=A0=A0=A0=A0 1046528 blocks super 1.2 level 5, 512k chunk, algori=
thm 2
> >> [2/2] [UU] bitmap: 0/1 pages [0KB], 65536KB chunk
> >>
> >> unused devices: <none>


In this case array is not failed (it is degraded). For that reason I
think that my changes are not related.

# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4] [raid1] [raid10]
md127 : active raid5 nvme5n1[1] nvme4n1[0](F)
      5242880 blocks super 1.2 level 5, 512k chunk, algorithm 2 [2/1]
[_U]

unused devices: <none>
# cat /sys/block/md127/md/array_state clean

# mdadm -D /dev/md127
/dev/md127:
           Version : 1.2
     Creation Time : Thu Mar  3 18:49:53 2022
        Raid Level : raid5
        Array Size : 5242880 (5.00 GiB 5.37 GB)
     Used Dev Size : 5242880 (5.00 GiB 5.37 GB)
      Raid Devices : 2
     Total Devices : 2
       Persistence : Superblock is persistent

       Update Time : Thu Mar  3 18:52:46 2022
             State : clean, degraded
    Active Devices : 1
   Working Devices : 1
    Failed Devices : 1
     Spare Devices : 0

            Layout : left-symmetric
        Chunk Size : 512K

Consistency Policy : resync

              Name : gklab-localhost:vol  (local to host
              gklab-localhost)
              UUID : 711594e8:73ef988c:87a85085:b30c838d
            Events : 8

    Number   Major   Minor   RaidDevice State
       -       0        0        0      removed
       1     259        9        1      active sync   /dev/nvme5n1

       0     259        5        -      faulty   /dev/nvme4n1


Do I miss something?

Thanks,
Mariusz
