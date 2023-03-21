Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5651C6FD1C
	for <linux-raid@archiver.kernel.org>; Tue, 21 Mar 2023 02:01:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjCUCBO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 22:01:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbjCUCBG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 22:01:06 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43015222C7
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 19:01:02 -0700 (PDT)
Received: from [170.75.143.55] (port=63264 helo=sauron.svh.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2 #2)
        id 1peQP1-0008WD-5M by authid <merlins.org> with srv_auth_plain; Mon, 20 Mar 2023 19:01:02 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.92)
        (envelope-from <marc@merlins.org>)
        id 1peRJ7-00FbLo-Vb; Mon, 20 Mar 2023 19:01:01 -0700
Date:   Mon, 20 Mar 2023 19:01:01 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: mdadm --detail works, mdadm --stop says "does not appear to be
 an md device"
Message-ID: <20230321020101.GC4049235@merlins.org>
References: <20230317173810.GW4049235@merlins.org>
 <20230320153639.0000238d@linux.intel.com>
 <20230320145035.GW21713@merlins.org>
 <20230320161659.00001c48@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320161659.00001c48@linux.intel.com>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
X-Broken-Reverse-DNS: no host name for IP address 170.75.143.55
X-SA-Exim-Connect-IP: 170.75.143.55
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Mar 20, 2023 at 04:16:59PM +0100, Mariusz Tkaczyk wrote:
> On Mon, 20 Mar 2023 07:50:35 -0700
> Marc MERLIN <marc@merlins.org> wrote:
> 
> > On Mon, Mar 20, 2023 at 03:36:39PM +0100, Mariusz Tkaczyk wrote:
> > > Hi,
> > > mdadm is unable to complete this task because it cannot ensure that it is
> > > safe to stop the array. It cannot open the array with O_EXCL.
> > > If it is mounted then it may hang if filesystem needs to flush some data.  
> >  
> > Thanks for the reply. The array was not mounted, that said, given that
> > it was fully down, there wasn't a way to flush the data if it had been
> > (cable problem to an enclosure, all the drives disappeared at once)
> > 
> > > Please, try umount the array if it mounted somewhere and then try:
> > > 
> > > # echo inactive > /sys/block/md6/md/array_state
> > > # echo clear > /sys/block/md6/md/array_state  
> > 
> > I can try this next time (already had to reboot), thanks.
> > 
> > That said, mdadm should output a better message in this case
> > > > mdadm: /dev/md6 does not appear to be an md device  
> > is clearly wrong 
> > 
> > Is that something easy to fix/improve?
> 
> Oh, sorry my bad, please see the code:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdopen.c#n472
> 
> We are failing to "understand" the array:
> https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/util.c#n229
> It has nothing to do with open and O_EXCL. I didn't dig into to determine why.
> 
> Anyway, now error seems to be reasonable but maybe we should be able to tract
> this array as valid? I requires more work and analysis so it is not simple fix.

You are definitely more knowledgeable about this than I am.
All I can say is that the array was down, not mounted, and I couldn't
stop it without a reboot, and that's a problem.

Any way to force stop in a case like this, would be quite welcome :)

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
