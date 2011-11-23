From: NeilBrown <neilb@suse.de>
Subject: Re: md metadata nightmare
Date: Wed, 23 Nov 2011 11:47:43 +1100
Message-ID: <20111123114743.1085889e@notabene.brown>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/lFOpKUR.IHbHgbS6aauUZ_h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kenneth Emerson <kenneth.emerson@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/lFOpKUR.IHbHgbS6aauUZ_h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Nov 2011 18:05:21 -0600 Kenneth Emerson
<kenneth.emerson@gmail.com> wrote:

> NOTE: I have set the linux-raid flag on all of the partitions in the
> GPT. I think I have read in the linux-raid archives that this is not
> recommended. Could this have had an affect on what transpired?

Net recommended, but also totally ineffective.  The Linux-RAID partition ty=
pe
is only recognised in MS-DOS partition tables.

>=20
> So my question is:
>=20
> Is there a way, short of backing up the data, completely rebuilding
> the arrays, and restoring the data (a real PIA) to rewrite the
> metadata given the existing array configurations in the running
> system?  Also, is there an explanation as to why the metadata seems so
> screwed up that the arrays cannot be assembled automatically by the
> kernel?

There appear to be two problems here.  Both could be resolved by converting=
 to
v1.0 metadata.  But there are other approaches.  And converting to v1.0 is
not trivial (not enough developers to work on all the tasks!).

One problem is the final partition on at least some of your disks is at a 6=
4K
alignment.  This means that the superblock looks valid for both the whole
device and for the partition.
You can confirm this by running
  mdadm --examine /dev/sda
  mdadm --examine /dev/sda4

(ditto for b,c,d,e,...)

The "sdX4" should show a superblock.  The 'sdX' should not.
I think it will show exactly the same superblock.  It could show a different
superblock... that would be interesting.

If I am correct here then you can "fix" this by changing mdadm.conf to read:

DEVICES /dev/sda? /dev/sdb? /dev/sdc? /dev/sdd? /dev/sde?
or=20
DEVICES /dev/sd[abcde][1-4]

or similar.  i.e. tell it to ignore the whole devices.

The other problem is that v0.90 metadata isn't good with very large devices.
It has 32bits to record kilobytes per device.
This show allow 4TB per device but due to a bug (relating to sign bits) it
only works well with 2TB per device.  This bug was introduced in 2.6.29 and
removed in 3.1.

So if you can run a 3.1.2 kernel, that would be best.

You could convert to v1.0 if you want.  You only need to do this for the la=
st
partition (sdX4).

Assuming nothing has changed since the "--detail" output you provided, you
should:

 mdadm -S /dev/md3
 mdadm -C /dev/md3 --metadata=3D1.0 --chunk=3D64k --level=3D6 --raid-device=
s=3D5 \
      missing /dev/sdb4 /dev/sdc4 /dev/sda4 /dev/sdd4 \
      --assume-clean

The order of the disks is import.  You should compare it with the output
of "mdadm --detail" before you start to ensure that it is correct and I have
made any typos.  You should of course check the rest as well.
After doing this (and possibly before) you should 'fsck' to ensure the
transition was successful.  If anything goes wrong, ask before risking
further breakage.

Good luck.

NeilBrown


--Sig_/lFOpKUR.IHbHgbS6aauUZ_h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTsxCujnsnt1WYoG5AQJvQBAAthynDR5z3i4hl8W06nPDtUxOLTF/Ks84
nNBqvnOhBP1EQVps7+QZ3U1+M2jcFH0QumozcWcHBOMJv/xhu5Ndydd1CfMWlPWq
7J0V4kWf2+WxxL9DXkncAjqgxWZ6w5hgHzKJWrYws+LHPpVaa3yTJEVrjVmh5i3q
U1HwUBdrXhVdeN4Br724X+SEX26WEL/HQ4GFnz985aFqDMA5j9lLW8kDqnpjlpkX
nNLGKTkICEEjp/CxQmJUxSEICYx/AFAAK0oRBAcfkEBhMX6/8W2ZFAeJbdhJq5P6
O1JiLmY+bivSMshBU2qJMfJEQoThujRvc0gHGg2ULc/pdtwAsZHpnwEjNsTyeNiC
3Z5/vS9eK3WLyXRrY22/iPEB2RGSEkvh0jw4roaJDpq6Yv5jLolh3NBtPuVWyQPw
JDYA02vEGE42uE8vYavPvgwVqYZlRj6B3/wDN2zHJoCrLRRvH/+931iQsdbx+T5D
iEW5RDsSvyzSKO5LnwsryyAffEFyYo8MlRgq06Ab2Qr9T42DlGE96PBv1aSgiCs0
7Hi+Bfa0wskedxWoMQJZdA6ashIonSfYOvd9cf+85xqhrB9EFpLg0YlvmP6AEzPr
XGkDh2S86dClUiz3WSB0qOHNn6UXxNQuGXO1vZPYanHiJX8BYzAPl1/C9CuE8JMo
FiE9/k7ENAQ=
=Rv+r
-----END PGP SIGNATURE-----

--Sig_/lFOpKUR.IHbHgbS6aauUZ_h--
