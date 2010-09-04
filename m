From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: the true behavior of mdadm's raid-1 with regard to vertical
 parity and silent error detection/scrubbing- confirmation or feature
 request
Date: Sat, 4 Sep 2010 20:56:21 +0200 (CEST)
Message-ID: <alpine.DEB.1.10.1009042054110.13746@uplift.swm.pp.se>
References: <4C6B59F6.5020001@silcon.com> <4C829240.1080600@tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C829240.1080600@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: "Brett L. Trotter" <brett@silcon.com>, linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Sat, 4 Sep 2010, Bill Davidsen wrote:

> This has been discussed to death, I don't see any changes coming.

True. If someone really wants this (for instance 64k on drive using 4k ECC 
data for a total of 68k per stripe) and are willing to put either money on 
the table for someone to write it, or someone is volunteering, I don't see 
this coming either.

If someone is willing to actually code (or have it coded) then a 
discussion should first happen if such a change would be accepted.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
