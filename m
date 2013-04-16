From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: raid 1 errors then I failed and removed the drive. now cant
 tell which one it was?
Date: Tue, 16 Apr 2013 18:03:38 +0200 (CEST)
Message-ID: <7574434.4.1366128218698.JavaMail.root@zimbra>
References: <20130416042742.GA12964@earthlink.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130416042742.GA12964@earthlink.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@post.harvard.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> [730639.815511] ata1.00: cmd c8/00:08:ef:9f:90/00:00:00:00:00/e1 tag =
0
> dma 4096 in
> [730639.815513] res 51/40:00:f4:9f:90/40:00:01:00:00/e1 Emask 0x9
> (media error)
> [730639.824457] ata1.00: status: { DRDY ERR }
> [730639.828930] ata1.00: error: { UNC }
> [730639.848936] ata1.00: configured for UDMA/33

If the drives support scterc, then it should be enabled to allow the dr=
ive to fail a single sector quickly without going into deep recovery mo=
de. Run "smartctl -l scterc /dev/disk" to check if it's enabled. To ena=
ble it for drives supporting it, and allow higher timeouts for those wh=
o don't, I have the following in my /etc/rc.local to do this:

for i in {b..h}
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
