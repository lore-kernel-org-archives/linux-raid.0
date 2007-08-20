From: "Dat Chu" <dattanchu@gmail.com>
Subject: Re: Linear RAID hot grow
Date: Mon, 20 Aug 2007 17:21:47 -0500
Message-ID: <d0e8f6370708201521g15974927lbfb91c03cb4428fe@mail.gmail.com>
References: <d0e8f6370708201435s33547f5agfdf44b384c9489f2@mail.gmail.com>
	 <Pine.LNX.4.64.0708201745170.16270@p34.internal.lan>
	 <d0e8f6370708201455i37e21a4mf2dbf8ecb0133cb0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d0e8f6370708201455i37e21a4mf2dbf8ecb0133cb0@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The links on Neil's website to those patches are no longer there. When
I try to hot grow a linear raid, it says that hot grow for linear raid
is not supported.

Where would I find those patches?

With warm regards,
Dat Chu



>
>
>
> On 8/20/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
> >
> >
> > On Mon, 20 Aug 2007, Dat Chu wrote:
> >
> > > I am trying to find the mdadm version that support Linear RAID hot
> > > grow. Does anyone have a link to point me to? I am currently running
> > > 2.6.2.
> > >
> > > With warm regards,
> > > Dat Chu
> > > -
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > > the body of a message to  majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
> > Not sure, it seems like it would be supported by now?
> >
> > But according to the docs for 2.6.2:
> >
> >         Grow   Grow  (or shrink) an array, or otherwise reshape it in some way.
> >                Currently supported growth options including changing the active
> >                size of component devices in RAID level 1/4/5/6 and changing the
> >                number of active devices in RAID1/5/6.
> >
> > --
> >
> > http://neil.brown.name/blog/SoftRaid
> >
> > --grow option for "linear" md arrays
> >
> >  I've just been working on an enhancement for Linux "MD" linear arrays
> > which allows them to be enlanged.
> >
> > More specifically, a new device (typcially disk drive) can be added to the
> > end of an active linear array now. The size increases accordingly.
> >
> > You can find patches for mdadm and 2.6.7-rc3-mm1.
> >
> > It is still a work in progress, as it isn't documented, some of the code
> > doesn't report errors very nicely, and I realised that there is some work
> > needed in md.c with respect to handling new superblocks.
> >
> > I really should do the new-superblock code in mdadm and get it all tidied
> > up.
> >
>
>
