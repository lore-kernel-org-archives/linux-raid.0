Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C694C2D0E4
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 18:50:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E4D71206D8
	for <linux-raid@archiver.kernel.org>; Tue, 24 Nov 2020 18:50:18 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mukund.org header.i=@mukund.org header.b="RbjPQ2zV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404000AbgKXSuS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 24 Nov 2020 13:50:18 -0500
Received: from mx.mukund.org ([144.76.205.247]:56029 "EHLO mx.mukund.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729281AbgKXSuR (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 24 Nov 2020 13:50:17 -0500
X-Greylist: delayed 41369 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Nov 2020 13:50:16 EST
Date:   Wed, 25 Nov 2020 00:20:04 +0530
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mukund.org; s=mail;
        t=1606243813; bh=si8yplzYbie3U1ldkOlJ1WSoTzIttcpC2uAdW5I+qxs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RbjPQ2zVml7TgWQ2xdduBvTzcqfc8nsNw0YXxA45QLoVb7xa/W7GGrzvaFmHlFGOo
         HUDpaYmC3OZthi55zqpB//ODMaQrck9SeOgiGDp4YpHD0x8IbGbIczPcXCs4utGEAe
         a9VhN/7zG2RduK1d4v0k7zYlqE/finzGnotxv0nM=
From:   Mukund Sivaraman <muks@mukund.org>
To:     Wols Lists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org
Subject: Re: RAID-6 and write hole with write-intent bitmap
Message-ID: <20201124185004.GA27132@jurassic.vpn.mukund.org>
References: <20201124072039.GA381531@jurassic.vpn.mukund.org>
 <5FBCDC18.9050809@youngman.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5FBCDC18.9050809@youngman.org.uk>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Wols

On Tue, Nov 24, 2020 at 10:10:32AM +0000, Wols Lists wrote:
> On 24/11/20 07:20, Mukund Sivaraman wrote:
> > Hi all
> > 
> > I am trying to setup a MD RAID-6 array and use the ext4 filesystem in
> > ordered mode (default) on it. The data gets backed up periodically. I
> > want the array to be always available.
> > 
> > I prefer not using a write-journal if it is sufficient for my usage. I
> > want to use the write-intent bitmap only. AIUI the write-hole problem
> > occurs when there is a crash or abrupt power off *and* disk failures.
> 
> No, I don't think so. I'm not sure, but aiui, there is a critical point
> where the data is partially saved to disk, and should a power failure
> occur at that precise point you have a stripe incompletely saved, and
> therefore corrupt. This is why you need a log to fix it ...

I appreciate that you took time to reply. Thank you. I am also in the
"not sure" group, and we may be served well by an authoritative answer
from someone who is familiar with the code. I also didn't follow whether
you're saying there is a write hole or not. The answer may be
implementation specific too, so I am looking for an answer from someone
who knows the code.

The following may be incorrect as I am a RAID layperson, but AIUI:

(a) With RAID-5, assuming there are 4 member disks A, B, C, D, a write
operation with its data on disk A and stripe's parity on disk B may
involve:

1. a read of the stripe
2. update of data on A
3. computation and update of parity A^C^D on B

These are not atomic updates. If power is lost between steps 2 and 3,
upon recovery the mismatch between data and parity for the stripe would
be found and the parity can be updated on B. The data chunk written to A
may be incomplete if power is lost during step 2, but the ext4's journal
would return the FS to a consistent state. Moreover, there should not be
any modification/corruption of data in the stripe on disks C and D
(assuming the disks are OK).

(b) With RAID-6, assuming there are 5 member disks A, B, C, D, E, a
write operation with its data on disk A and stripe's parity on disks
B(p) and C(q) would involve:

1. a read of the stripe
2. update of data on A
3. computation and update of parity on B(p)
4. update of parity on C(q)

These are not atomic updates. If power is lost between steps 2 and 3,
upon recovery the mismatch of data on A would be found and the data
chunk can be updated on A. The data chunk written to A may be incomplete
if power is lost during step 2, but the ext4's journal would return the
FS to a consistent state. If power is lost between steps 3 and 4, upon
recovery the mismatch of parity would be found between B(p) and C(q) and
the parity can be updated on B(p) and C(q). Mainly, there should not be
any modification/corruption of data in the stripe on disks D and E
(assuming the disks are OK).

The above may be incorrect, so please indicate what happens, and if
there is a write hole, why there is one.

We don't mind if data in files being written to at the time of power
loss are partially written. It can happen with any abrupt power
loss. The concern is if other unrelated parts of the filesystem not
tracked by the filesystem's journal get corrupted because of other data
chunks of a stripe being updated during recovery.

> > 
> > * After a crash or abrupt power off, the write-intent bitmap is used to
> >   rewrite parity where necessary. If there is no disk failure during
> >   this period, is the RAID-6 array guaranteed to recover without
> >   corruption?
> > 
> >   With RAID-6, will recovery with write-intent bitmap succeed with 1
> >   disk failure during the recovery period without a write-journal? i.e.,
> >   is there a possibility of write hole with 1 disk failure in a RAID-6
> >   array?
> > 
> > * With RAID-6 with write-intent bitmap in use, ext4 in ordered mode, no
> >   disk failures, and abrupt power loss, is there any chance of data loss
> >   in files other than those being written to just before the power loss?
> 
> Probably. Sod's law, you will have other files on the same stripe and
> things could go wrong ... Plus I believe some file systems (including
> ext4?) store small files in the directory, not as their own i-node, so
> there's a whole bunch of other complications possible, plus if you
> corrupt the directory ,,,
> > 
> > (Apologies if these are silly questions, but I request answers.)
> > 
> RULE 0: RAID IS NO SUBSTITUTE FOR BACKUPS.

The data is backed up periodically.

> And if you don't want to lose live data as it is being updated, you need
> a journal. Run the correct horse for the course :-)

It is important that the array is available and not in a failed state or
with an corrupted FS due to a power loss. We would also like to avoid
having to go to restoring from backups as much as possible. There is
power outage about once every week. The system is powered via an
inverter (a lead-acid battery backed UPS) which switches from mains to
battery power when there is power loss within a few tens of milliseconds
that the server's power supply tolerates. Rarely, the switchover time is
longer, or there is a dip, and the server powers off. So consider that
power outages are somewhat common and the array should survive it to
avoid extra work for us, regardless of backups.

The write-journal is a relatively new addition to MD and I feel
conservative about using it for now. I have come across failures
reported on the lists[1], it is not clear if others are using it in
production, and some things such as how to remove the write journal from
an array are not documented (there was a sequence of steps which was
mentioned in the commit log of a patch that introduced support[2], but a
step was missing in it as pointed out in a different mailing list
post[3]). Please don't take these things as criticism - it is just that
the feature appears to be relatively new. Adding an NVMe SSD to hold the
write journal would add another component to the mix which I want to
avoid. However if an authoritative answer indicates the write journal is
required in our case and the implementation is mature, we will try to
adopt it.

[1] https://www.spinics.net/lists/raid/msg62646.html
[2] https://marc.info/?l=linux-raid&m=149063896208043
[3] https://www.spinics.net/lists/raid/msg59940.html

		Mukund
