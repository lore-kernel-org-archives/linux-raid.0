Return-Path: <SRS0=7JT0=CJ=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C674FC433E2
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 19:21:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0A1820EDD
	for <linux-raid@archiver.kernel.org>; Mon, 31 Aug 2020 19:21:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729484AbgHaTVB (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Aug 2020 15:21:01 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:52232 "EHLO
        mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgHaTVA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 31 Aug 2020 15:21:00 -0400
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.15.2/8.15.2) with ESMTP id 07VJKsTh007118;
        Mon, 31 Aug 2020 20:20:54 +0100
From:   Nix <nix@esperi.org.uk>
To:     Ram Ramesh <rramesh2400@gmail.com>
Cc:     antlists <antlists@youngman.org.uk>,
        "R. Ramesh" <rramesh@verizon.net>,
        Linux Raid <linux-raid@vger.kernel.org>
Subject: Re: Best way to add caching to a new raid setup.
References: <16cee7f2-38d9-13c8-4342-4562be68930b.ref@verizon.net>
        <16cee7f2-38d9-13c8-4342-4562be68930b@verizon.net>
        <dc91cc7d-02c4-66ee-21b4-bda69be3bbd9@youngman.org.uk>
        <1310d10c-1b83-7031-58e3-0f767b1df71b@gmail.com>
        <101d4a60-916c-fe30-ae7c-994098fe2ebe@youngman.org.uk>
        <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com>
Emacs:  the prosecution rests its case.
Date:   Mon, 31 Aug 2020 20:20:54 +0100
In-Reply-To: <694be035-4317-26fd-5eaf-8fdc20019d9b@gmail.com> (Ram Ramesh's
        message of "Fri, 28 Aug 2020 17:40:18 -0500")
Message-ID: <87sgc2mxk9.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC--Metrics: loom 1481; Body=4 Fuz1=4 Fuz2=4
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 28 Aug 2020, Ram Ramesh verbalised:
> Mythtv is a sever client DVR system. I have a client next to each of
> my TVs and one backend with large disk (this will have RAID with
> cache). At any time many clients will be accessing different programs
> and any scheduled recording will also be going on in parallel. So you
> will see a lot of seeks, but still all will be based on limited
> threads (I only have 3 TVs and may be one other PC acting as a client)
> So lots of IOs, mostly sequential, across small number of threads. I
> think most cache algorithms should be able to benefit from random
> access to blocks in SSD.

FYI: bcache documents how its caching works. Assuming you ignore the
write cache (which I recommend, since nearly all the data corruption and
starvation bugs in bcache have been in the write caching code, and it
doesn't look like write caching would benefit your use case anyway:
if you want an ssd write cache, just use RAID journalling), bcache is
very hard to break: if by some mischance the cache does become corrupted
you can decouple it from the backing RAID array and just keep using it
until you recreate the cache device and reattach it.

bcache tracks the "sequentiality" of recent reads and avoids caching big
sequential I/O on the grounds that it's a likely waste of SSD lifetime
to do so: HDDs can do contiguous reads quite fast: what you want to
cache is seeky reads. This means that your mythtv reads will only be
cached when there are multiple contending reads going on. This doesn't
seem terribly useful, since for a media player any given contending read
is probably not going to be of metadata and is probably not going to be
repeated for a very long time (unless you particularly like repeatedly
rewatching the same things). So you won't get much of a speedup or
reduction in contention.

Where caches like bcache and the LVM cache help is when small seeky
reads are likely to be repeated, which is very common with filesystem
metadata and a lot of other workloads, but not common at all for media
files in my experience.

(FYI: my setup is spinning rust <- md-raid6 <- bcache <- LVM PV, with
one LVM PV omitting the bcache layer and both combined into one VG. My
bulk media storage is on the non-bcached PV. The filesystems are almost
all xfs, some of them with cryptsetups in the way too. One warning:
bcache works by stuffing a header onto the data, and does *not* pass
through RAID stripe size info etc: you'll need to pass in a suitable
--data-offset to make-bcache to ensure that I/O is RAID-aligned, and
pass in the stripe size etc to the underlying oeprations. I did this by
mkfsing everything and then doing a blktrace of the underlying RAID
devices while I did some simple I/Os to make sure the RAID layer was
doing nice stripe-aligned I/O. This is probably total overkill for a
media server, but this was my do-everything server, so I cared very much
about small random I/O performance. This was particularly fun given that
one LVM PV had a bcache header and the other one didn't, and I wanted
the filesystems to have suitable alignment for *both* of them at once...
it was distinctly fiddly to get right.)
