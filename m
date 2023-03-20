Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50208C6FD1D
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 14:53:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231796AbjCTOxX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 10:53:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231717AbjCTOww (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 10:52:52 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C50983C4
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 07:50:54 -0700 (PDT)
Received: from merlin by mail1.merlins.org with local (Exim 4.94.2 #2)
        id 1peGqJ-0003Eb-9g by authid <merlin>; Mon, 20 Mar 2023 07:50:35 -0700
Date:   Mon, 20 Mar 2023 07:50:35 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: mdadm --detail works, mdadm --stop says "does not appear to be
 an md device"
Message-ID: <20230320145035.GW21713@merlins.org>
References: <20230317173810.GW4049235@merlins.org>
 <20230320153639.0000238d@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320153639.0000238d@linux.intel.com>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
User-Agent: Mutt/1.10.1 (2018-07-13)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Mar 20, 2023 at 03:36:39PM +0100, Mariusz Tkaczyk wrote:
> Hi,
> mdadm is unable to complete this task because it cannot ensure that it is safe
> to stop the array. It cannot open the array with O_EXCL.
> If it is mounted then it may hang if filesystem needs to flush some data.
 
Thanks for the reply. The array was not mounted, that said, given that
it was fully down, there wasn't a way to flush the data if it had been
(cable problem to an enclosure, all the drives disappeared at once)

> Please, try umount the array if it mounted somewhere and then try:
> 
> # echo inactive > /sys/block/md6/md/array_state
> # echo clear > /sys/block/md6/md/array_state

I can try this next time (already had to reboot), thanks.

That said, mdadm should output a better message in this case
> > mdadm: /dev/md6 does not appear to be an md device
is clearly wrong 

Is that something easy to fix/improve?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/  
