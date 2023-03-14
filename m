Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4845AC6FD1C
	for <linux-raid@archiver.kernel.org>; Tue, 14 Mar 2023 08:33:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229869AbjCNIdp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 14 Mar 2023 04:33:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbjCNIdm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 14 Mar 2023 04:33:42 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FC13B645
        for <linux-raid@vger.kernel.org>; Tue, 14 Mar 2023 01:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678782815; x=1710318815;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2EwdwxPLXyyWkMaOVDIuqUBMnuMdal6fVhhQq7Dch+k=;
  b=I0LRR4T1CWPN6SKAscp3P+u5CNmok/h5EXM5y8heBEZ3YEXw7JzMOrBe
   SOYgyiDHoT50/b1QPKJ/8hp1VHsprq6ig9r7aBDDEI+jO7CeOqUUJBO/r
   ozvGhOE2P+Ch41yVlKASfONPFvuye98yF91USE24zWFVHlnKd6+mcCQE1
   lvUN84eWIhgEsz/LYO5yJBXWBPX6px+lO72OQiDfYM0BNYPn61M0w9Wqi
   k1PAutl634AFXq2RiRMsYGEQtuYAujMLG4n93puZdN1+pMy2yy04Fgoi9
   jjcUx2Aqb3LJj1LDYsZpAnUH/tlLl88FPjfnAbmJoNV0Pu2b4kkTkHyIq
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="423632923"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="423632923"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:33:34 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10648"; a="789270077"
X-IronPort-AV: E=Sophos;i="5.98,259,1673942400"; 
   d="scan'208";a="789270077"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.32.139])
  by fmsmga002-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2023 01:33:32 -0700
Date:   Tue, 14 Mar 2023 09:33:27 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
        Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: [PATCH 0/6 v2] Assorted patches relating to mdmon
Message-ID: <20230314093327.0000203e@linux.intel.com>
In-Reply-To: <167867886675.11443.523512156999408649.stgit@noble.brown>
References: <167867886675.11443.523512156999408649.stgit@noble.brown>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 13 Mar 2023 14:42:58 +1100
NeilBrown <neilb@suse.de> wrote:

> This series is a minor revision of the previous series with the same
> name.
> It includes the important bugfix identified by Mariusz and a few minor
> improvements suggested by Paul.
> 
> Original comment:
> 
> mdmon is a root-storage daemon is the sense defined by systemd
> documentation, but it does not follow the practice that systemd
> recommends.  Specifically it is run from the root filesystem when
> possible.  The instance started in the initrd hands-over to a root-fs
> based instance, which then hands-over to an initrd-based instance
> started by dracut at shutdown.
> 
> Part of the reason that we ignore systemd advise is that mdmon needs
> access to the filesystem - specifically /dev and /sys - which is not
> available in the initrd context after switchroot.  We could possibly
> change mdmon to work in the systemd-preferred way by splitting mdmon
> into two processes instead of just having 2 threads.  The "monitor"
> process could running entirely in the initrd context, the "manager"
> process could safely run in the root-fs context, passing newly opened
> file descriptors to the monitor over a unix-domain socket.
> 
> But we aren't there yet and may never be.
> 
> For now, mdmon doesn't work correctly.  There is no mechanism to ensure
> a new instance starts after switchroot.  Until recently the initrd
> instance of the systemd mdmon unit would be stopped at switchroot time
> because udev would temporarily forget about md devices.  This would
> allow the "udevadm trigger" process to start a new instance.  udev was
> recently fixed:
> 
> Commit: 7ec624147a41 ("udevadm: cleanup-db: don't delete information for kept
> db entries")
> 
> so now the attempt to start mdmon via "udevadm trigger" does nothing as
> mdmon already has an active unit.
> 
> The net result is that mdmon continues running in the initrd mount
> namespace and so cannot access new devices.  Adding a device to a root
> md array that depends on mdmon will no longer work.
> 
> We want the initrd instance of mdmon to continue running until the
> root-fs based instance starts, and that really requires we have two
> different systemd units.  This series achieves this in the final patch by
> using a different instance name inside or initrd and outside.
> "initrd-mdfoo" and "mdfoo".
> 
> Other patches in the series are mostly clean-ups and minor improvements
> in related code.
> 
> NeilBrown
> 
> 
> 

Hi Jes,
Sorry for the delay. We found one grow related problem and needed to determine
if it is the patchset related. It seems not, so for all patches:

Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Thanks to Neil we can revert "revert of Remove KillMode" patch (hopefully)
forever this time. Please apply those paches, then I will send a revert.

Thanks,
Mariusz
