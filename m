From: Gordon Henderson <gordon@drogon.net>
Subject: Stats... [RE: Spares and partitioning huge disks]
Date: Mon, 10 Jan 2005 12:21:02 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0501101116470.17714@lion.drogon.net>
References: <200501100903.j0A93K920694@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501100903.j0A93K920694@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guy <bugzilla@watkins-home.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 10 Jan 2005, Guy wrote:

> You said:
> "Have a quick look at
>
>   http://lion.drogon.net/mrtg/diskIO.html"
>
> Are you crazy!  Quick look, my screen is 1600X1200.
> Your quick look is over twice that size!  :)

Well, it's only a few graphs though, and you don't need to scroll
horizontally if you don't want to...

> What is all the red?  Oh, it's eye strain!  :)

they are just standard MRTG graphs arranged in a grid - mainly intended
for my own consumption, but I'm happy to share the code, etc. Give me a
few days and I'll tidy it up. After I had a server lose a case fan and
overheat I've kinda gone overboard on stats, etc. better to have them than
not, I guess.... Eg.

  http://lion.drogon.net/mrtg/sensors.html
  http://lion.drogon.net/mrtg/systemStats.html

and there are others, but they are even duller...

> Why do your graphs read right to left?  It makes my head hurt!

New data comes in at the left. I read books left to right and I'm
left-handed. Sue me..

> Well, I am surprised.  I have read somewhere that about a 10 to 1 ratio is
> common.  That's 10 reads per 1 write!
>
> Maybe you got your ins and outs reversed!

Well.. This did cross my mind! But I did some tests and check with vmstat
and I'm fairly confident it's doing the right thing. It does measure
sectors (or whatever comes out of /proc/partitions) so it might look more
than the number of blocks you may expect the filesystem to be dealing
with.

If you look at

  http://lion.drogon.net/mrtg/diskio.hda6-day.png
  http://lion.drogon.net/mrtg/diskio.hdc6-day.png

(small PNG images!) you'll see a green blip at about 11:30... This is the
result of 2 runs of:

  lion:/archive# tar cf /dev/null .

So this (and other tests I did when setting it up) makes me confident it's
doing the right thing!

> If you data set is small enough to fit in the buffer cache, then you may
> be correct.  I have worked on systems with a database of well over 1T
> bytes. The system had about 10T bytes total.  No way for all that to fit
> in the buffer cache!  But, I don't have any data to deny what you say.

Sure - this server is only a small one with 2 disks and a couple of dozen
web sites - it seems to churn out just under half a GB a day, but the
log-files are written and grow all the time )-: This might be a
consideration for further tuning though if it were to get worse... In any
case, the original comment about reads overshadowing writes may well be
true, but at the end of the day it really does depend on the application
and use of the server, and I think a few people might be surprised at
exactly what their servers are getting up to - especially database servers
which write log-files...

All my web servers seem to exhibit this behaviour though (part of my
business is server hosting) - heres a screeen dump of a small(ish) company
central server doing Intranet, file serving, (samba + NFS) and email for
about 30 people (it's a 4-disk RAID5 configuration)

  http://www.drogon.net/pix.png

(small 40KB image)

This is just the overall totals of the 4 disks - I can't show you the rest
easilly as it's behind a firewall...

It seems to exhibit the same behaviour - constant writes with the
exception of overnights just after midnight when it takes a snapshot of
itself then dumps the snapshot to tape. The read-blip at 6AM is the locate
DB update. (and at 8am I run a 'du' over some of the disks so I can use
xdu and point fingers at disk space hogs) Most of the writes are to the
/var partition - log-files and it's probably the email server whinging
about SPAM (it runs sendmail, MD & SA)

The partition that holds the user-data is a bit more balanced - the number
of reads & writes are about the same, although writes are marginally more.

> Here is my home system using iostat:

Hm. Debian doesn't seem to have 'iostat' - must look it up...

> # iostat -d
> Linux 2.4.28 (watkins-home.com)    01/10/2005
>
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> dev8-0            1.77       209.57        10.08   38729760    1862232
> dev8-1            1.78       210.75        10.08   38948102    1862232
> dev8-2           10.13       522.27        36.50   96518688    6745616
> dev8-3           10.52       524.71        37.94   96970042    7011712
> dev8-4           10.55       525.05        38.00   97032904    7021816
> dev8-5           10.60       524.90        37.99   97004392    7021080
> dev8-6           10.59       524.86        38.17   96997424    7054816
> dev8-7           10.56       524.89        38.23   97002160    7064552
> dev8-8           10.54       524.73        38.25   96973096    7068552
> dev8-9           10.54       524.55        37.89   96940336    7001736
> dev8-10          10.15       522.54        36.74   96568080    6789584
> dev8-11          10.18       522.51        36.52   96562208    6749696
> dev8-12          10.21       522.60        36.74   96578592    6790600
> dev8-13          10.22       522.67        37.10   96592848    6856800
> dev8-14          10.17       522.46        36.95   96552728    6828544
> dev8-15          10.19       522.30        36.70   96523856    6782136

Thats a rather busy home server - are you streaming music/video off it?
Mine (just a RAID1 system) sits with the disk spun down 95% of the time...
(noflushd) however, it's due for a rebuild when it'll turn into a home
'media server' then it might get a little bit more lively!

> Oops, I just checked my email server, it has 64 meg of RAM and only does
> email all the time.
> Device:            tps   Blk_read/s   Blk_wrtn/s   Blk_read   Blk_wrtn
> dev3-0            1.32         2.10        19.72    7284164   68380122
>
> That's 1 to 9.  I give up!

Log-files... Love em or loathe em...

> I got to mirror that system some day!

Go for it, you know you want to :)

Gordon
