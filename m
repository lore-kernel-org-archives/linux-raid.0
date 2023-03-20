Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCB2BC6FD1D
	for <linux-raid@archiver.kernel.org>; Mon, 20 Mar 2023 15:25:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232580AbjCTPZE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Mar 2023 11:25:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232672AbjCTPYl (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Mar 2023 11:24:41 -0400
Received: from mga11.intel.com (mga11.intel.com [192.55.52.93])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85C236686
        for <linux-raid@vger.kernel.org>; Mon, 20 Mar 2023 08:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679325469; x=1710861469;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=r8XRZFEpMbrHDQtSs6P1Vj3hRXnqdqMyID3RKkI4eVY=;
  b=IdY3DsaNeAxlORiKIyPAM4oxUiqhTiwKmQSyRQiPL6jPnPo4Nr5WSUvV
   GoLyvLsFBM+Gv+IvRG3nm5V+eAnoIwkXWoGekG5lTbvYNKcuG2mZGX4RP
   m/ruANC+sptRR5FbqJnvvsTBMhJccWwwblVi6S/nazbDwtQa8Qw3Zo3Bq
   v4NaroC9H4M0NmKrZ+rSp6bUfdbG7i+uAyoKMHgo41Ws+JcAqif4jEn+B
   yqYN3DLCMnn8/2X71ZSOUYUL2Bk+lcSDj7ECdtFyeho77lsm2YJ/bwzN0
   L3lPe8IQdMyFJPhhMzZYBmRPGs4fi0+wNpKcb6AMg9W21DK8keh8g+AvQ
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="336195488"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="336195488"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:17:04 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10655"; a="631161966"
X-IronPort-AV: E=Sophos;i="5.98,274,1673942400"; 
   d="scan'208";a="631161966"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.237.142.82])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2023 08:17:03 -0700
Date:   Mon, 20 Mar 2023 16:16:59 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-raid@vger.kernel.org
Subject: Re: mdadm --detail works, mdadm --stop says "does not appear to be
 an md device"
Message-ID: <20230320161659.00001c48@linux.intel.com>
In-Reply-To: <20230320145035.GW21713@merlins.org>
References: <20230317173810.GW4049235@merlins.org>
        <20230320153639.0000238d@linux.intel.com>
        <20230320145035.GW21713@merlins.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 20 Mar 2023 07:50:35 -0700
Marc MERLIN <marc@merlins.org> wrote:

> On Mon, Mar 20, 2023 at 03:36:39PM +0100, Mariusz Tkaczyk wrote:
> > Hi,
> > mdadm is unable to complete this task because it cannot ensure that it is
> > safe to stop the array. It cannot open the array with O_EXCL.
> > If it is mounted then it may hang if filesystem needs to flush some data.  
>  
> Thanks for the reply. The array was not mounted, that said, given that
> it was fully down, there wasn't a way to flush the data if it had been
> (cable problem to an enclosure, all the drives disappeared at once)
> 
> > Please, try umount the array if it mounted somewhere and then try:
> > 
> > # echo inactive > /sys/block/md6/md/array_state
> > # echo clear > /sys/block/md6/md/array_state  
> 
> I can try this next time (already had to reboot), thanks.
> 
> That said, mdadm should output a better message in this case
> > > mdadm: /dev/md6 does not appear to be an md device  
> is clearly wrong 
> 
> Is that something easy to fix/improve?

Oh, sorry my bad, please see the code:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdopen.c#n472

We are failing to "understand" the array:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/util.c#n229
It has nothing to do with open and O_EXCL. I didn't dig into to determine why.

Anyway, now error seems to be reasonable but maybe we should be able to tract
this array as valid? I requires more work and analysis so it is not simple fix.

Thanks,
Mariusz
