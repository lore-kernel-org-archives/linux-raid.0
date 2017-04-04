From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v1] mdadm/grow: reshape would be stuck from raid1 to raid5
Date: Tue, 04 Apr 2017 16:30:59 +1000
Message-ID: <877f30k7ks.fsf@notabene.neil.brown.name>
References: <wrfjk27aid6n.fsf@gmail.com> <20170330073808.6176-1-zlliu@suse.com> <87d1cukszu.fsf@notabene.neil.brown.name> <5B908F2B-D84A-4C4E-A0C6-863B6E793D75@suse.com> <99E3B202-848D-49F2-BC8A-966A631DE508@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <99E3B202-848D-49F2-BC8A-966A631DE508@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong <zlliu@suse.com>
Cc: Jes.Sorensen@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 04 2017, Zhilong wrote:

> Send from iPhone
>
>> =E5=9C=A8 2017=E5=B9=B44=E6=9C=884=E6=97=A5=EF=BC=8C13:07=EF=BC=8CZhilon=
g <zlliu@suse.com> =E5=86=99=E9=81=93=EF=BC=9A
>>=20
>>=20
>>=20
>> Send from iPhone
>>=20
>>>> =E5=9C=A8 2017=E5=B9=B44=E6=9C=883=E6=97=A5=EF=BC=8C12:36=EF=BC=8CNeil=
Brown <neilb@suse.com> =E5=86=99=E9=81=93=EF=BC=9A
>>>>=20
>>>> On Thu, Mar 30 2017, Zhilong Liu wrote:
>>>>=20
>>>> systemctl doesn't interpret mdadm-grow-continue@.service
>>>> correctly due to the wrong argument provided in [service],
>>>> it should be corrected %I as %i. Otherwise, if the service
>>>> cannot start by systemctl and the reshap progress would be
>>>> stuck all time when grows array from raid1 to raid5.
>>>>=20
>>>> reproduce steps:
>>>> ./mdadm -CR /dev/md0 -l1 -b internal -n2 /dev/loop[0-1]
>>>> ./mdadm --grow /dev/md0 -l5 -n3 -a /dev/loop2
>>>>=20
>>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>>> ---
>>>> systemd/mdadm-grow-continue@.service | 2 +-
>>>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>>>=20
>>>> diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow=
-continue@.service
>>>> index 5c667d2..882bc0b 100644
>>>> --- a/systemd/mdadm-grow-continue@.service
>>>> +++ b/systemd/mdadm-grow-continue@.service
>>>> @@ -10,7 +10,7 @@ Description=3DManage MD Reshape on /dev/%I
>>>> DefaultDependencies=3Dno
>>>>=20
>>>> [Service]
>>>> -ExecStart=3DBINDIR/mdadm --grow --continue /dev/%I
>>>> +ExecStart=3DBINDIR/mdadm --grow --continue /dev/%i
>>>=20
>>> Do you know why this makes a difference?  I don't think it should.
>>> man systemd.unit says that "%i" is the "Instance name" while "%I" is the
>>> "Unescaped instance name".
>>>=20
>>> The Instance name here is something like "md0" so there is nothing to
>>> escape.
>>>=20
>>> I would rather not change it unless we know exactly why it is broken,
>>> and I don't find your explanation to be convincing.
>>>=20
>>=20
>> Exactly, you're correct, in this case, %i and %I are the same. The root =
cause is the ExecStart part, all the path name should be verified by system=
d-escape=EF=BC=8Csuch as:
>> /sbin/mdadm should be corrected as sbin-mdadm, and /dev/%I should be -de=
v-%I. Thus I'm sorry for this patch, I do agree with you not to change it. =
And say sorry to Jes.
>>=20
>
> How about modifying this patch as:
>
> ExecStart=3D-sbin-mdadm --grow --continue -dev-%I
>

Why do you think anything needs changing here?

I have a tumbleweed install with the standard
mdadm-grow-continue@.server
file. i.e.

  ExecStart=3D/sbin/mdadm --grow --continue /dev/%I=20

I run
  strace -f -s 1000 -p 1 -o /tmp/strace

in one window, then

  systemctl start mdadm-grow-continue@md0.service

in another.

Then

 grep execve /tmp/strace

shows:

18680 execve("/sbin/mdadm", ["/sbin/mdadm", "--grow", "--continue", "/dev/m=
d0"], [/* 3 vars */] <unfinished ...>

which shows that mdadm is being correctly.

There is nothing to fix here that I can see.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAljjPaMACgkQOeye3VZi
gblX0xAAj9+riFwvMsQ4xNfuxURA+KMAWKZl5haMa7kmn82tD4yMbvHv6dQ/ss4U
J71Po/vI3ZFlqU2tKh+D2EZCfpXRSpkrXcXfwA7wAlTlNQ9Av3SbRR787Kdj7oid
2XEKTiq7NMyfQ59siQg4C0jz7CKIn+izxMLAk9dghY6EJEF+4QtLIxlFkSOuuSio
3nl815clJ1o3ZE2QPf/3Gg9MBp/w5zN91TXZYr63Ajm1zdiu6zP5I+Y5szzVBlee
FbHmbgZni6WHIZL74iK58yYlHatSNX9vIwNeu86cdjhd3G5kZIgqtsSK6LhhwMxy
L4ws3APXLmCgdeijiIwN8hqW9jVsS+54OSgrq0ELazJ8BLfEfM/asChcb2Y4HwvC
LST++6ekr+4pQgSud+tHCcIakMruEvIPr6NmRTZRjrfFBZ4targlMTRpyhLwen+/
MSRoTW6tDEnq/0ephwO1vHm/itYYHR1q5vYGuhwzvnJLn0IsspCx8sfGG2cVC9zC
gYsltlaqZTfqJTRuU1IK7Z1s88tUwiaNgBtgQPNG1swrcQk7Hhw4lNX4V7x5dz3F
NjnFIja1zqa/San7+qVIBWfjl9jZKA2UgpRNDsxvpuBCWy//7URbtbeTMFLvE1Bb
IC8xjswgHGpxfxW/4HPYsXboAgfTlEvH1M5uyV1spKdovyloHPE=
=088d
-----END PGP SIGNATURE-----
--=-=-=--
