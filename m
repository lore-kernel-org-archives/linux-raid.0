From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Sun, 17 Jul 2011 23:52:04 +0200
Message-ID: <4E235984.2070704@5t9.de>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <iud06d$ad5$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Brown wrote:
> However, AFAIUI, you are wrong about TRIM being essential for the 
> continued high performance of SSDs.  As long as your SSDs have some 
> over-provisioning (or you only partition something like 90% of the 
> drive), and it's got good garbage collection, then TRIM will have 
> minimal effect.

I beg to differ.

We are using SSDs in very much the way that Tom de Mulder intends,
and from our extensive performance measurements over many months
now I can say that (at least if you do have significant amounts
of write operations) it _does_ make a lot of difference whether you
periodically discard the unused sectors or not.
(For us, the write performance measured to be about half as good
when there are no free erase blocks available anymore.)

Of course, you can only benefit from discards if your filesystem
is not full (because then there is nothing to discard). But any
kind of "garbage collection" by the SSD itself will not have the
same effect, since it cannot know which blocks are in use by the
filesystem.

> I think other SSD-optimisations, such as those in BTRFS, are much more 
> important.

Actually, (apart from btrfs still being in development, not really
ready for production use, yet), XFS (-o delaylog,barrier) performs
better on our SSDs than btrfs - without any SSD-specific options.

What is really an important factor for SSD performance: The controller.
The same SSDs perform with significantly lower latency for us when
connected to SATA controller channels than when connected to SAS
controllers (and they perform abysmal when used as hardware-RAID
constituents, in comparison).

Regards,

Lutz Vieweg

