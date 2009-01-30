From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: sun x4500 soft lockup during raid creation
Date: Fri, 30 Jan 2009 23:28:42 +0100
Message-ID: <20090130222842.GA9733@rap.rap.dk>
References: <1233174633.7008.34.camel@hazard2.francoudi.com> <20090128223330.GA14409@sillage.bis.pasteur.fr> <20090128230852.GA8495@francoudi.com> <49831CBB.8010609@tmr.com> <1233344286.14088.36.camel@hazard2.francoudi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1233344286.14088.36.camel@hazard2.francoudi.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vladimir Ivashchenko <hazard@francoudi.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Tru Huynh <tru@pasteur.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Jan 30, 2009 at 09:38:06PM +0200, Vladimir Ivashchenko wrote:
> On Fri, 2009-01-30 at 10:28 -0500, Bill Davidsen wrote:
> 
> > > I changed the kernel to 2.6.27.12-78.2.8.fc9.i686 and so far it is stable. 
> > >
> > > x64 will be the next step. i686 is what our guys install by default, I didn't bother to reinstall it.
> > >
> >    
> > In spite of the theoretical benefits of 64 bit, I find that the 
> > advantages are "measurable but not noticeable" for most things. The lack 
> > of 64 bit versions of some applications was a problem for me, but may 
> > not be for you. I did find that even building from source not all 
> > applications worked right, or worked at all, or in some cases compiled. :-(
> 
> More or less this is our experience also, but this box will only be used
> as a file-server.
> 
> Does anybody know if software RAID benefits when being run in 64-bit ?

I think it may. IO buffer copying may be twice as  fast.
Some statistics on IO, including network traffic can be measured
when it goes beyound about 100 Mbit/s - tehere are some counters that
would overflow 32 bit.


best regards
keld
