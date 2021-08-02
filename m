Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73320C4338F
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 18:31:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4AB0160F58
	for <linux-raid@archiver.kernel.org>; Mon,  2 Aug 2021 18:31:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbhHBSb4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 Aug 2021 14:31:56 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:12445 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229537AbhHBSbz (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 2 Aug 2021 14:31:55 -0400
Received: from host86-162-184-27.range86-162.btcentralplus.com ([86.162.184.27] helo=[192.168.1.64])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1mAcj0-0008YS-G1; Mon, 02 Aug 2021 19:31:43 +0100
Subject: Re: help channel for md raid?
To:     =?UTF-8?Q?Stephan_B=c3=b6ttcher?= <boettcher@physik.uni-kiel.de>,
        linux-raid@vger.kernel.org
References: <s6n8s1j6he9.fsf@falbala.ieap.uni-kiel.de>
From:   Wols Lists <antlists@youngman.org.uk>
X-Enigmail-Draft-Status: N1110
Message-ID: <6108398C.3020509@youngman.org.uk>
Date:   Mon, 2 Aug 2021 19:29:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.7.0
MIME-Version: 1.0
In-Reply-To: <s6n8s1j6he9.fsf@falbala.ieap.uni-kiel.de>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 02/08/21 15:38, Stephan Böttcher wrote:
> 
> Moin!
> 
> May I ask a question on this list, or is this strictly for development?

Ask away!
> 
> Thanks,
> Stephan
> 
> 
> My qustion is how to translate sector numbers from a RAID6 as in
> 
>> Aug  2 01:32:28 falbala kernel: md8: mismatch sector in range 1460408-1460416
> 
> to ext4 inode numbers, as in
> 
>> debugfs: icheck 730227 730355 730483 730611
>> Block   Inode number
>> 730227  30474245
>> 730355  30474245
>> 730483  30474245
>> 730611  30474245
> 
> Is there a list, channel, matrix room for this kind of questions?
> Are there tools to do what I need?
> Is the approach below sensible?
> 
> It is a RAID6 with six drives, one of them failed.
> A check yielded 378 such mismatches.
> 
> I assume the sectors count from the start of the `Data Offset`.
> `ext4 block numbers` count from the start of the partition?
> Is that correct?

md8 is your array. This is the block device presented to your file
system so you're feeding it 730227, 730355, 730483, 730611, these are
the sector numbers of md8, and they will be *linear* within it.

So if you're trying to map filesystem sectors to md8 sectors, they are
the same thing.

Only if you're trying to map filesystem sectors to the hard drives
underlying the raid do you need to worry about the 'Data Offset'. (And
this varies on a per-drive basis!)
> 
> The failed drive has >3000 unreadble sectors and became very slow.

So you've removed the drive? Have you replaced it? If you have a drive
fail again, always try and replace it using the --replace option, I
think it's too late for that now ...

But as for finding out which files may have been corrupted, you want to
use the tools that come with the filesystem, and ask it which files use
sectors 1460408-1460416. Don't worry about the underlying raid.
Hopefully those tools will come back and say those sectors are unused.
If they ARE used, the chances are it's just the parity which is corrupt.
Otherwise you're looking at a backup ...

So I think what you need to do is (1) find out which files use those
sectors, (2) replace that missing drive asap, and (3) check the
integrity of the file system with fsck. Then (4) do a repair scrub.

(I gather such errors are reasonably common, and do not signify a
problem. On a live filesystem they could well be a collision between a
file write and the check ...)

Cheers,
Wol
