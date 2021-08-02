Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D805DC4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 22:39:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD9AB60EE6
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 22:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232164AbhHBWje convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 18:39:34 -0400
Received: from pott.psjt.org ([46.38.234.111]:39634 "EHLO pott.psjt.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231875AbhHBWjd (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 2 Aug 2021 18:39:33 -0400
X-Greylist: delayed 1103 seconds by postgrey-1.27 at vger.kernel.org; Mon, 02 Aug 2021 18:39:33 EDT
Received: from [10.1.1.1] (helo=miniq.psjt.org)
        by pott.psjt.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mAgIt-0004na-VK; Tue, 03 Aug 2021 00:20:59 +0200
Received: from blaulicht.dmz.brux ([10.1.1.10] helo=blaulicht)
        by miniq.psjt.org with esmtp (Exim 4.94)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mAgIs-0001rB-PQ; Tue, 03 Aug 2021 00:20:58 +0200
From:   =?utf-8?Q?Stephan_B=C3=B6ttcher?= <boettcher@physik.uni-kiel.de>
To:     Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
Subject: Re: help channel for md raid?
References: <s6n8s1j6he9.fsf@falbala.ieap.uni-kiel.de>
        <6108398C.3020509@youngman.org.uk>
Date:   Tue, 03 Aug 2021 00:20:58 +0200
In-Reply-To: <6108398C.3020509@youngman.org.uk> (Wols Lists's message of "Mon,
        2 Aug 2021 19:29:32 +0100")
Message-ID: <s6ny29jv67p.fsf@blaulicht.dmz.brux>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Wol writes:

> Ask away!

Thanks.

>> My qustion is how to translate sector numbers from a RAID6 as in
>> 
>>> Aug  2 01:32:28 falbala kernel: md8: mismatch sector in range 1460408-1460416
>> 
>> to ext4 inode numbers, as in
>> 
>>> debugfs: icheck 730227 730355 730483 730611
>>> Block   Inode number
>>> 730227  30474245
>>> 730355  30474245
>>> 730483  30474245
>>> 730611  30474245
>> 
>> It is a RAID6 with six drives, one of them failed.
>> A check yielded 378 such mismatches.
>> 
>> I assume the sectors count from the start of the `Data Offset`.
>> `ext4 block numbers` count from the start of the partition?
>> Is that correct?
>
> md8 is your array. 

Yes, and it issued a few hundred messages of sector numbers with
mismatches in the parity, like: sectors 1460408-1460416.

Those sectors seem to be in units of 512 bytes, per drive.

> This is the block device presented to your file system so you're
> feeding it 730227, 730355, 730483, 730611, 

These are block numbers I calculated that may match those sector
numbers, using the awk script in my first mail.

The ext4 block size is 4kByte.

The chunk size is 512kByte = 1024 sectors = 128 blocks.  Is that per
drive or total?  I assume per drive.

The sector numbers are per drive.  Sector 1460408 is in chunk
1460408/1024 = 1426, sector offset  1460408 % 1024 = 184.

My RAID6 with six drives has a payload of 4 × 512kByte per chunk slice.
That is 512 blocks per chunk.  The first block of the affected chunk
should be 1426 × 512 = 730112.

The sector offset 184 into the chunk is 184/8 = 23 blocks in, i.e., block
730112 + 23 = 730135.  And the corresponding sectors in the other drives
are multiples of the chunk size ahead, so I need to look for blocks
730112 + 23 + i×128, i=0…3.

So when I ask debugfs which inode uses the block 730135, I should get
(one of) the file(s) that is affected by the mismatch.

(My awk script was missing an `int()` call, that's why these numbers are
different from those posted before.)

Does any of this makes sense?

> these are the sector numbers of md8, and they will be *linear* within
> it.

I believe these sector numbers are per drive.  The parity is calculated
for all sectors at the same offset to 'Data Offset'. I found something
to that effect when searching for the term "mismatch sector in range".
The numbers I got agree with the size of my drives.

I did not find any much documentation how exactly the layout of such a
RAID6 works.  From what I did find, I made the conclusions above.  Maybe
I should look into the kernel source.  (Well, I did, grepping for
"mismatch sector in range").

What does "Layout : left-symmetric" mean?  I guess it does not matter
here, unless I need to map those four block numbers to drives.

> So if you're trying to map filesystem sectors to md8 sectors, they are
> the same thing.
>
> Only if you're trying to map filesystem sectors to the hard drives
> underlying the raid do you need to worry about the 'Data Offset'. (And
> this varies on a per-drive basis!)
>> 
>> The failed drive has >3000 unreadble sectors and became very slow.
>
> So you've removed the drive? Have you replaced it? If you have a drive
> fail again, always try and replace it using the --replace option, I
> think it's too late for that now ...

I'd need one more SATA port for that. I could put the slow drive on
a USB. I'll do that next time.  Most drive failures I had in the past
were total losses.

I issued mdadm --fail on it.  The drive was 100× slower than normal.
Then I did a parity check, which gave all those mismatch errors.  A fsck
went through without errors.

Replacement drives are in the drawer. It will go in tomorrow.

When I now do a resync with the new drive, how will those mismatches be
resolved?

I was thinking of pulling each of the remaining drives in turn, --assemble
--readonly, and see how the affected files are different,  If all failures
are on a single drive, I can --fail that drive too before the resync.

Will a -A --readonly assembled RAID be truly read-only?  When I plug a
pulled drive back in, will the RAID accept it?

The --fail-ed drive is still readable, slowly.  Unfortunately it is now
out of date.

> But as for finding out which files may have been corrupted, you want to
> use the tools that come with the filesystem, and ask it which files use
> sectors 1460408-1460416. Don't worry about the underlying raid.
> Hopefully those tools will come back and say those sectors are unused.

If it were that easy …

> If they ARE used, the chances are it's just the parity which is corrupt.
> Otherwise you're looking at a backup ...

No backup.  The computer center needs to backup several multi TByte
filesystems for our group.  This is one of the filesystems where
everybody is told not to put irreplaceable data.  As if anybody will
listen to what I say.

> (I gather such errors are reasonably common, and do not signify a
> problem. On a live filesystem they could well be a collision between a
> file write and the check ...)

So you say it may all be errors in the parity only?  This helps for 5/6th
of the data, not the chunks where the actual data was pulled.  

Gruß,
-- 
Stephan
