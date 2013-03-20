From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] MD: Quickly return errors if too many devices have
 failed.
Date: Wed, 20 Mar 2013 13:46:11 +1100
Message-ID: <20130320134611.4c9b0e75@notabene.brown>
References: <1363195764.24906.14.camel@f16>
	<20130318104905.4a70bc00@notabene.brown>
	<1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XcA45BNWR+AyqXnyfa8kEsz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1C64DEE2-FCED-4B9A-A134-E03EA898A8B7@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brassow Jonathan <jbrassow@redhat.com>
Cc: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/XcA45BNWR+AyqXnyfa8kEsz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Mar 2013 16:15:35 -0500 Brassow Jonathan <jbrassow@redhat.com>
wrote:

>=20
> On Mar 17, 2013, at 6:49 PM, NeilBrown wrote:
>=20
> > On Wed, 13 Mar 2013 12:29:24 -0500 Jonathan Brassow <jbrassow@redhat.co=
m>
> > wrote:
> >=20
> >> Neil,
> >>=20
> >> I've noticed that when too many devices fail in a RAID arrary that
> >> addtional I/O will hang, yielding an endless supply of:
> >> Mar 12 11:52:53 bp-01 kernel: Buffer I/O error on device md1, logical =
block 3
> >> Mar 12 11:52:53 bp-01 kernel: lost page write due to I/O error on md1
> >> Mar 12 11:52:53 bp-01 kernel: sector=3D800 i=3D3           (null)     =
      (null) =20
> >>         (null)           (null) 1
> >=20
> > This is the third report in as many weeks that mentions that WARN_ON.
> > The first two where quite different causes.
> > I think this one is the same as the first one, which means it would be =
fixed
> > by =20
> >      md/raid5: schedule_construction should abort if nothing to do.
> >=20
> > which is commit 29d90fa2adbdd9f in linux-next.
>=20
> Sorry, I don't see this commit in linux-next:
> (the "for-next" branch of) git://github.com/neilbrown/linux.git
> or git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git
>=20
> Where should I be looking?

Sorry, I probably messed up.
I meant this commit:
 http://git.neil.brown.name/?p=3Dmd.git;a=3Dcommitdiff;h=3Dce7d363aaf1e28be=
8406a2976220944ca487e8ca


>=20
> I did grab a patch from an earlier discussion where you mentioned a simil=
ar commit ID.  It didn't solve the problem, but it did prevent an endless p=
rogression of the same error messages.  I only saw one instance of the abov=
e after the patch.
>=20
> I'm fairly certain that the hang was affecting more than just RAID5 thoug=
h.  It also happened with raid1/10.  I'll go back with 3.9.0-rc3 and make s=
ure that's true until I can figure out which 'linux-next' commit you are ta=
lking about.

If you could get something concrete I'd love to hear about it, thanks.

NeilBrown

--Sig_/XcA45BNWR+AyqXnyfa8kEsz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUUki8znsnt1WYoG5AQJxSA//STSECcT/SfUDgAv8TRh9kMH9JOwmq6is
C/1s02nQ91QT1QcwvPetrPq1rPyFFOzMQrQImZP6Ego5H5rsv/XkpBmZXea/vkVt
iAjfPhrtSt0ejJ18upI5RHAP2ImnqyZ/wnJO96nbWhSisMJ9ErOw1yVUDt7qpnYi
H7OxMrlqTqzHJAJQpPGYvhMT7YqM9o5Jc4ORpVd8G39/Eqod1KsFVp2urcNGT4S5
CL+SwvyR5whOZLCSXiRwOs6tdS6dYaJ9tRT4SGHV2J2KXvOYNzb7epwRmVBeWPjl
MuX3RW6sLwHhY2jVYSfmQPXuxzn7xR0PTU9k6EbIFsQpDiJMeq4rmdc4jkdXYj8i
jGn43fqIRK+k3s0Ry6WH6dsVQyhEqAU+Exv4x0vK0Ue9eyfDDE8vOhCf4bEIC6od
PzHRKRWmQdJFAmeS9Nfd5YCJLj5Ajpr8ioCG2eCPy6M3nPngRIDYU+A556FMtJLF
dFDm2q7DEdFiRHSMcB35uTBLcnPjXJLP8TT8A7dC2VEWMXrOoIRnrGPxjBUO13fW
wY0+IgVw4U3srE1Go1ZtJSYKd8xUM3Hl8+nuI+4rnGdRv4AWuE9xzGLv5xL8N4NB
/jbQcmu8iauWRykGuGH3nnR1jxCBtnYmDtgXL6u+JLSQmtoFI1RXnp+B9lHLcaPQ
SO9BBeVctU0=
=Fz1s
-----END PGP SIGNATURE-----

--Sig_/XcA45BNWR+AyqXnyfa8kEsz--
