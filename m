From: Bernd Schubert <bernd-schubert@web.de>
Subject: Re: RAID migration from 2.4 -> 2.6
Date: Thu, 12 Aug 2004 20:51:01 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200408122051.06092.bernd-schubert@web.de>
References: <20040812152939.GD5326@romulus.a-s-i.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  protocol="application/pgp-signature";
  micalg=pgp-sha1;
  boundary="Boundary-02=_aw7GBp0kb2eeNRK";
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040812152939.GD5326@romulus.a-s-i.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Boundary-02=_aw7GBp0kb2eeNRK
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

On Thursday 12 August 2004 17:29, you wrote:
> At the moment I'm stumped, so I wonder if someone might be able
> to give me a hand.
>
> First, my RAID setup: I have a pair of Adaptec 7899 controllers
> with five 9GB SCSI disks on each.  The first disks on each controller
> are allocated in a RAID 1 configuration for boot, swap, /usr, etc.,
> while the next three disks on each controller are allocated in
> a RAID 5 configuration to our running services and data.  The last
> disk on each controller is designated as a spare disk for each RAID.
>
> These RAIDs work well with 2.4.  I've got them configured
> for autodetect, so the system brings them up at startup in 2.4.
>
> Now I'm trying to migrate to 2.6.7, and autodetection basically
> ignores all my SCSI disks.  I get three lines:

Does those partions have the FD type flag (linux raid autodetect)? With som=
e=20
2.4.X kernel versions it worked without it, but I think with 2.6.X you real=
ly=20
need to mark the partitions with this partition type.

Hope it helps,
	Bernd

PS: Sometimes I forget to set this flag and then have the same problem ;)



--Boundary-02=_aw7GBp0kb2eeNRK
Content-Type: application/pgp-signature
Content-Description: signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQBBG7waC8BUnAF+ydYRAnETAJ9o89MAhRuxJUx344YdIiob4cQbCQCfVE54
AdyRvHiJvZmOtMLZJ34IZxw=
=MfH2
-----END PGP SIGNATURE-----

--Boundary-02=_aw7GBp0kb2eeNRK--
