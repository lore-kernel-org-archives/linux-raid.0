From: NeilBrown <neilb@suse.de>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Tue, 1 May 2012 20:18:54 +1000
Message-ID: <20120501201854.19f7def9@notabene.brown>
References: <4F9AFBC6.7070803@weboperative.com>
	<20120428080355.70585026@notabene.brown>
	<20120501094508.GA24134@nsrc.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/07l1FL5lsNSjGHa+n2HvZsQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120501094508.GA24134@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/07l1FL5lsNSjGHa+n2HvZsQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 1 May 2012 10:45:08 +0100 Brian Candler <B.Candler@pobox.com> wrote:

> On Sat, Apr 28, 2012 at 08:03:55AM +1000, NeilBrown wrote:
> > I'm afraid you've been bitten by a rather nasty bug which is present in=
 3.3
> > and got back ported to some -stable kernel.  The fix has been submitted=
 and
> > should be appearing in -stable kernels soon (maybe already).
>=20
> Do you happen to know if this bug was present in ubuntu 11.10, kernel
> versions 3.0.0-15-server or 3.0.0-16-server ?

I don't keep track of what ubuntu (or anyone but suse) put in their kernels,
sorry.

>=20
> I saw failures to assemble RAID6 arrays after unclean shutdowns on both of
> these, just in test environments.  If it happens again I'll send mdadm
> --examine output. I just tried to replicate it and failed :-(

To replicate:

 - create an array.
 - stop the array
 - assemble the array with at least one missing device e.g.:
    mdadm -A /dev/md0 /dev/sda1 /dev/sdb1
   if it was a 3-device array
 - check in /proc/mdstat that it is listed as "inactivate"
 - reboot
 - now "mdadm -E" the devices.  If the raid level is -unknown- then the bug
   has hit.

NeilBrown


>=20
> Regards,
>=20
> Brian.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/07l1FL5lsNSjGHa+n2HvZsQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5+4jjnsnt1WYoG5AQIRow/+I0TvMb1ZfjG3CEz64xxxpz9Smb58rUyi
s3AU/DvRawFlRS8tySDaYJXa37LKkDsklOe0Uy7YWNq91WeM+6OoU5PBtfmQDYUs
/5A87V5YvVFZsRDl5rG1jbarhQ3X3vzcf+FK2bEZEHexy+Egpou5XcQRVz5y+n9G
FZokocO3Jx5ZP78kh0qfC3BACgSzSkBE2Qm0tqcR275CLrCkJQS54TBJ4zvLR2An
4kv6Bh8qtvXhVGJSWrhWBIz73b6Z+jI4WE+917TUZprJLtbcOAAWWXspF2fF3LwC
W8qMyLIdQtBcDXGVyV1LVKb5ezg7v2Hi7dC7I2As97oAjMbahCIKR3bBlKNSlbCF
ST0jNc3pSi+KA89eZbw465JVoO1XOx5b/TJsTU8FgffXUb5c6zZ51fJ8WdkO26Ck
6xvtPdrfsrPEvFlZbysht4BKyxwdIaO5WkhGnNGZphSsVfiYKN5Ui/RjYBhbYBz9
CnkJmxLoOVpTKRcYssz/XCF6EEAcJbV3JATJpY0jmWeaRkSERCEhTyu/76oKc568
kTSdfg6ToVOW+gQiKn3cdw5O4rc9xVhIhqErzbP0ZVwr+CeYCA1Sf0BOMu5NpN3O
T5PPaUc/BiHbzdvMt8F9mOEKzKZElb8TTR+mNY8EktXsAEyG6VXAlOD7Mn7pHJwK
Qm9EVYhlAWE=
=3TLf
-----END PGP SIGNATURE-----

--Sig_/07l1FL5lsNSjGHa+n2HvZsQ--
