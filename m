From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Changing Drive letters
Date: Sat, 12 Apr 2003 12:29:30 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16023.31242.311683.718259@notabene.cse.unsw.edu.au>
References: <Pine.LNX.4.44.0304101555440.25209-100000@karma.hagopian.net>
	<00ac01c2ffb5$4fff2580$6a01a8c0@wa1hco>
	<00c801c3007f$d03fbaf0$6a01a8c0@wa1hco>
	<16023.21137.893717.233525@notabene.cse.unsw.edu.au>
	<00d901c30095$9f8e8330$6a01a8c0@wa1hco>
	<3E97738F.7040500@hum.auc.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mads Peter Bach on Saturday April 12
To: Mads Peter Bach <mpb@hum.auc.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday April 12, mpb@hum.auc.dk wrote:
> jeff millar wrote:
> > Any limits on this, like when all the drive letter change at once?
>=20
> Nope.
> You can put something like:
> DEVICE /dev/sd[abcdef][1234567]
> and
> ARRAY /dev/md0 level=3Draid1 num-devices=3D2 UUID=3D49d38e1a:3ae5b824=
:9220fe3b:5a8129f0
> in your /etc/mdadm.conf

Exactly, and it doesn't matter where your drives are as long as they
are listed in a DEVICE line.

>=20
> And then do
> mdadm --assemble /dev/md0 --uuid 49d38e1a:3ae5b824:9220fe3b:5a8129f0

You don't need the uuid twice.  Given the above mdadm.conf,

  mdadm --assemble /dev/md0 --scan
will work.

>=20
> > Does the command need --force?
>=20
> Not as far as I remember.

That's correct.  --force is only needed if there is an inconsistancy in
the superblocks and you want mdadm to over-ride and fix things.
Normally when you use --force you will want to explicitly list the
devices to make sure mdadm doesn't do the wrong thing by mistake:
  mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdc1 ...

NeilBrown


>=20
> --=20
> Mads Peter Bach
> Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
> Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st
> # whois MPB1-DK@whois.dk-hostmaster.dk
>=20
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
