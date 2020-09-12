Return-Path: <SRS0=Qcx5=CV=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35858C43461
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 17:34:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C8A21531
	for <linux-raid@archiver.kernel.org>; Sat, 12 Sep 2020 17:34:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbgILReP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 12 Sep 2020 13:34:15 -0400
Received: from li1843-175.members.linode.com ([172.104.24.175]:40678 "EHLO
        mail.stoffel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725838AbgILReO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 12 Sep 2020 13:34:14 -0400
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Sep 2020 13:34:14 EDT
Received: from quad.stoffel.org (066-189-075-104.res.spectrum.com [66.189.75.104])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.stoffel.org (Postfix) with ESMTPSA id 7C02421347;
        Sat, 12 Sep 2020 13:28:31 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
        id B4BD0A6665; Sat, 12 Sep 2020 13:28:30 -0400 (EDT)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <24413.1342.676749.275674@quad.stoffel.home>
Date:   Sat, 12 Sep 2020 13:28:30 -0400
From:   "John Stoffel" <john@stoffel.org>
To:     antlists <antlists@youngman.org.uk>
Cc:     Brian Allen Vanderburg II <brianvanderburg2@aim.com>,
        linux-raid@vger.kernel.org
Subject: Re: Linux raid-like idea
In-Reply-To: <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
References: <1cf0d18c-2f63-6bca-9884-9544b0e7c54e.ref@aim.com>
        <1cf0d18c-2f63-6bca-9884-9544b0e7c54e@aim.com>
        <e3cb1bbe-65eb-5b75-8e99-afba72156b6e@youngman.org.uk>
        <ef3719a9-ae53-516e-29ee-36d1cdf91ef1@aim.com>
        <5F54146F.40808@youngman.org.uk>
        <274cb804-9cf1-f56c-9ee4-56463f052c09@aim.com>
        <ddd9b5b9-88e6-e730-29f4-30dfafd3a736@youngman.org.uk>
        <38f9595b-963e-b1f5-3c29-ad8981e677a7@aim.com>
        <9220ea81-3a81-bb98-22e3-be1a123113a1@youngman.org.uk>
X-Mailer: VM 8.2.0b under 26.1 (x86_64-pc-linux-gnu)
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

>>>>> "antlists" == antlists  <antlists@youngman.org.uk> writes:

antlists> On 11/09/2020 21:14, Brian Allen Vanderburg II wrote:
>> That's right, I get the various combinations confused.  So does raid61
>> allow for losing 4 disks in any order and still recovering? or would
>> some order of disks make it where just 3 disks lost and be bad?
>> Iinteresting non-the-less and I'll have to look into it.  Obviously it's
>> not intended to as a replacement for backing up important data, but, for
>> me any way, just away to minimize loss of any trivial bulk data/files.

antlists> Yup. Raid 6 has two parity disks, and that's mirrored to give four 
antlists> parity disks. So as an *absolute* *minimum*, raid-61 could lose four 
antlists> disks with no data loss.

antlists> Throw in the guarantee that, with a mirror, you can lose an entire 
antlists> mirror with no data-loss, that means - with luck and a following wind - 
antlists> you could lose half your disks, PLUS the two parities in the remaining 
antlists> disks, and still recover your data. So with a raid-6+1, if I had twelve 
antlists> disks, I could lose EIGHT disks and still have a *chance* of recovering 
antlists> my array. I'm not quite sure what difference raid-61 would make.

Of course your useful storage is 12/2 -2 = 4 disks, so only 33%
useable space.  Not very good.  At that point, I'd just go with RAID 1
pairs and striped together with RAID 0 (RAID 1+0) for only a 50% loss
of space.  Now if I lose the wrong four disks, I'm screwed, as opposed
to before where I can lose *any* four disks.

The problem with RAID6 is that random small IO writes have terrible
performance.  RAID1+0 gives you much better performance.  Arstechnica
had a great article on this earlier in the year that disk actual testing.

I think (and haven't done the math) that Erasure encoding gives you
better protection as you scale.  And I've even thought about glusterfs
or cephfs for home storage using a bunch of small single board
computers each talking to one disk for storage.  But... it's hard to
justify.

These days, I think it's better for your main storage to be a three
way mirror for the important stuff, performance wise.  And RAID6 with
hot spare for your large streaming collections like videos and such.
But even then... it's hard to justify since it costs alot.

antlists> (That says to me, if I have a raid-61, I need as a minimum a complete 
antlists> set of data disks. That also says to me, if I've splatted an 8+2 raid-61 
antlists> across 11 disks, I only need 7 for a full recovery despite needing a 
antlists> minimum of 8, so something isn't quite right here... I suspect the 7 
antlists> would be enough but I did say my mind goes Whooaaa!!!!)


>> It would be nice if the raid modules had support for methods that could
>> support a total of more disks in any order lost without loosing data.
>> Snapraid source states that it uses some Cauchy Matrix algorithm which
>> in theory could loose up to 6 disks if using 6 parity disks, in any
>> order, and still be able to restore the data.  I'm not familiar with the
>> math behind it so can't speak to the accuracy of that claim.

antlists> That's easy, it's just whether it's worth it. Look at the
antlists> maths behind raid-6. The "one parity disk" methods, 4 or 5,
antlists> just use XOR. But that only works once, a second XOR parity
antlists> disk adds no new redundancy and is worthless. I'm guessing
antlists> raid-6 uses that Cauchy method you talk about - certainly it
antlists> can generate as many parity disks as you like ... so that
antlists> claim is good, even if raid-6 doesn't use that particular
antlists> technique.

antlists> If someone wants to, mod'ing raid-6 to use 3 parity disks
antlists> shouldn't be that hard ...

It's not, but there's diminishing returns because you now have to do
the RMW cycle across even more disks, which is slow.  

antlists> But going back to your original idea, I've been thinking
antlists> about it. And it struck me - you NEED to regenerate parity
antlists> EVERY TIME you write data to disk! Otherwise, writing one
antlists> file on one disk instantly trashes your ability to recover
antlists> all the other files in the same position on the other
antlists> disks. WHOOPS! But if you think it's a good idea, by all
antlists> means try and do it.

Correct.  When compute parity, you do it across blocks.  And the
parity calculation is effectively free these days.  The cost comes
from the (on disks at least) rotational latency to read the entire
stripe across all the disks, modify one to N bytes in that stripe,
then re-writing the stripe back to all the disks.  That's alot of IO.

With RAID1, you just make two writes, one to each disk.  Done.  Even
with a three way mirror, it's simpler.

Now the RAID6 works better if you are replacing the entire stripe,
then you can drop your IOs in half, but you still need to write chunks
to different disks.

This is why big vendors have log based filesystems (Netapp, EMC,
Isilon, etc) with battery backed RAM caches, so they can A) tell the
client the writes are done, B) collect large changes into bigger
chunks, and C) write them in linear fashion down to the disk.

