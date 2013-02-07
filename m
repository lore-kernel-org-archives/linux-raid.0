From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: RAID performance
Date: Thu, 07 Feb 2013 21:19:36 +1100
Message-ID: <51137FB8.6060003@websitemanagers.com.au>
References: <51134E43.7090508@websitemanagers.com.au> <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKHEz2YLpyyqo-3XX=pX+D49QP1Y0DNaKcBN=9tPQDjmHAPfdw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Cundiff <syshackmin@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/13 20:07, Dave Cundiff wrote:
> On Thu, Feb 7, 2013 at 1:48 AM, Adam Goryachev
> <mailinglists@websitemanagers.com.au> wrote:
> Why would you plug thousands of dollars of SSD into an onboard
> controller? It's probably running off a 1x PCIE shared with every
> other onboard device. An LSI 8x 8 port HBA will run you a few
> hundred(less than 1 SSD) and let you melt your northbridge. At least
> on my Supermicro X8DTL boards I had to add active cooling to it or it
> would overheat and crash at sustained IO. I can hit 2 - 2.5GB a second
> doing large sequential IO with Samsung 840 Pros on a RAID10.

Because originally I was just using 4 x 2TB 7200 rpm disks in RAID10, I
upgraded to SSD to improve performance (which it did), but hadn't (yet)
upgraded the SATA controller because I didn't know if it would help.

I'm seeing conflicting information here (buy SATA card or not)...

>> 2) Move from a 5 disk RAID5 to a 8 disk RAID10, giving better data
>> protection (can lose up to four drives) and hopefully better performance
>> (main concern right now), and same capacity as current.
> 
> I've had strange issues with anything other than RAID1 or 10 with SSD.
> Even with the high IO and IOP rates of SSDs the parity calcs and extra
> writes still seem to penalize you greatly.

Maybe this is the single threaded nature of RAID5 (and RAID10) ?

> Also if your kernel does not have md TRIM support you risk taking a
> SEVERE performance hit on writes. Once you complete a full write pass
> on your NAND the SSD controller will require extra time to complete a
> write. if your IO is mostly small and random this can cause your NAND
> to become fragmented. If the fragmentation becomes bad enough you'll
> be lucky to get 1 spinning disk worth of write IO out of all 5
> combined.

This was the reason I made the partition (for raid) smaller than the
disk, and left the rest un-partitioned. However, as you said, once I've
fully written enough data to fill the raw disk capacity, I still have a
problem. Is there some way to instruct the disk (overnight) to TRIM the
extra blank space, and do whatever it needs to tidy things up? Perhaps
this would help, at least first thing in the morning if it isn't enough
to get through the day. Potentially I could add a 6th SSD, reduce the
partition size across all of them, just so there is more blank space to
get through a full day worth of writes?

Regards,
Adam

-- 
Adam Goryachev
Website Managers
www.websitemanagers.com.au
