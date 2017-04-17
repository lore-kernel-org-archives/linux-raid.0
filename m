From: NeilBrown <neilb@suse.com>
Subject: Re: GET_ARRAY_INFO assumptions?
Date: Tue, 18 Apr 2017 09:48:24 +1000
Message-ID: <87k26itx2v.fsf@notabene.neil.brown.name>
References: <ab07d303-85fb-e912-e4fa-9ee66a1277cc@gmail.com> <20170413203742.wg6mrnzedw7ew5ky@kernel.org> <0c3633e4-df8c-c59a-17d4-917495931ba1@gmail.com> <c0a29266-fdf4-2f07-aabd-6aa1f55d7d46@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c0a29266-fdf4-2f07-aabd-6aa1f55d7d46@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 14 2017, Jes Sorensen wrote:

> On 04/13/2017 05:06 PM, Jes Sorensen wrote:
>> On 04/13/2017 04:37 PM, Shaohua Li wrote:
>>> On Thu, Apr 13, 2017 at 01:50:06PM -0400, Jes Sorensen wrote:
>>>> Hi Neil,
>>>>
>>>> Looking at trying to phase out the ioctl usage, I am trying to
>>>> introduce a
>>>> helper for the 'is the array valid' situation.
>>>>
>>>> Now looking at places like Incremental.c (around like 557 in my current
>>>> tree):
>>>>     /* 7b/ if yes, */
>>>>     /* - if number of OK devices match expected, or -R and there */
>>>>     /*             are enough, */
>>>>     /*   + add any bitmap file  */
>>>>     /*   + start the array (auto-readonly). */
>>>>
>>>>     if (md_get_array_info(mdfd, &ainf) =3D=3D 0) {
>>>>         if (c->export) {
>>>>             printf("MD_STARTED=3Dalready\n");
>>>>         } else if (c->verbose >=3D 0)
>>>>             pr_err("%s attached to %s which is already active.\n",
>>>>                    devname, chosen_name);
>>>>         rv =3D 0;
>>>>         goto out_unlock;
>>>>     }
>>>>
>>>> I am wondering if there are any side effects/assumptions about
>>>> GET_ARRAY_INFO that I am not considering? Basically I am making the
>>>> assumption that if /sys/block/md<X>/md exists, the array is valid.
>>>
>>> what does 'valid' really mean? md<x>/md exists after a md device is
>>> allocated,
>>> the md device might not have any under layer disks bound yet.
>>>
>>>> The code in Incremental.c already deals with sysfs higher up in the
>>>> code, so
>>>> I guess the question is if the above test is even relevant anymore?
>>>>
>>>> Alternative, do we need export a new state in sysfs 'running'?
>>>
>>> I'd assume 'running' means the md device has a personality attached. See
>>> array_state_show(), !running =3D=3D 'clear' or 'inactive'.
>>
>> Good point, I guess what I am trying to figure out is what is assumed
>> when ioctl(GET_ARRAY_INFO) returns 0 and how do we map it to sysfs?
>
> Looking some more at this, it may be simpler than I thought. How about=20
> this approach (only compile tested):
>
> int md_array_active(int fd)
> {
> 	struct mdinfo *sra;
> 	struct mdu_array_info_s array;
> 	int ret;
>
> 	sra =3D sysfs_read(fd, NULL, GET_VERSION | GET_DISKS);
> 	if (sra) {
> 		if (!sra->array.raid_disks &&
> 		    !(sra->array.major_version =3D=3D -1 &&
> 		      sra->array.minor_version =3D=3D -2))
> 			ret =3D -ENODEV;
> 		else
> 			ret =3D 0;
>
> 		free(sra);
> 	} else {
> 		ret =3D ioctl(fd, GET_ARRAY_INFO, &array);
> 	}
>
> 	return !ret;
> }
>
> Note 'major =3D -1 && minor =3D -2' is sysfs_read's way of saying 'extern=
al'.
>
> This pretty much mimics what the kernel does in the ioctl handler for=20
> GET_ARRAY_INFO:
>
> 	case GET_ARRAY_INFO:
> 		if (!mddev->raid_disks && !mddev->external)
> 			err =3D -ENODEV;
> 		else
> 			err =3D get_array_info(mddev, argp);
> 		goto out;
>
> What do you think?

I think that it accurately mimics what the current code does.
I'm not sure that is what we really want.
For testing in Incremental.c if an array is "active" we really
should be testing more than "raid_disks !=3D 0".
We should be testing, as Shaohua suggested, if
array_state !=3D 'clear' or 'inactive'.
You cannot get that info through the ioctl interface, so I suppose
I decided the current test was 'close enough'.
If we are going to stop supported kernels that don't have (e.g.)
array_state, then we should really fo the right thing and test
array_state.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlj1VEgACgkQOeye3VZi
gbkAig/9HOdSU78USKyssvcgmVkdt5jXCXuYIoFso3gQ8LFKhl5g+R2lQBdU3UOr
M1EqryUg0OXYa0ILU+s/ku1GRAWlfg+u8EvA7B6oaf1STRPJ+bq8pLjNWIgcx0Gb
mTR3YlSOHH4kZMre5FepA2i4HJbQXNyn1DgSNMDO2556jFcP+gIL4R5H3STbgOSY
p2JMHi5QNQridAyd5mvoFVg+9FHgNTwdECypmqMCdzrrjiw4puUiqOHnayWM+sNJ
06+e04tjK1PmNKLF5tzwUvUEgfHb9pdNt606g2I6hvwrgCKBmHsltz9C3i97wuLf
bE0ksvCT+3yjGxDfi3sWQw34jbjEQoQshDdLs2lBmsbKIWcEpsYulijswNK6EgP5
myr2IhSYG7GLCYDAEyGCsVfdQTQ6dNWuPvn1ghJnkP3UJQJ2H9mNMCNOZgkaAOMO
2l7I9Xwfv41c9iF84lW7eZ+ZKcCtwwmJreV+9wRvB1RvRk2OHNOcbZjS3hr/fFFw
QdKrtcOeilh9WKyJutiC1v26VydQHTkdTHknzcIar8zLyzkcd41UlhaNgj09agQf
R3gkefIxat3mH8YHDBDo1qiyfSVIlXtCqDGy2aQX2FTgT4W2m7ekLGYsNtv7wmw6
geg9Y+rE8mWe+1fwED44+a6XKg0Qr2ExlGjR7QTGzE17PuXKUv0=
=Fu6I
-----END PGP SIGNATURE-----
--=-=-=--
