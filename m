From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having
 alive mirrors?
Date: Fri, 15 Mar 2013 13:32:13 +0100 (CET)
Message-ID: <3519169.10.1363350733597.JavaMail.root@zimbra>
References: <20130315172135.779185b5@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130315172135.779185b5@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > > What happened was:
> > > - a device (sdg1) was added as a write-mostly member to a degrade=
d
> > > two-member RAID1 (md3) and started recovering;
> >
> > May I be so frank as to guessing you found an old drive and added a=
s
> > write-mostly? sdg is the bad drive here=E2=80=A6
>=20
> This is correct, but I should note that I did not add it as
> write-mostly just
> because it's an older drive, but because it is my normal set-up for
> md3:
> a RAID1 mirror of a fast SSD (sdf) and a write-mostly HDD (sdg in thi=
s
> case).

This makes perfectly sense, but the HDD obviously isn't good, and perha=
ps some data were bad on the SSD as well. I'd replace the HDD with some=
thing else, perhaps after a badblocks test, and at least with a short S=
MART test, and rebuild. The errors on the filesystem should be solveabl=
e with an fsck. If not, well, I hope you have a good backup=E2=80=A6

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
