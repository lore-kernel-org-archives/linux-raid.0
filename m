From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] drivers/md/md.c: ignore recovery_offset if bitmap exists
Date: Fri, 30 Oct 2015 13:51:02 +1100
Message-ID: <87r3kdvzl5.fsf@notabene.neil.brown.name>
References: <1438111733-17778-1-git-send-email-nate.dailey@stratus.com> <55B93B9D.5000103@stratus.com> <55CE0207.1020707@stratus.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55CE0207.1020707@stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nate Dailey <nate.dailey@stratus.com>, linux-raid@vger.kernel.org
Cc: Jes.Sorensen@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 15 2015, Nate Dailey wrote:

> I hate to nag... but looking for feedback on this change, which addresses=
 what=20
> seems to me to be a serious bug.

Being a nag is good.  I don't have the earlier emails in my inbox - I
wonder what happened to them.... and for some reason this one was marked
"read".
But it arrived about when I converted over to notmuch and just before I
went on 3 weeks leave...

Anyway, Jes just poked me so I'm looking now.

>
> Thanks,
> Nate
>
>
>
>
> On 07/29/2015 04:46 PM, Joe Lawrence wrote:
>> On 07/28/2015 03:28 PM, Nate Dailey wrote:
>>> If a bitmap recovery is interrupted and later restarted, then
>>> sectors below the recovery offset, written between interruption
>>> and resumption, will not be copied. This results in corruption.
>>>
>>> See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D777511
>>> for a script that can be used to repro this.
>>>
>>> Seems like ignoring the recovery_offset if a bitmap exists is
>>> the way to go.

This doesn't feel like the right solution.
Why does the presence of a bitmap affect the validity of
=2D>recovery_offset.

Surely recovery_offset should always be reliable and we should always
use it.  Maybe it isn't being updated correctly in some situation when a
bitmap is present.

Does it ever make sense to honour the recovery-offset when a device is
re-added?
I don't think it does....

Oh.  Look what I found.
commit 7eb418851f3278de67126ea0c427641ab4792c57
Author: NeilBrown <neilb@suse.de>
Date:   Tue Jan 14 15:55:14 2014 +1100

    md: allow a partially recovered device to be hot-added to an array.

...
=2D               rdev->recovery_offset =3D 0;
+               if (rdev->saved_raid_disk < 0)
+                       rdev->recovery_offset =3D 0;


we used to clear recovery_offset for a re-add, but we don't any more.
I guess this patch introduced the bug.

I cannot find anything in my mail logs to suggest why I wrote that
patch.

Right now I cannot think of any real justification for that patch.
Could someone please test to see if reverting that patch fixes the
problem?

sorry for the delay in getting to this.

Thanks.
NeilBrown



>>>
>>> Signed-off-by: Nate Dailey <nate.dailey@stratus.com>
>>> ---
>>>   drivers/md/md.c | 24 +++++++++++++-----------
>>>   1 file changed, 13 insertions(+), 11 deletions(-)
>>>
>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>> index 0c2a4e8..79c6285 100644
>>> --- a/drivers/md/md.c
>>> +++ b/drivers/md/md.c
>>> @@ -7738,16 +7738,18 @@ void md_do_sync(struct md_thread *thread)
>>>   	else {
>>>   		/* recovery follows the physical size of devices */
>>>   		max_sectors =3D mddev->dev_sectors;
>>> -		j =3D MaxSector;
>>> -		rcu_read_lock();
>>> -		rdev_for_each_rcu(rdev, mddev)
>>> -			if (rdev->raid_disk >=3D 0 &&
>>> -			    !test_bit(Faulty, &rdev->flags) &&
>>> -			    !test_bit(In_sync, &rdev->flags) &&
>>> -			    rdev->recovery_offset < j)
>>> -				j =3D rdev->recovery_offset;
>>> -		rcu_read_unlock();
>>> -
>>> +		/* we don't use the offset if there's a bitmap */
>>> +		if (!mddev->bitmap) {
>>> +			j =3D MaxSector;
>>> +			rcu_read_lock();
>>> +			rdev_for_each_rcu(rdev, mddev)
>>> +				if (rdev->raid_disk >=3D 0 &&
>>> +				    !test_bit(Faulty, &rdev->flags) &&
>>> +				    !test_bit(In_sync, &rdev->flags) &&
>>> +				    rdev->recovery_offset < j)
>>> +					j =3D rdev->recovery_offset;
>>> +			rcu_read_unlock();
>>> +		}
>>>   		/* If there is a bitmap, we need to make sure all
>>>   		 * writes that started before we added a spare
>>>   		 * complete before we start doing a recovery.
>>> @@ -7756,7 +7758,7 @@ void md_do_sync(struct md_thread *thread)
>>>   		 * recovery has checked that bit and skipped that
>>>   		 * region.
>>>   		 */
>>> -		if (mddev->bitmap) {
>>> +		else {
>>>   			mddev->pers->quiesce(mddev, 1);
>>>   			mddev->pers->quiesce(mddev, 0);
>>>   		}
>>>
>> [+cc Ben & Cyril from the Debian bug report]
>>
>> -- Joe
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWMtsWAAoJEDnsnt1WYoG5Zu0QAIJNOEE2oIcqIFHnnaQQoBtz
3swb5/pyoGROOyfm/lMU2WXqP3f7lnzZPsYhnFmUCUMhXYpn4Z+F8oViDxNi2KUc
w6dna9ePz4uK9iTgJZxIpvoDbSGHp3E97aGq9HxDtVEszcyTk7JlWD9YiuQkxw+0
2VAD+JvyY5HZ4YXXaLW5pHO8ofgG2lHgNy/GT75eUXkNZsXISdIl8Kv6EXPnsD0V
nmSZHFn9qhcKV1COZsKCCiv5ozzVzne3EjY9F4jzpxY8/xLwlr3QKPOANmyzPNKr
3Au6fhfoXv/wbG9RH8s9ZUtc09EbUrP+nxRSbB6AeMn3sBfUNInnW+E3GEiplAEB
rAzHGBpXdgL5GZrbNO2xo1/hSieYRtbr9zTzHuBEsEGd8NgWDiIR3Ww2Je/bekzJ
nJlePY3QliAs4dbPfIe0aUjcDVdwjIyyH/u985muQQ2ch8kczU0YK/kH0EZ44UGs
mqGUy2d8Vt/lRMpyB8HPOQeeQXyJkAm7u+9sfyRbAmR2Ohpb/N2JSSMi8duc87z8
rFHV1NvqOn/tNt/NQOm+h6jTs+vx8fXsh5KzEa3dh3uly5bh/4XCTQJCoUHV24cM
j7LNb4/6ZNMAg5+oC6A/xLtiJYa0YXEG9QmBJvEDmQ4HXAJfOE/m1t5aTHtCOdXm
KgebpvRRb/VXXQE2ec2v
=Foy/
-----END PGP SIGNATURE-----
--=-=-=--
