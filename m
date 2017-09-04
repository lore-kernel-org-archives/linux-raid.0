From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: allow changing set_name of running array
Date: Mon, 04 Sep 2017 12:22:33 +1000
Message-ID: <874lsjdwye.fsf@notabene.neil.brown.name>
References: <429c2b1c84c44b0c09ea7aa8dfa86846885441f7.1504044125.git.mirq-linux@rere.qmqm.pl> <87tw0ne0xq.fsf@notabene.neil.brown.name> <20170901164110.y3op7umpgh4jvkr5@qmqm.qmqm.pl>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170901164110.y3op7umpgh4jvkr5@qmqm.qmqm.pl>
Sender: linux-raid-owner@vger.kernel.org
To: =?utf-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>
Cc: Shaohua Li <shli@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 01 2017, Micha=C5=82 Miros=C5=82aw wrote:

> On Fri, Sep 01, 2017 at 10:07:29AM +1000, NeilBrown wrote:
>> On Wed, Aug 30 2017, Micha=C5=82 Miros=C5=82aw wrote:
>> > Allow changing active array's set_name. This is the only way to
>> > safely update superblock on an array which carries a mounted fs.
>>=20
>> Do you really need to change the set_name of an active array?
>>=20
>> The name is only used when the array is actived, so wait until the next
>> time the array is stopped, and change the name then.
>>=20
>> You can boot with a rescue CD or similar and use "--assemble
>> --update=3Dname", or with a bit of effort you could get the normal boot
>> sequence to change the name.
>>=20
>> I wouldn't object to adding something to mdadm so that it would read
>> something from mdadm.conf, and update the set name at boot time.
>>=20
>> What is the underlying problem that you are trying to solve here?
>
> I had to fix /dev/md* naming on a system with no physical access.
>
> The problem was that despite matching mdadm.conf entries, arrays started
> with random 127-i indexes (because superblocks' set_names didn't match
> hostname, I guess).

That's odd.  If an array is listed in mdadm.conf, that is enough to tell
mdadm that it is "local" so that it doesn't need the hostname to match.
Can you show me exactly what was in your mdadm.conf?

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlmsuO0ACgkQOeye3VZi
gbl1FxAAoWgHsLpmpsUpTgAhu5GVAz1fuWatCymDT2KTlOf94Rs7mzKsojPybcqY
zvOVNMeSnjgJ8ms3zRZ7T87YiXXZHyD0G1FP3JBlYNllHSMFioIYTnmfmKgh+9eJ
6955fbijs3gYfodN9E3nOsKyl2jqKED3f+LfX0Ldd/EmSXdVa3ZbZfUW2QiQYJpE
gxpO3+eAOWixrqpWOf5npz9hTOSDlrRPPcLj/lkdeXN8Fp5LQUQgB2vy2tVIYYrI
am356DAJ+ri1YOwcFNtizFcHVxIQj49JTLuZ206H0NXx14GioIBYBR8gyKVsdScx
K+clU50rqjBs3e3L4gZvvSdaQoib4p7g9+4Bml3rMNvYuZ0LQEv2oZhTBoVcyxkr
jxawlq4cc5nh3UzMqKfV34agx2w5OdDnOa0PTCw7QlSOtr3P/4/ZWmQduOJkVl1B
grkI6Igk9XG3h3QitQGEtnBt58AOX9yhtmQTBrwG0mDGJMmp+WQ7eUI1Ektt2Ani
uwsI94JD/JWbQN2jMAN/TW8grwioGFgd/pBTr9YLhsgTTnZle/56yhDdL6E880t+
0Gnxz9aWC/hipxSlW90VjjgxSG8CgW/hLwRCjQnCQGiXi5+oSqt3sIIPKZaPDwKX
eXU4ulddnHRJLqinFrZs6wFyEFz1BW6RTXBZLb7wtvjVEkCvY74=
=TaHB
-----END PGP SIGNATURE-----
--=-=-=--
