From: Neil Brown <neilb@suse.de>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Fri, 2 May 2008 13:14:23 +1000
Message-ID: <18458.34575.416075.798546@notabene.brown>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
	<18408.36712.100712.499844@notabene.brown>
	<20080428162556.00ee0d72.taeuber@bbaw.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Lars Tauber on Monday April 28
Sender: linux-raid-owner@vger.kernel.org
To: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Cc: Anton Altaparmakov <aia21@cam.ac.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday April 28, taeuber@bbaw.de wrote:
> Hallo Neil,
>=20
> Neil Brown <neilb@suse.de> schrieb:
> > On Thursday March 13, aia21@cam.ac.uk wrote:
> > >=20
> > > Is there a better way to do this?  I am hoping someone will tell =
me to =20
> > > use option blah to utility foo that will do this for me without h=
aving =20
> > > to break the mirror twice and resync each time.  (-;
> >=20
> > Sorry, but no.  This mode of operation was never envisaged for md.
> > I would always put the md/raid1 devices below the LVM.
>=20
> could you write in some short words what in the design prohibits us t=
o grow a raid1 on a grown lvm?

By default, the metadata for an md array is stored near the end of
each device.  If you make the device larger, you lose the metadata.
This could be address for on-line resizing by having some protocol
whereby the LVM layer tells whoever is using it that it is about to
become larger, so that the metadata can be updated and moved, but that
is probably more hassle than it is worth.

If you use version 1.1 or 1.2 metadata, the metadata is stored at the
start of the device, so it doesn't get lost.  However the metadata has
recorded in it the amount of usable space on the device.  When you
make the device bigger you would need to update this number.
There is currently no way to update this for an active array.

You can stop the array, and the re-assemble it with=20
   --update=3Ddevicesize

this will update the field in the metadata which records the size of
each device.  You will then be able to grow the array to make use of
all the space.

It might not be to hard to make it possible to tell md that devices
have grown.... maybe one day :-)

NeilBrown



> We wanted to do the same:
>=20
>=20
> mutliple RAID1 (aoe targets)
> on top of
> multiple LVMs
> on top of
> gigantic RAID6
>=20
>=20
> Thanks
> Lars
> --=20
>                             Informationstechnologie
> Berlin-Brandenburgische Akademie der Wissenschaften
> J=E4gerstrasse 22-23                     10117 Berlin
> Tel.: +49 30 20370-352           http://www.bbaw.de
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
