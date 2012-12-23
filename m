From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Disk speed comparison
Date: Sun, 23 Dec 2012 06:29:39 +0100 (CET)
Message-ID: <2944870.0.1356240579079.JavaMail.root@zimbra>
References: <50D68FC0.70807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50D68FC0.70807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > I have an array with 6 2TB drives plus a spare. While this works
> > well, I can from the munin graphs at
> > http://munin.karlsbakk.net/munin/karlsbakk.net/smilla.karlsbakk.net=
/index.html
> > that the WD2001FASS drives (sd[bcfg]) perform some 30% better than
> > the Hitachi HDS723020BLA642 drives (sd[eh]). The drives are on a
> > mixed set of controllers, so this shouldn't be relevant. Since they
> > all are specified to spin on 7200RPM, I find it wierd that the
> > performance difference shown by the Munin graph is so big.
>=20
> You've provided zero information about the controllers or the
> configuration of the drives. If the SATA ASIC to which the Black
> drives
> are connected is AHCI and the other is not, then NCQ may account for
> the
> difference in performance. Or, both may currently be AHCI, but
> possibly
> the Hitachi drives perform better with NCQ disabled. This would not b=
e
> rare. If you laid partitions on the Hitachi drives and misaligned
> them,
> this could easily cause a 30% deficit. Etc, etc.
>=20
> I doubt there is a 30% overall performance difference between these
> two
> drive models. The Black models are "enthusiast" class drives, and do
> have some additional performance features, but not that I'd think
> would
> yield a 30% advantage.
>=20
> You need to dig deeper into the details.

no partitions on this setup, just plain drives. what munin tells me is =
those WD drives are rather faster than the hitachis. As noted, all driv=
es are on a mixed controller setup, the hitachis and wd drives share co=
ntrollers for some. the only known common factor for the slow and fast =
drives are their label.

--=20
Vennlige hilsener / Best regards

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
roy@karlsbakk.net
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
I all pedagogikk er det essensielt at pensum presenteres intelligibelt.=
 Det er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5=
 eksessiv anvendelse av idiomer med xenotyp etymologi. I de fleste tilf=
eller eksisterer adekvate og relevante synonymer p=C3=A5 norsk.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
