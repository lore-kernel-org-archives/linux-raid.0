From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: multiple disk failures in an md raid6 array
Date: Fri, 5 Apr 2013 19:06:42 +0200 (CEST)
Message-ID: <11216784.20.1365181602157.JavaMail.root@zimbra>
References: <515EBE0F.5090201@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <515EBE0F.5090201@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Mike Vanhorn <michael.vanhorn@wright.edu>
List-Id: linux-raid.ids

> > # for x in /sys/block/sd[cdfghij] ; do echo -n "$x: "; cat
> > $x/device/timeout; done
> >
> > Vennlige hilsener / Best regards
>=20
> Curious. Works fine here:
>=20
> # for x in /sys/block/sd[abcd] ; do echo $x $(< $x/device/timeout) ;
> done
> /sys/block/sda 30
> /sys/block/sdb 30
> /sys/block/sdc 30
> /sys/block/sdd 30
>=20
> Not that it matters, much. Use what works for you.

probably a typo - works now :P

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
