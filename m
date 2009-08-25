From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Tue, 25 Aug 2009 01:40:31 -0700 (PDT)
Message-ID: <264077.82481.qm@web51303.mail.re2.yahoo.com>
References: <20090825081617.GA8885@cthulhu.home.robinhill.me.uk>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090825081617.GA8885@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

--- On Tue, 25/8/09, Robin Hill <robin@robinhill.me.uk> wrote:

> From: Robin Hill <robin@robinhill.me.uk>
> Subject: Re: Raid 5 - not clean and then a failure.
> To: linux-raid@vger.kernel.org
> Date: Tuesday, 25 August, 2009, 9:16 AM
> On Tue Aug 25, 2009 at 12:54:49AM
> -0700, Jon Hardcastle wrote:
>=20
> > Guys,
> >=20
> > I have been having some problems with my arrays that I
> think i have
> > nailed down to a pci controller (well I say that - it
> is always the
> > drives connected to *a* controller but I have tried
> 2!) anyway the
> > latest saga is i was trying some new kernel options
> last night - which
> > didn't work.
> >=20
> Did they have the same chipset?=A0 I had problems with
> PCI controllers on
> one of my systems, which turned out to be some sort of
> conflict between
> the onboard chipset and the chipset on the
> controllers.=A0 I found a PCI
> card with a different chipset and have had no issues
> since.

They are/were cheapy little via ones from 'aria' I got a new one and in=
stalled it along side a week ago 1 drive on it to 'test', when my array=
 came to do a scrub a week later I got a whole host of issues. I am not=
 sure what the cause was but now either of the controllers seem work re=
liably. I have a pci express controller but my kernel doesnt (yet!) sup=
port pci express. Do you know of you can get sata 3 on pci? or is it to=
o slow?

> > But when i booted up again this morning it said one of
> the drives was
> > in an inconsistent state (not sure of the *exact*
> error message). I
> > then kicked off an add of the drive and it started
> syncing. It got
> > about 5% in and then the second drive in on that
> controller complained
> > and the array failed.
> >=20
> > Is there any hope for my data? If i get a good
> controller in there
> > will the resync continue? can I try and tell it to
> assume the drives
> > are good (which they ought to be)?
> >=20
> There's definitely hope.=A0 You can assemble the array
> (using the good
> drives and the last drive to fail) using the --force
> option, then re-add
> (and sync) the other drive (I'd recommend doing a fsck on
> the filesystem
> as well).=A0 I've just had to do a similar thing myself
> after two drives
> failed (overheated after a fan failure).
>=20
> Cheers,
> =A0 =A0 Robin
> --=20

Thank you, Thank you, Thank you. I probably wont look at this for a few=
 days now - i find when sitting down without enough time to really see =
it through is when I get problems! and I am abit busy bee atm!


-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------





     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
