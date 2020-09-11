Return-Path: <SRS0=sV2i=CU=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5EA4C43461
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 19:16:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9B43E22208
	for <linux-raid@archiver.kernel.org>; Fri, 11 Sep 2020 19:16:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725783AbgIKTQb (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 11 Sep 2020 15:16:31 -0400
Received: from smtp.hosts.co.uk ([85.233.160.19]:62981 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgIKTQb (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 11 Sep 2020 15:16:31 -0400
Received: from host86-136-163-47.range86-136.btcentralplus.com ([86.136.163.47] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1kGoX5-0007LR-C3; Fri, 11 Sep 2020 20:16:28 +0100
Subject: Re: Linux raid-like idea
To:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        linux-raid@vger.kernel.org
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
 <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
 <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
 <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
 <5F54146F.40808@youngman.org.uk>
 <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
From:   antlists <antlists@youngman.org.uk>
Message-ID: <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
Date:   Fri, 11 Sep 2020 20:16:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/09/2020 16:14, Brian Allen Vanderburg II wrote:
> 
> On 9/5/20 6:42 PM, Wols Lists wrote:
>> I doubt I understand what you're getting at, but this is sounding a bit
>> like raid-4, if you have data disk(s) and a separate parity disk. People
>> don't use raid 4 because it has a nasty performance hit.
> 
> Yes it is a bit like raid-4 since the data and parity disks are
> separated.  In fact the idea could be better called a parity backed
> collection of independently accessed disks. While you would not get the
> advantage/performance increase of reads/writes going across multiple
> disks, the idea is primarily targeted to read-heavy applications, so in
> a typical use, read performance should be no worse than reading directly
> from a single un-raided disk, except in case of a disk failure where the
> parity is being used to calculated a block read on a missing disk.
> Writes would have more overhead since they would also have to
> calculate/update parity.

Ummm...

So let me word this differently. You're looking at pairing disks up, 
with a filesystem on each pair (data/parity), and then using mergefs on 
top. Compared with simple raid, that looks like a lose-lose scenario to me.

A raid-1 will read faster than a single disk, because it optimises which 
disk to read from, and it will write faster too because your typical 
parity calculation for a two-disk scenario is a no-op, which might not 
optimise out.
> 
>> Personally, I'm looking at something like raid-61 as a project. That
>> would let you survive four disk failures ...
> 
> Interesting.  I'll check that out more later, but from what it seems so
> far there is a lot of overhead (10 1TB disks would only be 3TB of data
> (2x 5 disk arrays mirrors, then raid6 on each leaving 3 disks-worth of
> data).  My currently solution since I'ts basically just storing bulk
> data, is mergerfs and snapraid, and from the documents of snapraid, 10
> 1TB disks would provide 6TB if using 4 for parity.  However it's parity
> calculations seem to be more complex as well.

Actually no. Don't forget that, as far as linux is concerned, raid-10 
and raid-1+0 are two *completely* *different* things. You can raid-10 
three disks, but you need four for raid-1+0.

You've mis-calculated raid-6+1 - that gives you 6TB for 10 disks (two 
3TB arrays). I think I would probably get more with raid-61, but every 
time I think about it my brain goes "whoa!!!", and I'll need to start 
concentrating on it to work out exactly what's going on.
> 
>> Also, one of the biggest problems when a disk fails and you have to
>> replace it is that, at present, with nearly all raid levels even if you
>> have lots of disks, rebuilding a failed disk is pretty much guaranteed
>> to hammer just one or two surviving disks, pushing them into failure if
>> they're at all dodgy. I'm also looking at finding some randomisation
>> algorithm that will smear the blocks out across all the disks, so that
>> rebuilding one disk spreads the load evenly across all disks.
> 
> This is actually the main purpose of the idea.  Due to the data on the
> disks in a traditional raid5/6 being mapped from multiple disks to a
> single logical block device, and so the structures of any file systems
> and their files scattered across all the disks, losing one more than the
> number of available lost disks would make the entire filesystem(s) and
> all files virtually unrecoverable.

But raid 5/6 give you much more usable space than a mirror. What I'm 
having trouble getting to grips with in your idea is how is it an 
improvement on a mirror? It looks to me like you're proposing a 2-disk 
raid-4 as the underlying storage medium, with mergefs on top. Which is 
effectively giving you a poorly-performing mirror. A crappy raid-1+0, 
basically.
> 
> By keeping each data disk separate and exposed as it's own block device
> with some parity backup, each disk contains an entire filesystem(s) on
> it's own to be used however a user decides.  The loss of one of the
> disks during a rebuild would not cause full data loss anymore but only
> of the filesystem(s) on that disk.  The data on the other disks would
> still be intact and readable, although depending on the user's usage,
> may be missing files if they used a union/merge filesystem on top of
> them.  A rebuild would still have the same issues, would have to read
> all the remaining disks to rebuild the lost disk.  I'm not really sure
> of any way around that since parity would essentially be calculated as
> the xor of the same block on all the data disks.
> 
And as I understand your setup, you also suffer from the same problem as 
raid-10 - lose one disk and you're fine, lose two and it's russian 
roulette whether you can recover your data. raid-6 is *any* two and 
you're fine, raid-61 would be *any* four and you're fine.
>>
>> At the end of the day, if you think what you're doing is a good idea,
>> scratch that itch, bounce stuff off here (and the kernel newbies list if
>> you're not a kernel programmer yet), and see how it goes. Personally, I
>> don't think it'll fly, but I'm sure people here would say the same about
>> some of my pet ideas too. Give it a go!
>>
Cheers,
Wol
