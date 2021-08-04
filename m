Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6589C4338F
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 09:40:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93F2E60EFD
	for <linux-raid@archiver.kernel.org>; Wed,  4 Aug 2021 09:40:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237104AbhHDJk5 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 4 Aug 2021 05:40:57 -0400
Received: from pott.psjt.org ([46.38.234.111]:34586 "EHLO pott.psjt.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237157AbhHDJkx (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 4 Aug 2021 05:40:53 -0400
Received: from [10.1.1.1] (helo=miniq.psjt.org)
        by pott.psjt.org with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mBDO9-0004yi-PQ; Wed, 04 Aug 2021 11:40:37 +0200
Received: from blaulicht.dmz.brux ([10.1.1.10] helo=blaulicht)
        by miniq.psjt.org with esmtp (Exim 4.94)
        (envelope-from <boettcher@physik.uni-kiel.de>)
        id 1mBDO8-0003e7-MU; Wed, 04 Aug 2021 11:40:36 +0200
From:   =?utf-8?Q?Stephan_B=C3=B6ttcher?= <boettcher@physik.uni-kiel.de>
To:     antlists <antlists@youngman.org.uk>
Cc:     linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>
Subject: Re: help channel for md raid?
References: <s6n8s1j6he9.fsf@falbala.ieap.uni-kiel.de>
        <6108398C.3020509@youngman.org.uk>
        <s6ny29jv67p.fsf@blaulicht.dmz.brux>
        <7fd259a1-d7ed-2554-6b86-01bab3c0cf36@youngman.org.uk>
Date:   Wed, 04 Aug 2021 11:40:36 +0200
In-Reply-To: <7fd259a1-d7ed-2554-6b86-01bab3c0cf36@youngman.org.uk>
        (antlists@youngman.org.uk's message of "Tue, 3 Aug 2021 20:44:43
        +0100")
Message-ID: <s6n4kc5lf8r.fsf@blaulicht.dmz.brux>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


antlists <antlists@youngman.org.uk> writes:

> On 02/08/2021 23:20, Stephan Böttcher wrote:
>> Wol writes:
>> 
>> Yes, and it issued a few hundred messages of sector numbers with
>> mismatches in the parity, like: sectors 1460408-1460416.
>
> Bear in mind I'm now getting out of my depth, I just edit the wiki, I
> don't know the deep internals :-), but something doesn't feel right 
> here. 408-416 is *nine* sectors. I'd expect it to be a multiple of 2,
> or related to the number of data drives (in your case 4). So 9 is well
> weird.

from drivers/md/raid5.c:

       atomic64_add(STRIPE_SECTORS, &conf->mddev->resync_mismatches);
       if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery)) {
               /* don't try to repair!! */
               set_bit(STRIPE_INSYNC, &sh->state);
               pr_warn_ratelimited("%s: mismatch sector in range "
                                   "%llu-%llu\n", mdname(conf->mddev),
                                   (unsigned long long) sh->sector,
                                   (unsigned long long) sh->sector +
                                   STRIPE_SECTORS);

The check reads STRIPE_SECTORS=8 sectors from each drive at drive
location sh->sectors=…408, checks the parity, since one drive is missing
it cannot find out on which drive the error is and issues this warning,
reporting sectors […408, …416).

>> These are block numbers I calculated that may match those sector
>> numbers, using the awk script in my first mail.
>> The ext4 block size is 4kByte.
>> The chunk size is 512kByte = 1024 sectors = 128 blocks.  Is that per
>> drive or total?  I assume per drive.
>
> I would think so. You have 6 chunks per stripe, d1, d2, d3, d4, P and
> Q,   so each stripe is 2MB.

>> The sector numbers are per drive.  Sector 1460408 is in chunk
>> 1460408/1024 = 1426, sector offset  1460408 % 1024 = 184.
>
> ??? If it's scanning md8, then the sector numbers will be relative to
> md8.

why?

> Stuff working at this level is merely scanning a block device - it has
> no clue whether it's a drive - it may well not be!

?

>> My RAID6 with six drives has a payload of 4 × 512kByte per chunk
>> slice.
>> That is 512 blocks per chunk.  The first block of the affected chunk
>> should be 1426 × 512 = 730112.
>> The sector offset 184 into the chunk is 184/8 = 23 blocks in, i.e.,
>> block
>> 730112 + 23 = 730135.  And the corresponding sectors in the other drives
>> are multiples of the chunk size ahead, so I need to look for blocks
>> 730112 + 23 + i×128, i=0…3.
>> So when I ask debugfs which inode uses the block 730135, I should
>> get
>> (one of) the file(s) that is affected by the mismatch.
>
> If this is a DISK block, then debugfs will be getting VERY confused,
> because it will be looking for the filesystem block 73015, which will
> be somewhere else entirely.

- I took the sector number reported by the raid driver, and calculated
  which block numbers on /dev/md8 those correspond to.

    sector 1460408 -> block 730135

- I asked debugfs (ext2progs) which inodes uses those blocks.

- I asked debugfs which file paths point to those innodes.

- I asked debugfs to dump those files to a filesystem on another host.

The `debugfs dump` I repeated five times, once with each remaining drive
omitted from the --readonly assembly with four drives.  

A few files were always the same. Did I make a mistake in my
calculations, did I miss some offset?

Some files were different for all six dumps.  Probably because of errors
in multiple chunks.

Most files have dumps that agree for some subset. When that happened,
the "full" five drive dump was always among the set.

I put in a new drive, the array is now complete with six drives.  I will
have a look how the files compare now, and for those few that may be
valuable I may be able to fix something picking from the six dumps I made.

Gruß,
-- 
Stephan
