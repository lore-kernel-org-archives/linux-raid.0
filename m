From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: What raid to build on that drives?
Date: Tue, 2 Dec 2003 09:25:36 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16331.49120.609115.218260@notabene.cse.unsw.edu.au>
References: <7FD257BF8564D4119DA800508BDF07AA0FB51D47@usahm012.exmi01.exch.eds.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bailey, Scott on Monday December 1
To: "Bailey, Scott" <scott.bailey@eds.com>
Cc: 'Timo Boettcher' <spida@gmx.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 1, scott.bailey@eds.com wrote:
> 
> 4. At this point, I would *NOT* recommend building a RAID0 array from (2)
> and (3), as you will end up generating a lot of contention on the 36GB disks
> by doing so. Either use them as separate devices, or concatenate them (using
> LVM perhaps) if you really need all of the space in "one place".

or md/linear.

> 
> I imagine simultaneous rebuilds of both RAID5 devices would not be a
> pleasant experience. :-)
> 

It is never nice to have to rebuild an array (though it is nice that
it just works), however this case is no worse than any other.  md will
notice that the two raid5 arrays share some physical drives and will
serialise the rebuilds.

NeilBrown
