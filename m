From: NeilBrown <neilb@suse.de>
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Tue, 14 Jan 2014 09:27:51 +1100
Message-ID: <20140114092751.09464b7b@notabene.brown>
References: <52BD8EDD.10809@assyoma.it>
	<20131227151927.GA4003@www5.open-std.org>
	<52BD9B4F.3000509@assyoma.it>
	<20131227154952.GA6539@www5.open-std.org>
	<52CE57D9.1030501@assyoma.it>
	<20140113102021.1ef3e203@notabene.brown>
	<52D3A962.4000308@assyoma.it>
	<20140113204534.737a98f6@notabene.brown>
	<52D3BCB1.1010200@assyoma.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Mepbi0LHVk_XlZmOKnPedHM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52D3BCB1.1010200@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org, keld@keldix.com
List-Id: linux-raid.ids

--Sig_/Mepbi0LHVk_XlZmOKnPedHM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Jan 2014 11:15:13 +0100 Gionatan Danti <g.danti@assyoma.it> wrot=
e:

> On 01/13/2014 10:45 AM, NeilBrown wrote:
> > On Mon, 13 Jan 2014 09:52:50 +0100 Gionatan Danti <g.danti@assyoma.it> =
wrote:
> >
> >> Hi Neil,
> >> let me recap from a previous message:
> >>
> >>   >FAR LAYOUT
> >>   >md(4) states:
> >>   >"The first copy of all data blocks will be striped across the early=
 >part
> >>   >of all drives in RAID0 fashion, and then the next copy of all blocks
> >>   >will be striped across a later section of all drives, always ensuri=
ng
> >>   >that all copies of any given block are on different drives"
> >>   >
> >>   >The "on different drives" part let me wonder _how_ are chunks
> >>   >distributed. On a 4-disk array, I can imagine some different schema=
s:
> >>   >
> >>   >1)	A1 A2 A3 A4
> >>   >	.. .. .. ..
> >>   >	A4 A1 A2 A3
> >>   >
> >>   >2)	A1 A2 A3 A4
> >>   >	.. .. .. ..
> >>   >	A2 A1 A4 A3
> >>   >
> >>   >The first schema is the one depicted by SuSe documentation [1], whi=
le
> >>   >the second is the one described by Wikipedia [2].
> >>   >
> >>   >Question 1: as the two schema have different reliability
> >>   >characteristics, which is really used?
> >>
> >> SuSe entry:
> >> https://www.suse.com/documentation/sles11/stor_admin/data/raidmdadmr10=
cpx.html#b7cynnk
> >>
> >> Wikipedia entry:
> >> http://en.wikipedia.org/wiki/Linux_MD_RAID_10#LINUX-MD-RAID-10 (see how
> >> far layout is depicted)
> >>
> >> Keld kindly told me that the SuSe is simply not updated, as it depict a
> >> situation changed with newer kernels. So my two questions:
> >
> > I cannot see an important difference between the two pages you referenc=
e.
> > Both appear to be correct.
>=20
> Mmm... they seem different to me.
>=20
> SeSe FAR Layout:
>=20
> sda1 sdb1 sdc1 sde1
>    0    1    2    3
>    4    5    6    7
>    . . .
>    3    0    1    2
>    7    4    5    6
>=20
> Notice how (for example) sdb1 is coupled both to sda1 (0,4) and=20
> sdc1(1,5). If sdb1 fails, any sda1 or sdc1 failure lead to data loss.
>=20
> Now, Wikipedia FAR Layout:
>=20
> 4 drives (sda1, sdb1, sdc1, sdd1)
> --------------------
> A1   A2   A3   A4
> A5   A6   A7   A8
> A9   A10  A11  A12
> ..   ..   ..   ..
> A2   A1   A4   A3
> A6   A5   A8   A7
> A10  A9   A12  A11
> ..   ..   ..   ..
>=20
> Notice now how a single disk (eg: sdb1) is coupled to only another=20
> _single_ disk (eg: sda1). In this case, if sdb1 fails, you had to lose=20
> sda1 to have a data loss. Losing sdc1 or sdd1 will _not_ lead to data los=
s.
>=20

Thanks for being explicit - it is much easier to answer explicit questions =
:-)

Yes, they are different.  So the wikipedia article is wrong, or at least
misleading.  That is not what the "f2" layout looks like.

The md driver does support that layout.  I don't know yet what mdadm will
call it, but it won't be called "f2".

So this change:

http://en.wikipedia.org/w/index.php?title=3DNon-standard_RAID_levels&diff=
=3D501908270&oldid=3D501604733

was wrong.

NeilBrown

--Sig_/Mepbi0LHVk_XlZmOKnPedHM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUtRoZznsnt1WYoG5AQIomhAAqBAYkmBS5OHUWZCBgQ5I+bnruTTWuuIk
l+eLginPqqjvHci3RfoAFVIv13a4JxwZ8647o+6N2qQLAS2IDbAPJJlD6jxoVK8p
KYk9q4ipurjQDtiNDpqhn1DoezAkU9DUyIUG4Ss5jpomuaXkwXaV8Vvf0LXcQ+4W
F4O55AQ7eCcXjf2Zd9ZQRDAizR03PyWGJm0q+l8k3FGzwpHzLDdlSYiSW1sLy/AK
9bann8Snkc2rp1evz5q9W+I3iXvg5xuTiVTX6cfD9KY7WmeMBFMyfrIL4xfvap3C
FH+D4UiHjRCspLFpY3+EU4BwMZBcNho1bSC0cV7WPW6Zuo6/zkqQ+I3p3fuXHS25
hicShLxc7ZH0ziUSWFINPHSHl8OVx21tc2SWfBFYQe+V3y4Y1gG94VdX4AW7Vpfr
eFVpP432/SYvY7cSMmozXQdwdtKw5yRqhvt1khqwbr41nqst070LBgaCqXQEf5c4
nDXIjsHY7WaeWiJr36bvwo4Du66BlHA4ac3lt5AwubHwHHbsFd08N8c9F4B67O+C
sv5GVhDhNSKq19ZA+vgi4CUJ+ZJaz7Mn0T2Z68YHNUNiuNlhW8ePWkaZd8y7402u
0bjLC4iArzEU834EHi6hjqq/4O6+bJX9CHObzdvw1mnbLfj3AgA08J9jk9ZejKLm
DRprFqmeSeI=
=D3GV
-----END PGP SIGNATURE-----

--Sig_/Mepbi0LHVk_XlZmOKnPedHM--
