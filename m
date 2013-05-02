From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: replacing drives
Date: Thu, 2 May 2013 19:43:06 +0200 (CEST)
Message-ID: <1791114.8.1367516586634.JavaMail.root@zimbra>
References: <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1304301519350.26743@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

----- Opprinnelig melding -----
> On Tue, 30 Apr 2013, Roberto Nunnari wrote:
>=20
> > How do I increase that timeout?
>=20
> for x in /sys/block/sd[a-z] ; do echo 180 > $x/device/timeout ; done

I have this in my /etc/rc.local to attempt to enable scterc and fall ba=
ck to increasing timeout when it fails (on my wd black drives)

for i in b c d e f g h
do
    dev=3Dsd$i
    smartctl -l scterc,70,70 /dev/$dev || echo 180 > /sys/block/$dev/de=
vice/timeout
done


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
