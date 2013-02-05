From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: Interpreting mdstat output
Date: Tue, 5 Feb 2013 13:30:41 +0100 (CET)
Message-ID: <7952623.6.1360067441417.JavaMail.root@zimbra>
References: <20130205122048.GA417@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130205122048.GA417@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: Brian Candler <B.Candler@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> (Ubuntu 12.04.2, kernel 3.2.0-37-generic)
>=20
> I created a RAID5 array with 22 data disks and 2 hot spares, like
> this:
>=20
> # mdadm --create /dev/md/dbs -l raid5 -n 22 -x 2 -c 512 -b internal
> /dev/sd{b..y}

I beleive using 22 drives in a single RAID-5 is something like BASE jum=
ping with a large umbrella. You should at least use RAID-6, and perhaps=
 even split up the RAID into smaller ones.

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
