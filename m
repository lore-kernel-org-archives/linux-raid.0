From: Gordon Henderson <gordon@drogon.net>
Subject: RE: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 07:42:06 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501100728391.17714@lion.drogon.net>
References: <200501092320.j09NKQ918671@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501092320.j09NKQ918671@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 9 Jan 2005, Guy wrote:

> Why is RAID1 preferred over RAID5?
> RAID1 is considered faster than RAID5.  Most systems tend to read much more
> than they write.

You'd think that, wouldn't you?

However, - I've recently been doing work to graph disk IO by reading
/proc/partitions and feeding it into MRTG - what I saw surprised me,
although it really shouldn't. Most of the systems I've been graphing over
the past few weeks write all the time and rarely read -I'm putting this
down to things like log files being written more or less all the time, and
the active data set residing in the filesystem/buffer cache more or less
all the time. (also ext3 which wants to write all the time too)

However, I guess it all depends on what the server is doing - for a
workstion it may well be the case that it does more reads.

Have a quick look at

  http://lion.drogon.net/mrtg/diskIO.html

This is a moderately busy web server with a couple of dozen virtual web
sites and runs a MUD and several majordomo lists.

Blue is writes, Green reads. Note periods of heavy read activity just
after midnight when it does a backup (over the 'net to another server and
it also sucks another server onto the 'archive' partition), and 2am is
when it analyses the web log-files.

Also note that it's swapping - this has 256MB of RAM and is due for an
upgrade, but swap is keeping it all ticking away nicely.

The var partition seems to sustain writes at approx. 200-300
sectors/second... Not a fantastic amount, but I found it rather
surprising.

(I'll put the MRTG code online for anyone who wants it in a few days and
let you know)

Gordon
