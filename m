From: NeilBrown <neilb@suse.de>
Subject: Re: On URE and RAID rebuild - again!
Date: Tue, 5 Aug 2014 09:29:51 +1000
Message-ID: <20140805092951.7d8f8e6d@notabene.brown>
References: <53D8ACF0.1070202@assyoma.it>
	<alpine.DEB.2.02.1407301310100.7929@uplift.swm.pp.se>
	<53D8ED99.90606@assyoma.it>
	<20140731073121.38cd1773@notabene.brown>
	<53D9ED48.9000307@assyoma.it>
	<1370eb7a35b628323646a86094a26912@assyoma.it>
	<20140803134834.7773b0ab@notabene.brown>
	<53DF8A31.8060609@assyoma.it>
	<alpine.DEB.2.02.1408042037470.7929@uplift.swm.pp.se>
	<35916d10dab6084e6f28da2e0975fce7@assyoma.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/O7d3kW=5MN4DquKLunjaCRg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <35916d10dab6084e6f28da2e0975fce7@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/O7d3kW=5MN4DquKLunjaCRg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 05 Aug 2014 00:44:04 +0200 Gionatan Danti <g.danti@assyoma.it> wrot=
e:

> Il 2014-08-04 20:40 Mikael Abrahamsson ha scritto:
> >=20
> > Why do you think that's wrong? 10^-14 is what the vendor guarantees. I
> > have had drives with worse performance (after a couple of months I had
> > several UNC sectors without reading much).
> >=20
> > Your claim about the article being wrong is the same as saying that
> > the risk reported of getting into a car accident is wrong because
> > you've driven that amount of kilometers but haven't been in an
> > accident yet.
> >=20
> > This is statistics, marketing and warranty, not guaranteed behavior.
>=20
> Yes, I understand this. However, the linked article (and many others)=20
> state:
> "If you have a 2TB drive, you write 2TB to it, and then you fully read=20
> that, just over 6 times, then you will run into one read error,=20
> theoretically speaking."

This statement is wrong, and doesn't even make any sense.  It displays a de=
ep
misunderstanding of probability (the same deep misunderstanding that leads
people to buy lottery tickets).

>=20
> I read my 500 GB drive over _60_ times, reading 3x more total data than=20
> stated above.
>=20
> I started the entire discussion to know how UREs are calculated, trying=20
> to understand if they are expressed as probability ("1 probabily over=20
> 10^14 that we can not read a sector) or a statistical record ("we found=20
> that 1 on 10^14 is not readable").

Probabilities are often calculated by examining a statistical record - the
two concepts are not separate.
There is probably some theoretical analysis, some statistical analysis, some
marketing and maybe even some actuarial analysis that goes in to the quoted
figure.  I remember when CPU speed was measured in "MIPS".
This stood for=20
   Meaningless Indicators of Performance for Salesmen

URE rates numbers are probably equally trustworthy.

>=20
> If defined as a probability, I am very lucky: if my math is OK, I should=
=20
> have only 0.5% to read about 40 TB of data (my math is:=20
> (1-(1/10^14))^(3*(10^14))). If, on the other hand, UREs are defined as=20
> statistical evidence (as MTBF), environment and test conditions (eg:=20
> duty cycle, read/write distribution, etc) are absolutely critical to=20
> understand  what this parameter really mean for us.

The probability number doesn't tell you much at all about your drive.
Your drive probably works much better than the quoted rate, but could be mu=
ch
worse.
The quoted number might say something useful about a collection of 10,000
drives, but if you can afford those, you can probably afford to competent
statistician to explain the details too.


>=20
> I'm under impression (and maybe I'm wrong, as usual :)) that UREs mainly=
=20
> depends on incomplete writes and/or unsable sectors. If this is the=20
> case, maybe the published URE values are related to the entire HDD=20
> warranty. In other word, they should be read as "in normal condition,=20
> with typical loads, out HDD will exibit about 1/10^14 unrecoverable=20
> error during the entire disk lifespan".

I'm not an electro-magnetic engineer, but I would guess that UREs are caused
by some combination of:
 - irregularities in the physical media
 - imperfections in positioning of the write head
 - fluctuations in temperature and pressure which could
   affect precise performance of resistors and capacitors etc.

and probably various quantum effects that I know nothing about.

Maybe most UREs come from a spec of dust that was in the wrong place at the
wrong time.

If think a better summary would be:
  in normal conditions and typical loads, a collection of 10^14 drives will
  exhibit errors somewhere in the collection on a regular basis.

>=20
> It is reasonable? Or I am horribly wrong?
> Regards.
>=20

NeilBrown

--Sig_/O7d3kW=5MN4DquKLunjaCRg
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU+AXbznsnt1WYoG5AQKdAhAApYC7Z7/B33cdSLPD89NFxVwNX70HM/X4
lr+eoZK8KMPfSHn8ZIo+whNpScKwpGmWtBIa9Y7obRI3bCprverV9LVZcTGE6UeD
ocg7SfdMa+QYLgfTSTdKOqaWD66i8oXW3gKePK0AB61Zg+F3/NEckZ608zrC+zCE
JauCljjNc10ALeVV1oxltuYuSAguOfRxoAfFDRG9Fn/bzwwZUFYeBYXWwnL+qgMn
ZQWl6xPd3d0klBcrOvTXmJDAeGr30djE6JSan9KKG5wHomYwjVtv77x03IrRlQNh
LKYhuB7H8ucgN5JAhFl5u036SSVMXQ1Z0jLcXZwSsizdhETSZOp+H0dHbdYoUmCX
pJL6Y9LZdM7Z+sEUraYy7nXKc3mx/Tuv+xjGpQfyMflclF0sYZdK07z0fVNv833A
IqKIHYUryFE/uV4H0qOXZz6aO5+WGb/VgzhtVN5eOnM/VjD9fIOU8zHaK+xqdK7t
2sMyMPPRQ7shvm3Ewek9gGxEdCaPs+tTMuIdxL7rFPj6UgArMoq7A3gKipgM2z4v
q4/Niuwu9AEgcMFRD5tHT+2nQHTduHNJnFLEpRMt54DBflFbwfmC0bX32tt68Jhk
upDD0LQQ5XOODmnvPH6LRZimVaPyPA41cGIyRzzbOCqADoXyMsQo+12lMJnITpMD
zZFk8KVKdlo=
=5czg
-----END PGP SIGNATURE-----

--Sig_/O7d3kW=5MN4DquKLunjaCRg--
