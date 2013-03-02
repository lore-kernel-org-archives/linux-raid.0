From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Expanding array with multiple devices
Date: Sat, 2 Mar 2013 20:14:28 +0100 (CET)
Message-ID: <27995698.14.1362251668611.JavaMail.root@zimbra>
References: <alpine.DEB.2.00.1303021828510.14991@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1303021828510.14991@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-raid@vger.kernel.org, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

> > I agree. And the file copy to the raid5 would almost certainly run
> > faster than any raid6 with "missing". Then the reshape is one
> > operation
> > to both expand the drive count and switch to raid6.
>=20
> If he's running 2.6.32 that option isn't available (if I remember
> correctly). Since he didn't disclose what mdadm and kernel version he
> was running, I suggested the safest path that works on most kernels a=
nd
> mdadm versions.

You're right. If he's on Ubuntu Lucid, that should be solvable with an =
upgrade to Precise with "do-release-upgrade", which has been stable for=
 some time.

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
