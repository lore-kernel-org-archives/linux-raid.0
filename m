From: keld@keldix.com
Subject: Re: bug: 4-disk md raid10 far2 can be assembled clean with only two disks, causing silent data corruption
Date: Wed, 26 Sep 2012 10:28:48 +0200
Message-ID: <20120926082848.GA18616@www5.open-std.org>
References: <50606207.7040804@gooseman.cz> <20120925141959.0c22de7d@notabene.brown> <alpine.DEB.2.00.1209250658250.13902@uplift.swm.pp.se> <152edbf7bdad33717477f174f94116b7@192.168.93.35> <20120925223227.130ef8e3@notabene.brown> <50628B39.90205@gooseman.cz> <20120926154107.1568a115@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120926154107.1568a115@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jakub Hus?k <jakub@gooseman.cz>, Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 26, 2012 at 03:41:07PM +1000, NeilBrown wrote:
> On Wed, 26 Sep 2012 06:57:29 +0200 Jakub Hus?k <jakub@gooseman.cz> wrote:
> 
> > On 25.9.2012 14:32, NeilBrown wrote:
> > > On Tue, 25 Sep 2012 11:48:34 +0200 <jakub@gooseman.cz> wrote:
> > >
> > >>
> > >> Would you please refer to some documentation that this behaviour is
> > >> correct? I now tried to fail several disks in raid5, raid0 and raid10-near,
> > >> in case of r0 and r10n, mdadm didn't even allow me to remove more disks
> > >> than is sufficient to access all the data. In case of r5 I was able to fail
> > >> 2 out of 3, but the array was correctly marked as FAILED and couldn't be
> > >> accessed at all. I'd expect that behaviour even in my case of raid10-far. I
> > >> can't even assmenble and run it with less than required count of disks.
> > >>
> > > Could you please be explicit about exactly how the behaviour that you think
> > > of as "correct" would differ from the current behaviour?  Because I cannot
> > > really see what point you are making - I need a little help.
> > >
> > > Thanks,
> > > NeilBrown
> > I think that when two adjacent drives fail, or the array is being 
> > assembled with two adjacent drives missing, the status wouldn't be 
> > "clean, degraded", the array "running"  and reporting some inaccessible 
> > blocks when you try to use it - as it happens in my case of R10F.
> > Instead, the array status would be "FAILED " and won't be allowed to 
> > run. R0, R5, R10N behave in that manner (if i tested well), which I 
> > consider correct.
> > 
> > The "degraded" status means, at lest for me, that the array is fully 
> > functional, only with limited redundancy.
> > R10 with far2 layout and four disks can't be only "degraded" when any 
> > two disks are missing, unlike R10 near2 in some cases.
> > 
> > If something is still not clear, please be patient, i'll try to squeeze 
> > maximum out of my torturous English ;)
> > 
> > Thaks
> 
> Ahh.... I see it now.
> There is a bug in the 'enough' function in mdadm and in drivers/md/raid10.c
> It doesn't handle 'far' layouts properly.
> 
> I'll sort out some patches.

I also understand it now, I think. raid10,f2 with 4 disks cannot in the current implementation
survive 2 failing disks. We have discussed earlier how to implement raid10,far that would mean
better survival chances with more disks failing. This is not implemented yet.

Best regards
Keld
