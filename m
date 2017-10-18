From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] md: create new workqueue for object destruction
Date: Wed, 18 Oct 2017 18:29:08 +1100
Message-ID: <87h8uwj4mz.fsf@notabene.neil.brown.name>
References: <87mv4qjrez.fsf@notabene.neil.brown.name> <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20171018062137.ssdhwkeoy6fdp7yq@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 17 2017, Shaohua Li wrote:

> On Tue, Oct 17, 2017 at 04:04:52PM +1100, Neil Brown wrote:
>>=20
>> lockdep currently complains about a potential deadlock
>> with sysfs access taking reconfig_mutex, and that
>> waiting for a work queue to complete.
>>=20
>> The cause is inappropriate overloading of work-items
>> on work-queues.
>>=20
>> We currently have two work-queues: md_wq and md_misc_wq.
>> They service 5 different tasks:
>>=20
>>   mddev->flush_work                       md_wq
>>   mddev->event_work (for dm-raid)         md_misc_wq
>>   mddev->del_work (mddev_delayed_delete)  md_misc_wq
>>   mddev->del_work (md_start_sync)         md_misc_wq
>>   rdev->del_work                          md_misc_wq
>>=20
>> We need to call flush_workqueue() for md_start_sync and ->event_work
>> while holding reconfig_mutex, but mustn't hold it when
>> flushing mddev_delayed_delete or rdev->del_work.
>>=20
>> md_wq is a bit special as it has WQ_MEM_RECLAIM so it is
>> best to leave that alone.
>>=20
>> So create a new workqueue, md_del_wq, and a new work_struct,
>> mddev->sync_work, so we can keep two classes of work separate.
>>=20
>> md_del_wq and ->del_work are used only for destroying rdev
>> and mddev.
>> md_misc_wq is used for event_work and sync_work.
>>=20
>> Also document the purpose of each flush_workqueue() call.
>>=20
>> This removes the lockdep warning.
>
> I had the exactly same patch queued internally,

Cool :-)

>                                                   but the mdadm test suit=
e still
> shows lockdep warnning. I haven't time to check further.
>

The only other lockdep I've seen later was some ext4 thing, though I
haven't tried the full test suite.  I might have a look tomorrow.
Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnnAsYACgkQOeye3VZi
gbmmCw/+JhV+Ovu0EBmOJK4L9tWZE1PpZTnxV6UZNovov9eM+qMDPuAfrjldtrjq
b7nQuzg4zTO8IhBDOzy16y5e2MTR3ZvCW5WCsnjGDbxYdeiJGM35YYYUXlgpe163
ZqH6fOSYTF4w50sz+m9o9OczTBshGkbdSO4tMBcohhx49kYRdYAlDkcGL51sOoWo
2teoiaAlYC2eW1H+8YudDO8r8lIgwlw7aNTzEHmyFTVID1Hzv2SxWOJSsW76Dhqz
TASm//klDJk6GkRnCYcVIFs9FR2WlaGWN6powhu4cXPDS2TdpCjtkjHncBWGxRj6
Z1Qp1VYwexoJGllr49jsTxt99ywIvfAjFbq/8Uw25zoI8q/02bPxaduHiZm8PNTG
w3FOTyK1bR2wn+szvdWhxwynztELQZfhIl4dEturecieC/8Z/ipv112pTBucn4b6
afijvOfZxivykuNeQcRW/EsgcKFt7sOpq0naTgHkijt4UAgw6mjAVKbBruRxPzxk
7QxY4/y4lvyQHIuJ4zOmlHM++7gpL/l7bG2/RychAY8iWqib+fsSJF9EhHL+h6t2
yfylt2s0mGavYhcQH7yKb6x6SiCbly22mCE3m3za2Cn231KwFLlhZmCLozx3OlqL
I0b1BnA9NoYkjeiikn3z/vQzpmsosBqBV969mvMvdvXwvV55J8o=
=RKlz
-----END PGP SIGNATURE-----
--=-=-=--
