From: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Subject: Re: remark and RFC
Date: Sat, 19 Aug 2006 13:27:17 +0200 (MET DST)
Message-ID: <200608191127.k7JBRHk19468@inv.it.uc3m.es>
References: <20060819013518.GI6440@boogie.lpds.sztaki.hu>
Reply-To: ptb@inv.it.uc3m.es
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060819013518.GI6440@boogie.lpds.sztaki.hu> from "Gabor Gombas"
 at "Aug 19, 2006 03:35:19 am"
Sender: linux-raid-owner@vger.kernel.org
To: Gabor Gombas <gombasg@sztaki.hu>
Cc: linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

"Also sprach Gabor Gombas:"
> On Thu, Aug 17, 2006 at 08:28:07AM +0200, Peter T. Breuer wrote:
> 
> > 1) if the network disk device has decided to shut down wholesale
> >    (temporarily) because of lack of contact over the net, then
> >    retries and writes are _bound_ to fail for a while, so there
> >    is no point in sending them now.  You'd really do infinitely
> >    better to wait a while.
> 
> On the other hand, if it's a physical disk that's gone, you _know_ it
> will not come back,

Possibly. Disks are physical whether over the net or not - you mean a
"nearby"  disk, I think. Now, over the net we can distinguish between
a (remote) disk failure and a communications hiatus easily. The problem
appears to be that the software above us (the md layer) is not tuned to
distinguish between the two.

> and stalling your mission-critical application
> waiting for a never-occuring event instead of just continue using the
> other disk does not seem right.

Then don't do it. There's no need to, as I pointed out in the following
...

> >    You think the device has become unreliable because write failed, but
> >    it hasn't ... that's just the net. Try again later! If you like
> >    we can set the req error count to -ETIMEDOUT to signal it. Real
> >    remote write breakage can be signalled with -EIO or something.
> >    Only boot the device on -EIO.
> 
> Depending on the application,

?

> if one device is gone for an extended
> period of time (and the range of seconds is a looong time),

Not over the net it isn't. I just had to wait 5s before these letters
appeared on screen!

> it may be
> much more applicable to just forget about that disk and continue instead
> of stalling the system waiting for the device coming back.

Why speculate?  Let us signal what's happening.  We can happily set a
timeout of 2s, say, and signal -EIO if we get an error return within 2s
and -ETIMEDOUT if we don't get a response of any sort back within 2s.  I
ask that you (above) don't sling us out of the array when we signal
-ETIMEDOUT (or -EAGAIN, or whatever).  Let us decide what's going on and
we'll signal it - don't second guess us.

> IMHO if you want to rely on the network, use equipment that can provide

Your opinion (and mine) doesn't count - I think swapping over the net is
crazy too, but people do it, notwithstanding my opinion. So argument
about whether they ought to do it or not is null and void. They do.

Peter
