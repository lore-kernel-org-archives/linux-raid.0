From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Disk speed comparison
Date: Sat, 22 Dec 2012 18:49:09 +0100 (CET)
Message-ID: <19033157.9.1356198549636.JavaMail.root@zimbra>
References: <CAAMCDed=47sKjPBkP-MW=ZZoEuk6KXn6fQJj5hVdxpEdueLrHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDed=47sKjPBkP-MW=ZZoEuk6KXn6fQJj5hVdxpEdueLrHw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
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
> >
> > Anyone seen something similar?
>=20
> Go the the manufacturers web sites and find the spec sheets for the
> drivers.
>=20
> They will likely list a min speed and a max speed for how fast data i=
s
> passing under the head depending on if it is the inner or outer track=
=2E
>=20
> It basically comes down to if all is working exactly right, the numbe=
r
> of bytes passing under the head times rpm, so if one disk has a highe=
r
> bit density the rate will be larger, and this varies quite a bit from
> disk to disk.

Thanks for the replay

WD2001FASS: 4x500GB platters
HDS723020BLA642: 3x667GB platters

- Shouldn't higher density normally mean higher speed?

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
