From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: sd takes drive offline but md does not know
Date: Sun, 30 Nov 2008 20:34:05 +1300
Message-ID: <493241ED.70402@sauce.co.nz>
References: <4930FB21.2070108@sauce.co.nz> <A20315AE59B5C34585629E258D76A97C02D77A42@34093-C3-EVS3.exchange.rackspace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A20315AE59B5C34585629E258D76A97C02D77A42@34093-C3-EVS3.exchange.rackspace.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Lethe <david@santools.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

David Lethe wrote:

> What firmware, drivers & BIOS is the LSI controller running, and what is
> exact model number?

The card is the  SAS3442E-R using the B3 version of the 1068 controller 
and has the latest public versions of BIOS and IT version of the firmware.

> Several things to consider
>  - if you enabled SMART rather than telling the controller to enable
> SMART for the individual drives, then this will cause a problem
> depending on specifics of what you have .. especially if the controller
> is running the RAID firmware.
>  - There are firmware issues with some LSI chipsets and
> driver/bios/MPT-library revision logic which can cause bus resets.   In
> this case, the bus reset made the controller think the disk timed out to
> whatever I/O operations the LSI controller told it to perform ... so the
> controller took disk to offline state.


At this stage I am no longer concerned about using smartmontools - the 
card has performed flawlessly in all other respects, so I will avoid it 
in future.

I am concerned that when the drive was offlined, md was not made aware 
of it. Perhaps this is to be expected?

Unfortunately this machine is in production now, so I cannot really 
participate in any more testing/debugging.

Regards,

Richard
