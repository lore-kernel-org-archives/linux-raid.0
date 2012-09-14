From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: raid1 issue after disk failure: both disks of the array are
 still active
Date: Fri, 14 Sep 2012 09:16:20 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
References: <5051AF17.8010501@linuxsystems.it> <20120913103432.GA11764@cthulhu.home.robinhill.me.uk> <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 13 Sep 2012, Chris Murphy wrote:

> "check" records errors, no action is taken by the md driver to correct 
> it, although the disk firmware itself may try reallocation. So far, that 
> appears to not be the case.
>
> "repair" causes the md driver to write correct data (from copy or 
> reconstructed from parity), which should force the disk firmware to 
> reallocate the affected LBAs from bad physical sectors to good ones.
>
> It seems in this case "repair" is indicated.

I was under the impression that "check" would check if all data blocks and 
parity are correct, and record if there is a parity mismatch. This would 
then be corrected by using "repair" at a later time.

I was also under the impression that if there was a read error on a drive 
during "check", that read error would be corrected using parity because 
it's obviously a hard error, not a logical error.

Could you (or someone else) please confirm that my impression is wrong and 
if there indeed is a hard read error using "check", this will not be 
corrected? I would be interested in knowing why this decision was taken to 
have this behaviour, as I feel that if there is a hard read error, this 
should always be corrected using parity.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
