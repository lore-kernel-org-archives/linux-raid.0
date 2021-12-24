Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49214C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 24 Dec 2021 07:46:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241428AbhLXHp7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Dec 2021 02:45:59 -0500
Received: from dione.uberspace.de ([185.26.156.222]:36072 "EHLO
        dione.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbhLXHp7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Dec 2021 02:45:59 -0500
Received: (qmail 10813 invoked by uid 989); 24 Dec 2021 07:45:57 -0000
Authentication-Results: dione.uberspace.de;
        auth=pass (plain)
Date:   Fri, 24 Dec 2021 08:45:57 +0100
From:   Andreas Klauer <Andreas.Klauer@metamorpher.de>
To:     Tony Bush <thecompguru@gmail.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Need help Recover raid5 array
Message-ID: <YcV6tUwlKd+tLd78@metamorpher.de>
References: <CAA9kLn1nZZKHLahjkyJzChgTMC2WKEoyJG2PhHzeXbD_qY_-yw@mail.gmail.com>
 <Yb8ebs7lhEHHTqif@metamorpher.de>
 <CAA9kLn1JwRLWpOd-kRnLj2YqQhkRM_R_LFisA9_acxHdFJpFVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAA9kLn1JwRLWpOd-kRnLj2YqQhkRM_R_LFisA9_acxHdFJpFVg@mail.gmail.com>
X-Rspamd-Bar: /
X-Rspamd-Report: BAYES_HAM(-0.006751) MIME_GOOD(-0.1)
X-Rspamd-Score: -0.106751
Received: from unknown (HELO unkown) (::1)
        by dione.uberspace.de (Haraka/2.8.28) with ESMTPSA; Fri, 24 Dec 2021 08:45:57 +0100
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 23, 2021 at 10:55:01PM -0500, Tony Bush wrote:
> /dev/mapper/sda /dev/mapper/sdb /dev/mapper/sdc /dev/mapper/sdd
> /dev/mapper/sde

Hi Tony, 

your examine output of the one drive that was left showed Device role 1,  
and count starts from 0 so that's the 2nd drive in the array. The order 
of the others is unknown so yes, unless you are able to derive order 
from raw data, you simply have to try all combinations. This can be 
scripted as well.

Furthermore you should --examine the array you created and make sure 
that all other variables (offset, level, layout, ...), match your 
previous --examine.

As for re-creating overlays, you can do that for every single step 
but it might not be necessary just for mount attempt.

Note that there is the case where mounting might succeed but drive 
order is still wrong - find a large file and see if it is fully intact.

Best of luck,
Andreas Klauer
