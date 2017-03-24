From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: one question about the readonly and readwrite feature
Date: Fri, 24 Mar 2017 11:28:16 +1100
Message-ID: <87d1d7a57j.fsf@notabene.neil.brown.name>
References: <774691e9-6b1e-5141-bc37-6e768c1c8fdc@suse.com> <87zigdt1r1.fsf@notabene.neil.brown.name> <58D32AE2.1030303@suse.com> <871stobqvl.fsf@notabene.neil.brown.name> <600b22b5-762e-da9c-0d20-9023de4361b3@suse.com> <87poh8a2vz.fsf@notabene.neil.brown.name> <8aabda0c-023f-6033-26d1-c6a6c907b8e6@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8aabda0c-023f-6033-26d1-c6a6c907b8e6@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Guoqing Jiang <gqjiang@suse.com>, Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 23 2017, Zhilong Liu wrote:

> On 03/23/2017 03:06 PM, NeilBrown wrote:
>> Why?
>> How do the actions performed by set_disk_ro() interact with the actions
>> performed by md_wakeup_thread()?
>>
>> I'm not saying the code shouldn't be changed, just that there needs to
>> be a clear explanation of the benefit.
>
> here just according to my understanding for readonly code path, welcome
> the correction in my comments if I misunderstand this feature, :-).

I'm sorry if this sounds harsh, but I get the impression that you aren't
really trying to understand the code.  You are just guessing about what
things might be doing, rather than doing careful research to determine
exactly what the code does.

Do you know what "set_disk_ro()" does?  What are the consequences of
call it?  Until you know that, you cannot make any reasonable assessment
on where the call should go.

Do you know why we set MD_RECOVERY_NEEDED and wake up the thread?
You seem to expect that it might cause some write out, however it
happens just after a call to __md_stop_writes() which aims to stop all
writes happening to the array.  So that seems unlikely (but is worth
checking).


> ... ...
> static int md_set_readonly(struct mddev *mddev, struct block_device *bdev)
> {
>          int err =3D 0;
>          int did_freeze =3D 0;
>
>          if (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery)) {
>                  did_freeze =3D 1;
>                  set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);  -->=20
> here has set bit as FROZEN
>                  md_wakeup_thread(mddev->thread);
>          }
> ... ...
>
>          if (mddev->pers) {
>                  __md_stop_writes(mddev);
> /*
>   *  set FROZEN again, maybe can use test_and_set_bit(FROZEN) better, it=
=20
> doesn't matter.

Correct, it doesn't matter.


>   *  it flushed and synced all data, bitmap and superblock to array.

Correct again.


>   */
>                  err  =3D -ENXIO;
>                  if (mddev->ro=3D=3D1)
>                          goto out;
>                  mddev->ro =3D 1;
> /*
>   *  Here, I means that set_disk_ro until the daemon thread has=20
> completed all operations
>   *  include of sync and recovery progress. set_disk_ro when the array=20
> has cleaned totally,
>   *  then it would be safer.

Completed which operations exactly?  __md_stop_writes() has called
md_reap_sync_thread() so there cannot still be any recovery.  It has
called pers->quiesce() so there cannot be any outstanding io.
And just moving the call to afterwards would't cause it to wait for those
supposed operations to complete.

>   *  I'm not sure MD_RECOVERY_NEEDED would be running once the array has=
=20
> set_disk_ro,
>   *  actually I don't know how to test this scenario, thus asked this=20
> question.

The first step is to understand the code.
Your questions was "should we move this line to here", without asking any
questions about what the code does, or showing much understanding of it.

I do encourage you to ask questions, but it is best to start with
questions that make sense.
And once you have framed a question, try to answer it yourself.
Read the code (e.g. the code for set_disk_ro()) if you haven't read it
before, to be sure you understand what it does.
And if you don't know why some code does something, it often helps to
look through the git logs, or use "git blame" to find out when the code
was added or changed.  Often the changelog of the patch will explain the
purpose of the code.

NeilBrown


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljUaCAACgkQOeye3VZi
gbloQw//cBwjW0KcHfDn1tOvRUFAoQBzi7NsbZOMHUMlkXFx/dUBP7riDqxUlVGp
0Trr8k0uKadQnLNRjI5OTeJiCkYsJoSQ0z+imIf2JJOHiZLEUek1ScqanB0E36Uh
otU6C81aqYpeCdree91qL6en8CDFR8CfAG/TxncB5WB+hfou+P+ZMwj7QCvL/YtJ
PE5o7zPTrphym3n1lRd6U9HAypO7AJCV7Ulyj3NzXJ7p97Sgt1xaBdyn/BLeETDX
cOU9JtS6AHUisS+s12e7rqWYgYlF2N+Y+udth288GiE6TvckwOuVMZPkZI+tiko0
QJau7HPv3YD6DE1h+vgtYkdRNX/9aa2ZuGkCf0McBSqDll8iMwLtyqrVpogeVhpT
Si/HPnwlQemm/BhOtiI7InGP02jrTZ6znIb3qHjb608v2aW4U7m5ldIByvjuyrM7
I6M4al4WSnaFqtE4pkUYwtuYIMr/tq6JHvPXKHF/nyNEo6LoPPgdhE1lpYC0Pk1t
GCDzOx4nZUmShNF4j0Ls3de3E29SwkE/7ZUZyatXPwu8Etm37vOYy8St+FSEE6Kj
7ixgYOjohhphiylDqkXuYdGKDc0Za2a4eVgdCpg5dL2O9koDc+Yzt6teu+aMhpJi
UfYmhHStUbG4nPG31eVq1z4EvsH0LWC14otudUqYAFGZIBsSpHw=
=Hplf
-----END PGP SIGNATURE-----
--=-=-=--
