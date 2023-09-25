Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3D06CE7A81
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 09:44:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbjIYJop (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 05:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230108AbjIYJom (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 05:44:42 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D343D3
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 02:44:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695635075; x=1727171075;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MlT9vv465vetFjapKIBQWCMGmlGlXPMjpFXuSOAK7dI=;
  b=gq692hnEYuJHbHXv8/DfAVT59g1ETokbevefj3w7pnSfDRru9T1vhiDA
   sEvmVFK2bT8eRyXqY1UTFFkzCKgGLOxVDyWhwPufIYSrIYFqQEOfQr7vd
   AEgVFREWeZwMQprkdZ82lRrU6nRRAjZuG3OqDhAHQH0OUFm8q8MVy8Lir
   jQJlP5oeNA5LpQJi2LvVnovQqtKBhsbln886t/fZ7P++rGAdct42Vwowj
   xDDDsE7I21HOCGecGBILZ3xowNrZhZN+XeD8Y8MHG4Sk7k2avErGBaO2O
   /4xbG5nb16v+xs/2V8ggNHoihq/J4Pjxp/WbUWRnMYq5+YifBFOAy60nt
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="445321997"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="445321997"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 02:44:26 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="697920871"
X-IronPort-AV: E=Sophos;i="6.03,174,1694761200"; 
   d="scan'208";a="697920871"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.90])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 02:44:25 -0700
Date:   Mon, 25 Sep 2023 11:44:20 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Joel Parthemore <joel@parthemores.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: request for help on IMSM-metadata RAID-5 array
Message-ID: <20230925114420.0000302f@linux.intel.com>
In-Reply-To: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 23 Sep 2023 12:54:52 +0200
Joel Parthemore <joel@parthemores.com> wrote:

> Apologies in advance for the long email, but I wanted to include 
> everything that is asked for on the "asking for help" page associated 
> with the mailing list. The output from some of the requested commands is 
> pretty lengthy.
> 
> My home directory is on a three-disk RAID-5 array that, for whatever 
> reason (it seemed like a good idea at the time?), I built using the 
> hooks from the UEFI BIOS (or so I understand what I did). That is to 
> say, it's a "real" software-based RAID array in Linux that's built on a 
> "fake" RAID array in the UEFI BIOS. Mostly nothing important is stored 
> on the /home partition, but I forgot to back up a few important things 
> that are (or, at least, were). So I'd like to get the RAID array back if 
> I can, or know if I can't; and I will be extremely grateful to anyone 
> who can tell me one way or the other.
> 
> All was well for some number of years until a few days ago. After I 
> installed the latest KDE updates, the RAID array would lock up entirely 
> when I tried to log in to a new KDE Wayland session. It all came down to 
> one process that refused to die, running startplasma-wayland. Because 
> the process refused to die, the RAID array could not be stopped cleanly 
> and rebooting the computer therefore caused the RAID array to go out of 
> sync. After that, any attempt whatsoever to access the RAID array would 
> cause the RAID array to lock up again.
> 
> The first few times this happened, I was able to start the computer 
> without starting the RAID array, reassemble the RAID array using the 
> command mdadm --assemble --run --force /dev/md126 /dev/sda /dev/sde 
> /dev/sdc and have it working fine -- I could fix any filestore problems 
> with e2fsck, mount /home, log in to my home directory, do pretty much 
> whatever I wanted -- until I tried logging into a new KDE Wayland 
> session again. This happened several times while I was trying to 
> troubleshoot the problem with startplasma-wayland.
> 
> Unfortunately, one time this didn't work. I was still able to start the 
> computer without starting the RAID array, reassemble it and reboot with 
> the RAID array looking seemingly okay (according to mdadm -D) BUT this 
> time, any attempt to access the RAID array or even just stop the array 
> (mdadm --stop /dev/md126, mdadm --stop /dev/md127) once it was started 
> would cause the RAID array to lock up. That means (I think) that I can't 
> create an image of the array contents using dd, which is what -- of 
> course -- I should have done in the first place. (I could assemble the 
> RAID array read-only, but the RAID array is out of sync because it 
> didn't shut down properly.)
> 
> I'm guessing that the contents of the filestore on the RAID array are 
> probably still there. Does anyone have suggestions on getting the RAID 
> array working properly again and accessing them? I have avoided doing 
> anything further myself because, of course, if the contents of the 
> filestore are still there, I don't want to do anything to jeopardize 
> them. You may tell me that I've done too much already. :-)

Hi Joel,
sorry for late response, I see that you were able to recover the data!
I was few days off.

I think that metadata manager is down or broken from some reasons.
#systemctl status mdmon@md127.service

I you will get the problem again, please try (but do not abuse- use it as last
resort!!):
#systemctl restart mdmon@md127.service

We know that there was a change in systemd and it causes that our userspace
metadata manager was not responsible because it couldn't be restarted after
switch root. Issue is fixed in upstream:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=723d1df4946eb40337bf494f9b2549500c1399b2

I didn't read whole thread but issue matches for me.
Hopefully, you will find it useful.

Thanks,
Mariusz
