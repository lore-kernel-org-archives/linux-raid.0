From: maarten <maarten@ultratux.net>
Subject: Re: Spares and partitioning huge disks
Date: Mon, 10 Jan 2005 22:21:46 +0100
Message-ID: <200501102221.46018.maarten@ultratux.net>
References: <200501102009.j0AK9C922554@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501102009.j0AK9C922554@www.watkins-home.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday 10 January 2005 21:09, Guy wrote:

> I use ext3 filesystems.  No problems with performance (that I know of).
> I have never tried any others.

Reportedly, deleting a big (>2GB) file under XFS is way faster than under 
ext3, but I never verified this myself.  I barely ever ran ext3, I went with 
my distros' default, which was Reiserfs.
Deleting huge files is a special case though, so it does not make much sense 
to benchmark or tune for that. But in this special case it matters.

> Do you think the performance difference of the various filesystems would
> affect your PVR?

Ehm, no.  Well, not the raid-5 overhead at least.  The FS helps the GUI being 
more 'snappy'. It has been reported that ext3 takes a real long time to 
delete huge files (up to several seconds or more) (unconfirmed by me).

This is what a copy of a 5GB file and subsequent delete does on my system:

-rw-r--r--    1 root     root     4909077650 Jan 10 04:43 file
dozer:/mnt/store # time cp file away
real    3m15.778s
user    0m0.640s
sys     0m45.230s

dozer:/mnt/store # time rm away
real    0m0.237s
user    0m0.000s
sys     0m0.020s

(This was while the machine was idle, no recordings going on)

But the machine IS starved for CPU and bus bandwidth; the cpu should be almost 
fully pegged with recording up to two simultaneous channels, compressing 
realtime(!) in mpeg4 from two cheap bttv cards (at 480x480 rez, 2600 Kbps).
Therefore it is the fastest CPU I could afford back in last spring, an Athlon 
XP 2600. The machine is also overclocked from 200 FSB to 233, yielding a 38 
MHz PCI bus. Strangely enough, despite there being 5 PCI cards, amongst which 
two disk I/O controllers, this seems to work just fine. It's been tested 
in-depth by recording shows daily for months and it crashes rarely ( meaning 
< once a month which is not too bad, considering ). Maybe the bigass Zalman 
copper CPU cooler and the 12cm fan hovering above it help there, too ;-)
At the beginning it ran off a single 160GB disk, so when I switched to raid-5 
I was very afraid that either the extra CPU load, the extra IRQ load or the 
bus bandwidth would saturate, thus killing performance. You see, the PCI bus 
is fairly loaded too, since not only does it have to handle the various ATA 
controllers, but two uncompressed videostreams from the TV cards as well.

So all in all, the overhead of raid seems insignificant to me, or the code is 
very well optimized indeed :-)

Maarten


