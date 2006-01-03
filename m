From: ross@lug.udel.edu (Ross Vandegrift)
Subject: Re: disk light remains on
Date: Mon, 2 Jan 2006 23:49:14 -0500
Message-ID: <20060103044914.GB8876@lug.udel.edu>
References: <20060103033213.GB7888@adsl-64-142-29-25.sonic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20060103033213.GB7888@adsl-64-142-29-25.sonic.net>
Sender: linux-raid-owner@vger.kernel.org
To: debian@good-with-numbers.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Jan 02, 2006 at 07:32:13PM -0800, debian@good-with-numbers.com wrote:
> I just began using RAID-1 (in 2.6.12) on a pair of SATA drives, and
> now the hard disk drive light comes on during booting--about when the
> RAID system is loaded--and stays on.

Could you "cat /proc/mdstat"?  If this is an initial creation and your
disks are large, it's likely just the initial array build.  If your
array is synced and your disks are still being accessed, are you sure
that there's no processes using your disk?

Sorry - silly things first!

-- 
Ross Vandegrift
ross@lug.udel.edu

"The good Christian should beware of mathematicians, and all those who
make empty prophecies. The danger already exists that the mathematicians
have made a covenant with the devil to darken the spirit and to confine
man in the bonds of Hell."
	--St. Augustine, De Genesi ad Litteram, Book II, xviii, 37
