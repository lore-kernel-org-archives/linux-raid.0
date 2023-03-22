Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 360A5C76195
	for <linux-raid@archiver.kernel.org>; Wed, 22 Mar 2023 07:12:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229521AbjCVHML (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 22 Mar 2023 03:12:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbjCVHMK (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 22 Mar 2023 03:12:10 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C04B75A193
        for <linux-raid@vger.kernel.org>; Wed, 22 Mar 2023 00:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1679469129; x=1711005129;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=MEypv+UWs3j2GJYK18MmQSJUJKjlDGN5gRFlU/Pqzv0=;
  b=Zs6xnFkrh2vU1DqlzygxEBFTOplm/067fnR0pVYppvIudX2udjWmz25p
   gdnTb08KUBLb0B0YJPw7BN/M5w1xp27ulKnA5xE42CmSUDYcqTlOG5MLK
   0UxsoBVyVhVy/iXrXRbnV/lnBYT2F3ktewJEFtXUuE633Hjy2doDHMzV5
   01bKuZe2t2gjUoVHzNO3lFj0BRioGQKLIyOA0iAMWXyG8m1p7qASxr1zB
   Pt8kJULRab33FPkOzESeQUEkjDDWi4AtTEv/cqvHBKBmTkVcKmYBtN0VT
   bjtbq9mmqCubUcRuksAqCJhILd2xHP1V58zDJThZkBdc6sVOcdeCfscj/
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="425430505"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="425430505"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 00:11:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10656"; a="712122797"
X-IronPort-AV: E=Sophos;i="5.98,281,1673942400"; 
   d="scan'208";a="712122797"
Received: from ashfaqur-mobl1.ger.corp.intel.com (HELO localhost) ([10.252.62.75])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Mar 2023 00:11:31 -0700
Date:   Wed, 22 Mar 2023 08:11:26 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Marc MERLIN <marc@merlins.org>
Cc:     linux-raid@vger.kernel.org, Jes Sorensen <jes@trained-monkey.org>
Subject: Re: mdadm --detail works, mdadm --stop says "does not appear to be
 an md device"
Message-ID: <20230322081126.0000066d@linux.intel.com>
In-Reply-To: <20230321020101.GC4049235@merlins.org>
References: <20230317173810.GW4049235@merlins.org>
        <20230320153639.0000238d@linux.intel.com>
        <20230320145035.GW21713@merlins.org>
        <20230320161659.00001c48@linux.intel.com>
        <20230321020101.GC4049235@merlins.org>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 20 Mar 2023 19:01:01 -0700
Marc MERLIN <marc@merlins.org> wrote:

> On Mon, Mar 20, 2023 at 04:16:59PM +0100, Mariusz Tkaczyk wrote:
> > On Mon, 20 Mar 2023 07:50:35 -0700
> > Marc MERLIN <marc@merlins.org> wrote:
> >   
> > > On Mon, Mar 20, 2023 at 03:36:39PM +0100, Mariusz Tkaczyk wrote:  
> > > > Hi,
> > > > mdadm is unable to complete this task because it cannot ensure that it
> > > > is safe to stop the array. It cannot open the array with O_EXCL.
> > > > If it is mounted then it may hang if filesystem needs to flush some
> > > > data.    
> > >  
> > > Thanks for the reply. The array was not mounted, that said, given that
> > > it was fully down, there wasn't a way to flush the data if it had been
> > > (cable problem to an enclosure, all the drives disappeared at once)
> > >   
> > > > Please, try umount the array if it mounted somewhere and then try:
> > > > 
> > > > # echo inactive > /sys/block/md6/md/array_state
> > > > # echo clear > /sys/block/md6/md/array_state    
> > > 
> > > I can try this next time (already had to reboot), thanks.
> > > 
> > > That said, mdadm should output a better message in this case  
> > > > > mdadm: /dev/md6 does not appear to be an md device    
> > > is clearly wrong 
> > > 
> > > Is that something easy to fix/improve?  
> > 
> > Oh, sorry my bad, please see the code:
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/mdopen.c#n472
> > 
> > We are failing to "understand" the array:
> > https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/tree/util.c#n229
> > It has nothing to do with open and O_EXCL. I didn't dig into to determine
> > why.
> > 
> > Anyway, now error seems to be reasonable but maybe we should be able to
> > tract this array as valid? I requires more work and analysis so it is not
> > simple fix.  
> 
> You are definitely more knowledgeable about this than I am.
> All I can say is that the array was down, not mounted, and I couldn't
> stop it without a reboot, and that's a problem.
> 
> Any way to force stop in a case like this, would be quite welcome :)
> 
> Thanks,
> Marc

Jes, how you see this?

Thanks,
Mariusz
