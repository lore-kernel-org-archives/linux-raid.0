From: adfas asd <chimera_god@yahoo.com>
Subject: Re: NAS Remote Side of a Mirror
Date: Tue, 6 Oct 2009 08:36:45 -0700 (PDT)
Message-ID: <177866.95801.qm@web38807.mail.mud.yahoo.com>
References: <20091006152443.GA3151@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091006152443.GA3151@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--- On Tue, 10/6/09, Robin Hill <robin@robinhill.me.uk> wrote:
> > I am concerned about the boot process though, as the
> NASsed side will
> > not be available until the network comes up. 
> Will the array be able
> > to be patient for that and include that side once it
> comes up, and run
> > not degraded?
> > 
> The network can be brought up from within the initrd, so
> there's no need
> for the array to wait (that's even more trivial if you just
> have /home
> on the array as you suggest below).  Alternately, you
> could use
> write-intent bitmaps, in which case the resync should be
> very quick (you
> may want these anyway - depends how reliable the network
> connection and
> NAS is).

Wow, this is good news.  I'll do some research.

It's a freaky quantum world, when you don't even need a partition...

Ya have write-intent bitmaps enabled already, thanks.




      
