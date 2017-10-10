From: NeilBrown <neilb@suse.com>
Subject: Re: [mdadm PATCH] mdopen: call "modprobe md_mod" if it might be needed.
Date: Wed, 11 Oct 2017 07:16:13 +1100
Message-ID: <87bmleyd0y.fsf@notabene.neil.brown.name>
References: <87y3p372b0.fsf@notabene.neil.brown.name> <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cba5f77f-d6de-7a6b-35b0-70b7c56eb3f7@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, "jes.sorensen@gmail.com" <jes.sorensen@gmail.com>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10 2017, Zhilong Liu wrote:

> On 09/25/2017 01:52 PM, NeilBrown wrote:
>> Creating an array by opening a block-device with major number of 9
>> will transparently load the md module if needed.
>> Creating an array by opening
>>     /sys/module/md_mod/parameters/new_array
>> and writing to it won't, it will just fail if md_mod isn't loaded.
>>
>> So when opening that file fails with ENOENT, run "modprobe md_mod" and
>> try again.
>>
>> This fixes a bug whereby if you have "CREATE names=3Dyes" in mdadm.conf,
>> and the md modules isn't loaded, then creating or assembling an
>> array will not honor the "names=3Dyes" configuration.
>>
>> Signed-off-by: NeilBrown <neilb@suse.com>
>> ---
>>   mdopen.c | 4 ++++
>>   1 file changed, 4 insertions(+)
>>
>> diff --git a/mdopen.c b/mdopen.c
>> index 3c0052f2db23..dcdc6f23e6c1 100644
>> --- a/mdopen.c
>> +++ b/mdopen.c
>> @@ -312,6 +312,10 @@ int create_mddev(char *dev, char *name, int autof, =
int trustworthy,
>>   		if (block_udev)
>>   			udev_block(devnm);
>>   		fd =3D open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
>> +		if (fd < 0 && errno =3D=3D ENOENT) {
>> +			system("modprobe md_mod");
>
> Hi, Neil;
> this system() line would be treated warning as error when issue
> make everything-test.
> It complains:
> ... ...
> mdopen.c: In function =E2=80=98create_mddev=E2=80=99:
> mdopen.c:316:10: error: ignoring return value of =E2=80=98system=E2=80=99=
, declared with=20
> attribute warn_unused_result [-Werror=3Dunused-result]
>      system("modprobe md_mod");
>            ^
> cc1: all warnings being treated as errors
> Makefile:196: recipe for target 'mdadm.O2' failed
> make: *** [mdadm.O2] Error 1
> ... ...
>
> It shows that mdadm cannot assume that "system" will always succeed. The=
=20
> code becomes
> unreliable in this way.
>
> It should meets three conditions at the same time to ensure system is=20
> successful.
> 1. -1 !=3D status
> 2. WIFEXITED(status) is true
> 3. 0 =3D=3D WEXITSTATUS(status)
>
> Maybe add a test like this?
>
> diff --git a/mdopen.c b/mdopen.c
> index dcdc6f2..51bf2d3 100644
> --- a/mdopen.c
> +++ b/mdopen.c
> @@ -313,7 +313,10 @@ int create_mddev(char *dev, char *name, int autof,=20
> int trustworthy,
>                          udev_block(devnm);
>                  fd =3D open("/sys/module/md_mod/parameters/new_array",=20
> O_WRONLY);
>                  if (fd < 0 && errno =3D=3D ENOENT) {
> -                       system("modprobe md_mod");
> +                       int ret =3D system("modprobe md_mod");
> +                       if (ret) {
> +                               pr_err("modprobe md_mod got failed!\n");
> +                       }
>                          fd =3D=20
> open("/sys/module/md_mod/parameters/new_array", O_WRONLY);
>                  }
>                  if (fd >=3D 0) {
>

Hmmm.. that's annoying.  I wonder why "system" is marked
"warn_unused_result".
In this case I really don't care - I'm not convinced an extra error
message will really help.
Maybe
   if (system("modprobe md_mod") =3D=3D 0)
        fd =3D open("/sys/......", O_WRONLY);


We do what a better error message, then it should be based on 'fd < 0'.
e.g.
  if (fd < 0 || n !=3D strlen(devnm))
      pr_err("Fail create array using /sys/module/md_mod/parameters/new_arr=
ay\n");

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndKo4ACgkQOeye3VZi
gblu7A/9E1c1iNTx3wu+W2vtfrqDOdIQCzUHRKaRDX04VmtyIsyi4ArfKm/40tMs
b0jETR7wLzIME2/rSjV3AQvwO7sxSYskSPUbClleei1UB7vXx33rGLX5oOeOolaX
L77Id+JJhDYDq01pTWTv+0mxkRUVewxh/speyCNy2Y6xs+H1TJaL1Jm0d3k+clrI
4mb7y9axkO9Cr6NNw/58A0JUENSDLA/jnBweoOZ3VX1nPzT6lijx8ZW20A0M6kcS
1FHbmUx3giJ/sCdV5Xmctf9sHq31Qh/IHnpc7bBuBGTPUl+LSjCNT6dqqeHz65S3
ANF9Wy3zqWGos4dfgOWVbLQMy21yvNpgFsepE3dUXzym4o9wi9rwOT4VB0v5xzoa
QB8KnsO2thXB8hwoKN1drAosGmOoPN+FIAF95+u/Otk6Mwc9eyq+GUPuNMzVnJAX
C1QUy5rR5X6Wcljvdyf10bEgDH4Qs8p/OL+4ielpAdhHcn/FS/gDAlWtRVbFE/RK
CMj+VJWvF26g0jjf+pi7N15fXj3kJy9FaJoIfWshibLtb/vAAmeRhR1gYD1W8vYo
57qpPwygfg/wL5mHZn9F3F+HJo2lDeHxTYblMmBtyFsJ+uZ1f5jTgHdJTS4vXgWc
TaXd40JYtRvcVXOTS+RABqjEIPkTQgKhKBuButYyEjYaWxMho+c=
=oFM1
-----END PGP SIGNATURE-----
--=-=-=--
