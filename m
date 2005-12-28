From: Mike Hardy <mhardy@h3c.com>
Subject: Re: raid1: All my data completely vanished into the void
Date: Tue, 27 Dec 2005 20:33:03 -0800
Message-ID: <43B2157F.8030505@h3c.com>
References: <200512272340.48483.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200512272340.48483.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Mitchell Laks wrote:
> Hi,
> 
> I just set up a new server running stable Debian Sarge, fresh install,
> mdadm 1.9.0,  linux kernel 2.6.8-2 
> and all my (test) data has vanished into the ether. 
> 
> What did I do wrong? I don't want this to happen in real life :).


[ description of sane-looking md setup snipped ]

> Did I screw up everything by not unmounting the devices? What happened?

Failure to unmount the devices should have resulted in possibly last
writes but a journalling filesystem would have kept things consistent.

Failure to nicely stop the arrays also could have possibly degraged the
arrays if they were being written to as the machine went down, but they
should be there.

In short: it *definitely* should *not* have come back with what you saw.
I have no clue why this happened, all I can say is that I use md on
around 10 business critical production machines in exactly the way you
describe, and I have not seen this (though I've seen the failure modes I
described!).

Are you positively sure that nothing else weird could have been going
on? Some layer that remaps drive names? funky hardware? write caching
capable of holding 3GB before writing out? Write caching of some sort is
actually my best guess.

If there's no extra data to explain this, I'm at a loss.

Anyone else?

-Mike
