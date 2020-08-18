Return-Path: <SRS0=fBal=B4=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35701C433E1
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 21:10:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BFECB20786
	for <linux-raid@archiver.kernel.org>; Tue, 18 Aug 2020 21:10:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=thehawken.org header.i=@thehawken.org header.b="ucdr2vo9"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbgHRVKC (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Aug 2020 17:10:02 -0400
Received: from asav22.altibox.net ([109.247.116.9]:45794 "EHLO
        asav22.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726176AbgHRVKA (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Aug 2020 17:10:00 -0400
X-Greylist: delayed 359 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Aug 2020 17:09:57 EDT
Received: from mx1.thehawken.org (unknown [51.175.209.245])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by asav22.altibox.net (Postfix) with ESMTPS id B1D89200CF
        for <linux-raid@vger.kernel.org>; Tue, 18 Aug 2020 23:03:56 +0200 (CEST)
Subject: Re: Feature request: Remove the badblocks list
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=thehawken.org; s=mail;
        t=1597784636; bh=DCwPv3hlBtGvUcXrxUD9sP84qcDcE+LnNctgxdYZT/4=;
        h=Subject:To:References:From:Date:In-Reply-To:From;
        b=ucdr2vo9MvOWo6iR6hzRjQRjITxq1g6QuCe62N2ixIV+2QD9YUIfTVCSvbpoanoRS
         k/6kw8HeasXnOJYIRKPTjRlV98wvVCe/0lcTmcITJNZgf/yL+Q5/2suV5um2Vl0Jrb
         SHOXKtrGgbV/ui/NjbkzOvsndk28vtE7xDQp5n8PcxOXkOl196Covx38ID7uGC2FCG
         QDCOLgP3GBN6IFv7n4MZ9wxvSx3mM4JiNojSDK9Do4IPg+JTqAdAjbcmxjSmR62Ft2
         eOp/Z6lvN1NyEui95pH8Ptbta0ptlwYop2KInD6p5xRzNBegEynzrxUVMnDNoc/sH8
         0dnyeGLglQPoQ==
To:     Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <75076966.1748398.1597773608869.JavaMail.zimbra@karlsbakk.net>
From:   =?UTF-8?Q?H=c3=a5kon_Struijk_Holmen?= <hawken@thehawken.org>
Message-ID: <001c5a42-93fd-eddb-ba86-aa3e2695f2a8@thehawken.org>
Date:   Tue, 18 Aug 2020 23:03:56 +0200
MIME-Version: 1.0
In-Reply-To: <75076966.1748398.1597773608869.JavaMail.zimbra@karlsbakk.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-CMAE-Score: 0
X-CMAE-Analysis: v=2.3 cv=YqEhubQX c=1 sm=1 tr=0
        a=PoiGM2p7BgezEa0kfMnBZQ==:117 a=PoiGM2p7BgezEa0kfMnBZQ==:17
        a=IkcTkHD0fZMA:10 a=M51BFTxLslgA:10 a=xucnYjTFAAAA:8 a=VwQbUJbxAAAA:8
        a=vAbZ888TAAAA:8 a=xW9sQpbIAAAA:8 a=oXsCWPmS-oDcOD98PoEA:9
        a=QEXdDO2ut3YA:10 a=YQZzFssXFEgA:10 a=-FEs8UIgK8oA:10 a=NWVoK91CQyQA:10
        a=Xlg7844Iomi71Cc9oUTC:22 a=AjGcO6oz07-iQ99wixmX:22
        a=AX-sWcMKBiCjnIDZ3bjJ:22 a=5pObmKSiyA3eC14532UV:22
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/18/20 8:00 PM, Roy Sigurd Karlsbakk wrote:

> Hi all

Hi,

Thanks for the CC, I just managed to get myself subscribed to the list :)

I have gathered some thoughts on the subject as well after reading up on it,
figuring out the actual header format is, and writing a tool [3] to fix my array...

About the tool, it will try to read all the supposedly bad blocks in a drive,
and erase the whole list if no blocks fail to read. As long as it's not run against
a drive that got marked because data was unavailable during rebuild, this
should make it possible to read the data again. A possible improvement here, would be to reduce
the size of the list down to the actually bad blocks if some still fail, but right now the tool
will refuse to do anything to the drive if md was correct. You also need to flip a variable that
I hid awkwardly between two functions before it will write to the drive at all.

But I have some complaints about the thing..


Good data marked as bad:

My viewpoint is from what happened to my raid array, a 5 drive raid6.
3 of the drives had identical lists of bad blocks while 2 had empty lists.
Therefore, the marked sectors corresponded to lost data. This was solved by
iterating the bad block list, verifying that all the sectors were in fact readable,
and then removing the bad block list. Since I did not have any drive replacements,
I was certain enough that I would not run into uninitialized space. This gave me back
the data that md had decided was gone.

I do not really think one can say that the md badblock list corresponds
to bad blocks on the device. The lists consists of sectors where
md thinks the data is permanently unavailable. It happens in two ways:
- A read error occurs for any reason
- A new drive is rebuilt, but the array doesn't have the parity to find out what
   data was supposed to go there, because badblock entries for other devices prevents
   it from finding a source for the data that it's supposed to write there. It's assumed
   that such reads would fail.

Since these are added to the same list of bad blocks, it follows that
even if you were to have a successful read from a bad block, it can also be uninitialized
space.

Once enough drives have bad blocks for the same stripe, that data is now gone. md will not read it.
Even if it's there on the drives. I can only speculate on what happened in my case,
so far I think that some intermittent controller failure caused any reads to give errors, and
somehow md was still able to write to the badblock list.

I think it's not just me, and it seems like it's a common phenomenon that arrays end up with
identical lists across drives. Be this controller failures, or just a bug, it's not good
and undermines the assumption that the underlying blocks will actually be bad.

9 years ago, Lutz Vieweg asked "I've experienced drives
with intermittent read / write failures (due to controller or power stability
problems), and I wonder whether such a situation could quickly fill up the
"bad block list", doing more harm than good in the "intermittent error"-
szenario." [1]. I have my doubts that this was resolved.

I also don't know if this is the cause of the issue with many drives sharing the exact same
list, or if some other logic error type bug is causing it.


md indicating all is good:

In the same URL, Neil Brown said "(...) You shouldn't aim to run an array
with bad blocks any more than you should run an array degraded. The purpose
of bad block management is to provide a more graceful failure path, not to
encourage you to run an array with bad drives". However, an array with
bad blocks does not report this as "degraded", and you have to run
--examine to even see it. The result is that the array is not being treated
as bad, having md communicate that the array is still good. The end result
being, the software encouraging running an array with bad drives.

If the assumption was that one would treat this as a degraded array. But
you have to --examine and specifically look for it to see that there are bad blocks.


Lack of documentation:

I have added some links in addition to the ones found by Roy. This was the extent
of the documentation that I was able to find. I'll be interested if this is documented
better elsewhere. The kernel documentation also briefly mentioned the existence of bad
block lists in mdraid. The wiki article on the superblock format [5] hasn't been updated
with the badblock fields. The 2010 blog post [4] was the closest thing to documentation,
even if it was written before the thing was finalized.


Overall:

I don't think this uncertainty is good at all. I feel like it would be easier to deal with
a controller failure throwing the whole raid apart. You'd assemble it back together and
check the filesystem, and with fingers crossed, everything will be fine. I think one
finds that it makes sense how md acts without this algorithm enabled. Drives thrown out
of arrays still have data on them. This means that if unrecoverable errors occur, one can
still run ddrescue and try to copy the array to new drives, one by one and get as much data
back as possible.

Once you hit a bad block during read, adopting the zfs model of calculating parity and
overwriting seems better because it tries to just solve the problem so it doesn't happen
the next time around. I think md will throw it in the list and expect it to be fixed during
the next check operation. Unless that doesn't happen and more bad blocks accumulate until
data loss happens..

I would also like to see the functionality changed to opt-in or just removed. If it's kept as
opt-in, it still hope that some of this feedback is taken. For example, reporting the array
as degraded if the lists get populated. Automatically fixing bad blocks as soon as possible,
before the situation develops any further. Making the uninitialized data and the bad blocks
two separate things, so that one can still try reading those blocks and keep track of
where the data is supposed to be, and where it's definitely not.

Maybe dropping badblocks and taking inspiration from ZFS instead.

> [1] https://linux-raid.vger.kernel.narkive.com/R1rvkUiQ/using-the-new-bad-block-log-in-md-for-linux-3-1
> [2] https://raid.wiki.kernel.org/index.php/The_Badblocks_controversy
> [3] https://git.thehawken.org/hawken/md-badblocktool.git

[4]https://neil.brown.name/blog/20100519043730     

[5]https://raid.wiki.kernel.org/index.php/RAID_superblock_formats



Regards,
Håkon
     

