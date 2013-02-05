From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Interpreting mdstat output
Date: Tue, 5 Feb 2013 13:41:27 +0100 (CET)
Message-ID: <7680572.8.1360068087105.JavaMail.root@zimbra>
References: <20130205123419.GA492@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130205123419.GA492@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> On Tue, Feb 05, 2013 at 01:30:41PM +0100, Roy Sigurd Karlsbakk wrote:
> > I beleive using 22 drives in a single RAID-5 is something like BASE
> > jumping with a large umbrella. You should at least use RAID-6, and
> > perhaps even split up the RAID into smaller ones.
>=20
> Point taken, but this is actually a large dataset which could be
> recreated
> if necessary (i.e. it's derived from other data), and is also to be
> copied to another server.

Still, better use raid-6 + 1 spare than raid-5 + 2 spares. It will prob=
ably take a while to rebuild the data on that one in case of a double d=
isk failure, and with that amount of drives, the chances are pretty dec=
ent.

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
