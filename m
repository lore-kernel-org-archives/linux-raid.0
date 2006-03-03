From: "Molle Bestefich" <molle.bestefich@gmail.com>
Subject: Re: block level vs. file level
Date: Fri, 3 Mar 2006 15:07:10 +0100
Message-ID: <62b0912f0603030607n6927f168t489fc2d3fb9d3113@mail.gmail.com>
References: <43EF8CFB.5080403@kfa.org> <20060212213157.GX32687@strugglers.net>
	 <43EFDDF7.6090405@kfa.org>
	 <62b0912f0602200853m72af5676y4f2dcd07fe358ef8@mail.gmail.com>
	 <44013875.8080906@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <44013875.8080906@tmr.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: it <itech@kfa.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
> Molle Bestefich wrote:
> >it wrote:
> > > Ouch.
> > >
> > > How does hardware raid deal with this? Does it?
> >
> > Hardware RAID controllers deal with this by rounding the size of
> > participant devices down to nearest GB, on the assumption that no
> > drive manufacturers would have the guts to actually sell eg. a 250 GB
> > drive with less than exactly 250.000.000.000 bytes of space on it.
> >
> > (It would be nice if the various flavors of Linux fdisk had an option
> > to do this. It would be very nice if anaconda had an option to do
> > this.)
>
> I guess if you care you specify the size of the partition instead of
> "use it all." I use fdisk usually, cfdisk when installing, both let me
> set size, fdisk let's me set starting track and even play with the
> partition table's idea of geometry. What kind of an option did you have
> in mind?

I don't know.  Examples good enough?

a.) "Do not use space beyond highest GB"
b.) "Do not use last cylinder"

Help texts could be:

a.) "Helps ensure that you can replace fx. a 300GB drive from one
manufacturer with a 300GB from another."
b.) "Leave an area that Windows might use for disk metadata alone."
