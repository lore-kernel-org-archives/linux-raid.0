From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: raid/device failure
Date: Mon, 11 Feb 2013 02:13:53 -0700
Message-ID: <201302110213.53880.thomas@fjellstrom.ca>
References: <23314523.6.1360571363962.JavaMail.root@zimbra>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23314523.6.1360571363962.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On February 11, 2013, Roy Sigurd Karlsbakk wrote:
> > I've re-configured my NAS box (still haven't put it into "productio=
n")
> > to be a
> > raid5 over 7 2TB consumer seagate barracuda drives, and with some
> > tweaking, performance was looking stellar.
>=20
> Using that many drives in raid-5 is a bit risky. Better use raid-6=E2=
=80=A6
>=20
> Just my 2c

Yeah, I had first set it up in raid6. But I will have a separate backup=
 array=20
of this array. Nothing fancy, just a linear concat of some 3TB+1TB disk=
s,=20
though it may eventually get upgraded to a raid5 of 3TB disks.

I've figured that if I lose three disks all within the 5 hour time it t=
akes to=20
do a full rebuild, I probably have larger problems to worry about than =
losing=20
my collection of random linux isos, even more random downloaded files, =
debian=20
apt mirror, one copy of my important backed up files, and miscelaneous =
media=20
files. I'll be running with the bitmap enabled, so if there are minor=20
problems, the array will take minutes to resync rather than hours.

Also, since I've gotten decent power supplies and UPSs, I haven't had v=
ery=20
many issues with harddrives. I personally haven't had a drive failure t=
hat=20
wasn't within the first couple weeks of purchase in years. And I always=
 try to=20
make sure to stress test disks before putting them into service to weed=
 out=20
SIDS.

This way I get the 10TB+ I was aiming for when I decided to build a NAS=
=2E In=20
raid6, I get 9.2TB or so. Very close I know ;)

> Vennlige hilsener / Best regards
>=20
> roy
> --
> Roy Sigurd Karlsbakk
> (+47) 98013356
> roy@karlsbakk.net
> http://blogg.karlsbakk.net/
> GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
> --
> I all pedagogikk er det essensielt at pensum presenteres intelligibel=
t. Det
> er et element=C3=A6rt imperativ for alle pedagoger =C3=A5 unng=C3=A5 =
eksessiv anvendelse
> av idiomer med xenotyp etymologi. I de fleste tilfeller eksisterer
> adekvate og relevante synonymer p=C3=A5 norsk. --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--=20
Thomas Fjellstrom
thomas@fjellstrom.ca
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
