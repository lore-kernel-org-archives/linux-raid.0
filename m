From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] mdadm/grow: Component size must be larger than chunk size
Date: Mon, 09 Oct 2017 21:51:49 +1100
Message-ID: <87po9wy4oq.fsf@notabene.neil.brown.name>
References: <1504604498-26048-1-git-send-email-zlliu@suse.com> <1504604498-26048-2-git-send-email-zlliu@suse.com> <20171005114430.GA24654@proton.igk.intel.com> <674a1606-c3cb-3043-165c-1ca5400a4626@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <674a1606-c3cb-3043-165c-1ca5400a4626@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Tomasz Majchrzak <tomasz.majchrzak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Jes Sorensen <jes.sorensen@gmail.com>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 09 2017, Zhilong Liu wrote:

> On 10/05/2017 07:44 PM, Tomasz Majchrzak wrote:
>> On Tue, Sep 05, 2017 at 05:41:36PM +0800, Zhilong Liu wrote:
>>> Grow: Changing component size must be larger than current
>>> chunk size against stripe raids, otherwise Grow_reshape()
>>> would set s->size to '0'.
>>>
>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>> ---
>>>   Grow.c | 6 ++++++
>>>   1 file changed, 6 insertions(+)
>>>
>>> diff --git a/Grow.c b/Grow.c
>>> index 534ba80..f0a21ff 100644
>>> --- a/Grow.c
>>> +++ b/Grow.c
>>> @@ -1816,6 +1816,12 @@ int Grow_reshape(char *devname, int fd,
>>>   		return 1;
>>>   	}
>>>=20=20=20
>>> +	if (array.level > 1 &&
>>> +	   (array.chunk_size / 1024) > (int)s->size) {
>>> +		pr_err("component size must be larger than chunk size.\n");
>>> +		return 1;
>>> +	}
>>> +
>>>   	st =3D super_by_fd(fd, &subarray);
>>>   	if (!st) {
>>>   		pr_err("Unable to determine metadata format for %s\n", devname);
>>> --=20
>>> 2.6.6
>>
>> Hi Zhilong Liu,
>>
>> Above patch has broken RAID level conversion:
>>
>> Before the patch:
>>
>> mdadm --create /dev/md/raid --level=3D10 --raid-devices=3D4 /dev/nvme0n1
>> /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 --run --assume-clean
>> MDADM_EXPERIMENTAL=3D1 mdadm --grow /dev/md/raid --level=3D0
>> mdadm: level of /dev/md/raid changed to raid0
>>
>> After the patch:
>>
>> mdadm --create /dev/md/raid --level=3D10 --raid-devices=3D4 /dev/nvme0n1
>> /dev/nvme1n1 /dev/nvme2n1 /dev/nvme3n1 --run --assume-clean
>> MDADM_EXPERIMENTAL=3D1 mdadm --grow /dev/md/raid --level=3D0
>> mdadm: component size must be larger than chunk size.
>>
>> Could you take a look at it, please?
>
> Hi, Tomek;
>    I just back from vacation, and this is very important info for me,=20
> thanks very much.
> Against this issue, the codes should be proper like:
>
> diff --git a/Grow.c b/Grow.c
> index 1149753..180fd78 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -1814,7 +1814,8 @@ int Grow_reshape(char *devname, int fd,
>          }
>
>          if (array.level > 1 &&
> -          (array.chunk_size / 1024) > (int)s->size) {
> +          (array.chunk_size / 1024) > (int)s->size &&
> +           s->level =3D=3D UnSet) {
>                  pr_err("component size must be larger than chunk size.\n=
");
>                  return 1;
>          }

I think the correct fix for this bug is to add a test for "s->size > 0".
if "s->size =3D=3D 0", no size change has been requested.

NeilBrown

>
> Is this changing good for you? Any ideas is very welcome.
>
> Thanks,
> -Zhilong
>
>> Thanks,
>>
>> Tomek
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnbVMYACgkQOeye3VZi
gbkOKhAAk2soOW/UFZSzl7HcisPme/QUuytj3dLn1Gdzcko3ncVYApIdWBBmh1bw
t50IimDRVl8JUsMJeP1Vnou6GztGtVsPbhOPB3wkGyvXvgIgdLPWFhUvZOTzdsAT
kDtwOzA90gEnUCqBTieIQPgEceJ50NwviSLudPvoXsC2fLq9A8oWN4qDy+Av0Dvg
+Dm5C+HZlLWPM6kQB+rnUZucsNbovO2aCcbOpKx8WpsP170YnCcm53GVD4pjCMD7
Ci2mTfk7EU0wofvtFKEtvwgyNFEzihFkKpGm+I39hL7ygWeTEC5mn+WkuZMGp319
fUJni+qrdj9qw7DP8g1OJGBBH9WJDBKrPH83u1yw4hOh5M4ihLBY3gQrgg4tioXY
6QSQ9ejnzHWrLHyiUlQnD5lSRWHJz5T6K4wlUVqf6s2AR0WnUC3WhARQjQjbgWbX
XvdWIB322xyBjxoM4W43Y8cpu5tmadqdP+gFvN/mxeXMp01urtVEb0M+Ayj2gj4x
HkLqWDRqCcD3HjLfO2aTVim4HJy5a8eZZgOyeE16JFpSl/FqcnFoywdwM1dqnzVI
kQ/nvRsXT912m94heH72pnOC38IStFQ4wsIw9b24AxX0RUKA6gJuHWvPLzftf3RM
Y0G9gn+S6ep62n8dLSEnh5wiO0WBQsNFZq41sieuw+R3gO7ANOI=
=Logu
-----END PGP SIGNATURE-----
--=-=-=--
