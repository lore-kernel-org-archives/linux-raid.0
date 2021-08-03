Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4619CC4338F
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 19:44:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2130560F38
	for <linux-raid@archiver.kernel.org>; Tue,  3 Aug 2021 19:44:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239950AbhHCTo5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 3 Aug 2021 15:44:57 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:40288 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239846AbhHCTo5 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 3 Aug 2021 15:44:57 -0400
Received: from host86-162-184-27.range86-162.btcentralplus.com ([86.162.184.27] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mB0LD-000640-Bx; Tue, 03 Aug 2021 20:44:44 +0100
Subject: Re: help channel for md raid?
To:     =?UTF-8?Q?Stephan_B=c3=b6ttcher?= <boettcher@physik.uni-kiel.de>,
        linux-raid@vger.kernel.org
References: <s6n8s1j6he9.fsf@falbala.ieap.uni-kiel.de>
 <6108398C.3020509@youngman.org.uk> <s6ny29jv67p.fsf@blaulicht.dmz.brux>
Cc:     NeilBrown <neilb@suse.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <7fd259a1-d7ed-2554-6b86-01bab3c0cf36@youngman.org.uk>
Date:   Tue, 3 Aug 2021 20:44:43 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <s6ny29jv67p.fsf@blaulicht.dmz.brux>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/08/2021 23:20, Stephan Böttcher wrote:
> 
> Wol writes:
> 
>> Ask away!
> 
> Thanks.
> 
>>> My qustion is how to translate sector numbers from a RAID6 as in
>>>
>>>> Aug  2 01:32:28 falbala kernel: md8: mismatch sector in range 1460408-1460416
>>>
>>> to ext4 inode numbers, as in
>>>
>>>> debugfs: icheck 730227 730355 730483 730611
>>>> Block   Inode number
>>>> 730227  30474245
>>>> 730355  30474245
>>>> 730483  30474245
>>>> 730611  30474245
>>>
>>> It is a RAID6 with six drives, one of them failed.
>>> A check yielded 378 such mismatches.
>>>
>>> I assume the sectors count from the start of the `Data Offset`.
>>> `ext4 block numbers` count from the start of the partition?
>>> Is that correct?
>>
>> md8 is your array.
> 
> Yes, and it issued a few hundred messages of sector numbers with
> mismatches in the parity, like: sectors 1460408-1460416.

Bear in mind I'm now getting out of my depth, I just edit the wiki, I 
don't know the deep internals :-), but something doesn't feel right 
here. 408-416 is *nine* sectors. I'd expect it to be a multiple of 2, or 
related to the number of data drives (in your case 4). So 9 is well weird.
> 
> Those sectors seem to be in units of 512 bytes, per drive.
> 
>> This is the block device presented to your file system so you're
>> feeding it 730227, 730355, 730483, 730611,
> 
> These are block numbers I calculated that may match those sector
> numbers, using the awk script in my first mail.
> 
> The ext4 block size is 4kByte.
> 
> The chunk size is 512kByte = 1024 sectors = 128 blocks.  Is that per
> drive or total?  I assume per drive.

I would think so. You have 6 chunks per stripe, d1, d2, d3, d4, P and Q, 
  so each stripe is 2MB.
> 
> The sector numbers are per drive.  Sector 1460408 is in chunk
> 1460408/1024 = 1426, sector offset  1460408 % 1024 = 184.

??? If it's scanning md8, then the sector numbers will be relative to 
md8. Stuff working at this level is merely scanning a block device - it 
has no clue whether it's a drive - it may well not be!
> 
> My RAID6 with six drives has a payload of 4 × 512kByte per chunk slice.
> That is 512 blocks per chunk.  The first block of the affected chunk
> should be 1426 × 512 = 730112.
> 
> The sector offset 184 into the chunk is 184/8 = 23 blocks in, i.e., block
> 730112 + 23 = 730135.  And the corresponding sectors in the other drives
> are multiples of the chunk size ahead, so I need to look for blocks
> 730112 + 23 + i×128, i=0…3.
> 
> So when I ask debugfs which inode uses the block 730135, I should get
> (one of) the file(s) that is affected by the mismatch.

If this is a DISK block, then debugfs will be getting VERY confused, 
because it will be looking for the filesystem block 73015, which will be 
somewhere else entirely.
> 
> (My awk script was missing an `int()` call, that's why these numbers are
> different from those posted before.)
> 
> Does any of this makes sense?

Not really, primarily because (a) I don't know what you're trying to do, 
and (b) because if I do understand correctly what you're trying to do, 
you're doing it all wrong.
> 
>> these are the sector numbers of md8, and they will be *linear* within
>> it.
> 
> I believe these sector numbers are per drive.  The parity is calculated
> for all sectors at the same offset to 'Data Offset'. I found something
> to that effect when searching for the term "mismatch sector in range".
> The numbers I got agree with the size of my drives.
> 
> I did not find any much documentation how exactly the layout of such a
> RAID6 works.  From what I did find, I made the conclusions above.  Maybe
> I should look into the kernel source.  (Well, I did, grepping for
> "mismatch sector in range").

As I said above, you'll have 2MB per slice, 4 data and 2 parity chunks. 
The parity blocks move around, so if you want to recover the data, 
you're also going to have work out which disk your data chunk is on, 
because it's not a simple 1,5,9 or 1,7,13 ...

And while, with a brand new array, the data offset will be the same 
across all drives, any management activity is likely to move the data 
around, not necessarily the same across all drives.
> 
> What does "Layout : left-symmetric" mean?  I guess it does not matter
> here, unless I need to map those four block numbers to drives.

Yup. A quick google tells me it's the algorithm used to place the parity 
chunks.
> 
>> So if you're trying to map filesystem sectors to md8 sectors, they are
>> the same thing.
>>
>> Only if you're trying to map filesystem sectors to the hard drives
>> underlying the raid do you need to worry about the 'Data Offset'. (And
>> this varies on a per-drive basis!)
>>>
>>> The failed drive has >3000 unreadble sectors and became very slow.
>>
>> So you've removed the drive? Have you replaced it? If you have a drive
>> fail again, always try and replace it using the --replace option, I
>> think it's too late for that now ...
> 
> I'd need one more SATA port for that. I could put the slow drive on
> a USB. I'll do that next time.  Most drive failures I had in the past
> were total losses.

If you've got room, put an expansion card with an eSATA port on it. Or 
yes, you could physically replace the drive, put the old one back on a 
USB port, and do an mdadm --replace. DON'T do it the other way round, 
putting the new one on a USB for the mdadm replace before swapping it in 
- experience says this is a bad move ...
> 
> I issued mdadm --fail on it.  The drive was 100× slower than normal.
> Then I did a parity check, which gave all those mismatch errors.  A fsck
> went through without errors.
> 
> Replacement drives are in the drawer. It will go in tomorrow.
> 
> When I now do a resync with the new drive, how will those mismatches be
> resolved?

I'm not sure. Neil? I'm guessing that if all four data chunks have 
survived, parity will be recalculated, and everything is hunky-dory. But 
every third block is a parity. So you'll lose one block in three, 
because raid-6 can recover two missing pieces of information, but here 
we have three - a missing block (the failed drive), a corrupt block, and 
we don't know which block is corrupt.
> 
> I was thinking of pulling each of the remaining drives in turn, --assemble
> --readonly, and see how the affected files are different,  If all failures
> are on a single drive, I can --fail that drive too before the resync.

That's a lot of work that will almost certainly be a waste of time. The 
likely cause is parity being messed up on write, so that will be spread 
across drives.
> 
> Will a -A --readonly assembled RAID be truly read-only?  When I plug a
> pulled drive back in, will the RAID accept it?
> 
Well, if you don't mount the partition, or you mount that read-only, 
nothing is going to write to it.

> The --fail-ed drive is still readable, slowly.  Unfortunately it is now
> out of date.

Okay. Can you mount the partition read-only and stop it getting even 
more out-of-date?

Copy the dud drive with ddrescue, and then put it into the array with 
--re-add. Hopefully it will do a re-add, not an add. And then you'll 
have recovered pretty much everything you can.
> 
>> But as for finding out which files may have been corrupted, you want to
>> use the tools that come with the filesystem, and ask it which files use
>> sectors 1460408-1460416. Don't worry about the underlying raid.
>> Hopefully those tools will come back and say those sectors are unused.
> 
> If it were that easy …
> 
>> If they ARE used, the chances are it's just the parity which is corrupt.
>> Otherwise you're looking at a backup ...
> 
> No backup.  The computer center needs to backup several multi TByte
> filesystems for our group.  This is one of the filesystems where
> everybody is told not to put irreplaceable data.  As if anybody will
> listen to what I say.

Well, unfortunately, they're going to learn the hard way ...
> 
>> (I gather such errors are reasonably common, and do not signify a
>> problem. On a live filesystem they could well be a collision between a
>> file write and the check ...)
> 
> So you say it may all be errors in the parity only?  This helps for 5/6th
> of the data, not the chunks where the actual data was pulled.
> 
Auf wiederhoren,
Wol
