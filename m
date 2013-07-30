From: NeilBrown <neilb@suse.de>
Subject: Re: ddf: remove failed devices that are no longer in use ?!?
Date: Tue, 30 Jul 2013 11:34:35 +1000
Message-ID: <20130730113435.3421a111@notabene.brown>
References: <51F2E4B9.1020505@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/=50IKXbN=H2Hv/pr5V0zP2V"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F2E4B9.1020505@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/=50IKXbN=H2Hv/pr5V0zP2V
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jul 2013 23:06:01 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> here is another question. 2 years ago you committed c7079c84 "ddf:
> remove failed devices that are no longer in use", with the reasoning "it
> isn't clear what (a phys disk record for every physically attached
> device) means in the case of soft raid in a general purpose Linux compute=
r".
>=20
> I am not sure if this was correct. A common use case for DDF is an
> actual BIOS fake RAID, possibly dual-boot with a vendor soft-RAID driver
> under Windows. Such other driver might be highly confused by mdadm
> auto-removing devices. Not even "missing" devices need to be removed
> from the meta data in DDF; they can be simply marked "missing".
>=20
> May I ask you to reconsider this, and possibly revert c7079c84?
> Martin

You may certainly ask ....

I presumably had a motivation for that change.  Unfortunately I didn't reco=
rd
the motivation, only the excuse.

It probably comes down to a question of when *do* you remove phys disk
records?
I think that if I revert that patch we could get a situation where we keep
adding new phys disk records and fill up some table.

We should probably be recording some sort of WWN or path identifier in the
metadata and then have md check in /dev/disk/by-XXX to decide if the device
has really disappeared or is just failed.

Maybe the 'path' field in phys_disk_entry could/should be used here.  Howev=
er
we the BIOS might interpret that in a specific way that mdadm would need to
agree with....

If we can come up with a reasonably reliable way to remove phys disk records
at an appropriate time, I'm happy to revert this patch.  Until then I'm not
sure it is a good idea.....

But I'm open to being convinced.

Thanks,
NeilBrown

--Sig_/=50IKXbN=H2Hv/pr5V0zP2V
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfcYKznsnt1WYoG5AQJ/bw/7BqEYBgSysvhnKr4/w4T47BMByZTyuipY
ZInnUPM7y4vo2P2LR2wMo71e9sEM0xECpgxo0j+QZzQ0Aykt5FglFUJHS5mnYosH
J9XoUx3NXknYNINYnd57r4JTWHJeoa7zRO5OEgZ6r72qFu3jsFyrieINs6/surO5
raQjMbq7G0QIIFhx+Ox8uAVn5kLJe6uzQGvrdFLAHrF5cjXOhOZ2R+MpR6aVnRM/
Ji6QIawtt67jEmziF/5q+SpgBQ82LQqKbZ6Gd0NQzVrVunS+yeH6QvvLoXRZ2WFO
0xEyqDkDCThAIQQpnxYzP8pMMGcWcjtiMwh9NiC3d4JMq3ZITV1mURS0ktTKn7o/
d2OgMM61/AyktyJZ7K4XgqV0XEaZcHXP+a5iZbxtodkJiURR2rPnOH/IsqVSZc0L
sWFE7ZHPd/rJB0XXNgFLTWMkDu+6bYIs1uEKobPESyGQHGF4KKmYC8rR2flcgohx
wKsejTMbagiU4NIbUNmm6e9TlC54ty5barl7NHJxeIfQp4QJqHOBCXjlA0kOD3fN
S/vOusZ/1WtpCDm3osmiVmBpQxVhGD908mK3zmQRVS/FAmzkSGlqkR+5zKdIHivY
EDKa5fleljqy54kXVVOY65imTX5WJ5Z2HwmiN0SdfNec7cytabvKoUr0JFPb/3cf
UpR2v7m3toY=
=xm1c
-----END PGP SIGNATURE-----

--Sig_/=50IKXbN=H2Hv/pr5V0zP2V--