Log based filesystems are great for this.  Until they get fragmented.
SSDs help in that they really don't have a seek cost at all, so you
can handle fragmentation better.  BUT!  SSDs are generally written
assuming 512 byte blocks, but the underlying SSDs now generally use 4k
blocks on the NAND flash, so there's another layer of fragmentation
and wear levelling and other stuff happening outside your control
there as well.  

antlists> The other thing I'd suggest here, is try and make it more
antlists> like raid-5 than raid-4. You have X disks, let's say 5. So
antlists> one disk each is numbered 0, 1, 2, 3, 4. As part of
antlists> formatting the disk ready for raid, you create a file
antlists> containing every block where LBA mod 5 equals disk
antlists> number. So as you recalculate your parities, that's where
antlists> they go.

RAID4 suffers from the parity disk becoming a super hot spot, since it
needs to get written to no matter what.  No one uses it.

Until we can get back to cost effective SSDs using SLC NAND, RAID is
here to stay.  And so is mirroring since it does help protect from
alot of issues, both permanent and temporary.

I had one of my 4tb disks fall out of my main VG, but I didn't lose
and data, I just checked the disk and added it back in.  I've got a
new 4tb disk on order along with a drive cage so I can balance things
better.

But it's almost to the point where it's cheaper to buy a pair of 8tb
drives to replace the 4x4tb drives I'm using now.  But I probably
won't.

I could  write for hours here... it's a tough problem space to work
through.

John
