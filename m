From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: sata badness in 2.6.20-rc1? [Was: Re: md patches in -mm]
Date: Fri, 15 Dec 2006 23:04:54 +0100
Message-ID: <200612152304.55582.rjw@sisk.pl>
References: <20061204203410.6152efec.akpm@osdl.org> <20061215133927.a8346372.akpm@osdl.org> <20061215220618.06f1873c@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20061215220618.06f1873c@localhost.localdomain>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Alan <alan@lxorguk.ukuu.org.uk>
Cc: Andrew Morton <akpm@osdl.org>, Neil Brown <neilb@suse.de>, Jurriaan <thunder7@xs4all.nl>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jeff Garzik <jeff@garzik.org>, Tejun Heo <htejun@gmail.com>
List-Id: linux-raid.ids

On Friday, 15 December 2006 23:06, Alan wrote:
> On Fri, 15 Dec 2006 13:39:27 -0800
> Andrew Morton <akpm@osdl.org> wrote:
> 
> > On Fri, 15 Dec 2006 13:05:52 -0800
> > Andrew Morton <akpm@osdl.org> wrote:
> > 
> > > Jeff, I shall send all the sata patches which I have at you one single time
> > > and I shall then drop the lot.  So please don't flub them.
> > > 
> > > I'll then do a rc1-mm2 without them.
> > 
> > hm, this is looking like a lot of work for not much gain.  Rafael, are
> > you able to do a quick chop and tell us whether these:
> 
> The md one and the long history of reports about parallel I/O causing
> problems sounds a lot more like the kmap stuff you were worried about
> Andrew. I'd be very intereste dto know if it happens on x86_32 built with
> a standard memory split and no highmem....

But my box is a x86_64, so ...
