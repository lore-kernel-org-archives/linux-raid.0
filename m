From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: MD device id change
Date: Sun, 6 Apr 2003 15:20:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16015.47370.218258.430178@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.33.0304031754490.5184-100000@worf.desy.de>
	<16012.45741.447317.341813@notabene.cse.unsw.edu.au>
	<019301c2faac$fcde9640$f6de11cc@black>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mike Black on Friday April 4
To: Mike Black <mblack@csi-inc.com>
Cc: raid-list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Friday April 4, mblack@csi-inc.com wrote:
> Here's one I've run into Neil -- Put an already-running md on another system with the same minor #.
> 
> Can you start the new md and not have to stop the old one?
> 
> i.e.
> /dev/md2 on system#1
> /dev/md2 on system#2
> move /dev/md2 chassis to system#2
> 
> Would this work?
> mdadm --assemble --uuid=MOVED_MD2 --super-minor=2 /dev/md3

You would need to tell mdadm that devices to look at, possibly
using --config=partitions, but that would work to assemble the array.
> 
> And would the array now stay as md3?

Not in 2.4 (though in 2.5 it would).

You need --update=super-minor for that to happen.  Ofcourse if you use
mdadm for assembling arrays and always use UUID, then you don't need
to convern yourself with the minor number in the superblock at all.

NeilBrown
