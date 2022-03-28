Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49108C433F5
	for <linux-raid@archiver.kernel.org>; Mon, 28 Mar 2022 02:05:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237440AbiC1CGz (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 27 Mar 2022 22:06:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230063AbiC1CGx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 27 Mar 2022 22:06:53 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D512DEFF
        for <linux-raid@vger.kernel.org>; Sun, 27 Mar 2022 19:05:14 -0700 (PDT)
Received: from merlin by mail1.merlins.org with local (Exim 4.94.2 #2)
        id 1nYekq-0003GH-MZ by authid <merlin>; Sun, 27 Mar 2022 19:05:12 -0700
Date:   Sun, 27 Mar 2022 19:05:12 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     d tbsky <tbskyd@gmail.com>
Cc:     list Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
Message-ID: <20220328020512.GP4113@merlins.org>
References: <20220318030855.GV3131742@merlins.org>
 <CAC6SzHKFga59KpzhRhE-sz3K5z+=LUXfyxSB14KaOj7DCxCj-Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAC6SzHKFga59KpzhRhE-sz3K5z+=LUXfyxSB14KaOj7DCxCj-Q@mail.gmail.com>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Mar 27, 2022 at 04:40:38PM +0800, d tbsky wrote:
> Marc MERLIN <marc@merlins.org>
> > New drive is 4 sectors shorter, so I assume I can't use it as a replacement in my md5
> > array because it's 4 sectors too short, or does swraid5 not need the last few sectors
> > of a drive?
> 
>     4 sectors shorter are common for external hard drives (sold from
> seagate,toshiba,etc). if you attach the drive to internal sata port or
> normal usb enclosure(not sold from disk vendors),you will get back
> normal disk size. so maybe you want to check what connect to your
> disk.

OMG, using a USB adapter eats 4 setors? I had no idea...
Sure enough, I did connect the drives via USB for diagnosis since I had
run out of sata ports.

Thanks for the hint.
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/  
