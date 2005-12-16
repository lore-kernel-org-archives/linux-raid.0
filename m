From: Gordon Henderson <gordon@drogon.net>
Subject: Re: First RAID Setup
Date: Fri, 16 Dec 2005 08:42:33 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0512160824470.10784@lion.drogon.net>
References: <0481A62A3E95A044AC20A1A45899645C06B02F4B@glc-mail-1.tessco.com>
 <43A1D642.2010301@wasp.net.au> <43A1E0CE.7090805@medien.uni-weimar.de>
 <17314.7734.707554.88728@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17314.7734.707554.88728@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 16 Dec 2005, Neil Brown wrote:

> > - Does RAID6 have disadvantages wrt write speed?
>
> Probably.  I haven't done any measurements myself, but from a
> theoretical standpoint, you would expect raid6 to impose more CPU load
> (though that may not be noticeable) and as raid6 need to see the whole
> stripe to update the P and Q blocks (it cannot do a subtract old, add
> new update) there could well be more IO happening, particularly on
> large arrays (>5 devices).
>
> Of course, whether this caused noticeable reduction in throughput and
> latency would be very workload-dependant.

I now have several servers using RAID-6 in a production environment - so
far so good. For the most part, they are all connected to 100Mb networks,
and they are file-servers (rather than serving to a local application) and
throughput from the servers to the clients hasn't been a problem. I have
no problems saturating the Ethernet with file traffic in experiments I've
performed (mainly running Bonnie via NFS!)

Running Bonnie locally, I can get over 100MB/sec on some of these boses,
depending on the disks and processor, so it might just be able to cope
with Gb Ethernet, but if I were building something with those speeds
in-mind, then I probably wouldn't be using comodity hardware...

There is something that says that if you have a batch of disks which are
likely to fail then theres a certian probability that they'll all fail
round about the same time, so having an array with a cold spare might help
that, however that might be more hassle than it's worth, who knows!

Bonnie (and hdparm) are fairly crude when it comes to benchmarks, but they
give a fair idea of what to expect when streaming data - here is output of
a Bonnie run over a 6-disk RAID-6 array (SCSI) on a Dull 2850 dual Xeon
jobbie:

Version 1.02b       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
black            2G           74811  34 35960  16           79723  17 461.7   1
black,2G,,,74811,34,35960,16,,,79723,17,461.7,1,,,,,,,,,,,,,

I haven't tried to do anything clever (not sure I could with this!) All
drives are on the same SCSI bus (I did ask for the split backplane option
when I ordered it, but Dull said it couldn't be done, even though they
advertise it)

md6 : active raid6 sdf6[5] sde6[4] sdd6[3] sdc6[2] sdb6[1] sda6[0]
      394523648 blocks level 6, 64k chunk, algorithm 2 [6/6] [UUUUUU]

I was geting over 200MB/sec in & out of it when I configured it as a
RAID-0 when testing it.

And to compare, on a crappy old twin xeon/500MHz box with 8 external SCSI
drives:

Version  1.03       ------Sequential Output------ --Sequential Input- --Random-
                    -Per Chr- --Block-- -Rewrite- -Per Chr- --Block-- --Seeks--
Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  /sec %CP
bertha           1G           38659  69 18568  50           44925  73 562.2   8
bertha,1G,,,38659,69,18568,50,,,44925,73,562.2,8,,,,,,,,,,,,,

md0 : active raid6 sdl1[11] sdk1[8] sdj1[5] sdi1[2] sdh1[10] sdg1[7]
sdf1[4] sde1[1] sdd1[9] sdc1[6] sdb1[3] sda1[0]
      179203840 blocks level 6, 64k chunk, algorithm 2 [12/12] [UUUUUUUUUUUU]

There are split 4+4 over 2 SCSI buses, but the server only has one PCI
bus, so it all ends up going down the same path anyway.

So I'd say that with RAID-6 you can easilly produce something that will be
fully capable of saturating a 100Mb network, with capacity left over, but
you'll have to work a bit harder to saturate a Gb network.

Gordon
