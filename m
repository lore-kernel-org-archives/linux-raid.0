From: Chris Murphy <lists@colorremedies.com>
Subject: Re: md RAID1 passes I/O errors to the filesystem despite having alive mirrors?
Date: Fri, 15 Mar 2013 10:19:43 -0600
Message-ID: <E1F75819-ABCB-4C6F-85F4-1B812B168DB6@colorremedies.com>
References: <20130315041054.79eb5dcc@natsu> <32050581.8.1363345666963.JavaMail.root@zimbra> <20130315172135.779185b5@natsu>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130315172135.779185b5@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Mar 15, 2013, at 5:21 AM, Roman Mamedov <rm@romanrm.ru> wrote:

> On Fri, 15 Mar 2013 12:07:47 +0100 (CET)
> Roy Sigurd Karlsbakk <roy@karlsbakk.net> wrote:
>=20
>>> What happened was:
>>> - a device (sdg1) was added as a write-mostly member to a degraded
>>> two-member RAID1 (md3) and started recovering;
>>=20
>> May I be so frank as to guessing you found an old drive and added as=
 write-mostly? sdg is the bad drive here=85
>=20
> This is correct, but I should note that I did not add it as write-mos=
tly just
> because it's an older drive, but because it is my normal set-up for m=
d3:
> a RAID1 mirror of a fast SSD (sdf) and a write-mostly HDD (sdg in thi=
s case).

Again, I find it odd that sdg while rebuilding is reading any sectors. =
The read errors are coming from sdg. That it's also write-mostly enhanc=
es the mystery why sdg is being read from.

I would fail the HDD, and btrfs scrub the array which in effect should =
scrub only sdf. And it may also need an offline btrfsck. The source (sd=
f) is already suspect because of btrfs not finding checksums where it w=
as expecting to find them, and then on top of this you're getting sdg p=
roducing bad sector errors on reads.

You might also consider posting the configuration and full dmesg to the=
 btrfs list. I'm curious what btrfs developers think of this configurat=
ion.


Chris Murphy


P.S. Roman, there is a misconfigured MTA on your end, I always get emai=
ls from my MTAs indicating delays accepting handoffs of email only to y=
ou (with Reply All), it's possible it's wholesale rejecting an entire d=
omain (comcast.net). If you want raw message source, you'll have to ema=
il me from a totally different account that I can forward to.--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
