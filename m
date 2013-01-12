From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: recommended way to add ssd cache to mdraid array
Date: Sat, 12 Jan 2013 17:37:09 +0100 (CET)
Message-ID: <9897176.12.1358008628959.JavaMail.root@zimbra>
References: <50F16FAC.7000509@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <50F16FAC.7000509@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> > uh=E2=80=A6 how can the filesystem chosen be relevant to the disk e=
levator?
>=20
> It's the other way round. The chosen elevator can cause problems with
> the filesystem. You should find this relevant conversation amongst th=
e
> lead XFS developers educational:
>=20
> http://oss.sgi.com/archives/xfs/2011-07/msg00464.html

This article is about using CFQ with RAID controllers with write cache,=
 which isn't something I'd recommend. CFQ is, if I'm not mistaken, good=
 if Linux has local access to each disk, and the disks are spinning (!S=
SD).

> > CFQ will try to optimize access to reduce seeks
>=20
> "Completely Fair Queuing" -- The name alone tells you how it works. I=
t
> most certainly does not do what you state. Please read the brief
> Wikipedia article: http://en.wikipedia.org/wiki/CFQ

It's how it's designed, for spinning rust.

> > and should be completely independent on the filesystem used on top.
>=20
> Operative word: "should"
>=20
> The USA should not be $16 Trillion in debt, but it is. By
> international
> law whales should not be killed, but they still are. Etc.

Well, most things don't work as they are intended to do, but I guess CF=
Q works pretty well for spinning rust directly attached to a Linux box.

The default scheduler was changed in kernel, but only because SSDs are =
getting more common. Would those kernel developers know their things?

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
