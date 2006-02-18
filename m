From: Neil Brown <neilb@suse.de>
Subject: Re: component devices too large
Date: Sun, 19 Feb 2006 10:13:05 +1100
Message-ID: <17399.43521.951471.838911@cse.unsw.edu.au>
References: <1140298102.2932.23.camel@fritzdesk.potsdam.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jeff Hardy on Saturday February 18
Sender: linux-raid-owner@vger.kernel.org
To: Jeff Hardy <hardyjm@potsdam.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday February 18, hardyjm@potsdam.edu wrote:
> I'm running 2.6.14.6 with CONFIG_LBD yes, with access to some pretty
> large AoE block devices.  When I try to create a RAID1 between a couple
> of block devices larger than 4TB, mdadm complains with:
> 
> mdadm: devices too large for RAID level 1
> 
> As long as I back the size down to 4TB or less, it will work.  This is a
> bit confusing, because I searched through the archives and did not find
> much mention of max RAID size limits except for this about a 2TB maximum
> size for RAID5 component devices:
> 
> http://marc.theaimsgroup.com/?l=linux-raid&m=112782802028969&w=2
> 
> Mdadm (1.11.0 and newer) does this maximum size check for anything
> higher than RAID level 0, so I would assume RAID1 and RAID5 would be the
> same.
> 
> Apologies if this is obvious but: what is the current actual size limit
> for component devices in RAID levels greater than zero?

The amount of each component drive this is actually in use is stored -
in the default metadata - in a 32bit number as kilobytes.
This sets a limit of 4TB.

The version-1 metadata format has a 64bit field.

If you use mdadm 2.3, it will automatically select version-1 metadata
if you choose a size larger than 2TB (I think).
You might also need a very recent (16-rc) kernel for v.large raid1 to
work.  There were bugs related to this usage pattern that were fixed
only recently.

To avoid resyncing >4TB, use of a write-intent-bitmap is strongly
recommended. 

NeilBrown
