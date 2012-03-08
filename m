From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm: sending ioctl 1261 to a partition!
Date: Thu, 8 Mar 2012 11:04:21 +1100
Message-ID: <20120308110421.45d337b9@notabene.brown>
References: <4F54B997.3060207@crc.id.au>
	<4F54D314.9060504@anonymous.org.uk>
	<4F550BA8.3010306@crc.id.au>
	<20120306070143.4f8abc0e@notabene.brown>
	<4F556FA1.5020006@crc.id.au>
	<20120306132701.1b9600f4@notabene.brown>
	<4F55A0D7.4040908@zytor.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/asNtucBRNImDep5qW7.zkD9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F55A0D7.4040908@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Steven Haigh <netwiz@crc.id.au>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org, Jan Kara <jack@suse.cz>
List-Id: linux-raid.ids

--Sig_/asNtucBRNImDep5qW7.zkD9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 05 Mar 2012 21:29:59 -0800 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 03/05/2012 06:27 PM, NeilBrown wrote:
> >=20
> > So it is still called fsync_bdev and invalidate_bdev as long as the
> > ioctl function for the underlying disk returns -EINVAL or -ENOTTY.
> >=20
> > The function that shows that warning is scsi_verify_blk_ioctl in=20
> > block/scsi_ioctl.c The worst it can do is return -ENOTTY, and that
> > is safe.
> >=20
> > So the warning is bogus, the code still works.
> >=20
>=20
> We should whitelist ioctls if they are legitimately used and harmless.
>  Do we have a specific list?
>=20
> 	-hpa
>=20
>=20

We had the following in our SLES kernel for a while, though it seems it
disappeared when we pulled in 3.0.18.
Jan: should we put this stuff back?

NeilBrown




@@ -78,11 +83,19 @@ Index: linux-3.0-SLE11-SP2/block/scsi_ioctl.c
 +      case SG_GET_RESERVED_SIZE:
 +      case SG_SET_RESERVED_SIZE:
 +      case SG_EMULATED_HOST:
++      case BLKFLSBUF:
++      case BLKROSET:
 +              return 0;
 +      case CDROM_GET_CAPABILITY:
-+              /* Keep this until we remove the printk below.  udev sends =
it
-+               * and we do not want to spam dmesg about it.   CD-ROMs do
-+               * not have partitions, so we get here only for disks.
++      case CDROM_DRIVE_STATUS:
++      case FDGETPRM:
++      case RAID_VERSION:
++      case MTIOCGET:
++#ifdef CONFIG_COMPAT
++      case 0x801c6d02:        /* MTIOCGET32 */
++#endif
++              /* Keep this until we remove the printk below. udev/dd sends
++               * these and we do not want to spam dmesg about it. CD-ROMs
++               * & tapes do not have partitions, so we get here only for
++               * disks.
 +               */
 +              return -ENOTTY;
 +      default:


--Sig_/asNtucBRNImDep5qW7.zkD9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT1f3hTnsnt1WYoG5AQL4Ow/+LjSg3tsjl5oFo4ZBsM1Ui29LF9rPHoti
cqy/Th0jhdKFmcar9CdbLnN5R3JZcLABntnr4u0RB5B2ge3DP+7d5cIrOFXGQUsw
0nPgrZbUn6fr050/z6RcBbrPbf2flg1+dPW4UJuFUHMOAbcZfZwHg5t7feKhixTM
1151WW6Q7aSi+DxrrsulrDYTxS22Ya1cDTAtvK2IEQ3UBWhE2DBKu8LfSGS5q3Dk
GtsLk7OQLEVDw599efoyZpwg6DznAIEIsuH+9Y83tJUgi3UDfXqcv9ytZfPyo2pl
mBcu6qKDyShhg49UBy5rNAUw960QDe/lDERkyNLkDxY6ZvivKu2+iq6ohW1Uqhcn
OoiXAXjucZwMxqT3/aVmuLwb6nDrtRjQ7g0czzWHEmFWp3okTdyVXNIGSGWGNuV7
3r5+Bs8PjZEHCeDhH7UueyMEi9d+dfIe2klIFgpw4qbwfaTRKWVgG8DnRlxmfOeg
OVSBmKX9R5GSM0riERHzetFhdCvf+T03TYDv7omSvAqpljD/QtjPb9J5kd0regYK
illhnJHAyVb9ZQirp+87QX7OmPPy+6IEw7vXZao4b/SIEUh4NjgmSf9K+VhTDS4R
j4G2XJgPn3Mjaqp/lQV3SyVr1KUYnoEmJytsFYAfp1s5Ugat6zTgjssR/zTMQTtD
iW+Tc1uGvGA=
=NTo8
-----END PGP SIGNATURE-----

--Sig_/asNtucBRNImDep5qW7.zkD9--
