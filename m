From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Western Digital Green 3TB SATA3 experiences
Date: Thu, 21 Mar 2013 17:17:31 +0100 (CET)
Message-ID: <22222437.8.1363882651636.JavaMail.root@zimbra>
References: <BA739E16-8531-44F6-8518-0315AE136833@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BA739E16-8531-44F6-8518-0315AE136833@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org, Andris Berzins <pkix@inbox.lv>
List-Id: linux-raid.ids

> Small correction. They've yanked settable SCT ERC in at least the Blu=
e
> and Black laptop (Scorpio) drives, which used to have this feature. S=
o
> it's not just the greens that had the feature removed. I'm pretty sur=
e
> all of the desktop drives, green, blue, black, have had it removed in
> newer revisions. Now you can get it in reds, or RE drives only, at
> least WDC. Otherwise you're looking for a different vendor.

This is true. The only real difference between the blacks and the 'ente=
rprise' drives, is that the firmware isn't crippled. Seagate and (hopef=
ully still) Hitachi drives allow setting SCT ERC. This is from my /etc/=
rc.local

for i in b c d e f g h
do
	dev=3Dsd$i
	smartctl -l scterc,70,70 /dev/$dev || echo 180 > /sys/block/$dev/devic=
e/timeout
done

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
