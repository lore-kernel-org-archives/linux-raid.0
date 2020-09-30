Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9880C4727C
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 19:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1AAD620709
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 19:45:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=madore.org header.i=@madore.org header.b="c6Gyvdjk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729556AbgI3TpM (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 15:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725799AbgI3TpM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 30 Sep 2020 15:45:12 -0400
Received: from achernar.gro-tsen.net (achernar6.gro-tsen.net [IPv6:2001:bc8:30e8::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 686EBC061755
        for <linux-raid@vger.kernel.org>; Wed, 30 Sep 2020 12:45:12 -0700 (PDT)
Received: by achernar.gro-tsen.net (Postfix, from userid 500)
        id 456A221402D9; Wed, 30 Sep 2020 21:45:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=madore.org;
        s=achernar; t=1601495110;
        bh=6INEqDDtrMrm/f2T6vceD3RkAKjGABufbNzVs9ce0EY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c6GyvdjkY1JDOBxXDBslkdAmhvlbzoLlxSp/QvYZjmHalndsDTTgqiiRkM90GS2/d
         wGPbA62qWGundm2rhFP4U6vUnzhZPyog5+CmS6CzMx9Mt0FwrBhPRFKtOh5NMw6tLP
         PNneHcMX0LS3DPI5IS66nLjZF5iVnYtSkRElQ5D4=
Date:   Wed, 30 Sep 2020 21:45:10 +0200
From:   David Madore <david+ml@madore.org>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     Linux RAID mailing-list <linux-raid@vger.kernel.org>
Subject: Re: RAID5->RAID6 reshape remains stuck at 0% (does nothing, not even
 start)
Message-ID: <20200930194510.vki7zixjca6sxvin@achernar.gro-tsen.net>
References: <20200930014032.pd4csjwu3m7uihin@achernar.gro-tsen.net>
 <5F740390.7050005@youngman.org.uk>
 <20200930090031.6lzrs336fr4inpz4@achernar.gro-tsen.net>
 <90338e5b-9ed4-c86e-fa35-8acdd6768ca7@youngman.org.uk>
 <20200930185824.q6dphu2axpfcjjly@achernar.gro-tsen.net>
 <5F74D684.8020005@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5F74D684.8020005@youngman.org.uk>
User-Agent: NeoMutt/20170113 (1.7.2)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Sep 30, 2020 at 08:03:32PM +0100, Wols Lists wrote:
> On 30/09/20 19:58, David Madore wrote:
> > mdadm - v4.1 - 2018-10-01
> > 
> > - which I think is roughly contemporaneous to the kernel version I'm
> > using.  But the problem still persists (with the exact same symptoms
> > and details).
> 
> Except that mdadm is NOT the problem. The problem is that the kernel and
> mdadm are not matched date-wise, and because the kernel is a
> franken-kernel you need to use a different kernel.

I don't understand what you mean by "matched date-wise".  The kernel
I'm using is a longterm support branch (4.9) which was frozen at the
same approximate date as the mdadm I just installed.  And it was also
the same longterm support branch that was used in the Debian oldstable
(9 aka stretch).  Do you mean that there is no mdadm version which is
compatible with the 4.9 kernels?  How often does the mdadm-kernel
interface break compatibility?

> Use a rescue disk!!! That way, you get a kernel and an mdadm that are
> the same approximate date. As it stands, your frankenkernel is too new
> for mdadm 3.4, but too ancient for a modern kernel.

Using a rescue disk would mean taking the system down for longer than
I can afford (I can afford to have this particular partition down for
a long time, but not the whole system...  which unfortunately resides
on the same disks).  So I'd like to keep this as a very last resort,
or at least, not consider it until I've fully understood what's going
on.  (It's especially problematic that I have absolutely no idea of
the speed at which I can expect the reshape to take place, compared to
an ordinary resync.  If you could give me a ballpark figure, it would
help me decide.  My disks resync at ~120MB/sec, and the RAID array I
wish to reshape is ~900GB in per partition, so it takes a few hours to
do an "ordinary" resync: I assume a reshape will take much longer, but
how much longer are we talking?)

But I made another discovery in the mean time: when I run the --grow
command, something starts a systemd service called
mdadm-grow-continue@<device>.service (so in my case
mdadm-grow-continue@md112.service; I wasn't able to understand exactly
who the caller is), a unit which contains

ExecStart=/sbin/mdadm --grow --continue /dev/%I

so it ran

/sbin/mdadm --grow --continue /dev/md112

which failed with

mdadm: array: Cannot grow - need backup-file
mdadm:  Please provide one with "--backup=..."

Now if I override this service to read

ExecStart=/sbin/mdadm --grow --continue /dev/%I --backup=/run/mdadm/backup_file-%I

then it seems to work correctly, at least on my toy example with
loopback devices (but then I suppose it will break the reshape cases
where no backup file is needed?).

I'm very confused as to what's going on here: was this file supposed
to work in the first place?  Why is it needed?  Whence does it come
from?  Am I permitted to run mdadm --continue myself?  Supposed to?
How did all of this work before systemd came in?

PS: Oh, there's already a Debian bug for this: #884719
https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=884719
- but it's not marked as fixed.  Is array reshaping broken on Debian?

Cheers,

-- 
     David A. Madore
   ( http://www.madore.org/~david/ )
