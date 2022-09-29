Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 520ECC43219
	for <linux-raid@archiver.kernel.org>; Thu, 29 Sep 2022 09:36:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235156AbiI2JgU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 29 Sep 2022 05:36:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234766AbiI2Jfy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 29 Sep 2022 05:35:54 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88D3B32EFE
        for <linux-raid@vger.kernel.org>; Thu, 29 Sep 2022 02:35:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1664444127; x=1695980127;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=xSbKkSbBDeN+VY9iY8PjgYZQxq2GnCxPC2HLkKI4Qpg=;
  b=cmw2XOg2G0CB6c9BwcWo4oLDE85lof/hPyNq3DkSSsKOyjfruDZ7/Dex
   K+zdITYb1QBecj1ALMBms9vgzW4Kax1+UF4zyMzut9U6Y3jPFL8y7qlAD
   c1wPbR60wgSdRfy+nbyO0nUwC89HrfQwo1c0mjkuZz0y2nUACkTLpTVrx
   /GVXbV0F7Xac9ANYJ0duYc2aJCSCGhMhHCMN9HO9vqvWO4/BjLBREkklP
   lvsag0fMzrQELbfIBWAlaNnXylyHscP4+e0zVqB3RQMz5Mi5EmN8b0mbY
   Ya8+UHYWAlr+ONkZ7hAW8YRvmLD/h3uLa4hD0VdYt/qgkabgy4MNcZGC3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="302758297"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="302758297"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 02:35:25 -0700
X-IronPort-AV: E=McAfee;i="6500,9779,10484"; a="622288758"
X-IronPort-AV: E=Sophos;i="5.93,354,1654585200"; 
   d="scan'208";a="622288758"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.237.140.95])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Sep 2022 02:35:23 -0700
Date:   Thu, 29 Sep 2022 11:35:21 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     Nigel Croxon <ncroxon@redhat.com>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        mariusz.tkaczyk@intel.com, kinga.tanska@intel.com
Subject: Re: [PATCH] mdadm reshape hangs on external grow chunk
Message-ID: <20220929113521.000012af@intel.linux.com>
In-Reply-To: <20220923142635.470305-1-ncroxon@redhat.com>
References: <20220923142635.470305-1-ncroxon@redhat.com>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, 23 Sep 2022 10:26:35 -0400
Nigel Croxon <ncroxon@redhat.com> wrote:

> After creating a raid array on top of a imsm container. Try to
> grow the chunk size and the reshape will hang with zero progress.
> The reason is the computation of sync_max_to_set value:
> if (before_data_disks <= data_disks)
>         sync_max_to_set = sra->reshape_progress / data_disks;
>     else
>         sync_max_to_set = (sra->component_size * data_disks
>                        - sra->reshape_progress) / data_disks;
> 
> Can produce a zero result. Which is then used to set the maximum
> sync value, causing zero progress to the reshape.  The change is to
> test if the sync_max_to_set value is zero. And if so, set the sysfs
> sync_max to "max".
> 
> Steps to Reproduce:
> 1. Create a container and RAID0 array
> mdadm -CR /dev/md/imsm -e imsm -n2 /dev/nvme0n1 /dev/nvme1n1
> mdadm -CR  /dev/md/vol -l0 --chunk=16 -n2 /dev/nvme0n1 /dev/nvme1n1
> 2. Wait for resync
> 3. Try to grow the chunk size
> mdadm --grow /dev/md/vol --chunk=256
> 
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
>  Grow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Grow.c b/Grow.c
> index 0f07a894..6c5021bc 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -943,7 +943,7 @@ int start_reshape(struct mdinfo *sra, int
> already_running, if (!already_running)
>  		sysfs_set_num(sra, NULL, "sync_min",
> sync_max_to_set); 
> -        if (st->ss->external)
> +        if (sync_max_to_set)
>  		err = err ?: sysfs_set_num(sra, NULL, "sync_max",
> sync_max_to_set); else
>  		err = err ?: sysfs_set_str(sra, NULL, "sync_max",
> "max");

Hi Nigel,

I was trying to retest with your patch but still have the defect. I
analyzed it and found another reason, which causes this defect. In
validate_geometry_imsm function freesize and super is being checked and
return 1 if any of those is NULL. In my opinion 0 shall be returned
here, because it is an error and reshape should be stopped here. I will
prepare proper patch and send to review immediately.

King regards,
Kinga Tanska
