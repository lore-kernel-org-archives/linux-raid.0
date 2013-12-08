From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm rebuild
Date: Mon, 9 Dec 2013 08:55:54 +1100
Message-ID: <20131209085554.262006d5@notabene.brown>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/q7CMLfJc8xTX+Bul.8rY5/n"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hai Wu <haiwu.us@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/q7CMLfJc8xTX+Bul.8rY5/n
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Dec 2013 11:53:00 -0600 Hai Wu <haiwu.us@gmail.com> wrote:

> I am wondering whether it is possible for mdadm to auto-rebuild a failed
> raid1 driver upon its replacement with a new drive? The following lines
> from some RedHat website URL seems to indicate vaguely that it might be p=
ossible:
>=20

Yes and no.
"yes" because it is certainly possible to arrange this,
"no" because it isn't just mdadm which does it.

When a drive is plugged in, udev notices and can run various commands to do
things with that device.  You need to get udev to run "mdadm -I $devname"
when a new device is plugged in.
The udev scripts which come with mdadm will only do that for new drives whi=
ch
appear to be part of an array already.  You presumably want it to do that f=
or
any new drive.  The change should be quite easy.

Secondly, you need to tell mdadm that it is OK to add a new device as a spa=
re
to an array.  To see how to do this you need to read the documentation for
the "POLICY" command in mdadm.conf.5.

A line like:
    POLICY action=3Dforce-spare
tells mdadm that any device passed to "mdadm -I" can be added to any array =
as
a spare.  You might not want that, but you can restrict it in various ways.

    POLICY path=3Dpci-0000:00:1f.2-scsi* action=3Dspare

says that any device attached to a particular controller can be added to any
array as long as it is already a member of the array, or appears to be blan=
k.

There are various other directives which should allow you to describe
whatever you want.

NeilBrown


> Previously, mdadm was not able to rebuild newly-connected drives
> automatically. This update adds the array auto-rebuild feature and allows=
 a
> RAID stack to automatically rebuild newly-connected drives.
>=20
> The goal is to get mdadm software raid1 to behave the same as hardware
> raid1, when replacing failed hard drive. It should automatically detect n=
ew
> drive and rebuild the new drive into part of raid1 ..--
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/q7CMLfJc8xTX+Bul.8rY5/n
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqTq6jnsnt1WYoG5AQKtmw//f0fmVmxXUHVNkPfwEWJeKRBz7vGt/ZJ7
95wSXzaqwhb3HSqE7SW/g0f9+m5SzayrOeQDHqVDn+MiRMz4SjD2RFPuBCM20DNq
KTHTSLWeQRGjc0kg709KR9q0pYwmRh65aFGPLJ0nKavyFPfrzScI9U4DeLvZj57s
DFimILtBEIdmB24odDUq4LRLr3UAAC3Y2ivGMDG0SRNDtsD9cg862U7jGX3pQO8/
GRdz6O1BO94XBAveG6sr4CPMJIXERRrhf4MvE6cFU1SLAR8Q0ib637WIN9BozP8e
xqDQMS00JhJPF/otiU3fKmT6qHJL5lqnUXwBNsq8BL6vXLrnoPirvkg/3G9dXa+P
b8F8y7Wn6Tcp3uF94B/1SV4UFUSu9r9XH87pEHkFKBBU3RpOwdaW2sKlLopRvdF3
TdQR968leNAao/KyYvfDrCo5p1V96CklZWD94BFRteXwDfCX7NEJWzfr63oFv0dw
ee+Jkizcb6lYMMQlAwEvoBt9oQrzIlMWbYNYovYAvMkCPCb6c9dxc9BRoTAC8fxl
jq6NSSzw1wygoQY4e2BGSXeZg053NyqKaq86qIaj23jT6pnjiDAoz2+eZXfI1cXj
fATEFcf/uyGHz6AiJusSxwpsS+urxdEAEDVTOGjFtOGxPyv2Uum0vmjGFUFLBWhG
uhrzjyJSVEU=
=qf+5
-----END PGP SIGNATURE-----

--Sig_/q7CMLfJc8xTX+Bul.8rY5/n--
