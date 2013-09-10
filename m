From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 1/2] DDF: brief_examine_subarrays_ddf: print array name
Date: Tue, 10 Sep 2013 10:01:51 +1000
Message-ID: <20130910100151.31048cad@notabene.brown>
References: <1378502781-849-1-git-send-email-mwilck@arcor.de>
	<20130909111546.2e9551b1@notabene.brown>
	<522E13EF.3080001@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/NetQt=3KT94iBPqLcqNbR5v"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <522E13EF.3080001@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/NetQt=3KT94iBPqLcqNbR5v
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 09 Sep 2013 20:31:11 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> >> Print an array name in brief output. Do this even if no name is set,
> >> faking a simple pseudo name (may happen for some BIOS RAIDs).
> >> This makes DDF and IMSM behave equally.
> >>
> >> SUSE's YaST2 needs this in order to detect MD arrays during
> >> installation.
> >=20
> > Thanks, but I don't like this - I would really rather SUSE's YaST2 got =
fixed.
> >=20
> > mdadm.conf is really for mdadm to read.  And the "--brief" output is me=
ant
> > for inclusion in mdadm.conf.
> >=20
> > If other programs want to parse the output of mdadm, they should use
> > --export, not --brief.
>=20
> Well, yast is actually not calling --brief. It calls "mdadm --examine
> --scan", and --scan implies --brief (comment in mdadm.c). My patch
> simply causes DDF and IMSM to print similar output with "mdadm -Es".
> Isn't that reasonable?

This bit that I really didn't like is where you synthesised a "ddf_%d" name
if the name field was empty.  This is wrong.

There are a couple of other places where the name is extracted from the
ddf metadata: getinfo_super_ddf_bvd and container_content_ddf.
If brief_examine_subarrays_ddf uses the name in the same way following
the same rules (e.g. discarding trailing spaces) then that would be OK.
But if the name is empty, then no name should be given in the 'array' line.

NeilBrown

>=20
> Martin
>=20
>=20
> >=20
> > NeilBrown
> >=20
> >>
> >> Signed-off-b545d3bca8b105ba10dadbab2fcd31467b5613c11y: Martin Wilck <m=
wilck@arcor.de>
> >> ---
> >>  super-ddf.c |   13 +++++++++++--
> >>  1 files changed, 11 insertions(+), 2 deletions(-)
> >>
> >> diff --git a/super-ddf.c b/super-ddf.c
> >> index 8bba70a..72a8351 100644
> >> --- a/super-ddf.c
> >> +++ b/super-ddf.c
> >> @@ -30,6 +30,7 @@
> >>  #include "mdmon.h"
> >>  #include "sha1.h"
> >>  #include <values.h>
> >> +#include <ctype.h>
> >> =20
> >>  /* a non-official T10 name for creation GUIDs */
> >>  static char T10[] =3D "Linux-MD";
> >> @@ -1577,14 +1578,22 @@ static void brief_examine_subarrays_ddf(struct=
 supertype *st, int verbose)
> >>  		struct virtual_entry *ve =3D &ddf->virt->entries[i];
> >>  		struct vcl vcl;
> >>  		char nbuf1[64];
> >> +		char namebuf[sizeof(ve->name)+1], *c;
> >>  		if (all_ff(ve->guid))
> >>  			continue;
> >>  		memcpy(vcl.conf.guid, ve->guid, DDF_GUID_LEN);
> >>  		ddf->currentconf =3D&vcl;
> >>  		uuid_from_super_ddf(st, info.uuid);
> >>  		fname_from_uuid(st, &info, nbuf1, ':');
> >> -		printf("ARRAY container=3D%s member=3D%d UUID=3D%s\n",
> >> -		       nbuf+5, i, nbuf1+5);
> >> +		memcpy(namebuf, ve->name, sizeof(ve->name));
> >> +		namebuf[sizeof(ve->name)] =3D '\0';
> >> +		if (namebuf[0] =3D=3D '\0')
> >> +			sprintf(namebuf, "ddf_%d", i);
> >> +		for (c =3D namebuf; c < namebuf + sizeof(ve->name); c++)
> >> +			if (isspace(*c))
> >> +				*c =3D '-';
> >> +		printf("ARRAY /dev/md/%s container=3D%s member=3D%d UUID=3D%s\n",
> >> +		       namebuf, nbuf+5, i, nbuf1+5);
> >>  	}
> >>  }
> >> =20
> >=20


--Sig_/NetQt=3KT94iBPqLcqNbR5v
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUi5hbznsnt1WYoG5AQIgBw/+JxQ8ENbecQpuSo3o6SJisS/CwhGFloiD
ZdEvl/xu9oZScwRFnsyQpENqMC/pbWfJjzDKQ1wI/m1wYO1rvywEp8gzIB5XIuvn
tqTnGhRrbNCPXtxvb21nivs0SVeXLaUI0yl3QhREyN/rghUBnQevei403/gkaVVr
qF+pbllBa1MIFqeS7xSt0qF2iEwibtcLMnviJpyYeJx8dWkOqMqkjEQMT3wfE9cz
Gv+tWKbEA1383TB6WYcRSFTssa+EkWtMhZekgDjm4DYWHj9m5hcrHTtLiZlBYYNq
/GVsVvKmwHqMsiCfWU6+sPhSLf97qNoXmbIV9G6Kn+dH+J1OihAVLnzPG6RHlEfS
Y12Y97x8Zs+dPIbybD8RIRcASErhl0J7oIKy0ZMTiZTJqb5SOL4RpmmiAKYqRlKx
MwNsblAJhuIWR/2Oyw4VikQs7CzX42rw3AMTZaqvzdjiPUMF/oIO1aG2bPnd1R0B
Hl4lfc2tQTodcbBdbADADZqOYhXdjBCWWzF7JW72cAfSFysJVpi80CIDSrRnwPjC
4w3eBW3/+fY/qkXMYXGZh8HFmhOVdoPSJj+EdPdIqUJPGKg3OFB/OFIwbWtQIFoQ
muQTPFcU9t+GVN1rlC/d0fX9qyLxXxtGAtTor2JNQU/GTl/ia6O4foWut4FKjHm4
StMnSpJlZZo=
=1C//
-----END PGP SIGNATURE-----

--Sig_/NetQt=3KT94iBPqLcqNbR5v--
