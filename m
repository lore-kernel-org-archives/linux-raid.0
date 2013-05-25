From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: raid10 physical layout?
Date: Sat, 25 May 2013 15:31:33 +0200 (CEST)
Message-ID: <7725748.4.1369488693863.JavaMail.root@zimbra>
References: <519FBBE5.7050802@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519FBBE5.7050802@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, Matt Garman <matthew.garman@gmail.com>
List-Id: linux-raid.ids

> > I'm looking into building a six-disk raid10. The six disks are
> > comprised of three from one manufacturer, and three from another.
>=20
> > But based on what I've been reading, looks like mdadm's more
> > sophisticated raid10 layout schemes give better performance. For
> > example, can I create a raid10,f2 set in such a way as to meet my
> > "redundant copies on different manufacturer" criteria?
>=20
> Just alternate the manufacturers when you list the devices in the
> "--create" operation. MD lays out raid10,f2 redundant data on adjacen=
t
> disks. (Wraps around.)

You also may want to consider using LVM instead of md RAID-10, since th=
e latter isn't very flexible - you can't add new drives or otherwise gr=
ow raid-10 (atm).

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
