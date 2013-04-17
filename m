From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 10:20:52 +0600
Message-ID: <20130417102052.20c40887@natsu>
References: <15345091.8.1366130671716.JavaMail.root@zimbra>
	<516DABF2.5050409@tigertech.com>
	<516DAF21.5040409@aei.mpg.de>
	<516DD433.50100@tigertech.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/p56qLhYj7Vq+d090nIsVnbH"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516DD433.50100@tigertech.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert L Mathews <lists@tigertech.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/p56qLhYj7Vq+d090nIsVnbH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 16 Apr 2013 15:44:03 -0700
Robert L Mathews <lists@tigertech.com> wrote:

> On 4/16/13 1:05 PM, Carsten Aulbert wrote:
>=20
> > The problem I find with RAID1 is that it won't protect you against
> > silent corruptions (same as RAID5). What do you do if you do a through
> > check and both drives claim a data block is valid and intact, but data
> > differs? Do you trust disk1 or disk2?
>=20
> That's partly why we use three-disk arrays instead of two-disk.

You do know there is no "voting" system in md, right?

If you imagine that all three disks are being read in parallel, and if one
returns bad data, it is automatically "overruled" by a majority vote from t=
he
two other ones with correct data, that's not how it works at all.

The data is read randomly from all three disks (I think it's load-balanced =
by
process ID); if one disk happened to silently return corrupt data, that's i=
t,
your app just got corrupt data passed to it, and if happens to write it back
to disk (maybe after some processing), then the incorrect data will be
faithfully replicated by md to all three disks. So in the future you have n=
ot
even a _chance_ to read back the correct data that was previously there.

> In the meantime, I'd rather risk this problem than the endless reports
> of complete array failures that appear on the list with RAID 5 and even
> RAID 6 (a recent topic, I note, was "multiple disk failures in an md
> raid6 array"). I almost never see anyone reporting complete loss of a
> RAID 1 array.

In general, you seem to be WAY too concerned about losing your RAID array;
this sounds like you are someone who doesn't make backups and tries to use
RAID as a replacement for them. Don't forget if for example a rogue program
gets 'root' on your machine and overwrites the md device with zeroes, it wi=
ll
be instantly replicated to all three disks as well.

As for me, if I lose my primary RAID6, it's a maximum a day's worth of
changes, and some data transfer from here and there to get it all copied fr=
om
backups and be up and running again. (I could reduce even that risk and eas=
ily
back up 4 times a day, but do not see the need at the moment.)

--=20
With respect,
Roman

--Sig_/p56qLhYj7Vq+d090nIsVnbH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlFuIyQACgkQTLKSvz+PZwjf3ACgjsXD7aQ/d5svjGw7kum2AbJS
+jkAmwQVZ+OWjc3Oht9J42F1LQpnOse5
=YAmR
-----END PGP SIGNATURE-----

--Sig_/p56qLhYj7Vq+d090nIsVnbH--
