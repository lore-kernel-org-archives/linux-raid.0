From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Allow restarting an interrupted incremental
 recovery.
Date: Wed, 19 Oct 2011 10:00:08 +1100
Message-ID: <20111019100008.5ba51b9e@notabene.brown>
References: <339397930.59570.1318968365639.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
	<1009697343.60005.1318968927271.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/LQFFaGgiOa4CyueybeXZut3"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1009697343.60005.1318968927271.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Warkentin <awarkentin@vmware.com>
Cc: linux-raid@vger.kernel.org, Andrei Warkentin <andreiw@vmware.com>
List-Id: linux-raid.ids

--Sig_/LQFFaGgiOa4CyueybeXZut3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 18 Oct 2011 13:15:27 -0700 (PDT) Andrei Warkentin
<awarkentin@vmware.com> wrote:

> ----- Original Message -----
> > From: "Andrei Warkentin" <awarkentin@vmware.com>
> > To: "NeilBrown" <neilb@suse.de>
> > Cc: linux-raid@vger.kernel.org, "Andrei Warkentin" <andreiw@vmware.com>
> > Sent: Tuesday, October 18, 2011 4:06:05 PM
> > Subject: Re: [PATCH] MD: Allow restarting an interrupted incremental re=
covery.
> >=20
> > Hi Neil,
> >=20
> > ----- Original Message -----
> > > From: "Andrei Warkentin" <awarkentin@vmware.com>
> > > To: "NeilBrown" <neilb@suse.de>
> > > Cc: linux-raid@vger.kernel.org, "Andrei Warkentin"
> > > <andreiw@vmware.com>
> > > Sent: Tuesday, October 18, 2011 1:07:24 PM
> > > Subject: Re: [PATCH] MD: Allow restarting an interrupted
> > > incremental recovery.
> > >=20
> > > > Also I realised that clearing saved_raid_disk when an array is
> > > > not
> > > > degraded
> > > > is no longer enough.  We also need to clear it when the device
> > > > becomes
> > > > In_sync.
> > > > Consider a 3-drive RAID1 with two drives missing.  You add back
> > > > one
> > > > of them
> > > > and when it is recovered it needs saved_raid_disk cleared so that
> > > > the
> > > > superblock gets written out.
> > > >=20
> > > > So below is what I applied.
> > > >=20
> > >=20
> > > Wouldn't all drives being In_sync imply the array is not degraded -
> > > i.e. can the
> > > check for a degraded array be omitted then, at all? I.e. if after
> > > the
> > > resync the
> > > In_sync bit is set - drop saved_raid_role.
> > >=20
> >=20
> > Come to think of it - checking for !mddev->degraded might not be a
> > good idea at all. After all, you
> > could imagine a situation where in a RAID1 array with A and B, A is
> > recovered from B and then B goes away before
> > the SBs are flushed due to resync finishing - you would still want
> > A's SB to be flushed, even if array is degraded.
> >=20
> > Otherwise you'll end up with another incremental rebuilding A, and
> > lost/inconsistent data after array became degraded (since it was
> > going to A, but we never wrote out its SB, since array is degraded).
> >=20
>=20
> Errr, I confused myself. This is exactly why you added the check for In_s=
ync.
> OTOH, isn't the mddev->degraded now superflous - i.e. if all disks are In=
_sync,
> there is no need to check for degraded, right?
>=20
> A

Maybe.
However once we clear mddev->degraded we can start clearing bits in the
bitmap, so any saved_raid_disk information is definitely invalid and should
be removed.
You would expect that there won't be any, and you would probably be right.
But it feels safer keeping the check there.  It is probably superfluous, but
sometimes a little paranoia can be a good thing.

Thanks,
NeilBrown

--Sig_/LQFFaGgiOa4CyueybeXZut3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTp4E+Dnsnt1WYoG5AQL04Q/+NFkivQlMgk7mpd44Y/9Y1SQyqdEqc+FT
+fql0ynhVAso89BQ8M+yNbG5CJjpiITkmmDz3hLRR5S2GSo+z3i8l0+Kd6nRA6Uz
sOykImVEnulQdkUzhctSkUDiR0XXRuE910Oec/Z5eS09Gd80GjFk6glS1AjDwt5J
cmBmP00zj2kFNSrAzj04v+JvCnZAXHnsbedon+pYGklNcjKgDTWwAXjLdpqqyYdl
Ss2WiSTpApu3x1cRb5rVtrOYpji+nnvZ2nrFbfkEsM3s/7mOfKrODt8tvrKt357v
VncnfLXWcEA8ExrT3HnT8oktEfFStGkqH7dTCLKem5m4sEjdpNuXjALm6lygJAeh
qIMAT0T05+BztQV8jjzh1ryUFhIgCo6HOeRs/uRq4pVepwdvxbtZbSco2C3w7EnO
PrE5G7QRk081IJ4KpfpwmhvA2GPhNzhWbvoxqYRmkd/QpO7AoA1445SvwlnsCzVY
/3yz2JQMw1HvwxQXsnVjX3EKQluSwkYdXNm8/5mJOj5PYsL2NjObVzctMdTpSfrx
LS1iAlf8/ZtNohFIHX0JNOx4RoLbHV2YqXwf16IR+GpIzezKeK4blFF6to4PKHBA
sBqIXlDu+j6o90A3VHSmVn1869J7FGz4shaapcb2th7+bh7POan1GuIFY1Ftp3IM
lChx/TNgi9Y=
=jrtt
-----END PGP SIGNATURE-----

--Sig_/LQFFaGgiOa4CyueybeXZut3--
