From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Possible to rescue SW Raid5 with 2 missing Disks
Date: Tue, 19 Feb 2013 19:32:43 +0100 (CET)
Message-ID: <16900460.19.1361298763813.JavaMail.root@zimbra>
References: <5123BAF1.1030600@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5123BAF1.1030600@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org, Dragon <Sunghost@gmx.de>
List-Id: linux-raid.ids

> > Hello,
> > sorry for pushing, but any further doing to rescue the raid? sorry
> > but the system didnt run since Dec...
>=20
> I still think you are at the point where duplicating your original
> disks
> onto backups so you can try the combinations I identified is the only
> *safe* way forward. But only *safe* in the sense that if your first
> combination doesn't work, you can copy back and try another
> combination.
>=20
> I've yet to see any indication that the moosefs on top of your broken
> ext4 fs is likely to be saved.
>=20
> You should post the links to the "fsck -n" results of creating the
> array
> in the six combinations I had you try.
>=20
> You should also repost the output of mdadm -D and mdadm -E from the
> original array that you shared with me on Dec 17.

IMHO you should be using ddrescue (preferalbly the one from GNU) to cop=
y the disks onto new disks (at least the faulty ones). Do this first, s=
ince additional access may result in more data loss. After doing that, =
use the new drives for recovery, since they will (hopefully) not be thr=
owing errors. Working live on bad drives isn't something I would recomm=
end.
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
