From: =?ISO-8859-15?Q?Thomas_B=E4chler?= <thomas@archlinux.org>
Subject: Re: [PATCH 1/2] Modernize udev rules
Date: Mon, 11 Feb 2013 11:11:12 +0100
Message-ID: <5118C3C0.2030708@archlinux.org>
References: <1360432119-15910-1-git-send-email-thomas@archlinux.org> <20130211112016.3059ef95@notabene.brown> <5118ACE1.5020503@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="----enig2WERDRRLUPXTVSFEAWWTO"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5118ACE1.5020503@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
------enig2WERDRRLUPXTVSFEAWWTO
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Am 11.02.2013 09:33, schrieb Michael Tokarev:
> 11.02.2013 04:20, NeilBrown wrote:
>> On Sat,  9 Feb 2013 18:48:38 +0100 Thomas B=E4chler
>> <thomas@archlinux.org> wrote:
>=20
>>> -IMPORT{program}=3D"/sbin/blkid -o udev -p $tempnode"
>>> +IMPORT{builtin}=3D"blkid"
>=20
> Does this has additional udev version constrain?
> I mean, which is the minimum udev version to support this properly,
> do we care?

Udev relies on devtmpfs and thus does not create devices since version
176, therefore $tempnode is deprecated and only $devnode should be used
($tempnode seems to be around for compatibility, no idea if/when it will
be dropped).

The blkid builtin is also available since udev 176. In latest
util-linux, the 'blkid -o udev' output is marked as deprecated, although
Karel says it's not entirely going away for now.

Why do we care? We want correct udev rules ($tempnode vs. $devnode), and
the using builtin is faster and less error-prone than calling an
external tool (plus, it is used everywhere else in udev).

As for compatibility: I see no reason why anyone would use a version of
udev that is more than one year old (175) together with a mdadm version
that is to be released in the future (3.2.7). If someone really wants
that, they should be competent enough to adjust the udev rules for their
local build.



------enig2WERDRRLUPXTVSFEAWWTO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJRGMPAAAoJEChPw0yOSxoleJIQAI3AWsGzgqcP6vpMhCint4a8
XwFsXfxAuX9HnHE8g+YOt2ujyX8IV2sveXupY8O6qwcH2bQkO82oqW234Y1JPrSX
OtvAFSFeHsUcX6MS3nBbkSK2wnFTBKLTWo3aLZ4ldn+9SKEqfKdx8dCxGumBv2ST
iVRCBYKbtl0+qZVfnmC6OAEvpel2/FgMD3aiC3h00CV7PPo5LAZED3uKjAVLyBCP
jWX44e8NKsMGinGRSCCDwxmfKGQJbBP99pOacnPuCmk33HcwJ3IZPyyIOV3fIdF5
0IB97pgok1flrnFQpAefGYSdu2XrPHA5ItX7yGUqPCroJEDZfsteNp9YI76KmiLH
CW3UX1pEGr9+hki0+wPe6ZsfHNl/yKHu1hhB8AatrCC2kyte2Tb4L9ZLII6kXSYv
ugfLtIApbv5MBJJo5uJjPuhUy0zSKhr+rpkT7ySvLo/MTM6IpLdZgPA8nOsqUav/
btRn5v2DEYUy48t1T+JBoqAZE3YNQcLYKG41/iWAjj2emL5bEVRVwU87nxTQUUaF
dXf3gE+ERB456LAkyAcm549GAtrBBprSY9SSkcTKX/HgnPr7ftTuFVQ4u3XvdSlv
iYTG9YxjMv/VgFsID229iLIEqTgecvNUE6ZmkqTh95u9jIXeKwBiSEqqI7maQedx
Th2JI9KWi+B6RJmmBZGn
=yuhy
-----END PGP SIGNATURE-----

------enig2WERDRRLUPXTVSFEAWWTO--
