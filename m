From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Mon, 09 Oct 2017 15:10:50 +1100
Message-ID: <87h8v9yn91.fsf@notabene.neil.brown.name>
References: <22997.8664.67459.119616@quad.stoffel.home> <87a81637lq.fsf@notabene.neil.brown.name> <23002.37193.492253.120639@quad.stoffel.home> <87shetz207.fsf@notabene.neil.brown.name> <23002.53075.413063.6948@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23002.53075.413063.6948@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 08 2017, John Stoffel wrote:

>>>>>> "NeilBrown" =3D=3D NeilBrown  <neilb@suse.com> writes:
>
> NeilBrown> On Sun, Oct 08 2017, John Stoffel wrote:
>>>>>>>> "NeilBrown" =3D=3D NeilBrown  <neilb@suse.com> writes:
>>>=20
> NeilBrown> On Wed, Oct 04 2017, John Stoffel wrote:
>>>>> Since Eli had such a horrible experience where he shrunk the
>>>>> individual component raid device size, instead of growing the overall
>>>>> raid by adding a device, I came up with this hacky patch to warn you
>>>>> when you are about to shoot yourself in the foot.
>>>>>=20
>>>>> The idea is it will warn you and exit unless you pass in the --force
>>>>> (or -f) switch when using the command.  For example, on a set of loop
>>>>> devices:
>>>>>=20
>>>>> # cat /proc/mdstat
>>>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>>>>> [raid4] [multipath] [faulty]
>>>>> md99 : active raid6 loop4p1[4] loop3p1[3] loop2p1[2] loop1p1[1]
>>>>> loop0p1[0]
>>>>> 606720 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5]
>>>>> [UUUUU]
>>>>>=20
>>>>> # ./mdadm --grow /dev/md99 --size 128
>>>>> mdadm: Cannot set device size smaller than current component_size of =
/dev/md99 array.  Use -f to force change.
>>>>>=20
>>>>> # ./mdadm --grow /dev/md99 --size 128 -f
>>>>> mdadm: component size of /dev/md99 has been set to 0K
>>>>>=20
>>>=20
> NeilBrown> I'm not sure I like this.
> NeilBrown> The reason that mdadm will quietly accept a size change like t=
his is
> NeilBrown> that it is trivial to revert - just set the same to a big numb=
er and all
> NeilBrown> your data is still there.
>>>=20
>>> This is wrong, because if you use --grow --size ### with a small
>>> enough number, it destroys the MD raid superblock.
>
> NeilBrown> If that is true, then it is a kernel bug and should be fixed i=
n the kernel.
>
> I just remembered another point I wanted to make.  The earliest we get
> such a change into the kernel is 4.15, and then maybe back ported into
> some number of stable kernels.  But by putting this check into mdadm
> as well, we can protect people running older kernels as well.  It
> seems to me like a good arguement for fixing mdadm to:

If there is some action that mdadm can currently be told to perform, and
when it tries to perform that action it corrupts the array, then
it is certainly appropriate to teach mdadm not to perform that action.
It shouldn't even perform that action with --force.   I agree that
changing mdadm like this is complementary to changing the kernel.  Both
are useful.

This is quite separate from any proposal to require --force to reduce
the size with --grow --size.

NeilBrown

>
> - adding the --grow --Force ... option.
> - fixing the size check so you don't destroy the MD superblock even
>   with --Force.
> - reporting to the user the pre- and post- size of array components
>   when using --grow --size ##
>
> Thanks,
> John
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlna9ssACgkQOeye3VZi
gbnvUQ//U7bR5Nhvlh1EOg4Dnbi/tCzbI0RoZk/8/3NNtCArpeD+xBiFHyhAmMDw
M+3iZxWS8Pit1VwWIzGuioyNviRW9KaCwqNgKAImqfJfO8EQM6AT8dWdH7/J+GLx
X9Qupn8yf/lb60yw6IuH6rM5dwCG/bJkSwDjqDcWki1DuMSAz40I6d2Qx9sviUJK
Ksl/RYys0W4fUT88k0WdHEJPAn8jJk9TG2OiIxzMH4LDsL6hMjxjC0KiWcIV7foh
mKjQuOg/0STpOX+Cm3LD/qp2S8NAkIZnkDinrvSquj66QJHexIVaMVaGMzgqebbg
tHIxemcxH+qOo0AiR8Jd+O2k30dhTf4W3O3ZDnc0SgclC7sN0eoa1FdLpALGZTrw
WjhD6G4KyOooWvE027iQrWfz5nkmEDrVF7+V4rJo83FAhYt2KOLUXNkZJ+Y5QMoA
xoKd5aYTv02raYEER2oQA0jYKWKSsdAL13VqAVtIJwloP9AavvNPzkt5DjR3cOdu
+ON7RToq1/yt7FWR7v4DHhE+by08xV22ANXb58luz6yUiMqacush6bD9XHSNhO5r
7j9yuTJLeZNs0+qvV/DOqP3DDFeB/fQ0h/XfCFrKnIHjNPjsDbf/gHcQw7zPsKan
hbX6EhGnMU0kK+wCS2fsFYSWo1bM/GhEsH0/kcsUraQW3cHPgas=
=oZXf
-----END PGP SIGNATURE-----
--=-=-=--
