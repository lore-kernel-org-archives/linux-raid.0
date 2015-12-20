From: NeilBrown <neilb@suse.de>
Subject: Re: clustered MD - beyond RAID1
Date: Mon, 21 Dec 2015 10:25:41 +1100
Message-ID: <87si2w66tm.fsf@notabene.neil.brown.name>
References: <56742652.5040304@nasa.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56742652.5040304@nasa.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Dec 19 2015, Scott Sinno wrote:

> Neil(or anyone well informed in mdadm development roadmaps),
> 	
> 	Aaron and myself are engineers at NASA Goddard with strong interest in
> MDADM.  We currently host 6PB(raw) of live JBOD storage leveraging MDADM
> exclusively for RAID functionality.
>
> 	We're very interested in Clustered MDADM to improve data-availability
> in the environment, but note that only RAID1 is currently supported.
> Are there plans in the nearish-term(say over the next year) to expound
> clustered bitmap functionality to RAID5/6, or anything else you can
> divulge on that front?  Thanks in advance for any guidance.

We don't talk about plans that are not backed by code - you can't trust
them.

However I cannot imagine how you could make RAID5 work efficiently in a
cluster.
RAID1 works because we assume that the file system will have its own
locking to ensure that only one node writes to a given block at a given
time.  So while node-A is writing to a block, RAID1 knows that no other
node is writing there so it can update all copies and be sure no race
will result in the copies being inconsistent.

For this to work with RAID5 we would need to assume the filesystem will
ensure only one node is writing to a given stripe at a time, and that is
not realistic.

So to make it work we would need the md layer to lock each stripe during
an update.  I have trouble imagining that running with much speed.  Hard
to know without testing of course.
I know of no-one with plans to do that testing.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWdzj1AAoJEDnsnt1WYoG5mo0QALSIpzZ7/PMvmjY77gwcinBp
QxqQ8mHCkTUQwObwMqX3PycdBfQ/Zpbi2pBzbRyAo/aKzRPH6H0FGmoNpi48kBHm
BrKvpGn667o1tfLNgzg0IiKvPl9YTs9qkXfCD15bUU6T+KzeFowYruamkpRA33R0
H5cd4DGmiVaU0lV1Q2uMWY7niozCevOikhbLaFIMXz+cakVxclCPBU5mot0GmULt
X7Eu20+G+/NxHbXQC6q/ycaZhLlDiQv7OMpym4nDaMNvoTFoF0VCnrJDy4BSUmzh
tDozLpku9CVmtGXBnPwmHUa/gSEkhm9UVgapRK3U6mAiX+SkB9wCeOl5h6TBiegq
xob0HaOkDRt2HrOwWsYNyrn7wtyf8foQ8XCsnoKv8RnbjqIEHPl0mxVMF4n/JSqq
gqOKI94k6SpOohnxHqn46Z7MPT8PHfbODMQKM6JOa1VrwgjCdOppcLqByim3yaEN
qpAkAuSyf5X7jKJU6DdyLliZc5jqpMeZ/bxTM+eAqhmtwgrzZk7PU53VrEc6qQ7y
brEbRbXxFBP6F44vp6owtP15jNHhmoIpoPRmYLYSE76duz1bCCkfmC77ejuTrpnr
j3oiaUDl2g01tXGsSeX+s4Sig41zJMntnteKI71zOsQ/hsSSuES01JZmjJpF/m1k
J/fbz+fiTvyT7CU6VziM
=skgm
-----END PGP SIGNATURE-----
--=-=-=--
