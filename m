Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDA6C64ED6
	for <linux-raid@archiver.kernel.org>; Wed,  1 Mar 2023 08:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjCAIzm (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 1 Mar 2023 03:55:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCAIzl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 1 Mar 2023 03:55:41 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8060F2384C
        for <linux-raid@vger.kernel.org>; Wed,  1 Mar 2023 00:55:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677660940; x=1709196940;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=F9zPvRuhr5oYyssZe/8bIHAgitU/fxu7Ycg9KKcJyWM=;
  b=PIEtFPMLClHpbxNXPfcQphhy4Y8dwOW+Kt5Wbcevo8mWpILQONJ6oOqY
   oUTYlGniqs/clXW2fCiecViq1+gT0zMHSCGzQgPtsQP1jNEwEihKtgEK8
   7VgFmFm17rua+uDne6uHrfNGA3l/jCq/Nj89uT6Zshc015GM/M1MQzitl
   pvDB0I0TOammVxxtifJ6IQ8/6GS++7mQzADLNQp+Qra5EJ7Qmmqb02nNu
   Yma8XkDFPipZDz5ytVfsP+eeZ6CmnPOyCbkXXnfINb8lGZBVSXwq4/ddD
   35NvPZb3Gf6U+L/tYykOOvtjCX3rOgRkuGYhEBNXIi+cN1CfYPmRcWMaJ
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="318158704"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="318158704"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 00:55:39 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10635"; a="743340279"
X-IronPort-AV: E=Sophos;i="5.98,224,1673942400"; 
   d="scan'208";a="743340279"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.57.49])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2023 00:55:33 -0800
Date:   Wed, 1 Mar 2023 09:55:28 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org,
        Martin Wilck <martin.wilck@suse.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@intel.com>
Subject: Re: [PATCH 0/6] Assorted patches relating to mdmon
Message-ID: <20230301095528.00000bb9@linux.intel.com>
In-Reply-To: <167745586347.16565.4353184078424535907.stgit@noble.brown>
References: <167745586347.16565.4353184078424535907.stgit@noble.brown>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 27 Feb 2023 11:13:07 +1100
NeilBrown <neilb@suse.de> wrote:

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

Hi Jes,
The problem descried by Neil is critical for IMSM. I will test the patchset
ASAP.
Additionally, it resolves "KillMode=none" problem so we will be able to finally
drop it.

I will be back with results soon.

Thanks,
Mariusz
