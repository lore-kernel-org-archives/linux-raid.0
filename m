From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Suggestion for hot-replace
Date: Sun, 25 Nov 2012 16:31:45 +0100 (CET)
Message-ID: <10107277.2.1353857505404.JavaMail.root@zimbra>
References: <1759500.SiuUO4mi0r@workstation-home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1759500.SiuUO4mi0r@workstation-home>
Sender: linux-raid-owner@vger.kernel.org
To: Tommy Apel Hansen <tommyapeldk@gmail.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Hello, personally I would vote for an option to rotate spares into an=
d
> array
> like Peter suggests, keeping a drive idle doesn't guarrantee that it'=
s
> actually operational.

Only problem with this, is if you do it frequently, it'll degrade perfo=
rmance.

Btw, is there a way to replace a drive without failing one? In RAID-5, =
a common issue is to have a failed drive and then find bad sectors on a=
nother. In this setting (and possibly others), it'd be good to have md =
replace the drive while still active (like what can be done in ZFS).

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
