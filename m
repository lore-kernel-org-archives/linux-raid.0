From: NeilBrown <neilb@suse.de>
Subject: Re: Kernel oops adding bitmap
Date: Thu, 22 Mar 2012 07:03:08 +1100
Message-ID: <20120322070308.2233d1dd@notabene.brown>
References: <4F67627D.8050205@nuclearwinter.com>
	<20120320083210.4a272426@notabene.brown>
	<4F67A7C7.1050803@nuclearwinter.com>
	<CAGqmV7qgQUxndmFzAU=cx3stQryOYRSRGPb_1HX9Nw9Ludot-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/S6+Z3WetV+3sRJaJ3QCl399"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7qgQUxndmFzAU=cx3stQryOYRSRGPb_1HX9Nw9Ludot-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: Larkin Lowrey <llowrey@nuclearwinter.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/S6+Z3WetV+3sRJaJ3QCl399
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Mar 2012 17:21:55 +0400 CoolCold <coolthecold@gmail.com> wrote:

> Btw, was interested in, where bitmap will be placed when adding it on
> live array? I.e. as it requires some diskspace, we should provide some
> free space, but where it can be taken from if array is already created
> and used by, say filesystem?

For 0.90 metadata there is 60K of unused space after the superblock.  The
bitmap is stored there.

For 1.x, the metadata stores a data_offset and data_size.  All array data is
in that range.  Anything out side there is available for mdadm to use.
When mdadm creates an array it reserves enough space for bitmap and possible
other uses.

NeilBrown

>=20
> On Tue, Mar 20, 2012 at 1:40 AM, Larkin Lowrey
> <llowrey@nuclearwinter.com> wrote:
> > On 3/19/2012 4:32 PM, NeilBrown wrote:
> >> On Mon, 19 Mar 2012 11:44:45 -0500 Larkin Lowrey
> > <llowrey@nuclearwinter.com>
> >> wrote:
> >>
> >>> The following command oopsed.
> >>>
> >>> mdadm -G --bitmap=3Dinternal /dev/md0
> >>>
> >>> The array is a two disk raid1 and hosts the root filesystem.
> >>>
> >>> Is it not possible/allowed to add a bitmap to an active/mounted array?
> >>
> >> It is. But it is busted.
> >>
> >> Either use an older mdadm (3.2.2 or earlier), or apply this patch
> >>
> >> http://neil.brown.name/git?p=3Dmd;a=3Dcommitdiff;h=3D4474ca42e2577563a=
919fd3ed782e2ec55bf11a2
> >>
> >> which has been sent to Linus already and should appear in -stable
> > kernels in
> >> a couple of weeks.
> >>
> >> NeilBrown
> >
> > Thank you for the explanation.
> >
> > --Larkin
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>=20
>=20
>=20


--Sig_/S6+Z3WetV+3sRJaJ3QCl399
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT2o0Hjnsnt1WYoG5AQLHcw/+JMzydfP9XKRZhllKEpaYZKYuqAgJn+uM
y99MdMfP30N1w9U1TQ8FlZECavAlIEBGU2LOUAZB4fPvnwD3PyyTLIdt7LLarGe8
1S/1jlt4Q3QAFTsTx11xIs5OZKTMUxZ9xpu/mz0RlcozD1AWHl5BrgR2lzhyafSH
11hjq6bw1HCQv7yvXBldHRy30oOWUVc4SHVqZV9abrNEp5pb5ISkANR1uNGfX700
CA89S5svfX/F+3vn/Kmk/HksbG9IG/KWbBhOm85ZrjVgRWiWLOy9PWW8EXdtLd9u
a7QUJtmNKzdXizS/jVqGnUuqlIZx5cwJ8Auu8tIumjz8oIEazT1Mvfz13SuL7brY
nCJFw0lOMrjgA7nAlAdZEtkI8eUdrz4bD7PeG/yCw8FocdjwVJsOLzFDrLRKwWwe
TTuKrkJBY/ilnlTIHN2LJq2FnQMQKLnT/V/Cc6yNfBMKrSjTD2se8op8BHIv1CSr
ILp+L5Rf/iCfMKSb7yTG62R6vZzNflQOcJBPC1YMEiY+WVBdi7JXfiOhPHOFkSrZ
Kh6vO3BxZCpnrkO+PGkQ7DlglrNxXGErX4BVeS1ZJy71aj+crGgElAB+bd9ItrYz
EI2DUirSkZ5G9VJ7frkUH2+DOUTwxjYjWFGwNupef94j1Uw0i726m0XEX2E5T3D0
MWMnPLk6Slk=
=9EmI
-----END PGP SIGNATURE-----

--Sig_/S6+Z3WetV+3sRJaJ3QCl399--
