From: NeilBrown <neilb@suse.de>
Subject: Re: Accesses to not yet running array
Date: Mon, 26 Aug 2013 14:33:49 +1000
Message-ID: <20130826143349.31afbefa@notabene.brown>
References: <CAC9WiBgjEQxe_uymD6WW3Oj5Bm6aYD-RBD-8m3G40c1y3HUb0Q@mail.gmail.com>
	<20130821090634.413491d8@notabene.brown>
	<CAC9WiBiYYOjCVaa5tKVC7Lnkz7fcB2wHM0v2wdQUi=1Ufku5gA@mail.gmail.com>
	<CAC9WiBjBGD0J5vSe+q7y+UVGp2+++Ac++zeQ_=LUz9eQ-kCffA@mail.gmail.com>
	<5217B364.1070704@arcor.de>
	<CAC9WiBg7iRDAj40TFUJVq-TXcktNarhT=3_mCJhOkXnitF8HDQ@mail.gmail.com>
	<CAC9WiBi=fDYmtLv6DPfskyMGfSHVk-J_=5fFsQkdWuigNcHGBw@mail.gmail.com>
	<5218FE4F.7000209@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Jz5sbklCItbCre4M0b76iSY"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5218FE4F.7000209@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Jz5sbklCItbCre4M0b76iSY
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 24 Aug 2013 20:41:19 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> On 08/24/2013 02:42 PM, Francis Moreau wrote:
> > On Sat, Aug 24, 2013 at 2:40 PM, Francis Moreau <francis.moro@gmail.com=
> wrote:
> >> Hello Martin,
> >>
> >> On Fri, Aug 23, 2013 at 9:09 PM, Martin Wilck <mwilck@arcor.de> wrote:
> >>> On 08/23/2013 12:00 PM, Francis Moreau wrote:
> >>>
> >>>> [ adding Martin in CC since it seems related to DDF... ]
> >>>
> >>> I reproduced it here. The problem is that mdmon isn't running. Simply
> >>> try running "mdmon /dev/md127", and the mount should proceed.
> >>>
> >>
> >> oh, ok, I should have noticed.
> >>
> >>> You'd avoid the problem by running "mdadm -IR /dev/sda" in the first =
place.
> >>
> >> Actually this is how arrays are assembled during boot on some
> >> distributions (Fedora for example).
> >=20
> > I meant the sequence:
> >=20
> > mdadm -I /dev/sda
> > mdadm -I /dev/sdb
> > mdadm -R /dev/mdxxx
> >=20
> > is used by distribution.
>=20
> CentOS 6 uses the following sequence:
>=20
> mdadm -I /dev/sda
> mdadm -I /dev/sdb
> mdadm -I /dev/mdXXX
>=20
> I don't see mdadm -R anywhere on CentOS.
> You could change your udev rules to run "mdadm -IR /dev/mdXXX" instead.
> Have you tried that?
>=20
> I wonder if that woudn't be smarter anyway. Neil?

I don't think you want the udev rules to run "mdadm -IR ...".

If 'mdadm -IR...' to be run at all, it should probably be
   mdadm -IRs

and it should happen after all attached busses have been scanned and udev h=
as
processed all new devices.

NeilBrown

--Sig_/Jz5sbklCItbCre4M0b76iSY
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUhrarTnsnt1WYoG5AQKZZg//enUwrUq3OrxsWUDuzixBseRl0BFoANVt
bKdGJSNX5kfAr2UBn/WMYvjvdjRyqKS15M59wY8naSo2ku0Cm5t4C6/Il5nLqhOs
G5L8Ayg9AaD9W5190sFBCTMUSu8MXOGat3x6HrrdmjkPE/F94ZJmheQL7NxUTfJX
vO/e9Sv6ctmPEhNQcs46EVtQ0cdFoNmZpNZpTO/IzJ6Ms1jD7xWb+dg74Iikr0g8
FDFgXmwnC48bsbUNnp/SwAdIm8cGU6Vu7sBPqkQCHXIOMsKETcKLQzw3OMPL9jIF
O9XqC25tUcXTPnSSEvZawo4es6DjKc+I67gvtfhSqZ4avA28UuSx66ml2TToitvT
B1vI69wBvx8yLZYw+u38Age9AfX3vXrUTQ/Ukd1IZQZ+qnAGXlI8JhDcg4877OJX
cDzg5vVV2mplpJ3w0gsBEX63Ln8SEwZZPMsZPz1UNpELYqeBO0ej7snzanWQh7hi
qXp8pDMuPqoIGhwY3/Wfd2rlijFeLgpokZIVmDkvunuh2HCwQu3z8ISVtNmESqbi
O6zzop/MbynBX0d5N/mvi63vXx9ehe7G4zTJHVc9mGbhnXkknquwuPAgYtb4/yuu
/7MlgNrdnwVejVYgL9EWIyE1FCwS6ZF2HbHBbrcAoNpPQYZT7FyHp5ChfAIyr/nL
N/krLKE1e88=
=l2ev
-----END PGP SIGNATURE-----

--Sig_/Jz5sbklCItbCre4M0b76iSY--
