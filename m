From: Scott Long <scott_long@adaptec.com>
Subject: Re: 3ware escalade vs software raid, from a different jeff
Date: Thu, 19 Feb 2004 15:33:59 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <403539D7.30202@adaptec.com>
References: <Pine.GSO.4.33.0402191508420.28488-100000@sweetums.bluetronic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.GSO.4.33.0402191508420.28488-100000@sweetums.bluetronic.net>
To: Ricky Beam <jfbeam@bluetronic.net>
Cc: Michael <michael@insulin-pumpers.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Ricky Beam wrote:
> On Thu, 19 Feb 2004, Michael wrote:
>  >Bear in mind that what you are calling "true hardware raid" is really
>  >a microprocessor programmed to do the raid algorithims.
> 
> 3ware has custom designed matrix switch chips to handle each IDE drive.
> This *alone* is worth the cost of the card.  The RAID parity calculations
> are also done in hardware (not a bunch of CPU xor's.)  You'd be 
> surprised how
> much data a small "slow" processor can move when properly programmed.
> 

Are you talking about host-processor XOR or adapter card XOR?  The i960
processor used in practically every RAID card known to man right now has
an XOR engine in the memory controller.  It's not quite as efficient as
some higher-end implementations, but it's a heck of a lot better than
having that i960 core spin through an XOR software loop.

Scott

