From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 questions (mdadm 3.2.6/3.3.x)
Date: Sun, 13 Jul 2014 13:15:05 +1000
Message-ID: <20140713131505.6cd40cb8@notabene.brown>
References: <53C06815.2020302@dobrotescu.ca>
	<B953BC37-3769-4D9A-97FF-5EFE7C59EEA4@colorremedies.com>
	<20140712112034.6b04d49f@notabene.brown>
	<53C0A9A0.2020508@dobrotescu.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/6AT7Bzm6lFJiBs.dHwVScOs"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53C0A9A0.2020508@dobrotescu.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Vlad Dobrotescu <vlad@dobrotescu.ca>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/6AT7Bzm6lFJiBs.dHwVScOs
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 11 Jul 2014 23:21:04 -0400 Vlad Dobrotescu <vlad@dobrotescu.ca> wro=
te:

> On 11/07/2014 21:20, NeilBrown wrote:
> > On Fri, 11 Jul 2014 19:09:48 -0600 Chris Murphy<lists@colorremedies.com>
> > wrote:
> >>> 7. I am sure I read somewhere (can't find the source anymore) that th=
e "new" RAID features of LVM2 are based on a fork from the md code. If this=
 is true, are you guys are contributing to that project as well?
> >> It's a good question, I'm not certain but my understanding is device m=
apper is leveraging existing md code in the kernel, rather than having fork=
ed and duplicated that code. They have their own user space tools and on-di=
sk metadata so you can't use mdadm to manage it.
> > Your understanding is correct.  It is the same code for managing RAID
> > functionality, but different code for managing metadata and different
> > user-space tools.
> > I'm hoping that one day the RAID support in LVM2 will be better than md=
adm,
> > and then I can just fade away and no-one will notice that I am gone.
> >
> > http://downatthirdman.files.wordpress.com/2010/06/grinning-chesire-cat.=
jpg
> >
> > NeilBrown
> Thanks for the insight. I don't think your "hope" will ever come to=20
> reality, as they seem to be focused on a different "business case". I=20
> find the LV abstraction pretty cool, but, for my needs, their RAID=20
> support needs significant improvements. It seems a bit weird to have=20
> access to all the amazing md code from the kernel and not being able to=20
> use it to its value. That's why the idea of a fork made more sense to=20
> me. But, then, I don't know if in fact the features that seem important=20
> for me (i.e. adding disks/stripes to an array) are in the kernel code or=
=20
> in the user-space tools. Maybe I should take a look at the md/mdadm code=
=20
> ... until then, this question only comes from some kind of "academic"=20
> curiosity.
>=20
> Would you have any opinion on the questions 1-5?
>=20
> Vlad

1-yes
2-no, same -- Assuming I understand correctly.  I suggest you test and see.
3-try it and see, but "yes"
4-Not wrong, no penalty
5-it would work but is dangerous - too easy to assemble wrongly.
  Why are you using yesterday software to build tomorrows computer?

You've obviously done lots of research and figured out or guessed the corre=
ct
answer to your questions.  I seriously recommend experimentation to clarify
remaining issues.  If you've actually performed a few recoveries or
replacements without live data, you'll feel much more confident when a
disaster happens after you go live.

NeilBrown

--Sig_/6AT7Bzm6lFJiBs.dHwVScOs
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIUAwUBU8H5wTnsnt1WYoG5AQI9sA/4rehYVUFUY5remYvT6zKjSDYt1SyHM3gy
BcVNhSdwqcfWh64ZKoCae60YzB9EJf31ioHSnBC5YiUhv5oIquFRvMVM20UzgyQg
S9u8btOoE2RjoidcZnO9ToqY4xA481eDbF2rXIJjALexFYUXwJ0dW8YuZyC5MvIY
hwDxUcYP8279A1NtlzNf64/RRy9x+HhBf33/6A5JR5u4VesQzM0qQFLyattiQCyF
If16UUW6keFC4b5/NFHylZ4XDKyhDoV5awo2qQM8RpEmAV0kLV+s16nYYbhvveVW
zOmgQqGO9AHTn0tKKSfdHXn1H57MaK2CV+5W7LnOrfcPY8xUXPfx6WieZbhbxUv8
S0JTIvZMDxcYGxzD4U/UZcgahIscV1nQyL73iBw1UMfOqrFEkMPv4Qv6hoomMNir
Odas9Y31mY43fSXiXjaLeAuljaNy1HZwOIbBHg3A0DCIKE7xVVaxhLoum+Po9gKI
N88P567nE/Ru8EpsnwLCRvNGxmtR3nbG9+7g7HX1Z6D55dr2LaM+eMIptFbMrGKx
aMJYRm/1YBuUdd6i0krc/xxReFXUhmFwQAKQUKAzW1oLmvtUdM9QNMkOpWdI8GDQ
U355nfDA/a/cIW0JFV0Xn9EUDSAqzL5y1i+vmATqcWwhSpUf/SG8Tp77tuqf5e7B
AW6COQR0Aw==
=uvPg
-----END PGP SIGNATURE-----

--Sig_/6AT7Bzm6lFJiBs.dHwVScOs--
