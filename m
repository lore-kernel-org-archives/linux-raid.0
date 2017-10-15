From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
Date: Mon, 16 Oct 2017 09:41:28 +1100
Message-ID: <87d15okp9j.fsf@notabene.neil.brown.name>
References: <87y3p372b0.fsf@notabene.neil.brown.name> <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com> <87bmleyd0y.fsf@notabene.neil.brown.name> <375cf2fb-bd4b-abef-5012-1361c224d254@suse.com> <87h8v5nsa6.fsf@notabene.neil.brown.name> <7631f4ae-bcc5-b36d-bb63-678515109f05@suse.com> <87zi8wn44l.fsf@notabene.neil.brown.name> <4bfc741e-c9e6-1645-fc2b-f90da1c7cc20@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4bfc741e-c9e6-1645-fc2b-f90da1c7cc20@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 13 2017, Zhilong Liu wrote:

> On 10/12/2017 04:48 PM, NeilBrown wrote:
>>> On 10/12/2017 08:06 AM, NeilBrown wrote:
>> I wouldn't worry too much about checkpatch.pl.
>> It is worth looking at what it reports, but if you don't agree or the
>> maintainer doesn't agree, then feel free to ignore it.
>>
>>
>>> Is this changing ok to you?
>>>
>>> diff --git a/mdopen.c b/mdopen.c
>>> index dcdc6f2..da8d9d1 100644
>>> --- a/mdopen.c
>>> +++ b/mdopen.c
>>> @@ -26,6 +26,8 @@
>>>    #include "md_p.h"
>>>    #include <ctype.h>
>>>
>>> +#define NEW_ARRAY_FILE "/sys/module/md_mod/parameters/new_array"
>>> +
>> Splitting this out into a separate string does make sense.
>> However I would use
>>    static const char new_array_file[] =3D ....;
>> rather than #define.
>
> Maybe "const char *" is enough for this long string? Because this file=20
> only used when
> creating named array, not global using.

I would still suggest "const char new_array_file[] =3D " because you
don't need a variable to hold a pointer to the string, you just need the
string.

But if you want to make it static inside the function, rather then
static outside the function, I see no problem with that.

NeilBrown

>
>> I hadn't noticed that there are two places where we write to new_array.
>> Maybe that should be split out into a function.
>> Both should use modprobe if the open fails.
>
> how about this changing? Thanks for your patience to have a look at it.
>
>
> diff --git a/mdopen.c b/mdopen.c
> index dcdc6f2..6d8402d 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -100,6 +100,29 @@ void make_parts(char *dev, int cnt)
>          free(name);
>   }
>
> +int create_named_array(char *devnm)
> +{
> +       const char *file =3D "/sys/module/md_mod/parameters/new_array";
> +       int fd;
> +       int n =3D -1;
> +
> +       fd =3D open(file, O_WRONLY);
> +       if (fd < 0 && errno =3D=3D ENOENT) {
> +               if (system("modprobe md_mod") =3D=3D 0)
> +                       fd =3D open(file, O_WRONLY);
> +       }
> +       if (fd >=3D 0) {
> +               n =3D write(fd, devnm, strlen(devnm));
> +               close(fd);
> +       }
> +       if (fd < 0 || n !=3D (int)strlen(devnm)) {
> +               pr_err("Fail create %s when using %s\n", devnm, file);
> +               return 0;
> +       }
> +
> +       return 1;
> +}
> +
>   /*
>    * We need a new md device to assemble/build/create an array.
>    * 'dev' is a name given us by the user (command line or mdadm.conf)
> @@ -306,37 +329,19 @@ int create_mddev(char *dev, char *name, int autof,=
=20
> int trustworthy,
>
>          devnm[0] =3D 0;
>          if (num < 0 && cname && ci->names) {
> -               int fd;
> -               int n =3D -1;
>                  sprintf(devnm, "md_%s", cname);
>                  if (block_udev)
>                          udev_block(devnm);
> -               fd =3D open("/sys/module/md_mod/parameters/new_array",=20
> O_WRONLY);
> -               if (fd < 0 && errno =3D=3D ENOENT) {
> -                       system("modprobe md_mod");
> -                       fd =3D=20
> open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
> -               }
> -               if (fd >=3D 0) {
> -                       n =3D write(fd, devnm, strlen(devnm));
> -                       close(fd);
> -               }
> -               if (n < 0) {
> +               if (!create_named_array(devnm)) {
>                          devnm[0] =3D 0;
>                          udev_unblock();
>                  }
>          }
>          if (num >=3D 0) {
> -               int fd;
> -               int n =3D -1;
>                  sprintf(devnm, "md%d", num);
>                  if (block_udev)
>                          udev_block(devnm);
> -               fd =3D open("/sys/module/md_mod/parameters/new_array",=20
> O_WRONLY);
> -               if (fd >=3D 0) {
> -                       n =3D write(fd, devnm, strlen(devnm));
> -                       close(fd);
> -               }
> -               if (n < 0) {
> +               if (!create_named_array(devnm)) {
>                          devnm[0] =3D 0;
>                          udev_unblock();
>                  }
>
> Thanks,
> -Zhilong
>
>> Thanks,
>> NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnj5BkACgkQOeye3VZi
gblpUg//YkV4IaD05tK6R9SMMepSdSg8tX7MgDDDKmJmQQKEiM0AABZuZUlvPdMZ
IMLLmR9JfIU4FPb+Bmd86rV8bxcdH7Mwx7/we7KBb2t4J19uUxOYI/Z3rpHFO6qA
ENajfFy6UM843TvGshaceibhiG46w7u7pM/SPtGPS2+08LCbqZCSgJFpT5uCWoFe
8Y5gL7wdh8XTsTliPNeaLppGT50PSjUmZwT+Yen2YhHQbFse249mPJ7fCSUZJw3v
uzY2+KVy7lWl0RCO6sNbQPBSQq75Arp3FCrrrQfsY0CcHAZUytlCiTzELB1DXwJG
AVilOl00Hj5ToYOrdyDzydfRaSEQunIr++TVdGij5AnSbk68tfqtYCRciEEY0aLE
WXYCC+3WwUZPKqY1CDNC65tinJaz+bgyE5A5gG507EynVtFOH/u0PgjRriITVgEB
K4CKl4fmNl1rlIuzhIojlJfo/LGkGy5R4KaAWyMzghR8AvalYAOhzBHPn8ZNIp64
l4VxWeyawcXiHHvNMz7HsipXp5oBllDuW6tI19H+5aF77bM8kTW6x0D0pD9kBQxV
KRWftlpqi908inM/ZApwt1syyNiiAI5Gyq4jU1RBpdUOXh4lav6WB3HNipu0e1UI
pxbZI5fJOiniJ2UA+FJJY8qehquj17GN6QcmYpI9y5BnOfFi9og=
=XQJ5
-----END PGP SIGNATURE-----
--=-=-=--
