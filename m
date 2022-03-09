Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4271C4332F
	for <linux-raid@archiver.kernel.org>; Wed,  9 Mar 2022 16:35:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235230AbiCIQgp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Mar 2022 11:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238050AbiCIQbU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Mar 2022 11:31:20 -0500
X-Greylist: delayed 53727 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Mar 2022 08:25:33 PST
Received: from rin.romanrm.net (rin.romanrm.net [IPv6:2001:bc8:2dd2:1000::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F0D0192CAC
        for <linux-raid@vger.kernel.org>; Wed,  9 Mar 2022 08:25:33 -0800 (PST)
Received: from nvm (nvm2.home.romanrm.net [IPv6:fd39::4a:3cff:fe57:d6b5])
        by rin.romanrm.net (Postfix) with SMTP id 6D4286D4;
        Wed,  9 Mar 2022 16:25:30 +0000 (UTC)
Date:   Wed, 9 Mar 2022 21:25:29 +0500
From:   Roman Mamedov <rm@romanrm.net>
To:     David T-G <davidtg-robot@justpickone.org>
Cc:     Linux RAID <linux-raid@vger.kernel.org>
Subject: Re: to partition or not to partition (was "Re: striping 2x500G to
 mirror 1x1T")
Message-ID: <20220309212529.4eeaf79d@nvm>
In-Reply-To: <20220309160403.GH4455@justpickone.org>
References: <20220305044704.GB4455@justpickone.org>
        <20220309160403.GH4455@justpickone.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 9 Mar 2022 11:04:03 -0500
David T-G <davidtg-robot@justpickone.org> wrote:

> Is it OK to mirror a partition and an entire device?

Yes it is OK.

>   jpo:~ # parted /dev/sdb unit MiB print
>   Model: ATA ST31000524AS (scsi)
>   Disk /dev/sdb: 953870MiB
>   Sector size (logical/physical): 512B/512B
>   Partition Table: gpt
>   Disk Flags: 
> 
>   Number  Start      End        Size       File system  Name  Flags
>    1      1.00MiB    858307MiB  858306MiB  xfs          pri
>    4      950055MiB  953869MiB  3814MiB                 pri
> 

Here it seems weird that your 1TB drive has a 858GB partition, then a hole of
free space about 92 GB in size, and only then another partition of 4 GB. In
preparation for that partition to become a RAID member (instead of xfs data
directly), you could resize it to match the 944082MiB size of md0.

> with existing data (and having to fudge around, not surprisingly, the
> striping metadata overhead), and so I've been playing
> 
>   jpo:~ # parted /dev/md0 unit MiB print
>   Model: Linux Software RAID Array (md)
>   Disk /dev/md0: 944082MiB
>   Sector size (logical/physical): 512B/512B
>   Partition Table: gpt
>   Disk Flags: 
> 
>   Number  Start      End        Size       File system  Name         Flags
>    1      1.00MiB    934641MiB  934640MiB               500Graid0md  raid
>    4      934641MiB  944081MiB  9440MiB                 pri          msftdata
> 
> with how to slice up the stripe device to size it to match the existing
> sdb1 partition with the mirroring metadata overhead, when I wondered ...
> do I care?  I don't need the s4 slice on this virtual device; that's just
> leftover space.  I hate to think of it going to waste, but it's really
> trivial in the grand scheme of things.  Soooooo ... if it's just as happy
> to mirror against a whole device as it is a slice of one, then maybe I
> can skip ahead.

It is definitely an overkill to partition the md0 device. Better to just use
it entirely. If you fix up the partition size on sdb as mentioned above, there
will not be any wasted space on md0.

-- 
With respect,
Roman
