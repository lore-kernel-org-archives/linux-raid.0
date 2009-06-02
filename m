From: Nifty Fedora Mitch <niftyfedora@niftyegg.com>
Subject: Re: slow random raid5 access?
Date: Tue, 2 Jun 2009 15:44:49 -0700
Message-ID: <20090602224449.GA12169@tosh2egg.wr.niftyegg.com>
References: <200905301344.15895.tfjellstrom@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200905301344.15895.tfjellstrom@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Fjellstrom <tfjellstrom@shaw.ca>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, May 30, 2009 at 01:44:15PM -0600, Thomas Fjellstrom wrote:
> 
> I'm have a new md raid5 array, and have been trying to break it in and tweak 
> it a little. But random read or write are rather slow when using small record 
> sizes:
> 
> http://pastebin.ca/1441414
> 
> Is that normal? And is there a way to speed it up without significantly 
> slowing down sequential access?
> 

Tell us more about the perf numbers of the raw disks in the raid
and how it was built.   Geometry of the devices and the filesystem
type and setup all come to play.

For small anything the numbers are likely to reflect the speed of a
single underlying device.  When reads and writes are large enough to
span multiple devices you can expect to see acceleration as a result of
parallel and overlapping I/O.   Also many disks today have interfaces
that are much quicker than the bit rate to and from media which also
has implications.



-- 
	T o m  M i t c h e l l 
	Found me a new hat, now what?

