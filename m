From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: RAID5 recovering
Date: Tue, 16 Apr 2013 18:41:43 +0200 (CEST)
Message-ID: <8381772.6.1366130503769.JavaMail.root@zimbra>
References: <20130416143035.43533168@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130416143035.43533168@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Pierre Martineau <pierre.martineau@inserm.fr>, linux-raid@vger.kernel.org, Robin Hill <robin@robinhill.me.uk>
List-Id: linux-raid.ids

> > Given the rebuild time for a 1To disk, I'd be wary of running RAID5
> > - if
> > you have the space, adding another disk and going to RAID6 will be
> > much
> > safer.
>=20
> As I see it, 3 disks is about the only configuration where RAID5 stil=
l
> does make sense.
>=20
> 4 disks is a tricky spot, RAID5 already feels a bit too dangerous, bu=
t
> RAID6 is still not space-efficient enough.

Given the fact that all data demands grow, the space-efficiency part is=
 temporary, so I wouldn't worry too much about it. Helped a friend to s=
etup a RAID-5 and after her initial drive failure occured, gave her a t=
ip on getting a new one in addition to the RMAed one. 4 drives in RAID-=
6 now, half a year after the initial failure, rock solid. If she gets a=
 double drive failure, well, the chances are good her data survives it.

So yes, use RAID-6 if you can. Perhaps even with a spare if you've got =
another drive and you don't need the extra space.

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
