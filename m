Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4DF4C76196
	for <linux-raid@archiver.kernel.org>; Tue, 28 Mar 2023 16:48:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjC1QsK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 28 Mar 2023 12:48:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbjC1QsI (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 28 Mar 2023 12:48:08 -0400
Received: from mail1.merlins.org (magic.merlins.org [209.81.13.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16986769E
        for <linux-raid@vger.kernel.org>; Tue, 28 Mar 2023 09:48:05 -0700 (PDT)
Received: from [76.132.34.178] (port=41438 helo=sauron.svh.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim 4.94.2 #2)
        id 1phBaC-0002Tf-D2 by authid <merlins.org> with srv_auth_plain; Tue, 28 Mar 2023 09:47:59 -0700
Received: from merlin by sauron.svh.merlins.org with local (Exim 4.92)
        (envelope-from <marc@merlins.org>)
        id 1phCUJ-00E2E5-2i; Tue, 28 Mar 2023 09:47:59 -0700
Date:   Tue, 28 Mar 2023 09:47:59 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linux-raid@vger.kernel.org
Subject: Re: mdadm --detail works, mdadm --stop says "does not appear to be
 an md device"
Message-ID: <20230328164759.GF3084470@merlins.org>
References: <20230317173810.GW4049235@merlins.org>
 <20230320153639.0000238d@linux.intel.com>
 <20230320145035.GW21713@merlins.org>
 <20230320161659.00001c48@linux.intel.com>
 <20230321020101.GC4049235@merlins.org>
 <20230322081126.0000066d@linux.intel.com>
 <a8009c66-6542-95d8-0064-8022d4043a7f@trained-monkey.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8009c66-6542-95d8-0064-8022d4043a7f@trained-monkey.org>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
X-Broken-Reverse-DNS: no host name for IP address 76.132.34.178
X-SA-Exim-Connect-IP: 76.132.34.178
X-SA-Exim-Mail-From: marc@merlins.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Mar 22, 2023 at 02:59:12PM -0400, Jes Sorensen wrote:
> >> You are definitely more knowledgeable about this than I am.
> >> All I can say is that the array was down, not mounted, and I couldn't
> >> stop it without a reboot, and that's a problem.
> >>
> >> Any way to force stop in a case like this, would be quite welcome :)
> > 
> > Jes, how you see this?
> 
> If we can force stop it with a big fat warning, then I think that would
> be a good feature to add. The must reboot requirement is not exactly ideal.

Hi Jes, how goes?

That would be lovely, even if I realize it's an unusual corner case.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
 
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
