From: Bryan Mesich <bryan.mesich@ndsu.edu>
Subject: Re: Any benefity to write intent bitmaps on Raid1
Date: Wed, 8 Apr 2009 20:30:18 -0500
Message-ID: <20090409013018.GA3514@atlantis.cc.ndsu.NoDak.edu>
References: <45635.60.234.49.2.1239236645.squirrel@webmail.stevencherie.net>
Reply-To: Bryan Mesich <bryan.mesich@ndsu.edu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="G4iJoqBmSsgzjUCe"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45635.60.234.49.2.1239236645.squirrel@webmail.stevencherie.net>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Ellis <steven@openmedia.co.nz>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Apr 09, 2009 at 12:24:05PM +1200, Steven Ellis wrote:
> Given I have a pair of 1TB drives Raid1 I'd prefer to reduce any recovery
> sync time. Would an internal bitmap help dramatically, and are there any
> other benefits.
>
If one of your drives goes pear shaped and needs to be replaced,
then no, a write intent bitmap will not help you.  When you
replace the drive, the incomming drive will need to do a full
resync.

Many times a read/write error causes the drive to be failed. In
this case, the bad block that caused the read/write error should
get re-mapped by the HD firmware. If you have a write intent
bitmap enabled, the re-add only resyncs the out-of-sync pages
(not sure if page is the correct terminology).

There is some overhead when using a write intent bitmap as the
bitmap needs to be updated as data is written to the device.  For
most people, the overhead is not noticeable.  If you really need
performance, the bitmap can be moved to another disk(s) that is
not a member of the RAID1 array in question.

I've used write intent bitmaps many times in a SAN environment=20
in which FC initiators mirror 2 block devices.  Both block devices=20
come from different FC targets. This makes maintiance much easier
since all we have to do is break the RAID1 mirror on the
initiator (we also have good uptime :).  A write intent bitmap=20
speeds the re-syncing process up since we only resync the=20
out-of-sync data.

Bryan

--G4iJoqBmSsgzjUCe
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQFJ3U+qlSl3SAlkhEcRAuIRAJsF1lE7r3jzlIjl7P4n8OrZnmpmvQCfSSWs
1wYBoSk8maRcMmlutfXcW0E=
=h4ZG
-----END PGP SIGNATURE-----

--G4iJoqBmSsgzjUCe--
