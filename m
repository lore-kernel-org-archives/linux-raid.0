From: NeilBrown <neilb@suse.de>
Subject: Re: RAID1 growth of version 1.1/1.2 metadata violates least
 surprise.
Date: Mon, 24 Jun 2013 17:14:11 +1000
Message-ID: <20130624171411.12a85fd8@notabene.brown>
References: <201306091433.r59EX51u021372@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bayCS6Oos=XY=rMQS9/yiTN"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201306091433.r59EX51u021372@wind.enjellic.com>
Sender: linux-raid-owner@vger.kernel.org
To: greg@enjellic.com
Cc: greg@wind.enjellic.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bayCS6Oos=XY=rMQS9/yiTN
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 9 Jun 2013 09:33:05 -0500 "Dr. Greg Wettstein"
<greg@wind.enjellic.com> wrote:

> Hi, hope the week is starting out well for everyone.
>=20
> We ran into an interesting issue secondary to the growth of a RAID1
> volume with version 1.1 metadata.  We are interested in reflections
> from Neil and/or others as to whether the problem can be addressed.
>=20
> We grew a RAID1 mirror which had its two individual legs provided by
> SAN volumes from an SCST based target server.  We provisioned
> additional storage on the targets and then updated the advertised size
> of the two block devices.
>=20
> Following that we carried out a rescan of the block devices on the
> initiator and then used mdadm to 'grow' the size of the RAID1 mirror.
> That was about 4-5 months ago and we ended up running into issues when
> the machine was just recently rebooted.
>=20
> The RAID1 mirror refused to assemble secondary to the superblocks on
> the individual devices having a different idea of the volume size as
> compared to the actual volume size.  The mdadm manpage makes reference
> to this problem in the section on the '-U' (update) functionality.
>=20
> It would seem to violate the notion of 'least surprise' for a grow
> command to work only to end up with a device which would not assemble
> without external intervention at some distant time in the future.  It
> isn't uncommon to have systems up for a year or more which tends to
> result in this issue being overlooked on systems which have been
> resized.
>=20
> I'm assuming there is no technical reason why the superblocks on the
> individual devices cannot be updated as part of the grow.  Events such
> as adding/removing persistent bitmaps suggest this is a possibility.
> If its an issue of needing code we could investigate doing the
> legwork since it is an issue we would like to see addressed.
>=20
> This behavior was experienced on a largely stock RHEL5 box with the
> following versions:
>=20
> 	Kernel: 2.6.18-348.6.1.el5
> 	mdadm:	v2.6.9
>=20
> Obviously running Oracle.... :-)
>=20
> Any thoughts/suggestions would be appreciated.
>=20
> Have a good week.

(sorry for the delay - I guess I was having too much fun that week....)

Your description of events doesn't fit with my understanding of how things
should work.
It would help a lot to include actual error messages and "mdadm --examine"
details of devices.

Certainly if you provision underlying devices to be larger and then "grow"
the array, then the superblocks should be updated and everything should work
after a reboot.
If you were using 0.90 or 1.0 metadata which is at the end of the device
there could be confusion when reprovisioning devices (that is mainly with
--update=3Ddevicesize is for), but 1.1 metadata should not be affected.

So: I need details - sorry.

NeilBrown

--Sig_/bayCS6Oos=XY=rMQS9/yiTN
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcfxwznsnt1WYoG5AQKDLA/+OlIlBG8caRic5QV0wk5qo2YIEcGwzF74
WNbSx5iXSkLhshXmFrXgN6MVHlwzQTr+XshZKAhknKa/PICzBGFF7PFNqqc3KEHV
Hg5ZXkXK5h6vzg4/CnRkvR4ws5bgaNvYBkmWLKpJGjlU4ITavaW1mN2AuK+rG2CD
lOOyStUmlpzb2vHHiFlqSUOgdGHOf9uDWYj421HVajDFC9jvq/nYCxc2WQTFTBNQ
RtOObmph+UlwFqs4LbCQJuKQh97QFSG4jRhbEu9hi0bKZaQz4MPlHQzkBadmf2S8
v86vGaoBJ8j2DwJC6S4l0qoOSzyi+I1yWGUMtTYhTrPMqaiTGYHLxFYIDQI/FFt2
Jwbiu6+g3vu82HXnFFP71w+pwxDulRfnrKQbljRw2GQ2n2bIFTeXbgIgz/upzPJy
9YjjanoucoS/g6l86/DxrFXo4xSsrgTwYl0wOEM5ir/pFU55323hlkWOIu0XxnOV
5UOTTs3ORoH0zm+2hevWJ4dF79Xo+5F/3553zdw5TU03cB9eSH5WJYQJLhc15xQR
svM9WNxMBA7wq+Gh7LOpDeM6OBmRqT9X80yIfO7KkYriUrCQJbQZ3UmKr2qfCwTR
tYCDWYSoaEDSpHfyVVgqX2hjE3qzRlJW06n61T/GkJzxowM/wHjde+x7dv/ST9Ms
op8DfCFL8bs=
=i8vF
-----END PGP SIGNATURE-----

--Sig_/bayCS6Oos=XY=rMQS9/yiTN--
