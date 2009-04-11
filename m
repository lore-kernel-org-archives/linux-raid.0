From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: RAID-6 horizontal grow
Date: Sat, 11 Apr 2009 10:23:48 +0200
Message-ID: <20090411082348.GA3983@lazy.lzy>
References: <20090410215435.GA10451@lazy.lzy> <20090410215833.GF21242@cthulhu.home.robinhill.me.uk> <20090410223433.GA10797@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090410223433.GA10797@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi again,

I answer to myself.

It seems that the array needs to be assembled
with "--update devicesize", so that later the
"--grow --size=max" could really work.

It also seems that "--update" works only with
"--assemble".
Is there any way to update the device size "live",
i.e. without stopping and re-assembling the array?
(and without failing/removing/adding components?).

Thanks,

bye,

pg

On Sat, Apr 11, 2009 at 12:34:33AM +0200, Piergiorgio Sartor wrote:
> Hi again,
> 
> I made a quick test, but that does not seem to
> work, at least with RAID-6.
> 
> What I did was to create 4 loop devices of 128MB
> and then a RAID-6, metadata 1.1, on top of that.
> The I stopped the array and the loop, I added
> another 128MB (added as in "dd ... >> file"),
> run "losetup" again and "mdadm -A ...".
> Then "mdadm --grow --size=max ...", but the size
> of the array did not change from 256MB (2x128MB).
> The loop devices are 256MB (wc -c /dev/loop..).
> 
> So, either I'm missing something or this type of
> grow does not seem to affect RAID-6.
> 
> Any ideas?
> 
> Thanks again,
> 
> bye,
> 
> pg
> 
> On Fri, Apr 10, 2009 at 10:58:33PM +0100, Robin Hill wrote:
> > On Fri Apr 10, 2009 at 11:54:35PM +0200, Piergiorgio Sartor wrote:
> > 
> > > Hi all,
> > > 
> > > is it possible to grow a RAID-6, not by adding
> > > more drives, but by extending the partions which
> > > are composing the array?
> > > 
> > > In other words, let's say I've "n" partitions of
> > > "x" GB forming a RAID-6 array. After some time I
> > > increase the size of each partition to "y" GB, of
> > > course y > x.
> > > Is it then possible to use the complete space
> > > growing the array?
> > > How?
> > > 
> > Yes - "mdadm --grow --size=max /dev/mdX".  You'll also need to grow the
> > filesystem afterwards of course.
> > 
> > Cheers,
> >     Robin
> > -- 
> >      ___        
> >     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
> >    / / )      | Little Jim says ....                            |
> >   // !!       |      "He fallen in de water !!"                 |
> 
> 
> 
> -- 
> 
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
