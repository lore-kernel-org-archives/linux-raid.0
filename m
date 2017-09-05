From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: allow changing set_name of running array
Date: Tue, 05 Sep 2017 11:00:40 +1000
Message-ID: <87pob6c62v.fsf@notabene.neil.brown.name>
References: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl> <87tw0ne0xq.fsf@notabene.neil.brown.name> <20170901164110.y3op7umpgh4jvkr5@qmqm.qmqm.pl> <874lsjdwye.fsf@notabene.neil.brown.name> <20170904193639.iagu5d5iu3tdhce2@qmqm.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170904193639.iagu5d5iu3tdhce2@qmqm.qmqm.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04 2017, Micha=C5=82 Miros=C5=82aw wrote:

> On Mon, Sep 04, 2017 at 12:22:33PM +1000, NeilBrown wrote:
>> On Fri, Sep 01 2017, Micha=C5=82 Miros=C5=82aw wrote:
>>=20
>> > On Fri, Sep 01, 2017 at 10:07:29AM +1000, NeilBrown wrote:
>> >> On Wed, Aug 30 2017, Micha=C5=82 Miros=C5=82aw wrote:
>> >> > Allow changing active array's set_name. This is the only way to
>> >> > safely update superblock on an array which carries a mounted fs.
>> >>=20
>> >> Do you really need to change the set_name of an active array?
>> >>=20
>> >> The name is only used when the array is actived, so wait until the ne=
xt
>> >> time the array is stopped, and change the name then.
>> >>=20
>> >> You can boot with a rescue CD or similar and use "--assemble
>> >> --update=3Dname", or with a bit of effort you could get the normal bo=
ot
>> >> sequence to change the name.
>> >>=20
>> >> I wouldn't object to adding something to mdadm so that it would read
>> >> something from mdadm.conf, and update the set name at boot time.
>> >>=20
>> >> What is the underlying problem that you are trying to solve here?
>> >
>> > I had to fix /dev/md* naming on a system with no physical access.
>> >
>> > The problem was that despite matching mdadm.conf entries, arrays start=
ed
>> > with random 127-i indexes (because superblocks' set_names didn't match
>> > hostname, I guess).
>>=20
>> That's odd.  If an array is listed in mdadm.conf, that is enough to tell
>> mdadm that it is "local" so that it doesn't need the hostname to match.
>> Can you show me exactly what was in your mdadm.conf?
>
> This is what was I had when it would reassign arrays on boot. System
> hostname is 'rere' - it was renamed some time after creating arrays.
>
> ---8<---
> HOMEHOST <system>
> MAILADDR root
> ARRAY /dev/md/0  metadata=3D1.2 UUID=3Dd5ea39a9:5ec27c36:c83296d4:70f879d=
4 name=3Drere2:0
> ARRAY /dev/md/1  metadata=3D1.2 UUID=3D9bf69b92:2e7ba905:5f959c09:c8fecb9=
9 name=3Drere2:1
> ---8<---
>
> I don't have old versions of mdadm.conf, so had to recreate this one.
> IIRC I verified UUIDs back then, but don't remember whether I modified
> names or not. Thinking of it, how would mdadm behave if it had matching
> UUIDs and mismatching array names in mdadm.conf?

That's what I was wondering and part of why I asked to see the
mdadm.conf.

If a name is given in mdadm.conf and it doesn't match the name in the
metadata, that line will be ignored.  If mdadm doesn't find a match in
mdadm.conf and the hostname doesn't match, the the array will be treated
as "foreign" and will be assembled as e.g. /dev/md127 with a symlink
from /dev/md/0_1.
If the name and uuid in mdadm.conf do match the metadata, it will be
treat as "local" and will be given the name that you would expect
(/dev/md0, /dev/md/0).

So my guess is that the mdadm.conf you had at the time doesn't match
what you have provided above.

It would be nice to add an option to "mdadm --incremental" to tell it to
update various details like you can with "mdadm --assemble"....

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmt9zwACgkQOeye3VZi
gblzqA/+MPo9yVO3mNR94PBtKjrm8st85AxnbzEnEKzX769FufHphkIX0eTeHWH/
2EowzSn49QLXmRqIUxImWtbw+Da9aHfPZ2G6wV8QytzykMMON5KVqKEFk8jcWpQ5
nWinmlUx7VP9n7jsRlMxKcgvKrzeyWlJLb27oRCfrzP1ObunlLZTpS4CPcemu8g/
bgTVjQ/QNj5ji/+oiNcihMhxCKsMSN4HkJy9LUMNCRtUgQZqm998liI8zIAYGu2k
0RQNDo9RgLYDcMMcGU//2webBPRtMxhqvB4urJCaXzLBscseqBfeuduTCQOIQeTY
PAgeFftScIC/v7WJ2pK+g9anI2DdSo046ijqagtEArLc/gpgEpyW6W5xWj2aStu7
tGHzx1VqiUwOagnnDUdE+xCM5kgbqSxmVQa121rBsTceWJSdr82pIM0ae0Bfsfdx
zZC9w5isZY2YrANgJ1YWTzvXpGiQ1vTU/XNrM3XJVBruQN4AZRtMFImf2wpDL/bf
qXpaH2Ju5V7IPgfhM8wWxw8WwbMRhLVnghZLphx+OpeMYVAgPoNKT8BwEij/B4RO
pVBXkR9yFKGzQWLjb9yFpw0aQrr9vP7G6qyd/D2uRvGaERLiCG1bpJa4uRkUn0dA
rw4lhvxMdTI9jnfxNjMkhTBaP7XqWK8+vydkZqtCPcOVyzCaFu0=
=OcEm
-----END PGP SIGNATURE-----
--=-=-=--
