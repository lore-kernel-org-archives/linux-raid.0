From: NeilBrown <neilb@suse.de>
Subject: Re: How does linux hide underlying disks partitions?
Date: Sat, 30 May 2015 07:14:26 +1000
Message-ID: <20150530071426.75a7302e@notabene.brown>
References: <1432926434.4733.1.camel@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/4IdP68j27S87GH75xEz5B/e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1432926434.4733.1.camel@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Oleg Samarin <osamarin68@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/4IdP68j27S87GH75xEz5B/e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 29 May 2015 22:07:14 +0300 Oleg Samarin <osamarin68@gmail.com> wrot=
e:

> I'm trying to evaluate a complex mdadm-lvm-udev-anaconda issue
> https://bugzilla.redhat.com/show_bug.cgi?id=3D1226305 and to undestand
> how mdadm works.
>=20
> I have an intel imsm raid-1 volume /dev/md126 assembled with two
> disks /dev/sda and /dev/sdb.
> This volume has two partitions /dev/md126p1 and /dev/md126p2.
>=20
> Because it a simple mirror, both disks have te same information.
>=20
> When the normal system boots up, I can see with journalctl that
>=20
> 1. at first /dev/sda1, /dev/sda2, /dev/sdb1, /dev/sdb2 appear
> 2. then mdadm assembles /dev/md126 from /dev/sda and /dev/sdb
> 3. /dev/sda1, /dev/sda2, /dev/sdb1, /dev/sdb2 disappear
> 4. /dev/md126p1 and /dev/md126p2 coming instead
>=20
> Which program component is responsible for
> disappearing /dev/sda1, /dev/sda2, /dev/sdb1 and /dev/sdb2?

mdadm has a function "remove_partitions" which uses the BLKPG ioctl to tell
the kernel to forget about the partitions.

>=20
> Why can they be left after starting anaconda installer?

I don't know anything about anaconda - maybe someone else can help.

NeilBrown


>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/4IdP68j27S87GH75xEz5B/e
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVWjWsznsnt1WYoG5AQJyjg/+O/BGyKtHItd0NCrdJdCWT8WZO9eS18MB
Qbbo7p5VoyvOuyYIH1h7L/qfUXnvqDchordo1++TbFJjR7R1uJWcFpFdjn1E92vb
IlbC6thF5BxVQEitkL8QqzLHu5NIhKW1MhJfq5ERqn9axRaf33sLE2oKJO1eHW3K
WLYLQ6/SSE9xRQSIm2KYX2yB+K73srJjTQBtCH8dkCB7/tOETqDtJt8/So8qenv2
jz1n6UzpSGh6uE8mi42bL+2j1RXRWITG3RXcenIoR2V//RKMwHb4zodFlPwkD8Zu
7AoG7/SOsr9YorzwO/OrlXzZ0FXkU/3Cr+mHBu0PV77QI4pUb0CCh7qa8wnDXIfy
f5ADlWZA6TgvLOXHUS/+zZQPtFu9HKRh1zRSwShIe3JPgQChVT0a0lcD6IbV7/s1
5446XLkBhZKcWunDU/6LN0BIbnWd0OX0o4EjNj51jWNZIxi62MbtoB3YnSF5EfB/
mhhZ30nAU/56I4lNqMNSblxmOF04x3+ObWVAtxhZocbusV8pl7AFW3IRN1RVADze
mtwpz3uMGSsZAK8XNOjW2QcaxYxy1Aw5DNSIMYYap71t002eeBMTDb8uqwCe5J9l
s7C1UE5uJdYgQ27/CWVhfNKRz/iLbC9S3oGBlPeZVKi8R5hFKGtOow8MsFWGceb7
0yocX9sqEaM=
=5aLl
-----END PGP SIGNATURE-----

--Sig_/4IdP68j27S87GH75xEz5B/e--
