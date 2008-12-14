From: Dave Chinner <david@fromorbit.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Mon, 15 Dec 2008 10:36:17 +1100
Message-ID: <20081214233617.GD32301@disturbed>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan> <493A9BE7.3090001@sandeen.net> <alpine.DEB.1.10.0812130724340.18746@p34.internal.lan> <200812131826.25280.Martin@lichtvoll.de> <4943F37B.8080405@sandeen.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4943F37B.8080405@sandeen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Sandeen <sandeen@sandeen.net>
Cc: Martin Steigerwald <Martin@lichtvoll.de>, linux-xfs@oss.sgi.com, linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>xfs@oss.sgi.com
List-Id: linux-raid.ids

On Sat, Dec 13, 2008 at 11:40:11AM -0600, Eric Sandeen wrote:
> Martin Steigerwald wrote:
> 
> > At the moment it appears to me that disabling write cache may often give 
> > more performance than using barriers. And this doesn't match my 
> > expectation of write barriers as a feature that enhances performance. 
> 
> Why do you have that expectation?  I've never seen barriers advertised
> as enhancing performance.  :)
> 
> I do wonder why barriers on, write cache off is so slow; I'd have
> thought the barriers were a no-op.  Maybe I'm missing something.

Barriers still enforce ordering in this case, so it affects the
elevator algorithm....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
