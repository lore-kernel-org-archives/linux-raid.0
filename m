From: Neil Brown <neilb@suse.de>
Subject: Re: Raid5 reshape
Date: Sat, 17 Jun 2006 08:28:41 +1000
Message-ID: <17555.12441.42212.93049@cse.unsw.edu.au>
References: <449250ED.7090302@irule.net>
	<17554.21119.487820.638171@cse.unsw.edu.au>
	<4492D5B1.60004@nigelterry.net>
	<4492D8D9.7010101@irule.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tim T on Friday June 16
Sender: linux-raid-owner@vger.kernel.org
To: Tim T <irule@irule.net>
Cc: "Nigel J. Terry" <nigel@nigelterry.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday June 16, irule@irule.net wrote:
> You have to grow the ext3 fs separately. ext2resize /dev/mdX. Keep in 
> mind this can only be done off-line.
> 

ext3 can be resized online. I think ext2resize in the latest release
will "do the right thing" whether it is online or not.

There is a limit to the amount of expansion that can be achieved
on-line.  This limit is set when making the filesystem.  Depending on
which version of ext2-utils you used to make the filesystem, it may or
may not already be prepared for substantial expansion.

So if you want to do it on-line, give it a try.... or ask on the
ext3-users list for particular details on what versions you need and
how to see if your fs can be expanded.

NeilBrown
