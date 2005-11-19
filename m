From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: raid5 write performance
Date: Fri, 18 Nov 2005 23:40:57 -0500
Message-ID: <200511190440.jAJ4efw15919@www.watkins-home.com>
References: <437E2A43.4090207@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <437E2A43.4090207@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mike Hardy' <mhardy@h3c.com>, 'Dan Stromberg' <strombrg@dcs.nac.uci.edu>
Cc: =?ISO-8859-2?Q?'Jure_Pe=E8ar'?= <pegasus@nerv.eu.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Mike Hardy
> Sent: Friday, November 18, 2005 2:24 PM
> To: Dan Stromberg
> Cc: Jure Pe=E8ar; linux-raid@vger.kernel.org
> Subject: Re: raid5 write performance
>=20
>=20
> Moreover, and I'm sure Neil will chime in here, isn't the clean/uncle=
an
> thing designed to prevent this exact scenario?
>=20
> The array is marked unclean immediately prior to write, then the writ=
e
> and parity write happens, then the array is marked clean.
>=20
> If you crash during the write but before parity is correct, the array=
 is
> unclean and you resync (quickly now thanks to intent logging if you h=
ave
> that on)
>=20
> The non-parity blocks that were partially written are then the
> responsibility of your journalling filesystem, which should make sure
> there is no corruption, silent or otherwise.
>=20
> If I'm misunderstanding that, I'd love to be corrected. I was under t=
he
> impression that the "silent corruption" issue was mythical at this po=
int
> and if it's not I'd like to know.
>=20
> -Mike

It is not just a parity issue.  If you have a 4 disk RAID 5, you can't =
be
sure which if any have written the stripe.  Maybe the parity was update=
d,
but nothing else.  Maybe the parity and 2 data disks, leaving 1 data di=
sk
with old data.

Beyond that, md does write caching.  I don't think the file system can =
tell
when a write is truly complete.  I don't recall ever having a Linux sys=
tem
crash, so I am not worried.  But power failures cause the same risk, or
maybe more.  I have seen power failures, even with a UPS!

Guy

>=20
> Dan Stromberg wrote:
> > Would it really be that much slower to have a journal of RAID 5 wri=
tes?
> >
> > On Fri, 2005-11-18 at 15:05 +0100, Jure Pe=E8ar wrote:
> >
> >>Hi all,
> >>
> >>Currently zfs is a major news in the storage area. It is very
> interesting to read various details about it on varios blogs of Sun
> employees. Among the more interesting I found was this:
> >>
> >>http://blogs.sun.com/roller/page/bonwick?entry=3Draid_z
> >>
> >>The point the guy makes is that it is impossible to atomically both
> write data and update parity, which leaves a window of crash that wou=
ld
> silently leave on-disk data+paritiy in an inconsistent state. Then he
> mentions that there are software only workarounds for that but that t=
hey
> are very very slow.
> >>
> >>It's interesting that my expirience with veritas raid5 for example =
is
> just that: slow to the point of being unuseable. Now, I'm wondering w=
hat
> kind of magic does linux md raid5 does, since its write performance i=
s
> quite good? Or, does it actually do something regarding this? :)
> >>
> >>Niel?
> >>
> >
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
