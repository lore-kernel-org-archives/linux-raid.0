From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: getting I/O errors in super_written()...any ideas what would
 cause this?
Date: Wed, 28 Nov 2012 19:51:48 +0100 (CET)
Message-ID: <8134827.27.1354128708501.JavaMail.root@zimbra>
References: <CADNH=7GcgB7Beyf7yReYfDQUQfkVy2A0FBkjBOWokSHFGWzLwQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7GcgB7Beyf7yReYfDQUQfkVy2A0FBkjBOWokSHFGWzLwQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Linux-RAID <linux-raid@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>, Chris Friesen <chris.friesen@genband.com>
List-Id: linux-raid.ids

> > I'm running 2.6.27 with LVM over software RAID 1 over a pair of SAS
> > disks.
> >
> > Recently we started seeing messages of the following pattern:
> >
> > Nov 28 08:57:10 kernel: end_request: I/O error, dev sda, sector
> > 1758169523
> > Nov 28 08:57:10 kernel: md: super_written gets error=3D-5, uptodate=
=3D0
> > Nov 28 08:57:10 kernel: raid1: Disk failure on sda2, disabling
> > device.
> > Nov 28 08:57:10 kernel: raid1: Operation continuing on 1 devices.
> >
> > We're working through our changes to figure out what might have
> > triggered
> > it, but it seems likely the root cause lies in the core code.
> >
> > We're assuming it's a software issue since it's reproducible on
> > multiple
> > new-ish systems, although so far we've only tried it on systems wit=
h
> > one
> > particular configuration--we're planning on trying it with differen=
t
> > disks
> > just to be sure.
> >
> > For what it's worth, we've seen the problems with disk write cache
> > enabled
> > and disabled.
> >
> > Anyone have any ideas, or pointers as to what I should look at?
>
> Hi,
>=20
> It would be interesting to see what SMART says about the above, sinde
> the error is regarding sda first, then md follows.
>

Agreed - run smartctl -H /dev/sda or smartctl -a /dev/sda if -H succeed=
s
=20
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
