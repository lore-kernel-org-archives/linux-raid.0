From: Gabor Gombas <gombasg@sztaki.hu>
Subject: Re: remark and RFC
Date: Sat, 19 Aug 2006 03:35:19 +0200
Message-ID: <20060819013518.GI6440@boogie.lpds.sztaki.hu>
References: <17635.49745.179198.975962@cse.unsw.edu.au> <200608170628.k7H6S7W11745@inv.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200608170628.k7H6S7W11745@inv.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@inv.it.uc3m.es>
Cc: Neil Brown <neilb@suse.de>, linux raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 17, 2006 at 08:28:07AM +0200, Peter T. Breuer wrote:

> 1) if the network disk device has decided to shut down wholesale
>    (temporarily) because of lack of contact over the net, then
>    retries and writes are _bound_ to fail for a while, so there
>    is no point in sending them now.  You'd really do infinitely
>    better to wait a while.

On the other hand, if it's a physical disk that's gone, you _know_ it
will not come back, and stalling your mission-critical application
waiting for a never-occuring event instead of just continue using the
other disk does not seem right.

>    You think the device has become unreliable because write failed, but
>    it hasn't ... that's just the net. Try again later! If you like
>    we can set the req error count to -ETIMEDOUT to signal it. Real
>    remote write breakage can be signalled with -EIO or something.
>    Only boot the device on -EIO.

Depending on the application, if one device is gone for an extended
period of time (and the range of seconds is a looong time), it may be
much more applicable to just forget about that disk and continue instead
of stalling the system waiting for the device coming back.

IMHO if you want to rely on the network, use equipment that can provide
the required QoS parameters. It may cost a lot - c'est la vie.

Gabor

-- 
     ---------------------------------------------------------
     MTA SZTAKI Computer and Automation Research Institute
                Hungarian Academy of Sciences
     ---------------------------------------------------------
