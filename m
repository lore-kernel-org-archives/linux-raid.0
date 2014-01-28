From: Marc MERLIN <marc@merlins.org>
Subject: Re: Very long raid5 init/rebuild times
Date: Tue, 28 Jan 2014 08:50:20 -0800
Message-ID: <20140128165020.GL14998@merlins.org>
References: <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <52E76054.5090900@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jan 28, 2014 at 01:46:28AM -0600, Stan Hoeppner wrote:
> > Today, I don't use PMPs anymore, except for some enclosures where it's easy
> > to just have one cable and where what you describe would need 5 sata cables
> > to the enclosure, would it not?
> 
> No.  For external JBOD storage you go with an SAS expander unit instead
> of a PMP.  You have a single SFF 8088 cable to the host which carries 4
> SAS/SATA channels, up to 2.4 GB/s with 6G interfaces.
 
Yeah, I know about those, but I have 5 drives in my enclosures, so that's
one short :)

> > I generally agree. Here I was using it to transfer data off some drives, but
> > indeed I wouldn't use this for a main array.
> 
> Your original posts left me with the impression that you were using this
> as a production array.  Apologies for not digesting those correctly.
 
I likely wasn't clear, sorry about that.

> You don't get extra performance.  You expose the performance you already
> have.  Serial submission typically doesn't reach peak throughput.  Both
> the resync operation and dd copy are serial submitters.  You usually
> must submit asynchronously or in parallel to reach maximum throughput.
> Being limited by a PMP it may not matter.  But with your direct
> connected drives of your production array you should see a substantial
> increase in throughput with parallel submission.

I agree, it should be faster. 
 
> >> [global]
> >> directory=/some/directory
> >> zero_buffers
> >> numjobs=4
> >> group_reporting
> >> blocksize=1024k
> >> ioengine=libaio
> >> iodepth=16
> >> direct=1
> >> size=1g
> >>
> >> [read]
> >> rw=read
> >> stonewall
> >>
> >> [write]
> >> rw=write
> >> stonewall
> > 
> > Yeah, I have fio, didn't seem needed here, but I'll it a shot when I get a
> > chance.
> 
> With your setup and its apparent hardware limitations, parallel
> submission may not reveal any more performance.  On the vast majority of
> systems it does.

fio said:
Run status group 0 (all jobs):
   READ: io=4096.0MB, aggrb=77695KB/s, minb=77695KB/s, maxb=77695KB/s, mint=53984msec, maxt=53984msec

Run status group 1 (all jobs):
  WRITE: io=4096.0MB, aggrb=77006KB/s, minb=77006KB/s, maxb=77006KB/s, mint=54467msec, maxt=54467msec
 
> > Of course, I'm not getting that speed, but again, I'll look into it.
> 
> Yeah, something's definitely up with that.  All drives are 3G sync, so
> you 'should' have 300 MB/s data rate through the PMP.

Right.
 
> > Thanks for your suggestions for tweaks.
> 
> No problem Marc.  Have you noticed the right hand side of my email
> address? :)  I'm kinda like a dog with a bone when it comes to hardware
> issues.  Apologies if I've been a bit too tenacious with this.

I had not :) I usually try to optimize stuff as much as possible when it's
worth it or when I really care and have time. I agree this one is puzzling
me a bit and even if it's fast enough for my current needs and the time I
have right now, I'll try and move it to another system to see. I'm pretty
sure that one system has a weird bottleneck.

Cheers,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
