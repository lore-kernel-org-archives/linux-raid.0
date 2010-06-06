From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID Configuration For New Home Server
Date: Sat, 5 Jun 2010 21:01:40 -0500
Message-ID: <E7.72.03181.9810B0C4@cdptpa-omtalb.mail.rr.com>
References: <20100606010420.GA26325@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100606010420.GA26325@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: 'Keld Simonsen' <keld@keldix.com>
Cc: 'Mark Knecht' <markknecht@gmail.com>, 'Carlos Mennens' <carloswill@gmail.com>, 'Mdadm' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> From: Keld Simonsen [mailto:keld@keldix.com]
> Sent: Saturday, June 05, 2010 8:04 PM
> To: Leslie Rhorer
> Cc: 'Mark Knecht'; 'Carlos Mennens'; 'Mdadm'
> Subject: Re: RAID Configuration For New Home Server
>=20
> On Sat, Jun 05, 2010 at 06:56:31PM -0500, Leslie Rhorer wrote:
> > > > =A0 =A0 =A0 =A0It's certainly workable. =A0You might consider s=
omething other
> than
> > > > RAID1 for your swap partition.
> > >
> > > Looks reasonable. Some comments:
> > >
> >
> > > 2) I don't use RAID for swap. I let the kernel do that internally=
=2E I
> > > almost never swap out on my home server so trying to protect that=
 with
> > > RAID for the few moments I might use it seems like overkill to me=
=2E
> >
> > 	I halfway agree.  My servers almost never use any significant amou=
nt
> > of swap, and even my workstations only use it very occasionally.  T=
here
> have
> > been instances, however, where the swap has grown to be quite large=
=2E
> With
> > that in mind, and given the very small amount he has allocated for =
swap,
> one
> > might suggest a RAID0 array of the areas to be used for swap, or ma=
ybe
> an
> > LVM volume.
>=20
> If you use some mirrored RAID for swap, your system will continue to =
run,
> if
> one of your disks go bad. Then you can replace the faulty disk at a l=
ater,
> and possibly more convenient time.
>=20
> If you do not have RAID, your system will most likely go down, if the=
 swap
> partiion
> is damaged.

	True.  A 4 disk RAID1 array is overkill to the point of absurdity,
though.  Perhaps a RAID10 or RAID4 array would be a good compromise.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
