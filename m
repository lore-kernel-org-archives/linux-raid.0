Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDF2DC43217
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 09:42:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232902AbiBIJmO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 04:42:14 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:52982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231789AbiBIJmL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 04:42:11 -0500
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42F37C02B5C0
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 01:42:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644399729; x=1675935729;
  h=date:from:to:cc:subject:message-id:mime-version:
   content-transfer-encoding;
  bh=LVmUfe5DYqjgI9/YcZwzU10Qt1uiZNaj8OswbmgGyk4=;
  b=XoRlOUzzRqSed2h7aiyaASiAt5R+5MtI/S0bso4xSk5x4p8xvPvz5yJp
   CneJxw7+QwTOZ1VVICi/m7xASmVU98EjgE1Dy/yfo7qukWLA1mgdXmHSb
   YjrKh5tf5e4CameBfjV5OiVlixqdeJFehU5mgLyQCz4bihghBwWa4ulsx
   Ky1AbYmvn1fYMexJ5M9DHhdfe5rC+IgQgUw9qBlgtUlVSIoJSIOrunqe7
   DRATieeA3tVBFMO/D5QBMsT0XwImTO495fzgJdvy1AqmUApiGv5M7ZnFp
   xpYRbILiIYUYdV88pdZqwu1l7FmMDCGYxkUpYYt+kMiLZUZT1ARReyV6Y
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10252"; a="248926992"
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="248926992"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 01:40:53 -0800
X-IronPort-AV: E=Sophos;i="5.88,355,1635231600"; 
   d="scan'208";a="541022759"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.31.96])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2022 01:40:51 -0800
Date:   Wed, 9 Feb 2022 10:40:46 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Song Liu <song@kernel.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: fail_last_dev and FailFast/LastDev flag incompatibility
Message-ID: <20220209104046.00004427@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi All,
During my work under failed arrays handling[1] improvements, I
discovered potential issue with "failfast" and metadata writes. In
commit message[2] Neil mentioned that:
"If we get a failure writing metadata but the device doesn't
fail, it must be the last device so we re-write without
FAILFAST".

Obviously, this is not true for RAID456 (again)[1] but it is also not
true for RAID1 and RAID10 with "fail_las_dev"[3] functionality enabled.

I did a quick check and can see that setter for "LastDev" flag is
called if "Faulty" on device is not set. I proposed some changes in the
area in my patchset[4] but after discussion we decided to drop changes
here. Current approach is not correct for all branches, so my proposal
is to change:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7b024912f1eb..3daec14ef6b2 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -931,7 +931,7 @@ static void super_written(struct bio *bio)
                pr_err("md: %s gets error=%d\n", __func__,
                       blk_status_to_errno(bio->bi_status));
                md_error(mddev, rdev);
-               if (!test_bit(Faulty, &rdev->flags)
+               if (test_bit(MD_BROKEN, mddev->flag)
                    && (bio->bi_opf & MD_FAILFAST)) {
                        set_bit(MD_SB_NEED_REWRITE, &mddev->sb_flags);
                        set_bit(LastDev, &rdev->flags);


It will force "LastDev" to be set on every metadata rewrite if mddevice
is known to be failed.
Do you have any other suggestions?

+ Guoqing - author of fail_last_dev.
+ Xiao - you are familiarized with FailFast so please take a look.

[1]https://lore.kernel.org/linux-raid/CAPhsuW54_9CTR6sh7mnQ6O77F2HNArLHGWHYsUdbNGy7pXgipQ@mail.gmail.com/T/#m8cf7c57429b6fd332220157186151900ce23865d
[2]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=46533ff7fefb7e9e3539494f5873b00091caa8eb
[3]https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git/commit/?id=9a567843f7ce
[4]https://lore.kernel.org/linux-raid/CAPhsuW5bV+Bz=Od9jomNHoedaEMFAXymN11J80G62GVPwSp41g@mail.gmail.com/

Thanks,
Mariusz
