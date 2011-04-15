From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Recommended pci-e 1x SATA cards.
Date: Fri, 15 Apr 2011 11:03:58 +0600
Message-ID: <20110415110358.7e679722@natsu>
References: <4DA6CCFE.8020708@crc.id.au>
	<20110414165433.7a7d1cdc@natsu>
	<4DA74CF3.2050509@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/tvD+fl=lSazh4Smp83LRZEh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DA74CF3.2050509@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Steven Haigh <netwiz@crc.id.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/tvD+fl=lSazh4Smp83LRZEh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 14 Apr 2011 14:37:23 -0500
Stan Hoeppner <stan@hardwarefreak.com> wrote:

> > I suggest that you avoid Silicon Image 3132, they have data corruption
> > issue (on some board designs?), triggered or amplified by transferring =
via
> > both ports at the same time, at full speed.
>=20
> Stating this opinion based on a very limited number of such reports is
> irresponsible.

Irresponsible to chip and board makers maybe, but I prefer to be responsible
with regard to protecting my own data from possibly bad components first.

> If the issue is a bad PCB from a couple of vendors, state the vendors and
> the card model and rev.

Yes, after the initial report I was thinking the problem is limited to one
particular vendor of the boards or even just a batch, but since it was
confirmed on this list, by person from a different continent, who bought ca=
rd
from a different place/vendor/batch and still had the exactly same issue,
that's when it was enough for me to blacklist all cards on 3132 in general.

> Case in point:
>=20
> http://blog.backblaze.com/2009/09/01/petabytes-on-a-budget-how-to-build-c=
heap-cloud-storage/

They also recommend using Seagate 7200.11 1.5TB drives, is that a
recommendation you would also support? :)
http://www.desktopreview.com/default.asp?newsID=3D593
http://hardware.slashdot.org/story/09/01/17/0115207/Seagate-Hard-Drive-Fias=
co-Grows
http://it.slashdot.org/comments.pl?sid=3D1098793&cid=3D26542735

> BackBlaze uses three Sil3132 based 2 port Syba PCIe x1 SATAII cards in
> each storage 45 drive storage pod server, and one 4 port Addonics
> Sil3124 PCI card.  Odd balance WRT bandwidth, but if you read the doc
> it'll be clear why they did this.

The Syba card also costs 4 times what the cheaper cards on the same chip co=
st,
so is that what it takes to make a non-data-corrupting card with SiI3132? At
that price point, why not just get a Marvell 9123 anyway.
Oh wait, there are reports that even Syba corrupts data in the same way!
I even made a screenshot in case this goes away (can't find a permanent link
other than http://www.newegg.com/Product/Product.aspx?Item=3DN82E1681512402=
7)
http://ompldr.org/vODl1eg/2011-04-15T045338Z-syba.png
So it is just more expensive, not more reliable in any way. And it is after
all the chip's fault.

> Again, there is nothing wrong with the Silicon Image chips.  They have a
> very good reputation.

I do not agree, they have an terrible reputation and an awful track record
regarding reliability with the earlier 3112/3114/3124 chips. And their
problems most often manifest in the worst way possible, as silent corruption
of user data. See for yourself:
https://encrypted.google.com/search?hl=3Den&q=3D3112+data+corruption
https://encrypted.google.com/search?hl=3Den&q=3D3114+data+corruption

"Sil3112/3114 are now virtually the only controllers with occassional and
unresolved data corruption issues."
http://comments.gmane.org/gmane.linux.ide/44799

"there are known major problems with Silicon Image controllers on FreeBSD,
Linux, and Windows.  The most common problem is silent data
corruption. ...JMicron controllers are known to behave OK"
http://lists.freebsd.org/pipermail/freebsd-hackers/2008-September/026152.ht=
ml

So it is not surprising to me AT ALL, that 3132 would also have similar kind
of 'surprises'. And with presence of a readily-available cheap alternative,
namely JMicron JMB363 (with an untarnished reputation, and being a nice
standard 'ahci' controller), just excluding any Silicon Image from future
choices forever, seems to be the right thing to do to me.

--=20
With respect,
Roman

--Sig_/tvD+fl=lSazh4Smp83LRZEh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk2n0b4ACgkQTLKSvz+PZwh0JgCgjpKOV+SZ8fWTeba81l6LHN4X
3h0AnA03I1W7AzI+ajF3imXT+Mz0tvt4
=LuIW
-----END PGP SIGNATURE-----

--Sig_/tvD+fl=lSazh4Smp83LRZEh--
