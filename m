From: NeilBrown <neilb@suse.de>
Subject: Re: RAIS5 Rebuild Help - Possible Data Offset
Date: Mon, 31 Mar 2014 18:12:27 +1100
Message-ID: <20140331181227.69c4e583@notabene.brown>
References: <CAFth78x1SkCEUmETFt+F+79UpjUbhanNLUbZoWa7Hxi3EzsdMw@mail.gmail.com>
	<20140131102551.GA2425@cthulhu.home.robinhill.me.uk>
	<CAFth78xfsaBLzg9TC=UkEoQiafpg-oVJyoxbYgWyrVHCyAuHew@mail.gmail.com>
	<20140331172953.3f37f6c2@notabene.brown>
	<CAFth78wtf5X0ycUuKCTV3QSvs4Uv8mvvZYH2Vqhwc2WwOqkHfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7FkQkigidE9w_6P32..1+03"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFth78wtf5X0ycUuKCTV3QSvs4Uv8mvvZYH2Vqhwc2WwOqkHfg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yorik <yoriks13@westnet.com.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7FkQkigidE9w_6P32..1+03
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 31 Mar 2014 14:54:31 +0800 Yorik <yoriks13@westnet.com.au> wrote:

> Hi Neil
>=20
> Thanks very much for the help and advice.. Output as follows.
>=20
> [root@desktop mdadm]# ./mdadm --assemble --force --verbose /dev/md0
> /dev/sd[abc]1 /dev/sd[defgi]
> mdadm: looking for devices for /dev/md0
> mdadm: superblock on /dev/sdf doesn't match others - assembly aborted
>=20
>=20
> Maybe there has been some differences in Data Offset and superblock
> sizes with different versions of mdadm. I am not really sure what to
> do now, I just got back from a long project overseas and was about to
> start looking deeper into my options.
>=20
> Appreciate any further help or advice that you have.


Could you post the full output of=20
  mdadm --examine /dev/[abc]1 /dev/sd[defgi]

Some is clearly different at least with sdf.

NeilBrown

>=20
> Regards
> Derek
>=20
> On 31 March 2014 14:29, NeilBrown <neilb@suse.de> wrote:
> > On Sat, 1 Feb 2014 15:56:14 +0800 Yorik <yoriks13@westnet.com.au> wrote:
> >
> >> Thank you for your help. Sorry for my omission, I thought I had put
> >> that in. It was one of the first things that I tried and have numerous
> >> times since.
> >>
> >> #mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
> >> mdadm: /dev/md0 assembled from 5 drives - not enough to start the arra=
y.
> >>
> >> Then if I try the command again, I get the following
> >>
> >> # mdadm -Af /dev/md0 /dev/sd[abc]1 /dev/sd[defgi]
> >> mdadm: /dev/sda1 is busy - skipping
> >> mdadm: /dev/sdb1 is busy - skipping
> >> mdadm: /dev/sdc1 is busy - skipping
> >> mdadm: /dev/sdd is busy - skipping
> >> mdadm: /dev/sde is busy - skipping
> >> mdadm: /dev/sdf is busy - skipping
> >> mdadm: /dev/sdg is busy - skipping
> >> mdadm: /dev/sdi is busy - skipping
> >>
> >> And my /proc/mdstat looks like this, with all drives marked as spare.
> >>
> >> # cat /proc/mdstat
> >> Personalities :
> >> md0 : inactive sda1[0](S) sdf[7](S) sdg[8](S) sde[5](S) sdi[6](S)
> >> sdd[4](S) sdc1[2](S) sdb1[1](S)
> >>       23442114872 blocks super 1.1
> >>
> >> unused devices: <none>
> >
> > If this is still a problem then please:
> > 1/ get the latest mdadm:
> >      cd /tmp
> >      git clone git://neil.brown.name/mdadm
> >      cd mdadm
> >      make
> > 2/ stop the array
> >      ./mdadm --stop /dev/md0
> > 3/ force-assemble the array with --verbose:
> >
> >      ./mdadm --assemble --force --verbose /dev/md0 /dev/sd[abc]1 /dev/s=
d[defgi]
> >
> > and report all the output of the last command.
> >
> > NeilBrown
> >


--Sig_/7FkQkigidE9w_6P32..1+03
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUzkVWznsnt1WYoG5AQL0Fw/+IfrS9ptyF6OnHvA4IQ0ycyIpIZVaLZcM
riTFbo9kxKDoWswUygCQ9lZmA2Q7qq+3Cfblzwt+6ZQTtkoXJu/JCST8+xzeO9sY
reDB3xIM82m0MjercXnjW0xwA/tAikZN/U+xWwm6/zmZ7nGU7lLLrImfGvvub7zh
RSBCnMecppXdxtq85j9lZDo1vWM8hKWHfMxAKtBVwqfiyNL2etRHlIfWADj1gWBF
quHT/4KSKfSoKhkVZnPFKAn20NtIR3Wpjw/o22DbXTOMfICUPx+g/UMhWfLHDEQ6
jPklCFXx1zD78TLjlmqaTgDoHo5d+dCWDSS6hDksdKNnYZxoZrie31nzCxPlYcYf
/bbjwj66BNeExgFEFKejO0LKy4ZyBSeXqjPlwHdMyQzGnElQTMM/jdU45NuG6rTE
NaV7aOKs2/zo1Nww/V0Gq/tN39WP0AK+q5N4hY2HIQThFTJnJ4R53xYVmKwYwpQS
bCL9M1PrViC4Elv21Qsn4ZVKm1dQ3oTKdGVPHymNq7zhxvB89MiY9lrTBvNFuMXH
kZHAkwda1PYtLiAgB8E14RbxsoJyY3a0gkHFWv3/apKsNKYXJ6GxJL8Md9v/Y9B+
eV/wuA6iOEoqzjGTeIF2p/QI24pNfAYLYXb/9QifOIG4ogCKMpYMdWzFWBkSVDsd
I4y9HCc+9+g=
=Mi5X
-----END PGP SIGNATURE-----

--Sig_/7FkQkigidE9w_6P32..1+03--
