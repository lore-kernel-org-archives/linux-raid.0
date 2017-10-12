From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
Date: Thu, 12 Oct 2017 19:48:26 +1100
Message-ID: <87zi8wn44l.fsf@notabene.neil.brown.name>
References: <87y3p372b0.fsf@notabene.neil.brown.name> <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com> <87bmleyd0y.fsf@notabene.neil.brown.name> <375cf2fb-bd4b-abef-5012-1361c224d254@suse.com> <87h8v5nsa6.fsf@notabene.neil.brown.name> <7631f4ae-bcc5-b36d-bb63-678515109f05@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7631f4ae-bcc5-b36d-bb63-678515109f05@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 12 2017, Zhilong Liu wrote:

> On 10/12/2017 08:06 AM, NeilBrown wrote:
>> On Wed, Oct 11 2017, Zhilong Liu wrote:
>>
>>> On 10/11/2017 04:16 AM, NeilBrown wrote:
>>>> On Tue, Oct 10 2017, Zhilong Liu wrote:
>>>>
>>>>> On 09/25/2017 01:52 PM, NeilBrown wrote:
>>>>>> Creating an array by opening a block-device with major number of 9
>>>>>> will transparently load the md module if needed.
>>>>>> Creating an array by opening
>>>>>>       /sys/module/md_mod/parameters/new_array
>>>>>> and writing to it won't, it will just fail if md_mod isn't loaded.
>>>>>>
>>>>>> So when opening that file fails with ENOENT, run "modprobe md_mod" a=
nd
>>>>>> try again.
>>>>>>
>>>>>> This fixes a bug whereby if you have "CREATE names=3Dyes" in mdadm.c=
onf,
>>>>>> and the md modules isn't loaded, then creating or assembling an
>>>>>> array will not honor the "names=3Dyes" configuration.
>>>>>>
>>>>>> Signed-off-by: NeilBrown <neilb@suse.com>
>>>>>> ---
>>>>>>     mdopen.c | 4 ++++
>>>>>>     1 file changed, 4 insertions(+)
>>>>>>
>>>>>> diff --git a/mdopen.c b/mdopen.c
>>>>>> index 3c0052f2db23..dcdc6f23e6c1 100644
>>>>>> --- a/mdopen.c
>>>>>> +++ b/mdopen.c
>>>>>> @@ -312,6 +312,10 @@ int create_mddev(char *dev, char *name, int aut=
of, int trustworthy,
>>>>>>     		if (block_udev)
>>>>>>     			udev_block(devnm);
>>>>>>     		fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONL=
Y);
>>>>>> +		if (fd < 0 && errno =3D=3D ENOENT) {
>>>>>> +			system("modprobe md_mod");
>>> [nip]
>>>> Hmmm.. that's annoying.  I wonder why "system" is marked
>>>> "warn_unused_result".
>>> in /usr/include/stdlib.h:
>>> ...
>>> 712 /* Execute the given line as a shell command.
>>> 713
>>> 714    This function is a cancellation point and therefore not marked w=
ith
>>> 715    __THROW.  */
>>> 716 extern int system (const char *__command) __wur;
>>> ...
>>>
>>> the "warn_unused_result" is from the __wur parameter, re-compile mdadm
>>> after delete the '__wur',
>>> it works.
>>>
>>>> In this case I really don't care - I'm not convinced an extra error
>>>> message will really help.
>>>> Maybe
>>>>      if (system("modprobe md_mod") =3D=3D 0)
>>>>           fd =3D open("/sys/......", O_WRONLY);
>>> Agree.
>>>> We do what a better error message, then it should be based on 'fd < 0'.
>>>> e.g.
>>>>     if (fd < 0 || n !=3D strlen(devnm))
>>>>         pr_err("Fail create array using /sys/module/md_mod/parameters/=
new_array\n");
>>> you mean something like this?
>>>
>>> diff --git a/mdopen.c b/mdopen.c
>>> index dcdc6f2..9de347e 100644
>>> --- a/mdopen.c
>>> +++ b/mdopen.c
>>> @@ -313,14 +313,17 @@ int create_mddev(char *dev, char *name, int autof,
>>> int trustworthy,
>>>                           udev_block(devnm);
>>>                   fd =3D open("/sys/module/md_mod/parameters/new_array",
>>> O_WRONLY);
>>>                   if (fd < 0 && errno =3D=3D ENOENT) {
>>> -                       system("modprobe md_mod");
>>> -                       fd =3D
>>> open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
>>> +                       if (system("modprobe md_mod") =3D=3D 0)
>>> +                               fd =3D
>>> open("/sys/module/md_mod/parameters/new_array",
>>> +                                         O_WRONLY);
>>>                   }
>>>                   if (fd >=3D 0) {
>>>                           n =3D write(fd, devnm, strlen(devnm));
>>>                           close(fd);
>>>                   }
>>> -               if (n < 0) {
>>> +               if (fd < 0 || n !=3D strlen(devnm)) {
>>> +                       pr_err("Fail create array using "
>>> + "/sys/module/md_mod/parameters/new_array\n");
>>>                           devnm[0] =3D 0;
>>>                           udev_unblock();
>>>                   }
>>>
>> Yes - exactly like that except that I wouldn't wrap the long string.
>> Lines longer than 80 chars are good to avoid, but breaking string
>> literals is worse than having long lines.  e.g. it makes searching for
>> the string hard.
>
> Thanks for your detail explanation. I draft it like this, and
> already checked it via to ./linux/scripts/checkpatch.pl.

I wouldn't worry too much about checkpatch.pl.
It is worth looking at what it reports, but if you don't agree or the
maintainer doesn't agree, then feel free to ignore it.


> Is this changing ok to you?
>
> diff --git a/mdopen.c b/mdopen.c
> index dcdc6f2..da8d9d1 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -26,6 +26,8 @@
>   #include "md_p.h"
>   #include <ctype.h>
>
> +#define NEW_ARRAY_FILE "/sys/module/md_mod/parameters/new_array"
> +

Splitting this out into a separate string does make sense.
However I would use
  static const char new_array_file[] =3D ....;
rather than #define.

I hadn't noticed that there are two places where we write to new_array.
Maybe that should be split out into a function.
Both should use modprobe if the open fails.

Thanks,
NeilBrown


>   void make_parts(char *dev, int cnt)
>   {
>       /* make 'cnt' partition devices for 'dev'
> @@ -311,16 +313,17 @@ int create_mddev(char *dev, char *name, int autof,=
=20
> int trustworthy,
>           sprintf(devnm, "md_%s", cname);
>           if (block_udev)
>               udev_block(devnm);
> -        fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
> +        fd =3D open(NEW_ARRAY_FILE, O_WRONLY);
>           if (fd < 0 && errno =3D=3D ENOENT) {
> -            system("modprobe md_mod");
> -            fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRO=
NLY);
> +            if (system("modprobe md_mod") =3D=3D 0)
> +                fd =3D open(NEW_ARRAY_FILE, O_WRONLY);
>           }
>           if (fd >=3D 0) {
>               n =3D write(fd, devnm, strlen(devnm));
>               close(fd);
>           }
> -        if (n < 0) {
> +        if (fd < 0 || n !=3D strlen(devnm)) {
> +            pr_err("Fail create array using %s\n", NEW_ARRAY_FILE);
>               devnm[0] =3D 0;
>               udev_unblock();
>           }
> @@ -331,12 +334,13 @@ int create_mddev(char *dev, char *name, int autof,=
=20
> int trustworthy,
>           sprintf(devnm, "md%d", num);
>           if (block_udev)
>               udev_block(devnm);
> -        fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
> +        fd =3D open(NEW_ARRAY_FILE, O_WRONLY);
>           if (fd >=3D 0) {
>               n =3D write(fd, devnm, strlen(devnm));
>               close(fd);
>           }
> -        if (n < 0) {
> +        if (fd < 0 || n !=3D strlen(devnm)) {
> +            pr_err("Fail create array using %s\n", NEW_ARRAY_FILE);
>               devnm[0] =3D 0;
>               udev_unblock();
>           }
> --=20
> 2.6.6
>
>
> Thanks,
> -Zhilong
>
>> Thanks,
>> NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnfLFsACgkQOeye3VZi
gbn4pBAAtprEV9F0QhBtkyePARwDRFBldiCI9GFAakV9rg0VCxhwIwJOGvm6m1dk
lrvfAJPU7NlIcuAEm5mPdRnVXtJOOXRG56RWfgisXtM2GhAMQl1c0gRum7WeI7vj
7ChDC2iUNIBC4i0thrq5X/rxuSpEAxuc7EPnJKx5Q3ryRb6hqYhf6zCmfJMJoorp
fwt+p7TPZcGRTMwPaxZhj1gVoHA2tbSepp+68FDQHdv64jKNr0VyrwfS5KyMZq5T
osAWZzaI5MI4u8FuE2IY3VebnYoQFVRKV7zNXQ4+xpYcsDiBnzzS+fetgrgY2cyz
CuHvjl/TpQc8/gDvAonYJR1FIvrVoJ5GwqfU3YAmYkI44koOhSYh/Q0KHa/wHznA
DcCDoueWGrf68rym93+f+DMf9dBj5Tt9JrJeQJ57dyiHEyesfgQjvgSNKKmc23IR
PxUOatm5WHlOI9vJRddvsb/GNBDxQV+ekaHqoQ8yTvrVymCV7gUkAlKw4+k8uA6A
q8Keoxh055uaYbuU+VRGYZCep9FARg/qELwWBikHvJ9noBG8Ixa9hUQ3DgavkYOY
FX5Bk7r62ELozg0pHiynGvjV/y98FzrZN2iUqMW08Q1qvC8qQu1DyM6rVfN3Y+fP
Klz0W42yclDW2+RBkLx9F+xJNr814F3XyJyKPwzpOG3zUUhMxS0=
=Ey9k
-----END PGP SIGNATURE-----
--=-=-=--
