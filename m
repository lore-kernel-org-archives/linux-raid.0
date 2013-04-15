From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Odd --examine output
Date: Mon, 15 Apr 2013 20:42:54 +0200 (CEST)
Message-ID: <10112252.14.1366051374769.JavaMail.root@zimbra>
References: <CD917B51.41713%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD917B51.41713%michael.vanhorn@wright.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Mike Vanhorn <michael.vanhorn@wright.edu>
Cc: Phil Turmel <philip@turmel.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >NOT a guess. Back up what you can, while you can, and start over. Us=
e
> >"fdisk -u" so you can ensure partitions start on multiples of eight
> >(8)
> >sectors. (Modern fdisk uses 1MB alignment by default. Highly
> >recommended.)
> >
> >
>=20
> So, if I start the partition at sector 64 (rather than 63), that's
> better,
> right (since 64 is a multiple of 8)? Or is there more math to do and
> I'm still not getting it?

I still don't understand why people use partitions for RAID when the wh=
ole drive is used anyway. Partitions were invented to partition things =
up and are of no use if you want to spend the whole drive's space for R=
AID use (or otherwise).

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
