Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 883DCC3DA78
	for <linux-raid@archiver.kernel.org>; Sun, 15 Jan 2023 21:56:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231488AbjAOV4u (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 15 Jan 2023 16:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjAOV4o (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 15 Jan 2023 16:56:44 -0500
Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BF3718174
        for <linux-raid@vger.kernel.org>; Sun, 15 Jan 2023 13:56:42 -0800 (PST)
Received: from host86-138-24-20.range86-138.btcentralplus.com ([86.138.24.20] helo=[192.168.1.65])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1pHAzX-000Bhn-FN;
        Sun, 15 Jan 2023 21:56:40 +0000
Message-ID: <b397091a-e82c-070b-04d7-f2a13521dc39@youngman.org.uk>
Date:   Sun, 15 Jan 2023 21:56:39 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: Parity distribution when adding disks to md-raid6
To:     boscabeag <boscabeag@protonmail.com>,
        anthony <antmbox@youngman.org.uk>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
References: <A73A8YRNkUS11zoz7eEaNfvnfZqyj6-vP-7mvI6_FFLdSETs_g6CFYgIL_PyV0F8AE6cXMomd7SznnsQDGQqwLuSJFMi8EbxGzxibvYjZ2s=@protonmail.com>
 <7ef4bb85-2d0f-8f1a-7fb7-336142acf405@youngman.org.uk>
 <moIqP54ll6VYnb_ngZT_xyboobMPrU3-h5c5-J6WUPVBsFvt40THsGFwYdOObavZ3OF2StdVWZpNOTTnVbldJXK8u-gVxSpRgnBFCGkoqvg=@protonmail.com>
Content-Language: en-GB
From:   Wol <antlists@youngman.org.uk>
In-Reply-To: <moIqP54ll6VYnb_ngZT_xyboobMPrU3-h5c5-J6WUPVBsFvt40THsGFwYdOObavZ3OF2StdVWZpNOTTnVbldJXK8u-gVxSpRgnBFCGkoqvg=@protonmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 15/01/2023 21:25, boscabeag wrote:
> On Sunday, January 8th, 2023 at 22:20, anthony <antmbox@youngman.org.uk> wrote:
> 
>> I'm GUESSING you're trying to move from a non-raid setup.
> 
> First of all, thank you for taking the time to respond.
> 
> But no, I really am just asking about how and when the parity chunks get distributed across a new device when a md-raid6 group is grown.
> 
> There was a time when some raid systems (not naming names, and if I remember correctly) would NOT re-distribute parity chunks on a grown group.  If the group was built with devices A, B, C, & D, then the parity chunks would remain on those four devices, and added devices E & F, etc. would only ever have data chunks, since the placement of parity chunks in a stripe was only done at initial group creation time, even if the stripe was extended to additional devices.
> 
> I'm not questioning that growing a md-raid group works and is fully functional.  This is very much a "what happens behind the curtain" question.
> 
> I don't know how md-raid6 works at this low and internal level, hence the question.
> 
> Does the re-sync triggered by the grow re-write the entirety of all stripes and some P & Q chunks get moved to the new device?

Yes.
> 
> If the re-sync does change some P & Q chunks to data chunks to place those parity chunks on the new device, is the layout identical to what it would be if the group was created with all devices instead of being grown?
> 
NO! And this is what bites people who've got an old array that has been 
grown and shrunk and generally moved around a couple of times.

> Does it happen when a stripe is re-written through normal activity?  this implies if a stripe never gets any write activity, it will never re-layout the location of its P & Q chunks.
> 
When you add new devices, the array gets rebuilt. Completely.

While I may not have got the fine detail correct (I don't know the code) 
it goes pretty much as follows ...

I'll start with the assumption that your original array was built 
cleanly on four drives. Now you add two new drives. So three stripes on 
the old array are two stripes on the new one ...

The first thing mdadm will do is lock the first three stripes. It can 
then back them up into spare space. Lastly it rewrites them as two 
stripes, and unlocks the new stripes. This is what's called the 
"window". We now have the start of a new array, and the end of the old 
array, with a blank stripe inbetween. the raid is still fully 
functional, fully redundant, etc etc.

It then locks the next three stripes from the old array, backs them up, 
writes them into the new array, moves the window and unlocks. Once again 
we have an array that is a mix of old and new, fully functional, fully 
redundant, etc etc.

Now the next three stripes get locked, rewritten and unlocked. We no 
longer need to back them up, because while the first two lots the old 
and new overlapped and a crash would have lost data in flight, now 
there's no overlap between old and new.

So the rewrite window slowly moves through the array - any read-writes 
into the window have to wait, accesses below the window access the new 
array, accesses above the window access the old array. When the rewrite 
completes, you have a complete, consistent, new 6-drive array.

If the changes shrink the array, the rewrite starts from the top down, 
again to minimise the need for backing up stripes.


The reason I said people with older arrays get bitten is that this 
moving around can change all sorts of drive parameters - like where the 
data starts (its offset) in the partition, and the default offset has 
been known to change too. There's other gotchas like that too I believe.

But the takeaway you're after is yes, the array is rebuilt, and you end 
up with a layout pretty close to what a new clean build would have given 
you.

Cheers,
Wol
