From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having
 alive mirrors?
Date: Sun, 17 Mar 2013 14:04:50 +0100 (CET)
Message-ID: <1567316.0.1363525490131.JavaMail.root@zimbra>
References: <E1F75819-ABCB-4C6F-85F4-1B812B168DB6@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E1F75819-ABCB-4C6F-85F4-1B812B168DB6@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > This is correct, but I should note that I did not add it as
> > write-mostly just
> > because it's an older drive, but because it is my normal set-up for
> > md3:
> > a RAID1 mirror of a fast SSD (sdf) and a write-mostly HDD (sdg in
> > this case).
>=20
> Again, I find it odd that sdg while rebuilding is reading any sectors=
=2E
> The read errors are coming from sdg. That it's also write-mostly
> enhances the mystery why sdg is being read from.
>=20
> I would fail the HDD, and btrfs scrub the array which in effect shoul=
d
> scrub only sdf. And it may also need an offline btrfsck. The source
> (sdf) is already suspect because of btrfs not finding checksums where
> it was expecting to find them, and then on top of this you're getting
> sdg producing bad sector errors on reads.

Have you done a SMART check of sdg? smartctl -H first, then smartctl -t=
 short, then smartctl -t long (with smartctl -H between them)

> You might also consider posting the configuration and full dmesg to
> the btrfs list. I'm curious what btrfs developers think of this
> configuration.

It's not btrfs - it's below that.

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
