From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Power Outage and Recovery
Date: Fri, 4 Jun 2004 11:23:41 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16575.53021.158720.522017@cse.unsw.edu.au>
References: <1925.66.230.1.56.1086292161.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephen Hargrove on Thursday June 3
To: stephen@exitwound.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday June 3, stephen@exitwound.org wrote:
> 
> # mdadmin --assemble --scan
> mdadm: no devices found for /dev/md0
> 
> Do I need to run reiserfsck on each of the four drives?  How should I
> proceed in order to recover my array?

No.

> 
> If I've left out anything important, just let me know and I'll be glad to
> supply it.

cat /proc/partitions
mdadm -E /dev/hd?1

might help.

NeilBrown
