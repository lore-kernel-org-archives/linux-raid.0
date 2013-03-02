From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Expanding array with multiple devices
Date: Sat, 2 Mar 2013 18:15:56 +0100 (CET)
Message-ID: <25032068.12.1362244556592.JavaMail.root@zimbra>
References: <513232B4.7030404@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <513232B4.7030404@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Oliver Schinagl <oliver+list@schinagl.nl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> On 03/02/2013 09:07 AM, Roy Sigurd Karlsbakk wrote:
> >> While expanding an existing raid is as simple as mdadm --add,
> >> followed
> >> by an mdadm --grow, How would you go about this when expanding it
> >> with
> >> multiple devices.
> >
> > Given a RAID-5 on /dev/sd[bcde], I'd do
> >
> > # mdadm --add /dev/md0 /dev/sd[fghi]
> > # mdadm --grow --level=3D6 --raid-devices=3D8
> >
> > No need to create a new RAID and then move the data.
>=20
> You missed the bit where he states he needs to use mkfs to switch
> filesystem features.

Oh, sorry. Then why not start off with an identical RAID-5, move the da=
ta, and then expand as above? No dangling "missing" drives, just plain =
and simple.

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
