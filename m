From: NeilBrown <neilb@suse.com>
Subject: Re: mdadm: Patch to restrict --size when shrinking unless forced
Date: Mon, 09 Oct 2017 09:52:08 +1100
Message-ID: <87shetz207.fsf@notabene.neil.brown.name>
References: <22997.8664.67459.119616@quad.stoffel.home> <87a81637lq.fsf@notabene.neil.brown.name> <23002.37193.492253.120639@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23002.37193.492253.120639@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
Cc: John Stoffel <john@stoffel.org>, Eli Ben-Shoshan <eli@benshoshan.com>, Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, Oct 08 2017, John Stoffel wrote:

>>>>>> "NeilBrown" =3D=3D NeilBrown  <neilb@suse.com> writes:
>
> NeilBrown> On Wed, Oct 04 2017, John Stoffel wrote:
>>> Since Eli had such a horrible experience where he shrunk the
>>> individual component raid device size, instead of growing the overall
>>> raid by adding a device, I came up with this hacky patch to warn you
>>> when you are about to shoot yourself in the foot.
>>>=20
>>> The idea is it will warn you and exit unless you pass in the --force
>>> (or -f) switch when using the command.  For example, on a set of loop
>>> devices:
>>>=20
>>> # cat /proc/mdstat
>>> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5]
>>> [raid4] [multipath] [faulty]
>>> md99 : active raid6 loop4p1[4] loop3p1[3] loop2p1[2] loop1p1[1]
>>> loop0p1[0]
>>> 606720 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5]
>>> [UUUUU]
>>>=20
>>> # ./mdadm --grow /dev/md99 --size 128
>>> mdadm: Cannot set device size smaller than current component_size of /d=
ev/md99 array.  Use -f to force change.
>>>=20
>>> # ./mdadm --grow /dev/md99 --size 128 -f
>>> mdadm: component size of /dev/md99 has been set to 0K
>>>=20
>
> NeilBrown> I'm not sure I like this.
> NeilBrown> The reason that mdadm will quietly accept a size change like t=
his is
> NeilBrown> that it is trivial to revert - just set the same to a big numb=
er and all
> NeilBrown> your data is still there.
>
> This is wrong, because if you use --grow --size ### with a small
> enough number, it destroys the MD raid superblock.

If that is true, then it is a kernel bug and should be fixed in the kernel.

>  So again, I think
> the --force option is *critical* here.  Or we need to block the size
> change from going smaller than the superblock size.  Here's my test,
> where I just warn if the size is going to be smaller:
>
>     # ./mdadm --grow /dev/md99 --size 128
>     mdadm: setting raid component device size from 202240 to 128 in array=
 /dev/md99,
>     this may need to be reverted if new size is smaller.
>     mdadm: component size of /dev/md99 has been set to 0K
>
>     # ./mdadm --grow /dev/md99 --size 202240
>     mdadm: setting raid component device size from 0 to 202240 in array /=
dev/md99,
>     this may need to be reverted if new size is smaller.
>     mdadm: Cannot set device size in this type of array.
>
>     # mdadm -E /dev/md99
>     mdadm: No md superblock detected on /dev/md99.
>
> So I think this argues for a much stronger check, and/or the --force
> option when shrinking.  I'll re-spin my patch series into two chunks,
> one just the message if changing size.  The second to require the
> --force option.

Why don't you like my suggestion that you should need to reduce the
=2D-array-size first?

Thanks,
NeilBrown

>
> And I think we need a third option to make sure the size can't be
> smaller than the array superblock size as well.  Otherwise a simple
> mistake trashes your array.
>
> My current warning only patch (with whitespace damage...)
>
>> git diff
> diff --git a/Grow.c b/Grow.c
> index 455c5f9..18aea63 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1625,6 +1625,10 @@ int Grow_reshape(char *devname, int fd,
>                 return 1;
> 		        }
>
> +       if (s->size !=3D (unsigned)array.size) {
> +               pr_err("setting raid component device size from %u to %ll=
u in array %s,\nthis may need to be reverted if new size is smaller.\n",(un=
signed)array.size,s->size,devname);
> +       }
> +
>         st =3D super_by_fd(fd, &subarray);
> 	        if (!st) {
> 		                pr_err("Unable to determine metadata format for %s\n", =
devname);
>=20=09=09=09=09
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnarBkACgkQOeye3VZi
gbnHNA//XGR+rMGJ7+TcWR9t2ymUJN9HP7Y22sLEirJkjD2XNeXVW9ZMSc2Ps6po
SCWlF41vYWKOZedfnEeGAiT11EivaIMVml4c9DACyk4voEUtHcll44UjfQHSIqpl
aZ5jejqS7fIsbN/wpjT8dMjA3zhLbhTc/FGeo9G8v88PDZov4ZSy+VfRjLJhVEBr
5Hu+gTMmEP07uXFTYdiYiWcN0h/V7nEu03e9oqdZ0tyoXElFj++Pwc1ruIv4siXu
u/3K42CtwEHFOiI4o2RYo3iToS0SeXrSLJ8w5HV9qdIo6c+cPK7CGzu66TjZOHgC
naLVV1douTYH+xm4e68V3mD0OHbc6K+CtE0Q+QOpW14+uavokfIIORzbwihEhCX0
YJKrqPNwqTMzYyrGsl7wSXSYEGjIMrEHoK/zQRIJNlZP7Um90cIivYxaNTJapzFQ
7mi6GCNSqQMtZbZITFArLZtgsWLyx3xWN0EOInkCwxET1/de1o1zVgJ2prx53XcV
No9X8leqlouj1EEbbG9FLLEBa/ZOjDy8mgKt4c0SNuEcZp7eiLOO8eD3nCuXqKD6
b/wQfz8cr8oA7yB0qRb3HwY5YT9ewh4M+QERg6FQkxNvGe45yqDDXXfRdz4lbpyh
TBmQkAkuLZqO63N6UzjDuek/4+drJDWL6RlqsZcLcRRtoFZi1qo=
=WudN
-----END PGP SIGNATURE-----
--=-=-=--
