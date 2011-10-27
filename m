From: NeilBrown <neilb@suse.de>
Subject: Re: [md PATCH 00/16] hot-replace support for RAID4/5/6
Date: Fri, 28 Oct 2011 07:44:45 +1100
Message-ID: <20111028074445.7ecfa029@notabene.brown>
References: <20111026014240.21110.28487.stgit@notabene.brown>
	<1319735434.3930.34.camel@hermosa.site>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/K94BOo7r_7zdPy51qCKr7PF"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1319735434.3930.34.camel@hermosa.site>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter W. Morreale" <morreale@sgi.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/K94BOo7r_7zdPy51qCKr7PF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Oct 2011 11:10:34 -0600 "Peter W. Morreale" <morreale@sgi.com>
wrote:

> On Wed, 2011-10-26 at 12:43 +1100, NeilBrown wrote:=20
> > The following series - on top of my for-linus branch which should appea=
r in
> > 3.2-rc1 eventually - implements hot-replace for RAID4/5/6.  This is alm=
ost
> > certainly the most requested feature over the last few years.
> > The whole series can be pulled from my md-devel branch:
> >    git://neil.brown.name/md md-devel
> > (please don't do a full clone, it is not a very fast link).
> >=20
> > There is currently no mdadm support, but you can test it out and
> > experiment without mdadm.
> >=20
> > In order to activate hot-replace you need to mark the device as
> > 'replaceable'.
> > This happens automatically when a write error is recorded in a
> > bad-block log (if you happen to have one).
> > It can be achieved manually by
> >    echo replaceable > /sys/block/mdXX/md/dev-YYY/state
> >=20
> > This makes YYY, in XX, replaceable.
> >=20
> > If md notices that there is a replaceable drive and a spare it will
> > attach the spare to the replaceable drive and mark it as a
> > 'replacement'.
> > This word appears in the 'state' file and as (R) in /proc/mdstat.
> >=20
> > md will then copy data from the replaceable drive to the replacement.
> > If there is a bad block on the replaceable drive, it will get the data
> > from elsewhere.  This looks like a "recovery" operation.
> >=20
> > When the replacement completes the replaceable device will be marked
> > as Failed and will be disconnected from the array (i.e. the 'slot'
> > will be set to 'none') and the replacement drive will take up full
> > possession of that slot.
>=20
> Neil,
>=20
> Seems to work quite well.  Note I have not yet performed a data
> consistency check, just the mechanics of 'replacing' an existing
> drive. =20
>=20
> I see in the code that a recovery is kicked immediately after changing
> the state of a drive.  One question is whether it will be possible to
> mark multiple drives for replacement, then invoke the recovery one time,
> replacing all disks marked in a single pass?
>=20
> Right now, it changing state on multiple drives kicks off sequential
> recoveries.  For larger disks (3TB/etc), recovery takes a long time and
> there is a non-zero performance hit on the live array.
>=20
> There are two common use cases to think about.  First being an array
> disk replacement to (say) larger disks.  Second being a new array in use
> for a period of time where the disks are approaching end-of-life, and
> multiple disks are showing signs of possible failure.  So we want to
> replace a number of them at one time and incur the performance hit one
> time.=20
>=20
> I see where the code limits a recovery to one sync at a time, would it
> be possible to extend this to multiple concurrent replacements?
>=20
> What would it take to enable this?

echo frozen > /sys/block/mdX/md/sync_action
for i in /sys/block/mdX/md/dev-*/state
do echo replaceable > $i
done
echo repair > /sys/block/mdX/md/sync_action

should do it.  You certainly should be able to replace several devices at t=
he
same time using this approach, though I haven't tried it.

(hmmm... it probably shouldn't accept a 'replaceable' flag on spares - I'll
make a note of that).

>=20
> Thanks again for this effort, this is terrific.=20

Thanks.

NeilBrown


>=20
> Best,
> -PWM
>=20
>=20
> >=20
> > It is not possible to assemble an array with replacement with mdadm.
> > To do this by hand:
> >=20
> >   mknod /dev/md27 b 9 27
> >   < /dev/md27
> >   cd /sys/block/md27/md
> >   echo 1.2 > metadata_version
> >   echo 8:1 > new_dev
> >   echo 8:17 > new_dev
> >    ...
> >   echo active > array_state
> >=20
> > Replace '27' by the md number you want.  Replace 1.2 by the metadata
> > version number (must be 1.x for some x).  Replace 8:1, 8:17 etc
> > by the major:minor numbers of each device in the array.
> >=20
> > Yes: this is clumsy.  But they you aren't doing this on live data -
> > only on test devices to experiment.
> >=20
> > You can still assemble the array without the replacement using mdadm.
> > Just list all the drives except the replacement in the --assemble
> > command.
> > Also once the replacement operation completes you can of course stop
> > and assemble the new array with old mdadm.
> >=20
> > I hope to submit this together with support for RAID10 (and maybe some
> > minimal support for RAID1) for Linux-3.3. By the time it comes out
> > mdadm-3.3 should exist will full support for hot-replace.
> >=20
> > Review and testing is very welcome, be please do not try it on live
> > data.
> >=20
> > NeilBrown
> >=20
> >=20
> > ---
> >=20
> > NeilBrown (16):
> >       md/raid5: Mark device replaceable when we see a write error.
> >       md/raid5: If there is a spare and a replaceable device, start rep=
lacement.
> >       md/raid5: recognise replacements when assembling array.
> >       md/raid5: handle activation of replacement device when recovery c=
ompletes.
> >       md/raid5:  detect and handle replacements during recovery.
> >       md/raid5: writes should get directed to replacement as well as or=
iginal.
> >       md/raid5: allow removal for failed replacement devices.
> >       md/raid5: preferentially read from replacement device if possible.
> >       md/raid5: remove redundant bio initialisations.
> >       md/raid5: raid5.h cleanup
> >       md/raid5: allow each slot to have an extra replacement device
> >       md: create externally visible flags for supporting hot-replace.
> >       md: change hot_remove_disk to take an rdev rather than a number.
> >       md: remove test for duplicate device when setting slot number.
> >       md: take after reference to mddev during sysfs access.
> >       md: refine interpretation of "hold_active =3D=3D UNTIL_IOCTL".
> >=20
> >=20
> >  Documentation/md.txt      |   22 ++
> >  drivers/md/md.c           |  132 ++++++++++---
> >  drivers/md/md.h           |   82 +++++---
> >  drivers/md/multipath.c    |    7 -
> >  drivers/md/raid1.c        |    7 -
> >  drivers/md/raid10.c       |    7 -
> >  drivers/md/raid5.c        |  462 +++++++++++++++++++++++++++++++++++--=
--------
> >  drivers/md/raid5.h        |   98 +++++-----
> >  include/linux/raid/md_p.h |    7 -
> >  9 files changed, 599 insertions(+), 225 deletions(-)
> >=20
> > --=20
> > Signature
> >=20
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--Sig_/K94BOo7r_7zdPy51qCKr7PF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTqnCxDnsnt1WYoG5AQKFTw//clHzZFMwfT/+RU5bmkWx6m+fu9us56u0
aAA6YWRGZkqsL7A/XkRfnyjF5KhaHlUj1MJ8Bu4GHfJeDa1E2i9nPHwvHMpL9bch
LRuPLfi7VeVfAo11FAG9J5Qbp+KoiWSq8oECRZTs6qDA7D/2IVN3ubk5p4eaqh29
wVrBUqjtaoEuWygR3GAaMq2VNUX3aJD8Bu4RE/LMxoHQHMl1C7gTNVwA1swHBKna
kKlgrAc9crEo0thb8NdoFxCKj8oq9CRwzrAzvQsXVxKJMwN1Ynsfzypgxxqw1YYv
LC8iiWlWb4y0J2cj0IhNDKFAukUu5eKmhSKzbcF3p10I0AxDIefJg/LiGq/JN75K
IOIjPReyuCaqskvAGkZzsYhltpjJqA7LJsLXaQ+O2vPuhMAdknYmtIDeFyVmt0DB
OFkKa2vF83vJoCNpCPjAbA2Z1iCBP3aZVuWK4utMWfyYDFFysIV56tqLVIAYo496
5KaaK8z+NgfQiDzocu1vbvRrieW2JF7a/Xn81Sa1SFwB6XdZXrQ4Kn3P8YaPnE5l
79cmH+Th/POb3w/8PW3oHbphX5/5U/tcs6nArmTmoEb+fM6BE2bOQHL2WyJvYE6r
ty9ZuZHENbjo1kn26ZzYR0w4IKdj9io73ey7HBZb7pBsH8Hts/Xt4V6arQemYfBv
C9U7TlzUXMo=
=VoZp
-----END PGP SIGNATURE-----

--Sig_/K94BOo7r_7zdPy51qCKr7PF--
