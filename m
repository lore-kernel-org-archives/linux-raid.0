From: Kourosh <linux-raid@mindwaresystems.com>
Subject: Re: Raid5 Construction Question
Date: Thu, 19 Aug 2004 13:26:01 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040819202601.GA14858@mutsumi.mindwaresystems.com>
References: <200408191730.i7JHUd313659@watkins-home.com> <4124E8F5.1010105@psc.edu> <200408192224.06572.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200408192224.06572.maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 19, 2004 at 10:24:06PM +0200, Maarten van den Berg wrote:
> On Thursday 19 August 2004 19:52, PAulN wrote:
> > Guy,
> > thanks for the snappy reply!  I wish my disks were as fast :)
> > I failed to mention that I had been tweaking those proc values.  Currently
> > they are:
> > (root@lcn0:raid)# cat speed_limit_max
> > 200000
> > (root@lcn0:raid)# cat speed_limit_min
> > 10000
> >
> > If I'm correct, this means that the min speed is 10MB/sec per device.
> > I've verified that each device has a seq write speed of about 38MB/sec so
> > each should be capable of handling 10,000Kbytes sec.  Right after I issue
> > a raidstart the speed is pretty good (~30MB/sec) but is just falls until
> > it hits
> > around 300K.
> >
> > md0 : active raid5 sdh1[7] sdf1[6] sdg1[5] sde1[4] sdd1[3] sdc1[2]
> > sdb1[1] sda1[0]
> >       481949184 blocks level 5, 64k chunk, algorithm 2 [7/7] [UUUUUUU]
> >       [>....................]  resync =  2.4% (1936280/80324864)
> > finish=4261.4min speed=305K/sec
> 
> Something like this happened to me a while ago.  The speed is good at start, 
> then after a certain amount of time starts degrading until very very low, 
> like 5k/sec.  It keeps ever decreasing. Also, the decrease of speed occurred 
> at exactly the same point every time.  After a lot of searching, asking and 
> bitching the true reason was revealed; one of the disks had problems and 
> couldn't read/write a part of its surface.  Only when I ran dd on it (and saw 
> the read errors reported) did I realize that.
> 
> So if what you are seeing is this ever-decreasing speed, starting at a 
> specific point, I'd strongly concur with Guy in saying: Test each disk 
> separately by reading /and or writing its _entire_ surface using the dd 
> commands suggested. Not using hdparm or benchmarks, but reading the entire 
> disk(s) as described.  The purpose of this is NOT that you get an idea of the 
> speed, but that you verify that the entire surface is still ok.
> 
> Beyond that, I have no suggestions to offer you.
> 
> Maarten

I've found that one of the better ways of varifying a disk is to run 
the disk manufacturers disk utilities on it.  They all provide a 
bootable disk to run the utilities.  Several times I've had problems 
similar to this and each time it ended up being a disk that was 
failing.  Run the utility as all the vendors I've dealt with require 
the error code from the utility to process an RMA, so might as well do 
it sooner, rather than later.

You could also try low-level formating each disk using the SCSI 
controllers utilities.  IIRC it should remap any bad blocks.

Hope this helps,

Kourosh
