From: Kyler Laird <kyler-keyword-linuxraid00.a7e7f0@lairds.com>
Subject: Re: recovering from a controller failure
Date: Sat, 29 May 2010 19:15:04 -0500
Message-ID: <20100530001504.GE7501@flews.lairds.us>
References: <20100529190751.GM2167@flews.lairds.us>
 <4C01849D.8080101@sauce.co.nz>
 <20100529213610.GC7501@flews.lairds.us>
 <4C01896A.7030705@sauce.co.nz>
 <20100529214532.GD7501@flews.lairds.us>
 <4C018C22.2090503@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4C018C22.2090503@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, May 30, 2010 at 09:50:26AM +1200, Richard wrote:

> How about adding entries to your mdadm.conf file containing the UUID
> of /dev/md0, eg:
> 
> ARRAY /dev/md8 level=raid6 num-devices=16
> UUID=38a06a50:ce3fc204:728edfb7:4f4cdd43
> 
> note this should be all one line.

I'll be happy to do that.

> mdadm -D /dev/md0 should get you the UUID.

	root@00144ff2a334:/# mdadm -D /dev/md0
	mdadm: md device /dev/md0 does not appear to be active.

So...how do I get the UUIDs?  I tried blkid and got this.
	http://lairds.us/temp/ucmeng_md/uuids
Those UUIDs are far from unique.

Thanks!

--kyler
