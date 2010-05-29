From: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Subject: Re: recovering from a controller failure
Date: Sat, 29 May 2010 16:45:32 -0500
Message-ID: <20100529214532.GD7501@flews.lairds.us>
References: <20100529190751.GM2167@flews.lairds.us>
 <4C01849D.8080101@sauce.co.nz>
 <20100529213610.GC7501@flews.lairds.us>
 <4C01896A.7030705@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C01896A.7030705@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 30, 2010 at 09:38:50AM +1200, Richard wrote:

> mdadm -A -f /dev/mdX

	root@00144ff2a334:/# mdadm -A -f /dev/md0
	mdadm: /dev/md0 not identified in config file.

These are net-booted file servers.  They share a root file system so I
rely on auto-detection of the RAID partitions.

I appreciate the hand holding.

--kyler
