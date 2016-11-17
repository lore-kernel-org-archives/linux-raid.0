From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v6 03/11] md/r5cache: State machine for raid5-cache write back mode
Date: Thu, 17 Nov 2016 11:28:26 +1100
Message-ID: <871syb9cgl.fsf@notabene.neil.brown.name>
References: <20161110204623.3484694-1-songliubraving@fb.com> <20161110204623.3484694-4-songliubraving@fb.com> <87bmxgi8hi.fsf@notabene.neil.brown.name> <0F99C371-BD11-4032-945A-4E19A80AD771@fb.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0F99C371-BD11-4032-945A-4E19A80AD771@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Nov 16 2016, Song Liu wrote:

>> This bothers me.  Why would a stripe *ever* be in "caching mode" (or
>> "caching phase") when the array is in write-through?  It doesn't seem to
>> make sense.
>
> I was thinking about replacing STRIPE_R5C_WRITE_OUT with something
> like STRIPE_R5C_CACHING. So that:
>
> caching-phase is STRIPE_R5C_CACHING =3D=3D 1
> write-out phase is STRIPE_R5C_CACHING =3D=3D 0=20
>
> In this case, stripes in write-through mode will always have=20
> STRIPE_R5C_CACHING =3D=3D 0.=20
>
> This requires some changes to current state machine, but it might work ou=
t.=20
>
> How do you like this?=20

I almost suggested that myself :-)
I'm not against it, but now that I think of "write_out" as an action, it
seems to make sense for that to be a flag.
Before we had the journal we didn't need a flag.  We just assessed the
state of the stripe and then either
 - read some blocks, or
 - calculate parity and write some blocks.

Now that we have the journal, write-out is multi-stage and
"write-to-journal" isn't always followed by 'write to RAID'.  So an extra
flag is needed.
So I'm now happy with WRITE_OUT, but I'd probably be happy with CACHING
too.


>
>
>> There are two actions that can be taken when where are ->towrite blocks
>> on a stripe.  We can enter WRITE_OUT, or they can be cached in the
>> journal.  Also we can enter WRITE_OUT when a stripe needs to be removed
>> From memory or from the journal.
>> This makes "writeout" and "cache" seem more like "actions" than states,
>> modes, or phases.  Naming is hard.
>
> Yes, it is more like action. We used to name it as "modes" as different *=
mode*
> handles writes with different *action*. So at end of the day, it doesn't =
really=20
> matter?

The exact choice of word isn't vital but it is important to ensure the
code is maintainable, and that means it must be easy to understand.  The
fact that we have had trouble describing what is happening suggests that
this is an area that needs to be clearly explained.
So where the flag is declared, it would help a lot to document:

 /*  set when ...
  *  cleared when ...
  *  used for ....
  */
because whatever name we use for the flag, it won't by itself be
enough.  We need to also explain what it means.

Thanks,
NeilBrown


>
> Thanks,
> Song

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLPmqAAoJEDnsnt1WYoG5wDQP+waGGewWZX9qRyCEY+QqYu4X
gSzwLPdGhC73BFsLWp7MmbftL2MdqG8orxrpZsfVXwCHfBKcTcbwELHNc+zdbO/s
51B2BMcFp6DGX9VKqP6jMXioEcOMpP1tPjY5PANUg5CsGe+DZvPeQBk5TTsBi0OI
2OjGBGxI5nqCW9VTBlkyR9egprmqRzDJVwOxyoAk3Hm7YkuCodwJ/bDNGg7FtKXU
CXSFA16s+Nhgpsw1TKvcWruF+KrWJEH2TP5H0cvuhUH3YfLzxWJG1cJF2C4py7MQ
V1w+eLvHF9u5rJ+PPjbN0BBqEuEFmYSvJR5gtq1W+NnxemgalKDBwavNjENVd4IT
R2BV0oPXxcewZ8M2C+Kfy03ge60tuFuWmgLlclcusNMvwxaAn8PJqjNbuJjDQUOo
EdGHlsWxADa2GxKWxJa8sTX+Ew1vaFSCJNiHi2cbYjZd9iUO9SoN4gH94EUKDtww
1f2Z1CiOuf5SAbSOEUBk8GNDA14dXdZnHuYbT+E8X8pxHK50bsPf8M7lo1f9mdiy
KiA9zsLZg3JX3kO0XDIldopMEmXdh298bkkprmpjhYODAN/zKL1zf6WAyhw0hRoE
aDXFARy9F1orqPz4pNLX1QgC9K6TFJk34rGs2Wlv2i9PQDg+lhPqEx0KF51N7c7q
ftLJHM20U5U7Sbr5xFFC
=Nq++
-----END PGP SIGNATURE-----
--=-=-=--
