Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A56F0C00140
	for <linux-raid@archiver.kernel.org>; Thu, 18 Aug 2022 08:19:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiHRIT5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 18 Aug 2022 04:19:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232816AbiHRIT4 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 18 Aug 2022 04:19:56 -0400
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D0327AC25
        for <linux-raid@vger.kernel.org>; Thu, 18 Aug 2022 01:19:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660810795; x=1692346795;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=47B4wXIenAgnwAEJddfidgrxbcJwAo5zARneib8VeqQ=;
  b=MEMl3KSnSOK89U5Q6Lbr9SAXXL6gCyjDPiKLgCEy63dG6fS/xO+MaX5M
   FiDcwVl6EVpFKGbC3YbTXX9asya6p5oETXYHo8s75Bdj0K7LmfGfV+C7e
   Shj3Fp1k7DdRq5X4RiKfTWcqCqiwX8Bz4D173x1g7uCBVH2StaK0yg3t/
   KToXVe7HONBsVTBIQsmctR1iUn84hSJ5MlxHaMyb732ANtAkq1LMMqnDi
   CeKC/WywXI8tKiLjGUMxfen/y1xa/to9viJ6xkh4ST1sZqBc+ZJVBlOvn
   9egSCXXnTlcxI0ybL6a+WlizGYXKGudyX60+gXOnwmsg99R7JRku1ccx+
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10442"; a="293491084"
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="293491084"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 01:19:55 -0700
X-IronPort-AV: E=Sophos;i="5.93,245,1654585200"; 
   d="scan'208";a="668002810"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.252.40.116])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Aug 2022 01:19:53 -0700
Date:   Thu, 18 Aug 2022 10:19:48 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     "David F." <df7729@gmail.com>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: Timeout waiting for /dev/md/imsm0 ?
Message-ID: <20220818101948.00007fda@linux.intel.com>
In-Reply-To: <CAGRSmLvKtjtDtrmv1pp7YEdxOGRYnRXs0WaFS_y0HJxX3NYSaA@mail.gmail.com>
References: <CAGRSmLvY48qanq6qdi40LE_50xT9ZzUq456KntesLSrxt8AmBw@mail.gmail.com>
        <20220816082344.00001dbf@linux.intel.com>
        <CAGRSmLvKtjtDtrmv1pp7YEdxOGRYnRXs0WaFS_y0HJxX3NYSaA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 16 Aug 2022 19:04:02 -0700
"David F." <df7729@gmail.com> wrote:

> What rules should be used?   I don't see a /dev/md directory, I
> created one, stopped the raid (all the /dev/md* devices went away)
> and tried to start the raid, same thing and only /dev/md127 gets
> created, nothing in /dev/md/ directory and none of the md126 devices ?
>  You then get the timeout.

https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/udev-md-raid-arrays.rules#n24
ENV{DEVTYPE}=="disk", ENV{MD_DEVNAME}=="?*", SYMLINK+="md/$env{MD_DEVNAME}"

The clue here is:
IMPORT{program}="BINDIR/mdadm --detail --no-devices --export $devnode"
where property MD_DEVNAME is generated. It is obtained from "/var/run/mdadm/map"
file and generally is same as name property in metadata.

It is all in udev-md-raid-arrays.rules

