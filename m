From: NeilBrown <neilb@suse.de>
Subject: Re: raid1_end_read_request does not retry failed READ from a
 recovering drive
Date: Mon, 8 Sep 2014 17:17:02 +1000
Message-ID: <20140908171702.5b2853fc@notabene.brown>
References: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/w73eDl1Yn2yWf1tb8fmZR5W"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6B0ZWtr1xv7_-qAzww+UNcfausrxRnMzDBP3n5348e7A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/w73eDl1Yn2yWf1tb8fmZR5W
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 7 Sep 2014 17:18:16 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hi Neil,
> we see the following issue:
>=20
> # RAID1 has 2 drives A and B, drive B is recovering
> # READ request arrives
> # read_balanace selects drive B to read from, because READ sector
> comes before B->recovery_offset
> # READ is issued to drive B, but fails (drive B fails again)
>=20
> Now raid1_end_read_request() has the following code:
>=20
>     if (uptodate)
>         set_bit(R1BIO_Uptodate, &r1_bio->state);
>     else {
>         /* If all other devices have failed, we want to return
>          * the error upwards rather than fail the last device.
>          * Here we redefine "uptodate" to mean "Don't want to retry"
>          */
>         unsigned long flags;
>         spin_lock_irqsave(&conf->device_lock, flags);
>         if (r1_bio->mddev->degraded =3D=3D conf->raid_disks ||
>             (r1_bio->mddev->degraded =3D=3D conf->raid_disks-1 &&
>              !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags)))
>             uptodate =3D 1;
>         spin_unlock_irqrestore(&conf->device_lock, flags);
>     }
>=20
> According to this code uptodate wrongly becomes 1, because:
> r1_bio->mddev->degraded =3D=3D conf->raid_disks-1 is TRUE
> and
> !test_bit(Faulty, &conf->mirrors[mirror].rdev->flags) is also TRUE
>=20
> Indeed, drive B is not marked as Faulty, but also not marked as In_sync.
> However, this function treats !Faulty being equal to In_Sync, so it
> decides that the last good drive failed, so it does not retry the
> READ.
>=20
> As a result, there is IO error, while we should have retried the READ
> from the healthy drive.
>=20
> This is happening in 3.8.13, but your master branch seems to have the
> same issue.
>=20
> What is a reasonable fix?
> 1) Do not read from drives which are !In_sync (a bit scary to read
> from such drive)

It is perfectly safe to read from a !In_sync device providing you are before
->recovery_offset.


> 2) replace !Faulty to In_sync check

That probably makes sense... though that could race with raid1_spare_active=
().
If a read-error returned just after raid1_spare_active() set In_sync, and
before 'count' was subtracted from ->degraded, we would still set uptodate
when we shouldn't.
It probably make sense to put all of raid1_spare_active inside the spinlock=
 -
it doesn't get call often enough that performance is an issue (I hope).

So:
 1/ change !Faulty to In_sync
 2/ extend the spinlock in raid1_spare_active to cover the whole function.

Thanks,
NeilBrown

--Sig_/w73eDl1Yn2yWf1tb8fmZR5W
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVA1X7jnsnt1WYoG5AQIG/g//f5yp8uzFjcTJRJVhTgDOWOo8PKyawCpX
tI+3JzwiGeyyExOJIw5DX0Q8pjqTnfmLmS/oaHxqeFj5IPdFCfgfkqdvXKxO5kf4
xStYudil4n5B9pkFjDHXWgmNCkYFvTnZm6XOrOi9ZjvMAyJYt4vRImZAJWFIlw09
th25ceQcpVdgEb4ZSFrfoJ6U2jz5p8d23n1oZg+XMTc2t9aQZ0E3UN1Fi4VRp3q/
zbO9uOqsckrSuQJo8l5Fuoqxx4NX80qE28Fg9JF6NjmQPw18lvnvkcTRcOB9toCN
kvlAgkWaypaBrrml4v5SYhH3KPzSDw3vaYMGDYAy+jDXknO/WwtfR7D9r7Rx+Xfq
LtAaYzVOUTdSnd5tWtHvrko3LiM03CTnkyB4IL7lqVY02Oct1xHJ6E3eoLwVNvBN
pbjC+YRJS4M+lXeQEcaBX1ujy5otARaThII2ilksvqjU6P4VzIGxdM54fIWkbyO4
3rKLtc1kQ1Omf4/APm09NQ+m0507H8+Pza7Aqmt3o6ZdeKyJSCTJ0D+BmFZ9Lm7e
7gwNnYbJ2/EiNvHMl3hc8zwNuIsmZ/JnGeStmCLLpNDKS+FlowaD+O0Cx67kSKUr
385qdqr6r/2Jfld+SYP+aKPUC6NlDgKXgn6Owg27ANcs5hlXyCZcsmkKYXaICm5n
A8AnjLZt9qg=
=idbU
-----END PGP SIGNATURE-----

--Sig_/w73eDl1Yn2yWf1tb8fmZR5W--
