Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A97D5C433F5
	for <linux-raid@archiver.kernel.org>; Fri,  3 Dec 2021 18:00:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343534AbhLCSEK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Dec 2021 13:04:10 -0500
Received: from smtpout2.vodafonemail.de ([145.253.239.133]:55182 "EHLO
        smtpout2.vodafonemail.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236479AbhLCSEJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Dec 2021 13:04:09 -0500
Received: from smtp.vodafone.de (unknown [10.2.0.38])
        by smtpout2.vodafonemail.de (Postfix) with ESMTP id 307BE61D25;
        Fri,  3 Dec 2021 19:00:27 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nexgo.de;
        s=vfde-smtpout-mb-15sep; t=1638554427;
        bh=5NUW132JqAncCa/NNZGXcFmyrNtppQze2nrfXELt9hA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=PYkfq2SlLXvgYKxgMbmvXPNX0pQZrsXixmf5kYf+Q9Dw6QYqovDkeHrs71zWIBkGF
         jGMhcOWMTiR29yqxVuAsQt2ksryzQJL1k46RT7eTT+5FHMnhmCtEgVWMvBEV3+FMI0
         T0cryodQlbgZHrP6Y75q9q5SOfKtKPpDtHhIWFP0=
Received: from lazy.lzy (p579d7c55.dip0.t-ipconnect.de [87.157.124.85])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp.vodafone.de (Postfix) with ESMTPSA id 4J5LFz6qlKzKm54;
        Fri,  3 Dec 2021 18:00:20 +0000 (UTC)
Received: from lazy.lzy (localhost [127.0.0.1])
        by lazy.lzy (8.17.1/8.14.5) with ESMTPS id 1B3I0Kwf009120
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Fri, 3 Dec 2021 19:00:20 +0100
Received: (from red@localhost)
        by lazy.lzy (8.17.1/8.16.1/Submit) id 1B3I0KWn009119;
        Fri, 3 Dec 2021 19:00:20 +0100
Date:   Fri, 3 Dec 2021 19:00:20 +0100
From:   Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
To:     Matt Garretson <matt@mattyo.net>
Cc:     linux-raid@vger.kernel.org
Subject: Re: Help ironing out persistent mismatches on raid6
Message-ID: <YapbNC7jgkTqnLwj@lazy.lzy>
References: <7be1c467-c2c2-5f90-dc1c-f1c443954f03@mattyo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7be1c467-c2c2-5f90-dc1c-f1c443954f03@mattyo.net>
X-purgate-type: clean
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
X-purgate-size: 2173
X-purgate-ID: 149169::1638554427-000004AE-BD89C14D/0/0
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Dec 02, 2021 at 05:04:57PM -0500, Matt Garretson wrote:
> Hi, I have this RAID6 array of 6x 8TB drives:
> 
> /dev/md1:
>            Version : 1.2
>      Creation Time : Fri Jul  6 23:20:38 2018
>         Raid Level : raid6
>         Array Size : 31255166976 (29.11 TiB 32.01 TB)
>      Used Dev Size : 7813791744 (7.28 TiB 8.00 TB)
>       Raid Devices : 6
> 
> There is an ext4 fs on the device (no lvm).
> 
> The array for over a year has had 40 contiguous mismatches in the same spot:
> 
> md1: mismatch sector in range 2742891144-2742891152
> md1: mismatch sector in range 2742891152-2742891160
> md1: mismatch sector in range 2742891160-2742891168
> md1: mismatch sector in range 2742891168-2742891176
> md1: mismatch sector in range 2742891176-2742891184

If you dare to try, you can use
"raid6check" which should be
together with "mdadm" (at least
in source form).

If I recall correctly, this could
check a given range (whole array will
take forever) and report, if possible,
*which* drive is having the mismatch.

It is also possible to use it to
repair the mismatch, if caused by a
single drive problem.

Of course, standard disclaimer is that
nothing is guarantee to work as advertised.
Use at your own risk...

bye,

pg

> 
> Sector size is 512, so I guess this works out to be five 4KiB blocks, or
> 20KiB of space.
> 
> The array is checked weekly, but never been "repaired".  The ext4
> filesystem has been fsck'd a lot over the years, with no problems.  But
> I worry about what file might potentially have bad data in it.  There
> are a lot of files.
> 
> I have done:
> 
> dd status=none if=/dev/md1 ibs=512 skip=2742891144 count=40  |hexdump -C
> 
> ... and I don't see anything meaningful to me.
> 
> I have done  dumpe2fs -h /dev/md1 and it tells me block size is 4096 and
> the first block is 0.  So does....
> 
> 2742891144 * 512 / 4096 = 342861393
> 
> ...mean we are dealing with blocks # 342861393 - 342861398 of the
> filesystem?  If so, is there a way for me to see what file(s) use those
> blocks?
> 
> Thanks in advance for any tips...
> -Matt

-- 

piergiorgio
