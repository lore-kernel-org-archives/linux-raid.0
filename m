From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 0/4] RFC: attempt to remove md deadlocks with metadata without
Date: Wed, 11 Oct 2017 08:20:56 +1100
Message-ID: <87vajmwvgn.fsf@notabene.neil.brown.name>
References: <150518076229.32691.13542756562323866921.stgit@noble> <87o9qe9p3j.fsf@notabene.neil.brown.name> <446747392.10694917.1505364915884.JavaMail.zimbra@redhat.com> <871sn9alrh.fsf@notabene.neil.brown.name> <393232447.10845976.1505375841983.JavaMail.zimbra@redhat.com> <87vaju18dc.fsf@notabene.neil.brown.name> <c0e9b424-05d2-df6e-71ce-240a8141a2fd@redhat.com> <874lrc28x8.fsf@notabene.neil.brown.name> <1345780738.18087591.1507512089744.JavaMail.zimbra@redhat.com> <87a810zznc.fsf@notabene.neil.brown.name> <441ae9fe-fd73-2aac-8bb1-c64da28cda27@redhat.com> <871smczx4j.fsf@notabene.neil.brown.name> <ebf97c38-c8e0-aa87-be84-efc8d56802f0@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ebf97c38-c8e0-aa87-be84-efc8d56802f0@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10 2017, Xiao Ni wrote:

> On 10/09/2017 01:52 PM, NeilBrown wrote:
>> On Mon, Oct 09 2017, Xiao Ni wrote:
>>
>>> On 10/09/2017 12:57 PM, NeilBrown wrote:
>>>> It would if you had applied
>>>>      [PATCH 3/4] md: use mddev_suspend/resume instead of ->quiesce()
>>>>
>>>> Did you apply all 4 patches?
>>> Sorry, it's my mistake. I insmod the wrong module. I'll apply the four
>>> patches
>>> and do test again.
>>>> Thanks.  I looks suspend_lo_store() is calling raid5_quiesce() directly
>>>> as you say - so a patch is missing.
>>> Yes, thanks for pointing about this.
>
> Hi Neil
>
> I applied the four patches and one patch "md: fix deadlock error in=20
> recent patch."
> There is a new stuck. It's stuck at suspend_hi_store this time. I add=20
> the calltrace
> as an attachment.
>
> I added some printk to print some information.
>
> [12695.993329] mddev suspend : 1
> [12695.996270] mddev ro : 0
> [12695.998790] mddev insync : 0
> [12696.001641] mddev active io: 1

You didn't tell me where (in the code) you printed this information.
That makes it hard to interpret.

If mddev->active_io is 1, then some thread must be in this range
of code

	atomic_inc(&mddev->active_io);
	rcu_read_unlock();

	if (!mddev->pers->make_request(mddev, bio)) {
		atomic_dec(&mddev->active_io);
		wake_up(&mddev->sb_wait);
		goto check_suspended;
	}

	if (atomic_dec_and_test(&mddev->active_io) && mddev->suspended)
		wake_up(&mddev->sb_wait);

If that thread is blocked (which appears to be the case) it must be in
=2D>make_request() because nothing else there blocks.
None of the threads you showed are in that code.
But you didn't report all the threads - only those which hard printed
warnings.

  echo t > /proc/sysrq-trigger

will produce the stack traces of *all* threads.  That would be more
useful.

>
> Can it be:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index b6b7a28..55e9280 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7777,7 +7777,7 @@ void md_check_recovery(struct mddev *mddev)
>          if (mddev->ro && !test_bit(MD_RECOVERY_NEEDED, &mddev->recovery))
>                  return;
>          if ( ! (
> -               (mddev->flags & ~ (1<<MD_CHANGE_PENDING)) ||
> +               (mddev->flags & (mddev->external =3D=3D 1 &&  ~=20
> (1<<MD_CHANGE_PENDING))) ||

Please read that code again and see how it doesn't make any sense at
all.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndObkACgkQOeye3VZi
gblD5g//dnGt09K7uFJ5Pv19d1tnLaDrC+6tYvAmyZuz5R9ptLfyiYIHijmlKes6
0IUxlOl3g/IzTRfqMMHnodyYwBjWJh53W50spfgzNrPinjSfiktONj+Ex8TJU4Fh
QXfPPKTfMc5P3G1z6x/t6b46iVh4D8m0Ap7UaV4FBvqw+fTDfc9ldU1ROuy69TGm
6W4uVxC8VWpGMueEkiLJMFrNQV2iARskdSh1CG2PM1MuGorszKXzLGWnuF+pZQO8
G0i1crpzLJhGJDQ1ElKxWskwK5r4tGMVY8dq272SPm0qyPno6SeivCLV82OTamTK
G0M9M4Ov8hhOcieLVLXpVxyZ2wL6zK8NyDiEfqfIgH2WXCTePHeP8JMF3TLVtPfL
GJIlQR5WW336SahprPBlBaSPo4jCBJ8K9N7DFhNQ3gfvzyRbaJhgeR0BvpMj21DN
0cp00yJ9yO93PpACnGbHjS8+nmqKAJukM6KDpH7fzdNydrIXxCa43eOfYwQJaAsv
3Z0shTWKKwxmSVX9r7tsrreIPg1i7wHUKrIDhbfoGscRLbuMKx5DZxH7stSYHRjq
bYjq39L5xRi30Hci48xIx1OxKUY7tx2bRWW1e6dZBa2CWSrXcMkoc1UQM5vySpc4
IbzpAcek1CKINzQkTH8YT3i9ac6q9NetRvbKeMXqjM5z5MCjqJc=
=Mr8P
-----END PGP SIGNATURE-----
--=-=-=--
