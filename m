From: Neil Brown <neilb@suse.de>
Subject: Re: raid6 and parity calculations
Date: Wed, 15 Sep 2010 20:26:27 +1000
Message-ID: <20100915202627.12752443@notabene>
References: <20100914144540.25913.qmail@s217.sureserver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100914144540.25913.qmail@s217.sureserver.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Sallaway <michael@sallaway.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 14 Sep 2010 14:45:40 +0000
"Michael Sallaway" <michael@sallaway.com> wrote:

> Hi,
> 
> I've been looking through the drivers/md code, and I've got a few questions about the RAID6 parity calculations that have me stumped.
> 
> I can see that when recovering 1 or 2 data sections, it calls functions based on the content that we're recovering (eg. async_gen_syndrome, async_xor, async_raid6_datap_recov, etc.) However, the length parameter is always given as STRIPE_SIZE, which from what I can tell is the same as PAGE_SIZE, which for vanilla systems like the one I'm playing with is 4096 bytes.
> 
> The thing that I can't figure out is how this interacts with the RAID6 chunk size; the array I'm playing with has a default chunk size (64kb), which I understand means that there's 64kb of data striped across each disk (bar two), then 64kb of P, then 64kb of Q for the first stripe, correct? If so, I can't figure out where the whole parity calculation is done for all 64kb. There's no loops, no recursion, or anything that would process it that I can find. I'm obviously missing something here, can anyone enlighten me?
> 
> Thanks for any advice or pointers!

It is best not to think to think to much about chunks.  Think about strips
(not stripes).
A strip is a set of blocks, one per device each at the same offset.
Think of page sizes blocks/strips.
Each strip has a P block and a Q block and a bunch of data blocks.  Which
is P and which is Q and which each data block is a function of the offset,
the layout and the chunk size.  Once you have used the chunksize to perform
that calculation, don't think about chunks any more - just blocks and strips.

Hope that helps.

> 
> Cheers,
> Michael
> 
> 
> (as a side note: I'm playing with all this as I've managed to royally screw up an array which had 2 dropped drives, by readding them back in (in what appears to be the wrong order). That would have been fine if thr rebuild finished completely, however the rebuild failed a few percent in, so now I have 2 drives with "swapped" data. That is, drive A contains the data for raid member 4 for the first x%, and raid member 5 for the rest, and drive B contains the data for raid member 5 for the first x% and raid member 4 for the rest. So I'm trying to write a userspace program to manually go through the array members, inspecting each stripe, and manually doing parity calculations for a range of drive permutations to try and see what looks sensible, hence I'm trying to understand what's ON the dr
 ive to reverse engineer it.)

Ouch... good luck.

NeilBrown


> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

