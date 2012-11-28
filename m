From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Checksumming RAID?
Date: Wed, 28 Nov 2012 11:56:28 +0100 (CET)
Message-ID: <23882377.7.1354100188235.JavaMail.root@zimbra>
References: <C516161F-6B9A-41D8-BFA0-7B6ACF848DB8@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C516161F-6B9A-41D8-BFA0-7B6ACF848DB8@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > According to a few studies I've read, the number of silent errors
> > are identical on both consumer SATA drives and SAS drives. It's the
> > density that makes errors, and the platters and disk heads are
> > produced alike.
>=20
> That's not what I'm reading:
>=20
> Corruption detected in 8.5% of nearline disks, and 1.9% in enterprise
> disks.
> http://www.pdsi-scidac.org/events/PDSW09/resources/pdsw09_slides13.pd=
f

That doesn't make sense. Nearline and enterprise drives are large 7k2 d=
rives that come in consumer and enterprise models, such as Hitachi Desk=
star and Ultrastar. The latter is said to have better bearings etc, alt=
hough I don't know the difference for sure. With WDs large drives, most=
 of the difference is said to be in the firmware (such as TLER in the e=
nterprise/RAID drives). Comparing "nearline" and "enterprise" like done=
 here, is merely a comparison of small and large drives, where it's wel=
l known that the smaller (less dense) drives have less errors.

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
