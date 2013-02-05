From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: What layout with 6x2TB, Intel Atom?
Date: Tue, 5 Feb 2013 01:01:24 +0100 (CET)
Message-ID: <733670.23.1360022484693.JavaMail.root@zimbra>
References: <511040F5.1020407@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <511040F5.1020407@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: =?utf-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Third, use XFS, and format with alignment to the md device:
> ~$ mkfs.xfs -d su=3D512k,sw=3D4

Why? ext4 should be just as good for that, and better for metadata

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
