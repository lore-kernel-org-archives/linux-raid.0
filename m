From: Lutz Vieweg <lvml@5t9.de>
Subject: Re: Software RAID and TRIM
Date: Tue, 19 Jul 2011 11:29:20 +0200
Message-ID: <j03ipg$uqk$1@dough.gmane.org>
References: <alpine.OSX.2.00.1106281628320.257@trogdor.csi.cam.ac.uk> <iud06d$ad5$1@dough.gmane.org> <4E235984.2070704@5t9.de> <j012fa$6k6$1@dough.gmane.org> <j01ssr$j1i$1@dough.gmane.org> <j024fe$4va$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <j024fe$4va$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/18/2011 10:18 PM, David Brown wrote:
> You don't need to fill an erase block for writing - writes are done as write blocks (I think 4K is
> the norm).

You are right on that. Those sectors in a partially used
erase block that have not been written to since the last erase of the
whole erase block can be written to as good as sectors in completely
empty erase blocks.


> My main point about TRIM being expensive is the effect it has on the block IO queue, regardless of
> the implementation in the SSD.

Because of those effects on the block-IO-queue, the user-space work-around
we implemented to discard the SSDs our RAID-1s consist of will not discard
"one area on all SSDs at a time", but rather iterate first through all
unused areas on one SSD, then iterate through the same list of areas on the
second SSD.

The effect of this is very much to our liking: While we can see
near-100%-utilization on one SSD at a time during the discards,
the other SSD will happily service the readers, and even the writes that
go to the /dev/md* device are buffered in main memory long enough that we
do not really see a significantly bad impact on the service.
(This might be different, though, if the discards were done
during peak-write-load times of the day.)


> I really hope your SSD's return zeros for TRIM'ed blocks

For RAID-1, the only consequence of not doing so is just that "data-check" runs may result
in a > 0 mismatch_cnt. It does not destroy any of your data, and as long as I have
two SSDs in a RAID, both of which give a non-error result when reading a sector, I would
have no indication of "which of the returned sector contents to prefer", anyway.

(I admit that for health monitoring it is useful to have a meaningful mismatch_cnt.)

> and that you are sure all your TRIMs are
> in full raid stripes - otherwise you will /seriously/ mess up your raid arrays.

Again, for RAID0/1 (even 10) I don't see why this would harm any data.

Regards,

Lutz Vieweg


