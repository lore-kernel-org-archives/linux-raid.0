From: Jose Manuel dos Santos Calhariz <jose.spam@netvisao.pt>
Subject: Re: Script to save array info
Date: Fri, 22 Jun 2012 12:50:51 +0100
Message-ID: <20120622115051.GA24066@calhariz.com>
References: <20120620232149.GA7767@animx.eu.org>
 <20120621142613.GA28130@calhariz.com>
 <20120621213700.GC10443@animx.eu.org>
Reply-To: jose.spam@netvisao.pt
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="M9NhX3UHpAaciwkO"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120621213700.GC10443@animx.eu.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--M9NhX3UHpAaciwkO
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 21, 2012 at 05:37:00PM -0400, Wakko Warner wrote:
> Jose Manuel dos Santos Calhariz wrote:
> > On Wed, Jun 20, 2012 at 07:21:49PM -0400, Wakko Warner wrote:
> > > After reading some of the stories about lost metadata, I was wonderin=
g if
> > > anyone had a script that would output the member info for each device=
 with
> > > the device's physical serial number.
> > >=20
> > > For a crude one I did this while in /sys/block:
> > > for x in sd*;do
> > > 	echo /dev/$x
> > > 	/lib/udev/scsi_id --export --page=3D0x80 --whitelisted /dev/$x
> > > 	mdadm -E /dev/$x
> > > done
> > >=20
> > > And saved the output.  It works for me because all but 3 of my raid m=
embers
> > > are full disks.
> >=20
> > I made a script for myself, that collects the information by
> > inspecting /sys instead of doing mdadm -E.  The script see all mdraid
> > devices and all devices that belong to a mdraid.  I would like to know
> > if the script works or not.  It works for me.
>=20
> I've looked into /sys/block/md*/md before.  I've noticed there is
> information not present in the output.
>=20
> I just checked.  About the only thing important to me would be the "name"
> that mdadm -E lists.  I don't know how important UUIDs would be but it co=
uld
> be.
>=20
> Looks like your script does essentially this one liner:
> find /sys/block/md*/md -type f | xargs grep .
>=20
> I didn't run it though.  I think yours added the ls -l of the rdX/block/
> link.
> I looked through everything in the block for some of my devices and none =
had
> the serial number.  I had to use scsi_id from udev to get it.

Good points, my script is a fragment of a bigger script to collect
information about a system.  In my bigger script:

  - I get the UUID of the raid by running "mdadm --detail" for all
  /dev/md*.=20

  - I get the serial number by running "smartctl -a" for all disks and
  collect health information too.

>=20
> One thing you might want to do to yours is "exec >> ${FILEMD}" instead of=
 all
> the >> ${FILEMD} that you had in your file.
>=20

     Jose Calhariz

--=20
--

Ambi=E7=E3o: um supremo desejo de ser vilipendiado por seus inimigos enquan=
to voc=EA est=E1 vivo e ser ridicularizado pelos amigos quando estiver morto

--Ambrose Bierce

--M9NhX3UHpAaciwkO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBCAAGBQJP5FwbAAoJEDSKd41ohe+PezsP/jUbZGILQ10M1TTAThAoSLRP
RF5d30QIYLlCgSPVNn2hQ3XZf/nHdDyqiuAb0HayAQ/GYIgx/ynunOfkW7TudmvE
os26/JUr1ZMihxdhcOSPxh2QotIciWE6WKFu5Dtmy/5zJp1e2aUwC4FNfqHlW0Ah
jhGFdmA/lD8C7dIoHKmhH5SJuhDqqlxjl/Fvew1pxmTi0teOsSvE84BSCx7GTmM5
vdBZF57xQ9Tp8UCFsMuwOvf3sagFc2Qbnmvl0Wt2E1JrghSUluiRu4hjttdJHx+s
+cpLonv13qRSq+aZI9XQIZ+edIodeykpc0hNKUhO/uUk7e2nnyCpswFDtiNsHD1V
Kg+o5r3dszIoCMR2Yjg0CNkPp/GRfsoAVZCe2ppLSJXmLIZZHfM+kzpP0J26TZuj
E3+txh9Q+v05Fc2P9na0ce8N4/0uQRIMD1J6nSv+Kf86GNpnjnCfpJ8Kb17usHVc
Ieu40RwIf/T8k49RbajbA47LzRWVIC1HHJO7L+Fjb1olIlrH0GVXApfLRSvE9Gsn
Izna2tFFtOYMbGHs5HhIlRV0BODYf2yH8nhhBulutOcz9kozdvlzs+Nyju8bTSs7
bG+YxPy0d+wpe2GoDqnD6IO8tMG40a/NVlJND3Fk6aZoTEnNCnteUPwoFiNH8ABc
GWwT6j+ndUltDSavffKx
=UWJD
-----END PGP SIGNATURE-----

--M9NhX3UHpAaciwkO--
