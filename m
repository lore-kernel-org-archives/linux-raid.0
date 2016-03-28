From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: Looking to pick PCIe x4/x8 4+ SATA expansion card recommendation.
Date: Mon, 28 Mar 2016 21:35:41 +0200
Message-ID: <20160328193541.GA9502@EIS>
References: <56F97B91.4070302@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <56F97B91.4070302@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 28, 2016 at 01:44:33PM -0500, Ram Ramesh wrote:
> The recommendations typically go for PCIe x1-2port type cards

Well, an 8 port card (like HP H220 or similar) is a bit too 
expensive if all you need is two more slots, and it's not 
like mdadm is picky - anything goes, well, as long as it
meets minimum requirements (no I/O errors etc)...

If you're looking for something on an even larger scale, 
maybe have a look at the Backblaze Storage Pod blog posts. 
Although the hardware they use seems to be hard to get,
it might give you some ideas.

They actually use port multipliers, I actually wish they 
were as widespread (and as cheap) as USB hubs, so we all 
could simply put three or four disks to a single SATA port,
but alas...

Maybe next time.

Regards
Andreas Klauer
