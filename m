Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88732C001DF
	for <linux-raid@archiver.kernel.org>; Thu,  3 Aug 2023 07:12:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233561AbjHCHMZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Aug 2023 03:12:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232800AbjHCHMX (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Aug 2023 03:12:23 -0400
Received: from mgamail.intel.com (unknown [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08B1FF
        for <linux-raid@vger.kernel.org>; Thu,  3 Aug 2023 00:12:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691046741; x=1722582741;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=cVhbgifOYRvJdZ6887ErsS0DQ/nSEKCyL6vY0ylhvDM=;
  b=kqVAeXO6KJUUAbh+ete5AMABbl6fFY/yMDOiUBukxninZ7SaN4bdUfOz
   IB5CzaelHACtJu2quK+QiE6dCZlCgN/IGXYUM+MApoWUK3GYQhIaP6CLc
   V6yetObhXrBj2TSd6K5klvHwOZ4dfHE9B+4MWqoSOYsfbX6Fk14gvDyD7
   Ps/ggUBx7xbF/FY1yk+OGoXbLBl8xjSjiS1A0NVUaaoUoKCToG2x3XnQG
   Uuhc/hLRBz6wuH9JY/1gUtUidjV/ndpPYf6nyl7X1x6w8Yi5aWG2B8H+P
   DdPT6OQJ6ZRpJ8oPUmGxpcLxjM0WZ2wt79xfMJL4w3zLlZh9rzQGOwe00
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10790"; a="372525613"
X-IronPort-AV: E=Sophos;i="6.01,251,1684825200"; 
   d="scan'208";a="372525613"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:04:35 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.01,202,1684825200"; 
   d="scan'208";a="872806805"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.159.97])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Aug 2023 00:04:36 -0700
Date:   Thu, 3 Aug 2023 09:04:29 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: The imsm regression tests fail
Message-ID: <20230803090429.0000046a@linux.intel.com>
In-Reply-To: <CALTww2_FrkmafTkObCX4W1SXVeJiy45h7TR68iHUMpzfAOseHQ@mail.gmail.com>
References: <CALTww2_FrkmafTkObCX4W1SXVeJiy45h7TR68iHUMpzfAOseHQ@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, 3 Aug 2023 11:27:57 +0800
Xiao Ni <xni@redhat.com> wrote:

> Hi Mariusz
> 
> Now most imsm regression tests fail.
> 
> +++ /home/mdadm/mdadm --quiet --create --run /dev/md/vol0 --auto=md
> --level=0 --size=5120 --chunk=64 --raid-disks=3 /dev/loop0 /dev/loop1
> /dev/loop2 --auto=yes
> +++ rv=0
> +++ case $* in
> +++ cat /var/tmp/stderr
> mdadm: timeout waiting for /dev/md/vol0
> 
> +++ echo '**Fatal**: Array member /dev/md/vol0 not found'
> **Fatal**: Array member /dev/md/vol0 not found
> 
> Could you have a look at this problem?
> 
> Best Regards
> Xiao
> 

Hi Xiao,
Please provide (I guess it is md126):
# mdadm -D --export /dev/md126

If there is no MD_DEVNAME property then udev has no content to make the link.

Do you have this one applied?
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=ef6236da232e968dcf08b486178cd20d5ea97e2a

Thanks,
Mariusz
