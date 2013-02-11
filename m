From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: [PATCHv2 2/2] udev: Fix order of execution of the md rules
Date: Mon, 11 Feb 2013 11:01:53 +0100
Message-ID: <5118C191.7020409@archlinux.org>
References: <1360432119-15910-2-git-send-email-thomas@archlinux.org> <1360442987-30856-1-git-send-email-thomas@archlinux.org> <20130211113101.6ec5dfac@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2CATOOSRNHKACBFVOTNPT"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130211113101.6ec5dfac@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>, systemd Mailing List <systemd-devel@lists.freedesktop.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2CATOOSRNHKACBFVOTNPT
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 11.02.2013 01:31, schrieb NeilBrown:
> On Sat,  9 Feb 2013 21:49:47 +0100 Thomas B=E4chler <thomas@archlinux.o=
rg>
> wrote:
>=20
>> Right now, the rules that run blkid on raid arrays are executed after
>> the assembly rules. This means incremental assembly will always fail
>> when raid arrays are again physical components of raid arrays.
>=20
> I'm not at all against splitting the udev rules into two files, but you=
r
> reasoning seems a bit odd and I want to be sure that I understand.
>=20
> We run "mdadm -I" based on the contents of ID_FS_TYPE, and ID_FS_TYPE i=
s set
> by "blkid", which is called after the "mdadm -I" rules.  So why do they=
 work
> at all?

If a new device, say /dev/md0 is added by udev, before the patch, the
rules would do the following:

1) go to md_inc_skip, because ID_FS_TYPE is unset, thus skip incremental
assembly.
2) call blkid and set ID_FS_TYPE

If ID_FS_TYPE is again linux_raid_member, then it would have been
necessary to call mdadm -I for /dev/md0 here.

This is probably what happens here: https://bugs.archlinux.org/task/32558=


The short version is: The reporter joins three disks as a RAID0 (md2),
then combines md2 with another hard drive as RAID1.

With my changes, incremental assembly should work in this case, because
ID_FS_TYPE is set before incremental assembly tests for it.

> Presumably something else is calling "blkid" ?
> That seems to be "persistent-storage.rules"  which calls "blkid" on som=
e
> devices, but not on others.  That seems sub-optimal.   It is probably
> reasonable that it skips "sr*" (which is explicit) but for us it is
> unfortunate that it skips "md*".

Yes, udev's standard rules skip md*, and I do not know why.

> I cannot see a good reason for persistent-storage-rules to skip 'md' de=
vices,
> so I would suggest that the best way to fix the problem is the fix that=

> rules file.  Then we could remove the "blkid" call from the md rules wh=
ich is
> nice as it removes duplication.

CC'ing Kay here. Kay, is there a good reason to skip md* in
60-persistent-storage.rules?

> We could still split the md rules files, but I would rather do that bec=
ause
> it was a good and clean thing to do, not do that because it helps work =
around
> a short-coming in some other rules files.

The "good reason" is that the rules fulfill two different tasks:
1) Apply incremental assembly to RAID members.
2) Set properties on RAID arrays.
Two tasks means two separate files, so you can easily disable or
override only one of them.



------enig2CATOOSRNHKACBFVOTNPT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJRGMGUAAoJEChPw0yOSxolBjsQAMK9+VZYYvWUGDQ9UO3UaCpE
W5Cg1mMrx7dPPK7OxdXjY8jXsGeHz/7EbBMeGu4NKLu50sAEtKbsf2ZZt2C6s7n3
uH8LnPSu56NX/0XtwxD9rFKGr5f6uubjqFFogBBZslu3ux8i+9iF3XdcPp4CxsJb
NbTRT+MwPDgz5zxwDtYvIoJR+pzrV7TTfhxQNdXrKBwd9QwllaL+EuHgVAR+FbkK
d5Qojbmfuxbx8iv1mRaqHgavtvAXu41zFAUKBN5GaI6bJbS2Z8N+Uh/ntJLlyEvv
pGTGbTfJANCduQXsIh0PPDiurPLM0hpB0RLNR+bP4e3y+F9+qWescuMTbxWz7Wer
5Uhyfq7ZBEMnS9ryPpO7k67SZTMpfv0wGA5X3uRSO0ytaIyDxa8VJN+kuSsl/fNZ
M3ds2ti9YwFT17Ea/HEjb+b1lmV8IDHTnCfdxmLBsgWih2tQVNegIgDFHNbWtpDT
dmi6O/Mybmi4Er6NnZm0njzhNI3Vwf8cjSUSywitDvoG/v5ucb7CzOlR2SwO9WQQ
YfXlmcYuajxrLZstBluyTRti++2muw4xj5Sd6gv5vPN1mvKtf0Bc6HJP4nxcHpZP
XwQTCN3zh10s5TcwBo5p3Yi2H4EukxfIUoG96BRIajKoccQtk1K1eF6/AEyOrnLg
jo9t7gunID4KPeA6rVbm
=Y9YJ
-----END PGP SIGNATURE-----

------enig2CATOOSRNHKACBFVOTNPT--
