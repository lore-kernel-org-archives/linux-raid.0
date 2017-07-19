From: NeilBrown <neilb@suse.com>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Thu, 20 Jul 2017 09:14:28 +1000
Message-ID: <87fudsxbmz.fsf@notabene.neil.brown.name>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com> <87tw2f2425.fsf@notabene.neil.brown.name> <0341a04d-9aa5-7665-d9ff-527fe9fc8238@gmail.com> <87pod0ypmh.fsf@notabene.neil.brown.name> <8d3e1264-2f0a-6ee9-52b5-edddc1e6f185@gmail.com> <ad3c5c59-dc37-2573-341a-39a381621746@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ad3c5c59-dc37-2573-341a-39a381621746@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 19 2017, Ram Ramesh wrote:

> Here is my attempt to repeat the steps in my last attempt to remove,=20
> repartition, re-add. Last time I did it on /dev/sdb. Now I am going to=20
> do it on /dev/sdc. Note that I have not been successful as you see at=20
> the end. I am going to keep the array degraded so that I can still get=20
> old info from /dev/sdc1, if you need anything else. I will keep it this=20
> way till tomorrow and then add the device for md to rebuild. Please ask=20
> anything else before that or send me a note to keep the array degraded=20
> so that you can examine /dev/sdc1 more.

Thanks.  I *love* getting all the details.  You cannot send too many
details!

This:
> <good device still in md0>
>> zym [rramesh] 265 > sudo  mdadm --examine /dev/sdb1
>> /dev/sdb1:
..
>>  Avail Dev Size : 6442188800 (3071.88 GiB 3298.40 GB)

and this:

> <device just removed and repartitioned>
>> zym [rramesh] 267 > sudo mdadm --examine /dev/sdc1
>> /dev/sdc1:
...
>>  Avail Dev Size : 11720780943 (5588.90 GiB 6001.04 GB)

Shows the key difference.  "Avail Dev Size", aka sb->data_size, is
wrong.  We can fix it.

>
> <Cannot re-add!!!!>
>> zym [rramesh] 270 > sudo mdadm /dev/md0 --re-add /dev/sdc1
>> mdadm: --re-add for /dev/sdc1 to /dev/md0 is not possible

Please try
   sudo mdadm /dev/md0 --re-add /dev/sdc1 --update=3Ddevicesize

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllv59YACgkQOeye3VZi
gbk1Tw//QFg4sOa+Txrm0urxgqwEAnPcnHUMyGo3ODY6nwNtK1mqfqGPzZs5KKfJ
CPlV8TR1L4I4krRXdhKBJ4WZ3X/iYwwX7d/zVi9cjVXVF6QkPuTqXxOGHqWl43rS
gsHlJUXpO31UZtWFu6siRZipHaH/koGALcg34201p7m4GLoiUn0ggchQ9JsGYAL6
gEBp+ATaxtUG2pfECEmZ+r+8pmJnMFJM7udDydJTuOGXRagPstUGfbo0uGRXefB7
vgTZeTNidqpNBNa0fm2Csv++zhKkrJNCLQBhfH4nYr0YU5DVL/18Tud33M4cy2lz
Yt3YyJVtKUBCV6eam+aBXgiLvvMav/XVveH8oKeuXtmXLIQxi75OhaW1vv9G7bKd
vagZ6MygRJQ1jAF5qTHaCJ7u7mg8Gxk20d/TKp+6pF5j8AtISj+xgN1JSh4dDjkM
ykLN0WR2et531kFT++JBnltGEHBJClp7gTcz48aYvH6BmtFbsK6PZVtGz/6VEs+g
K6Ow4rAtWa/AXhs8lOO39wAmpl/1mvnotua+0oHsPMmg6ZUGzjFIapGJ4swZFTKO
fMT+gGo4s0etpPAag5F57eikVGYM3uk0ClPMqqcwqMHQKGzo1ufCN3QIQy9Dh7l5
S5CV06oQ8arSibhyxjs0rklGr+IxKN07Na1bP1R69WLkpJIvu5A=
=pNSm
-----END PGP SIGNATURE-----
--=-=-=--
