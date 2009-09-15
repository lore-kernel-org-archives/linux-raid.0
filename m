From: Alex Butcher <linraid@assursys.co.uk>
Subject: Re: Re-map disk sectors in userspace when rewriting after read
 errors
Date: Tue, 15 Sep 2009 08:37:52 +0100 (BST)
Message-ID: <alpine.LFD.2.00.0909150832000.5083@sbhezbfg.of5.nffheflf.cev>
References: <h8nbt5$n8p$1@ger.gmane.org> <alpine.LFD.2.00.0909150810510.5083@sbhezbfg.of5.nffheflf.cev> <h8nfoe$n8p$3@ger.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h8nfoe$n8p$3@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 15 Sep 2009, Matthias Urlichs wrote:

> On Tue, 15 Sep 2009 08:13:08 +0100, Alex Butcher wrote:
>
>> IME, discs don't remap after read errors, only on writes.
>
> Some may remap after recoverable read errors. However, the RAID code
> does (I assume - see below) rewrite the data -- which the disk happily
> acknowledges  -- only to report the very same error next time that spot's
> being read. :-(

Odd. If I hadn't observed something similar myself with a 40G Maxtor
(badblocks -w fails, wipe with dd if=/dev/zero, badblocks -w succeeds,
badblocks -w fails again), I wouldn't believe it.  SMART seems to think that
it's nowhere near the reallocated sector count threshold.  The only
conclusion I can come to is that the firmware is trash, or being way too
forgiving of inconsistently-performing spinning media.  Either way, it's not
suitable for data I even care a little bit about.

What does SMART say about reallocated and pending sectors on your disks? If
the reallocated threshold has been crossed, this might be the failure mode,
I guess.

What make/model are they?

>> Are you sure that refresh-writes triggered by read errors are expected
>> behaviour of md's RAID5/6 mode?
>
> Not 100%, no -- but recovering the data but otherwise ignoring the error
> (other than increment the error counter) would be a level of foolishness
> I won't assume of the RAID code's authors.

Well, the RAID code had been in the kernel and was being used in production
systems for quite some time before 2.6.15 came along. It took a BSD user to
point it out and a read through the kernel source for me to believe it...

Cheers,
Alex
