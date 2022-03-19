Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 66D38C433EF
	for <linux-raid@archiver.kernel.org>; Sat, 19 Mar 2022 22:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244266AbiCSWEJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 19 Mar 2022 18:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238128AbiCSWEH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 19 Mar 2022 18:04:07 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82CA8261305
        for <linux-raid@vger.kernel.org>; Sat, 19 Mar 2022 15:02:45 -0700 (PDT)
Received: from c-24-5-124-255.hsd1.ca.comcast.net ([24.5.124.255]:48572 helo=sauron.svh.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2 #2)
        id 1nVh9h-0006iX-20 by authid <merlins.org> with srv_auth_plain; Sat, 19 Mar 2022 15:02:37 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.92)
        (envelope-from <marc@merlins.org>)
        id 1nVh9g-00D7jj-Rx; Sat, 19 Mar 2022 15:02:36 -0700
Date:   Sat, 19 Mar 2022 15:02:36 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Wols Lists <antlists@youngman.org.uk>,
        Roman Mamedov <rm@romanrm.net>
Cc:     Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
Message-ID: <20220319220236.GZ3131742@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220319154559.09f649e4@nvm>
 <01d2c8c5-46ea-f69e-e285-da0abe6cd594@youngman.org.uk>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
X-SA-Exim-Connect-IP: 24.5.124.255
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Mar 19, 2022 at 10:14:16AM +0000, Wols Lists wrote:
> mdadm has absolutely no trouble with that at all. All it cares about is if
> something is a block device - if it finds an mdadm signature at the start of
> a block device it will use it.
 
I think I remember back in the day that auto joining of raid1 arrays by
the kernel at boot time so that you could then mount the filesystem as
root, only worked if it was on partitions. That was a long time ago
though.

On Sat, Mar 19, 2022 at 03:45:59PM +0500, Roman Mamedov wrote:
> As for...
> 
> > >    8      128 5860522584 sdi
> > >    8      129 5860521543 sdi1
> > >
> > >    8      160 5860522580 sdk
> > >    8      161 5860521536 sdk1
> 
> Which tool returns this output?
 
cat /proc/partitions

> What do you get for 
> 
>   blockdev --getsize64 /dev/sdi
>   blockdev --getsize64 /dev/sdk

gargamel:/dev# blockdev --getsize64 /dev/sdi
6001175126016
gargamel:/dev# blockdev --getsize64 /dev/sdk
6001175121920

> If this returns the same size for both, wipe a few first MB the new drive with
> zeroes using dd, and try a different partitioning tool.

Good suggestion, but the drives indeed seem different, very slightly so.
Thankfully not enough to matter for my mdadm array it seems, so that's
good news

Thanks to all for the help
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
