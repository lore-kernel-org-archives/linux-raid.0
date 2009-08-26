From: Jon Hardcastle <jd_hardcastle@yahoo.com>
Subject: Re: Raid 5 - not clean and then a failure.
Date: Wed, 26 Aug 2009 07:19:51 -0700 (PDT)
Message-ID: <353971.56181.qm@web51308.mail.re2.yahoo.com>
References: <7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com>
Reply-To: Jon@eHardcastle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90908260714j4ddc6b56w580b511bdcf12491@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>, Ryan Wagoner <rswagoner@gmail.com>
Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Can a bitmap be easily removed? I might give it ago if it can.

I am never sure how thorough these checks are. Are they read/write, or =
just read? for example. I make of point of doing read/write badblocks c=
hecks with e2fck -cc when I do run them (not the automatic ones tho - d=
unno how) but that only checks that partition, which is on LVM, which i=
s on RAID so WHO KNOWS what underlying drives are being checked.

I have before now, dismantled the array and run read/write badblocks di=
rectly on the constituent drives so at least smart is aware of them and=
 although i aim to do this once every six months, I think I have actual=
ly done it only 1nce in the 2 year life of the array.

-----------------------
N: Jon Hardcastle
E: Jon@eHardcastle.com
'Do not worry about tomorrow, for tomorrow will bring worries of its ow=
n.'
-----------------------


--- On Wed, 26/8/09, Ryan Wagoner <rswagoner@gmail.com> wrote:

> From: Ryan Wagoner <rswagoner@gmail.com>
> Subject: Re: Raid 5 - not clean and then a failure.
> To: "Goswin von Brederlow" <goswin-v-b@web.de>
> Cc: Jon@ehardcastle.com, linux-raid@vger.kernel.org
> Date: Wednesday, 26 August, 2009, 3:14 PM
> Wouldn't weekly RAID consistency
> checks reveal a bad block before you
> had a failure that required the need to do a full resync?
> It only
> takes 3 hours to resync my 3 x 1TB drives and having a
> bitmap would
> reduce the performance. I've never had to have a resync in
> the year
> I've had the array up. I just wonder if the performance
> drawback is
> worth having the bitmap to save a possible resync once
> every couple
> years. Or are the RAID consistency checks not reliable
> enough to
> prevent more errors during a resync?
>=20
> Ryan
>=20
> On Wed, Aug 26, 2009 at 7:18 AM, Goswin von Brederlow<goswin-v-b@web.=
de>
> wrote:
> > Jon Hardcastle <jd_hardcastle@yahoo.com>
> writes:
> >
> >> Guys,
> >>
> >> I have been having some problems with my arrays
> that I think i have nailed down to a pci controller (well I
> say that - it is always the drives connected to *a*
> controller but I have tried 2!) anyway the latest saga is i
> was trying some new kernel options last night - which didn't
> work.
> >>
> >> But when i booted up again this morning it said
> one of the drives was in an inconsistent state (not sure of
> the *exact* error message). I then kicked off an add of the
> drive and it started syncing. It got about 5% in and then
> the second drive in on that controller complained and the
> array failed.
> >>
> >> Is there any hope for my data? If i get a good
> controller in there will the resync continue? can I try and
> tell it to assume the drives are good (which they ought to
> be)?
> >>
> >> Please help!
> >
> > The inconsistency is probably just a block here or
> there and I'm
> > assuming none of your drives actualy failed. So
> 99.9999% of your data
> > should be there. Just rebooting might actualy just get
> your raid back
> > (to syncing). If not then you have to force reassembly
> from the drives
> > with the newest serials. That will give you some data
> corruption,
> > whatever was writing when the controler gave errors.
> Worst case you
> > have to recreate the raid with --assume-clean.
> >
> > I recommend adding a bitmap to the raid. That way a
> wrongfully failed
> > drive can be resynced in a matter of minutes instead
> of hours or
> > days. Makes it way less likely another error occurs
> during resync.
> >
> > MfG
> > =A0 =A0 =A0 =A0Goswin
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
> >
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=A0 http://vger.kernel.org/majordomo-info.html
>=20


     =20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
