From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/1] Make failure message on re-add more explcit
Date: Mon, 27 Feb 2012 11:01:14 +1100
Message-ID: <20120227110114.478c0485@notabene.brown>
References: <1329930000-20679-1-git-send-email-Jes.Sorensen@redhat.com>
	<20120223090412.2b14fb7f@notabene.brown>
	<4F457758.8060807@redhat.com>
	<4F459D05.5060104@anonymous.org.uk>
	<4F45FA1A.2020706@redhat.com>
	<1329986847.32304.140661040222909@webmail.messagingengine.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Dp+5wuWFS6+9DAw87=//xCQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1329986847.32304.140661040222909@webmail.messagingengine.com>
Sender: linux-raid-owner@vger.kernel.org
To: "J. Ali Harlow" <ali@juiblex.co.uk>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, John Robinson <john.robinson@anonymous.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Dp+5wuWFS6+9DAw87=//xCQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2012 08:47:27 +0000 "J. Ali Harlow" <ali@juiblex.co.uk> wrot=
e:

> On Thu, Feb 23, 2012, at 09:34 AM, Jes Sorensen wrote:
> > On 02/23/12 02:57, John Robinson wrote:
> > > On 22/02/2012 23:16, Jes Sorensen wrote:
> > > [...]
> > >> The goal was to try and reduce the number of bug reports over this by
> > >> making it more obvious/explicit, so if you have a suggestion for how=
 to
> > >> do so in a better way, I am all game.
> > >=20
> > > How about:
> > >=20
> > > mdadm /dev/md0 --add %s
> > > : %s was already a member of /dev/md0, attempting re-add
> > > : Re-add failed because <reason>
> > > : Not performing add as that would zero the superblock on %s and make=
 it
> > > a spare
> > > : mdadm --add used to do that automatically but it was potentially
> > > dangerous
> > > : If that is what you really want to do, use mdadm --zero-superblock =
%s
> > > first.
> > >=20
> >=20
> > This would get my vote, way better than my messy attempt.
>=20
> Would
> : If %s doesn't hold any useful data, use "mdadm --zero-superblock %s"
> before adding.
> be a further refinement?

Maybe .. though "useful" seems a bit of a .... soft(?) word.  What exactly
does it mean in this context?
I would probably prefer something like "If you are happy to discard the data
on .....".

And in the earlier suggestion with have "<reason>" which would certainly be
good to have, but filling in the details is not straight forward
unfortunately.

I'm happy to take patches .... they don't have to be perfect, just an
improvement on what we currently have is enough.

NeilBrown


--Sig_/Dp+5wuWFS6+9DAw87=//xCQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT0rHyjnsnt1WYoG5AQJpiA//eufFrEtgtWVRGeX69DfnasZ8Vv2jhxkd
4b1PG/t3qa6+wGz02BZje2sK6TWzbryk5HW8qlc8TDkSiqcIH17SQd5UugyIncwE
u6ULBVt/opteqG9UwVe9iWhop+UeG4kPZxk2KfYESvigr52bxaMT2jXTipYX6Vfh
ffcppQgvpiv6of8ivXJMBrSqgLX9/+9JEKpl/DqM09sNTldfQvooeYHpdvEyTII5
KaufOFR/yAQRcW6hXo5gZBAVUVNmnGgV/8o9+pVJOKk4/VjBacd2/LNN42zhlR2H
jz6Rzk40xBIDQiQStlRdbDCtGn+ecQ85lXPgI+pan6Ar2W1DL+BCDlEMeyP4Bbxg
6DuLXUBVC7sOga5wnpHCt2NOtRIO7ecSmuQhVLX/RRD251XkYzrpD1Ox3D1bCJzH
N7p1jlGci8mReKYWArNgb4ItUvyHSwD+tN6Reop6UQaodNtpi8gzFtWsxreNkUrW
2gqQu/SNQC3ycHt7Ojtu49j2PvCjoMRY5oqxNYarpjdPJOw84biz7UYpZSRWQ/hK
2LBxpJJbXvfj8kru4x07zK3GhXIdZLxVb+N5MsWCMK2Ikj3xAVN9mpnUP35RZhUj
6i2oGuEoDM3VfoTdTDIxkSapu7wt3JHm9mCIowEE2oCRW8hmqebCJAZEM+95n0ZK
IqyJQWNk2XA=
=mPCw
-----END PGP SIGNATURE-----

--Sig_/Dp+5wuWFS6+9DAw87=//xCQ--