Mariusz
> 
> On Tue, Aug 16, 2022 at 12:03 AM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > Hi David,
> > On Mon, 15 Aug 2022 15:28:08 -0700
> > "David F." <df7729@gmail.com> wrote:
> >  
> > > I'm not sure if this list is getting the messages but to summarize, if
> > > I pass the 5.15.x kernel parameter "nomdraid" to skip udev from doing
> > > anything with the RAID and then run:
> > >
> > > mdadm - v4.1 - 2018-10-01
> > >
> > > mdadm --examine --scan to create the /etc/mdadm/mdadm.conf file with:
> > >
> > > ARRAY metadata=imsm UUID=788c3635:2e37de4b:87d08323:987f57e5
> > > ARRAY /dev/md/TestRAID container=788c3635:2e37de4b:87d08323:987f57e5
> > > member=0 UUID=835de710:3d35bfb1:d159af46:6570f120
> > >
> > > Then run:
> > >
> > > mdadm --assemble --scan --no-degraded -v
> > >
> > > I get:
> > >
> > > mdadm: looking for devices for further assembly
> > > mdadm: no RAID superblock on /dev/sdc1
> > > mdadm: /dev/sdc is not attached to Intel(R) RAID controller.
> > > mdadm: No OROM/EFI properties for /dev/sdc
> > > mdadm: no RAID superblock on /dev/sdc
> > > mdadm: no RAID superblock on /dev/sda5
> > > mdadm: no RAID superblock on /dev/sda3
> > > mdadm: no RAID superblock on /dev/sda2
> > > mdadm: no RAID superblock on /dev/sda1
> > > mdadm: /dev/sdb is identified as a member of /dev/md/imsm0, slot 1.
> > > mdadm: /dev/sda is identified as a member of /dev/md/imsm0, slot 0.
> > > mdadm: added /dev/sdb to /dev/md/imsm0 as 1
> > > mdadm: added /dev/sda to /dev/md/imsm0 as 0
> > > mdadm: Container /dev/md/imsm0 has been assembled with 2 drives
> > > mdadm: timeout waiting for /dev/md/imsm0
> > > mdadm: looking for devices for /dev/md/TestRAID
> > > mdadm: cannot open device /dev/md/imsm0: No such file or directory
> > > mdadm: Cannot assemble mbr metadata on /dev/sdc1
> > > mdadm: Cannot assemble mbr metadata on /dev/sdc
> > > mdadm: /dev/sdb has wrong uuid.
> > > mdadm: Cannot assemble mbr metadata on /dev/sda5
> > > mdadm: Cannot assemble mbr metadata on /dev/sda3
> > > mdadm: Cannot assemble mbr metadata on /dev/sda2
> > > mdadm: no recogniseable superblock on /dev/sda1
> > > mdadm: /dev/sda has wrong uuid.
> > > mdadm: looking for devices for /dev/md/TestRAID
> > > mdadm: cannot open device /dev/md/imsm0: No such file or directory
> > > mdadm: Cannot assemble mbr metadata on /dev/sdc1
> > > mdadm: Cannot assemble mbr metadata on /dev/sdc
> > > mdadm: /dev/sdb has wrong uuid.
> > > mdadm: Cannot assemble mbr metadata on /dev/sda5
> > > mdadm: Cannot assemble mbr metadata on /dev/sda3
> > > mdadm: Cannot assemble mbr metadata on /dev/sda2
> > > mdadm: no recogniseable superblock on /dev/sda1
> > > mdadm: /dev/sda has wrong uuid.
> > >
> > > If I let UDEV start it and then stop the RAID with:
> > >
> > > mdadm --stop --scan  
> >
> > No, You didn't ask udev. You asked mdadm to do clean up. It will trigger
> > "remove" event at some point so then udev will be involved.  
> > >
> > > (which does stop it) then try to start again using the above command,
> > > I still get the timeout.
> > >
> > > This was working fine with older version 5.10.x kernel with the
> > > following differences:
> > >
> > >    mdadm v4.1 - 2018-10-01 (but from a different build - debian
> > > instead of devuan)
> > >    kmod as an older version
> > >    udev (eudev) was built against the older kmod.
> > >    all the various shared libraries and utilities were moved up to
> > > versions with Devuan Chimaera
> > >    rules updated (although I tried with the old rules too, no difference)
> > >
> > > Any idea on what is wrong?  Any tricks to have it output more
> > > information to diagnose what is happening?   The /dev/md127 device
> > > gets created, the actual devices never get created, even if you wait.  
> >
> > The error you mentioned in subject is caused by udev. This error means that
> > udev failed to create link in /dev/md/ directory.
> > If you are not referencing to this link, it can be ignored. We are expecting
> > that udev will create the link and we are waiting for it as some point in
> > mdadm.
> >
> > Thanks,
> > Mariusz  

