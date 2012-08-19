From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: md raid behavior, bad sector uncorrectable read error
Date: Sun, 19 Aug 2012 11:47:35 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1208191145230.27104@uplift.swm.pp.se>
References: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E06D7FC-092A-4CB6-B79C-7EC94424DEEE@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 18 Aug 2012, Chris Murphy wrote:

> If the affected chunk is rebuilt from parity (or copy in case of 
> mirror), does md raid issue a write command to write the rebuilt chunk 
> back to the disk at the same LBAs? If so, shouldn't this force the drive 
> to determine if the sector error is transient or persistent, and if 
> persistent the disk firmware will remap the bad sector to a reserve 
> sector?

If I remember correctly from what has been described here before, a read 
error will cause a re-write with information created from parity, and the 
drive should figure it out (either is successfully writes the new 
information to the existing sector, or if it can't, it writes it to a 
spare sector (re-map)). If it throws a write error, the drive is kicked 
from the array (because a drive with write errors is clearly defective).

So yes, you're correct in your assumption from what I know.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
