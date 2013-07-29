From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Mdadm server eating drives
Date: Tue, 30 Jul 2013 00:25:11 +0200 (CEST)
Message-ID: <20609926.4.1375136711302.JavaMail.root@zimbra>
References: <51BA7B28.9030808@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51BA7B28.9030808@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Barrett Lewis <barrett.lewis.mitsi@gmail.com>
List-Id: linux-raid.ids

> > 5) for x in /sys/block/sd*/device/timeout ; do echo $x $(< $x) ;
> > done
> >                  http://pastie.org/8040870
>=20
> All timeouts are still the default 30 seconds. With enabled ERC
> support, these values must be two to three minutes. I recommend 180
> seconds. Your array *will not* complete a rebuild with dealing with
> this problem.

With ERC suppot, those timeouts should be around 7 seconds, not 3 minut=
es. What he pasted was 180 seconds, as in three minutes, which will bus=
t a RAID rather quickly.

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
