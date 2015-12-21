From: NeilBrown <nfbrown@novell.com>
Subject: Re: RESYNC Bug ? [was Re: Stop resync operation]
Date: Mon, 21 Dec 2015 15:09:22 +1100
Message-ID: <87poy04f4d.fsf@notabene.neil.brown.name>
References: <CAF8SPVJigc-NjeEZVinzx1YFLE6CjMBBMNpxjSzpsi_bi2kovg@mail.gmail.com> <564171DE.3020808@gmail.com> <CAF8SPVK_S0QGETNvZacmnN7Y=T0d0MFYWZsEWEke1sHf=YHX-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF8SPVK_S0QGETNvZacmnN7Y=T0d0MFYWZsEWEke1sHf=YHX-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: d4lamar <d4lamar@gmail.com>, Anugraha Sinha <asinha.mailinglist@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Tue, Nov 10 2015, d4lamar wrote:

> 2015-11-10 5:26 GMT+01:00 Anugraha Sinha <asinha.mailinglist@gmail.com>:
>> Hi,
>>
>> Could you share your kernel version and mdadm package version, please?
>
> Of course.
>
> 2.6.32-220.7.1.el6.lustre.4033.x86_64

This is a Redhat kernel based on a very old mainline kernel.
You are experiencing a kernel bug (which seems vaguely familiar by I
don't recall the details).
To get support for a Redhat kernel, you need to talk to Redhat.
If you want help here, you need to be running a kernel must closer to
current mainline.  It doesn't have to be the very latest, but something
released in the last year would be best.

NeilBrown



> mdadm-3.2.2-9.xrtx.5.x86_64
>
> Thanks,
> d4lamar
>
>> On 11/10/2015 1:13 PM, d4lamar wrote:
>>>
>>> Dear Developers,
>>>
>>> I am here again to ask you support about RESYNC operation.
>>> In my first mail I asked if there were any method to stop a running
>>> RESYNC.
>>>
>>> Now I am experiencing a very strange behaviour... RESYNC operation
>>> exceeded 100% completion percentage...
>>>
>>> # cat /proc/mdstat
>>> Tue Nov 10 05:02:41 CET 2015
>>> Personalities : [raid1] [raid10] [linear]
>>> md66 : active linear md0[0]
>>> 2939452080 blocks super 1.2 4k rounding
>>>
>>> md0 : active raid10 sdab[17](S) sdt[16](S) sdaj[0] sdx[12] sdai[11]
>>> sdah[9] sdam[15] sdae[7] sdas[6] sdaa[5] sdap[4] sdao[3] sdaf[14]
>>> sdz[1]
>>> 2939453104 blocks super 1.2 4K chunks 2 near-copies [14/12]
>>> [UUUUUUUUUU_UU_]
>>> [=========================>] resync =129.9% (545894292/419921872)
>>> finish=20192933978332.0min speed=7612K/sec
>>> bitmap: 22/22 pages [88KB], 65536KB chunk
>>>
>>> md65 : active raid1 sdal[0] sdar[1]
>>> 419921875 blocks super 1.2 [2/2] [UU]
>>> bitmap: 0/4 pages [0KB], 65536KB chunk
>>>
>>> unused devices: <none>
>>>
>>> Are you aware of such possible behaviour ? Do you think I have just hit a
>>> BUG ?
>>>
>>> Thanks and Best Regards,
>>> d4lamar
>>>
>>> 2015-11-06 7:44 GMT+01:00 d4lamar <d4lamar@gmail.com>:
>>>>
>>>> Dear Developers,
>>>>
>>>> I have a question for you.
>>>>
>>>> I have a raid10 md array:
>>>>
>>>> Is it theoretically possible to stop a running resync operation and
>>>> mark the array as clean without stopping the array ?
>>>>
>>>> I do not want the resync to be respawned automatically.
>>>>
>>>> Thanks and Best Regards,
>>>> d4lamar
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWd3tyAAoJEDnsnt1WYoG5vCQP/iSpx0vVaOEG9FhCdf6ibIJS
JJEH2P4nEJCzVxcfeCT0fROJ+CAFuIHt82zgCHclQ+FxLMt+0qrGoJCFx3sjjwch
nnOpi+uLcyz9R7bSbve9+kWvkeXfkE0pP1G+YIkUsLd2KRfjlwhdPZRksDubZn3a
gWMrDWmPL2zMEAaOJiBdJlTpYsHHm40lZ0XtH7fVSrkMwhl49rgeK9GTUxNZDude
uNwQthBVAncBKBonXIDYtnhAnN03sUu9rsBiNkQEtL45svZBP9eERrSsWfOPsOlR
uMyx+/4UO89XurOaxsjUPIvH+m1rVAl1zndcMmkKDOKc+rrwO12SvPYaEZLZhvNE
d9MVmrFFabhZxpCUhC8OL2MarA8wzbp5RODDtvAxZfcSY0/eAkvkUzYCJhRGf85p
qVK9+kCVaJBhhAzQJyICKNqhweBoI+5KKhHLaOHspM4QhRfx8snsxck0yD1xBrMl
56mKZuzAutcBUrvoyxtC2f8G3df6K2w6R4Fs1FU3zS65le0WxyfNUuIjVIevaStJ
RrTp4xNsf0Z//U7Mb020EC+oalB/djirw51p3zr8PW3wEvze5ZekB2RRaeh28u72
ASvz6Os9AUKG0/Hib62/TD3UwzTRBxrw1U/kQg3eX0we0gLo6l3lOXWZmVWfk8hF
kX7Z793nFAWYH1nQFdhQ
=lgvs
-----END PGP SIGNATURE-----
--=-=-=--
