From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 04:03:09 -0500
Message-ID: <200501100903.j0A93K920694@www.watkins-home.com>
References: <Pine.LNX.4.56.0501100728391.17714@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0501100728391.17714@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Gordon Henderson' <gordon@drogon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You said:
"Have a quick look at

  http://lion.drogon.net/mrtg/diskIO.html"

Are you crazy!  Quick look, my screen is 1600X1200.
Your quick look is over twice that size!  :)

What is all the red?  Oh, it's eye strain!  :)

Why do your graphs read right to left?  It makes my head hurt!

Well, I am surprised.  I have read somewhere that about a 10 to 1 ratio is
common.  That's 10 reads per 1 write!

Maybe you got your ins and outs reversed!

If you data set is small enough to fit in the buffer cache, then you may be
correct.  I have worked on systems with a database of well over 1T bytes.
The system had about 10T bytes total.  No way for all that to fit in the
buffer cache!  But, I don't have any data to deny what you say.

Here is my home system using iostat:
# iostat -d
Linux 2.4.28 (watkins-home.com)    01/10/2005

Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
dev8-0            1.77       209.57        10.08   38729760    1862232
dev8-1            1.78       210.75        10.08   38948102    1862232
dev8-2           10.13       522.27        36.50   96518688    6745616
dev8-3           10.52       524.71        37.94   96970042    7011712
dev8-4           10.55       525.05        38.00   97032904    7021816
dev8-5           10.60       524.90        37.99   97004392    7021080
dev8-6           10.59       524.86        38.17   96997424    7054816
dev8-7           10.56       524.89        38.23   97002160    7064552
dev8-8           10.54       524.73        38.25   96973096    7068552
dev8-9           10.54       524.55        37.89   96940336    7001736
dev8-10          10.15       522.54        36.74   96568080    6789584
dev8-11          10.18       522.51        36.52   96562208    6749696
dev8-12          10.21       522.60        36.74   96578592    6790600
dev8-13          10.22       522.67        37.10   96592848    6856800
dev8-14          10.17       522.46        36.95   96552728    6828544
dev8-15          10.19       522.30        36.70   96523856    6782136

The first 2 are my OS disks (RAID1).  The others are my 14 disk RAID5.

That's about 13 to 1 on my RAID5 array.  But I would not claim my system is
typical.  It is a home system, not a database server or fancy web server.
Mostly just a samba server.  My email server is a different box.

Oops, I just checked my email server, it has 64 meg of RAM and only does
email all the time.
Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
dev3-0            1.32         2.10        19.72    7284164   68380122

That's 1 to 9.  I give up!
I got to mirror that system some day!

Guy



-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Gordon Henderson
Sent: Monday, January 10, 2005 2:42 AM
To: linux-raid@vger.kernel.org
Subject: RE: Spares and partitioning huge disks

On Sun, 9 Jan 2005, Guy wrote:

> Why is RAID1 preferred over RAID5?
> RAID1 is considered faster than RAID5.  Most systems tend to read much
more
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
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

