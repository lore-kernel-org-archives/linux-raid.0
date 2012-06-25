From: NeilBrown <neilb@suse.de>
Subject: Re: Can't expand linear RAID on top of 2 x RAID1
Date: Mon, 25 Jun 2012 12:52:24 +1000
Message-ID: <20120625125224.6e33b342@notabene.brown>
References: <4FE44BDD.302@websitemanagers.com.au>
	<4FE4FA32.8010506@hardwarefreak.com>
	<32a64312-93cd-47d7-9154-2e28eda58003@email.android.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/29OMYFj/nVXecft_MTk9nUf"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <32a64312-93cd-47d7-9154-2e28eda58003@email.android.com>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/29OMYFj/nVXecft_MTk9nUf
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 23 Jun 2012 12:53:12 +1000 Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:

> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>=20
> >On 6/22/2012 5:41 AM, Adam Goryachev wrote:
> >> I have expanded my system over time, I started with 2 x 2TB drives in
> >> RAID1 (md2)
> >>=20
> >> I then added 2 x 750GB drives, configured as RAID1 (md1)
> >> Then created a third raid (md3) as linear with the md2 + md1
> >>=20
> >> Finally, I've upgraded the 2 x 750G to 2 x 1TB drives (one at a
> >time).
> >>=20
> >> I then did a mdadm --grow to expand the RAID1 from 750G to 1TB
> >>=20
> >> The problem I am having is that I can't expand the linear (md3) array
> >to
> >> grow the extra 250G of space.
> >>=20
> >> Could anyone suggest how I might be able to get the extra 250G of
> >space
> >> to become available?
> >
> >If you think about this for a few minutes more, and re-read how md
> >--linear works, and thus how growing a linear array works, you'll
> >surely
> >understand why you can't do what you're attempting to do.
>=20
> Actually, no I don't understand the problem... From my (probably limited)=
 understanding, linear simply appends each drive to the array. I understand=
 that you would not be able to increase the size of any constituent device =
which is not the last component of the array, but I don't see any reason wh=
y it is not possible to increase the size of the last component. (Which is =
what I am attempting to do)
>=20
> >As for seeing that extra 250GB, I don't have an answer.  Typically
> >linear arrays are used in lieu of growing constituent member arrays.
> >That's kinda the whole point of linear (concatenation).
>=20
> Well, the only other alternative I can think of is to reduce the size of =
the array back to 750G, reduce the size of the partitions for that array to=
 750G. Then create a new 250G partition on the two 1TB drives, create a fou=
rth RAID1 array, and then add that 4th RAID1 array to the end of the existi=
ng linear array. This just didn't seem like a very good solution (ie, not c=
lean).
>=20
> >You could try deleting the linear array and simply creating a new one.
> >But surely the changed offsets would wreak havoc on the filesystem
> >currently spanning this mess.
>=20
> Perhaps this would work. If I delete the linear array and re-create, with=
 assume-clean (or whatever the right flag is, I'll read the man page later =
when I'm doing it), then like I said, the first component device will be th=
e same, the second component device is the same, but just happens to be big=
ger. Any comments on whether this should work?

The is no '--assume-clean' for linear.  Linear arrays cannot be clean or
dirty as md stores no redundant information.

Just re-creating the array would probably work, but there is an easier way.

md doesn't record the size of the array for Linear and RAID0.  It just adds
together the sizes of the devices that it finds.

With 1.x metadata, md does record the effective size of each devices, so ad=
ds
those together.
You can update this effective size by assembling with=20
   --update=3Ddevicesize

I just checked this will loop devices and it works as expected (assuming you
have 1.1 or 1.2 metadata).
So:
  mdadm -S /dev/md2
  mdadm -A --update=3Ddevicesize /dev/md0 /dev/md1

(order doesn't matter with assemble).

>=20
> What should I do to ensure that the component devices are ordered the way=
 I think they are? Apparently the numbers in /proc/mdstat just tell me what=
 order the devices were added, not what order they are in the array?

mdadm --detail  or mdadm --examine would tell you what you want to know.

NeilBrown


>=20
> Thank you for your advice.
>=20
> Regards,
> Adam
>=20
>=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/29OMYFj/nVXecft_MTk9nUf
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+fSaDnsnt1WYoG5AQL6pBAAr9d4ETQaWoRhVVIwysHtIpOcpVfGcqwS
ymRTclwh5RHLFuUaoeYKIPgmcZ2KKmQL82X6KSFfPUZz5J7sOMR1YE2FLPWF0Mfs
JqBK9WddOkyMQarBRLGeavl4nnTtPJsN9aFk6fi4YfxAfKUrWZwooDIFj3veZ1Ee
G6vqFjiJT2iUaBN5ivLuLYdHE74hIVJvtnPIEsGI6k3B1dgfH8yLZmphB0Wo81Xp
5zbENuCKMle4Bn562Ky2GhOrQ6wlTnYZy5wpBGU1uLfH1mct5ieTo/LsHbk7lhgx
9jqC+MzAs/k/lG/hxl1EnTWOc8z8EOOZp7REbzP232yjgcrAnT+R2iUkznUA8jGD
yFnsiV7OuUoFMp2HjmsjH+/pfXzWvyf0CxA5h71pVODSrnnrF8o9XHiUgKWY/Fvn
AbUNggGCot3kXbIgKCla1qj9P+So0S19qdAvxoE4EVW5PXZjgc8yivQYvsxiVNco
gVqXvncC3bM2p38fgIwvWfLx4BT1QuESbiQn+trnmR5qP3gf0bZ8A6E74fU3Cw3Y
scHmNKUEKahg/Hi4LULUifOHxsRKs8DRYV/DmvrYA+6WAU/+9FCIWUj+ch3pRaFY
Goek7Lvmx0mC1I0B4DxuMlDMgLggE5n8q2cpGG6ZHCaNW+RRBeieGQhVjqPOl30s
VP/LyGAWh/0=
=gwqv
-----END PGP SIGNATURE-----

--Sig_/29OMYFj/nVXecft_MTk9nUf--
