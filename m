From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/2] raid5-cache: update superblock at shutdown/reboot
Date: Fri, 18 Nov 2016 14:49:18 +1100
Message-ID: <87mvgxfnwh.fsf@notabene.neil.brown.name>
References: <5d6f023fb1d1398317d07f02634f90b055e26f4b.1479345454.git.shli@fb.com> <87wpg2heg8.fsf@notabene.neil.brown.name> <20161117181353.z7mgiynosyb664oc@kernel.org> <8760nlhd18.fsf@notabene.neil.brown.name> <20161118014151.d6f3garrxovzrz66@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161118014151.d6f3garrxovzrz66@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Shaohua Li <shli@fb.com>, linux-raid@vger.kernel.org, songliubraving@fb.com, Zhengyuan Liu <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18 2016, Shaohua Li wrote:

> On Fri, Nov 18, 2016 at 11:01:07AM +1100, Neil Brown wrote:
>> On Fri, Nov 18 2016, Shaohua Li wrote:
>>=20
>> > On Thu, Nov 17, 2016 at 04:18:15PM +1100, Neil Brown wrote:
>> >> On Thu, Nov 17 2016, Shaohua Li wrote:
>> >>=20
>> >> > Currently raid5-cache update superblock in .quiesce. But since at
>> >> > shutdown/reboot, .quiesce is called with reconfig mutex locked,
>> >> > superblock isn't guaranteed to be called in reclaim thread (see
>> >> > 8e018c21da3). This will make assemble do unnecessary journal recove=
ry.
>> >> > It doesn't corrupt data but is annoying.  This adds an extra hook to
>> >> > guarantee journal is flushed to raid disks.  And since this hook is
>> >> > called before superblock update, this will guarantee we have a upto=
date
>> >> > superblock in shutdown/reboot
>> >>=20
>> >> Hi.
>> >> I don't quite follow some of the reasoning here.
>> >> In particular, the ->stop_writes() that you have implemented
>> >> does almost exactly the same thing as r5l_quiesce(1).
>> >> So why not simply call ->quiesce(mddev, 1) in __md_stop_writes()??
>> >> You probably need to also call ->quiesce(mddev, 0) to keep things
>> >> balanced.
>> >
>> > reboot (md_notify_reboot) doesn't call .quiesce, maybe we should do th=
ough. And
>> > in stop, we hold reconfig_mutex before calling .quiesce. And with comm=
it
>> > 8e018c21da3, r5l_write_super_and_discard_space tries to hold the recon=
fig_mutex
>> > before write super, which it can't hold, so superblock write is skippe=
d. After
>> > .quiesce we don't write superblock. To fix the shutdown case, we can a=
dd a
>> > superblock write after .quiesce. But I think it's more generic to add a
>> > ->stop_writes since it will work for the reboot case.
>>=20
>> I hadn't quite processed that this was about md_notify_reboot().
>> I would be very wary of optimizing this code.  It should certainly avoid
>> data loss, but anything more doesn't belong here.
>> During a clean shutdown the array should be stopped properly.
>> md_notify_reboot() is only meant for minimizing damaged caused by a
>> hasty "reboot -f -n".
>
> yep, this isn't the priority. So do you still suggest we ignore the reboo=
t case
> and add the journal flush after .quiesce() is called in stop?

Not sure... is there a problem we are trying to solve?

mddev_detach() calls ->quiesce() so things get cleaned up when the array
is stopped. md_set_readonly() only calls __md_stop_writes() though.
I would probably support adding a ->quiesce() call to __md_stop_writes,
except that r5l_quiesce() registers a new reclaim_thread() so when
__md_stop_writes() is followed by mddev_detach(), the thread would be
killed, then recreated, then killed, then recreated, then finally killed
in r5l_exit_log().
It would be nice if we could either
 1/ not kill the thread, just freeze it, or
 2/ have it start up some other way.
    e.g. get raid5d() to start the thread if it isn't running and
    conf->quiesce is 0, and array isn't clean.
=20=20=20=20

>
>> A "clean" shutdown currently includes systemd/mdadm.shutdown (in the
>> mdadm package) running "mdadm --wait-clean --scan".
>> "mdadm --wait-clean" changes the "safe_mode_delay" so that the array
>> will become "clean" more quickly.
>> Possibly we should add something to that to trigger a flush of the
>> journal, and to wait for the flush to complete.
>
> I'm not sure how we can do this. But adding a different state in 'array_s=
tate'
> indicating journal isn't clean makes sense.

Possible, though as mdmon uses array_state, we would need to be careful.
Of course mdmon never looks at an array with a journal, so that wouldn't
actually be a problem.

Ignoring the new caching code for the moment, whenever the array is
"clean", the journal is irrelevant.  Possibly we could arrange that if
the array is found to be "clean" on startup, the journal is ignored?
For that to work with the caching code, we would need to hold off
marking the array as 'clean' until the journal is flushed.  I think that
is probably a good idea.
When safe_mode_delay is set to 0 (or 1) we should probably set the cache
flush time down from 30 seconds to (nearly) zero too.  That way, the
current WaitClean() code would continue to work.

NeilBrown

>
> Thanks,
> Shaohua

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLno+AAoJEDnsnt1WYoG5sLwP/1TzIdDdFw63YvX5DOnD/D7H
7orXBXcoCA38n6cbD5YE02fDGKYJKUrtOtr4T8jmM5MC0+fncpVetylU69Z75jty
xetjwrc01gFEME7E5ptJfapxNbRVUmVnkWivfJ5V2x/L7qksdAtwK8FYjdzF3JTv
hjW6+q4F+xgw5qOJs64CbKscw0dnrFWFscrG/cX6CJdeO1lPhiUKpm8pCU9FJEDn
mh/qLY00VZ6fGrjF4sQ9SQ6NNarfylbCABHSLcDVzC4ICiVw3kdZ/1VxniDMuX/q
yVCT2cbWVBjw7mSWzQjztw1vW3znsGiMj/g7IkbkANnT7Z/mcVl8PdyaMH3HefRo
LNQA1s7NLg9Gk5skg5nWoWv2rpovi0+pT2xhziEWMM47MaYgNShyQ9vRetMViuBP
cEy432NwNaY0b30StKv8EVHgGK5cHSeerqw05BbZpheEmuYpdcDtKTUjx8RI9jvf
ufRuoKBsSLYsckLbrlWp6mGW++h3yTCkPrOl+tt/p7d14YZS+KRJnj9tLEGQM1p0
93iWTWzg3m2omh5o33Yl6LI7pekpCcon2lIveSQSkECFZe7x47n30EA3OfamobC8
e0JS+9ylHa4p7+xLPMc0++t2+z54j04vyJ8RgJbG77W91nFcrjaAJpAuY133fpSK
JQFCL9NWjv3Z7iTeooHz
=xYAT
-----END PGP SIGNATURE-----
--=-=-=--
