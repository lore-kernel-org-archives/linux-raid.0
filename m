From: Doug Dumitru <doug@easyco.com>
Subject: Re: Can reading a raid drive trigger all the other drives in that set?
Date: Fri, 2 Sep 2011 14:28:21 -0700
Message-ID: <CAFx4rwTDCm67QpegfxpVjqeRHmCt=a3z1tNQB2zvW7=0AV-aSQ@mail.gmail.com>
References: <20110628162205.GG20420@merlins.org>
	<20110902012327.GK30313@merlins.org>
Reply-To: doug@easyco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110902012327.GK30313@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

What you are looking to do is not really what raid is all about.
Essentially, the side effect of a drive wakeup is non optimal in that
the raid layer is not aware of this event.  Then again, the drive does
this invisibly, so no software is really aware.

You "could" fix this with a "filter" plug-in.  Basically, you could
write a device mapper plug-in that watched IO and after some length of
pause kicked off dummy reads so that all drives would wake up.  In
terms of code, this would probably be less than 300 lines to implement
the module.

Writing a device mapper plug-in is not that hard (see dm-zero.c for a
hello-world example), but it is kernel code and does require a pretty
good understanding of the BIO structure and how things flow.  If you
had such a module, you would load it with a dmsetup command and then
use the 2nd mapper device instead of /dev/mdX.

If this is an important, ie. commercial, issue that is costing you
money, then you might want to pursue this.  If not, then you probably
need to just disable drive spin-downs or live with it.

It is also possible that you could appeal to someone with some free
time (ie, not me) that could do this as a "green" project.  Anyone who
has worked anywhere near the device-mapper or software-raid layers
should be able to throw something together.

Doug Dumitru
EasyCo LLC

On Thu, Sep 1, 2011 at 6:23 PM, Marc MERLIN <marc@merlins.org> wrote:
>
> On Tue, Jun 28, 2011 at 09:22:05AM -0700, Marc MERLIN wrote:
> > I have ext4 over lvm2 on a sw raid5 with 2.6.39.1
> >
> > In order to save power I have my drives spin down.
> >
> > When I access my filesystem mount point, I get hangs of 30sec or a =
bit more
> > as each and every drive are woken up serially.
> >
> > Is there any chance to put a patch in the block layer so that when =
it gets a
> > read on a block after a certain timeout, it just does one dummy rea=
d on all
> > the other droves in parallel so that all the drives have a chance t=
o spin
> > back up at the same time and not serially?
>
> Ok, so the lack of answer probably means 'no' :)
>
> Given that, is there a user space way to do this?
> I'm thinking I might be able to poll drives every second to see if th=
ey
> were spun down and got an IO. If any drive gets an IO, then the other
> ones all get a dummy read, although I'd have to make sure that read i=
s
> random so that it can't be in the cache.
>
> I take it there is no such code in existence yet, correct? :)
>
> Thanks,
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" =
- A.S.R.
> Microsoft is to operating systems ....
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0.... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--
Doug Dumitru
EasyCo LLC
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
