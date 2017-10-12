From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
Date: Thu, 12 Oct 2017 11:06:41 +1100
Message-ID: <87h8v5nsa6.fsf@notabene.neil.brown.name>
References: <87y3p372b0.fsf@notabene.neil.brown.name> <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com> <87bmleyd0y.fsf@notabene.neil.brown.name> <375cf2fb-bd4b-abef-5012-1361c224d254@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <375cf2fb-bd4b-abef-5012-1361c224d254@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 11 2017, Zhilong Liu wrote:

> On 10/11/2017 04:16 AM, NeilBrown wrote:
>> On Tue, Oct 10 2017, Zhilong Liu wrote:
>>
>>> On 09/25/2017 01:52 PM, NeilBrown wrote:
>>>> Creating an array by opening a block-device with major number of 9
>>>> will transparently load the md module if needed.
>>>> Creating an array by opening
>>>>      /sys/module/md_mod/parameters/new_array
>>>> and writing to it won't, it will just fail if md_mod isn't loaded.
>>>>
>>>> So when opening that file fails with ENOENT, run "modprobe md_mod" and
>>>> try again.
>>>>
>>>> This fixes a bug whereby if you have "CREATE names=3Dyes" in mdadm.con=
f,
>>>> and the md modules isn't loaded, then creating or assembling an
>>>> array will not honor the "names=3Dyes" configuration.
>>>>
>>>> Signed-off-by: NeilBrown <neilb@suse.com>
>>>> ---
>>>>    mdopen.c | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/mdopen.c b/mdopen.c
>>>> index 3c0052f2db23..dcdc6f23e6c1 100644
>>>> --- a/mdopen.c
>>>> +++ b/mdopen.c
>>>> @@ -312,6 +312,10 @@ int create_mddev(char *dev, char *name, int autof=
, int trustworthy,
>>>>    		if (block_udev)
>>>>    			udev_block(devnm);
>>>>    		fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
>>>> +		if (fd < 0 && errno =3D=3D ENOENT) {
>>>> +			system("modprobe md_mod");
> [nip]
>> Hmmm.. that's annoying.  I wonder why "system" is marked
>> "warn_unused_result".
>
> in /usr/include/stdlib.h:
> ...
> 712 /* Execute the given line as a shell command.
> 713
> 714    This function is a cancellation point and therefore not marked with
> 715    __THROW.  */
> 716 extern int system (const char *__command) __wur;
> ...
>
> the "warn_unused_result" is from the __wur parameter, re-compile mdadm=20
> after delete the '__wur',
> it works.
>
>> In this case I really don't care - I'm not convinced an extra error
>> message will really help.
>> Maybe
>>     if (system("modprobe md_mod") =3D=3D 0)
>>          fd =3D open("/sys/......", O_WRONLY);
>
> Agree.
>>
>> We do what a better error message, then it should be based on 'fd < 0'.
>> e.g.
>>    if (fd < 0 || n !=3D strlen(devnm))
>>        pr_err("Fail create array using /sys/module/md_mod/parameters/new=
_array\n");
>
> you mean something like this?
>
> diff --git a/mdopen.c b/mdopen.c
> index dcdc6f2..9de347e 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -313,14 +313,17 @@ int create_mddev(char *dev, char *name, int autof,=
=20
> int trustworthy,
>                          udev_block(devnm);
>                  fd =3D open("/sys/module/md_mod/parameters/new_array",=20
> O_WRONLY);
>                  if (fd < 0 && errno =3D=3D ENOENT) {
> -                       system("modprobe md_mod");
> -                       fd =3D=20
> open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
> +                       if (system("modprobe md_mod") =3D=3D 0)
> +                               fd =3D=20
> open("/sys/module/md_mod/parameters/new_array",
> +                                         O_WRONLY);
>                  }
>                  if (fd >=3D 0) {
>                          n =3D write(fd, devnm, strlen(devnm));
>                          close(fd);
>                  }
> -               if (n < 0) {
> +               if (fd < 0 || n !=3D strlen(devnm)) {
> +                       pr_err("Fail create array using "
> + "/sys/module/md_mod/parameters/new_array\n");
>                          devnm[0] =3D 0;
>                          udev_unblock();
>                  }
>

Yes - exactly like that except that I wouldn't wrap the long string.
Lines longer than 80 chars are good to avoid, but breaking string
literals is worse than having long lines.  e.g. it makes searching for
the string hard.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlneshIACgkQOeye3VZi
gbmLiA//YIRn5lZejLycX5LXGhRKOJ+pxOnGzVE/11YQuvmW2UmwZxvH3whN4SWj
caVl/2l3tHnyxunQDQS5qXl1n8hvX+nJxihKlZUq0+iUUxQzv+s05L6qvdLD38iF
pilp4GdhIOnLPE/iHLwVs3DxTl5LZCVE6gC7BQ6g9A0Qgfx1p2aPKK21ilfsgxzW
d8iA3Pq1b5j1fvYxDIW3ZckOUj9Y7hTbknrmTPx98o7jKJ9W5I+hVLlrUniSU67D
5uCFw3L1XHSg9uTsYkleY7zOff4xOo0Cfl7r2XZmlz2OMjEwRS93CNAoI3QZIYkl
OBVVd+J/uGsuY+FBVs9Chx6oCqMM8dLoTCRv0S/TOh0ndBR8J7KnOCRLA19d0j9y
2TyI5aD9mNH4wnRZqs52GKTY+Ah0QhWSz9Fy+i4gLgT4uRomC83rtO9anj/GZnnx
oDZw2jCsmcJeT4c18vh/JJM9yd8BFh+npvrpy1KWokUasCz2CrOTMDx+SQaq5IkL
iSEDpvtymzh3mkWhE9uFXgdUbweDqk5exN0qBerQwCyFjnlcmkrAsM2VIcAyMWO3
vXeY+cYmT1Ek9+VebHPtJO0mKXWfyEGACFCSZMW/EBwTyRHo92TyLSqVXyEIlmEi
dF/kcoOVoliSUy7upjDlyqwXfreso/FgYhzqE92vGtMUZGPOb2Q=
=qny+
-----END PGP SIGNATURE-----
--=-=-=--
