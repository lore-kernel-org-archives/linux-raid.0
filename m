From: Neil Brown <neilb@suse.de>
Subject: Re: Bad raid0 bio too large problem
Date: Fri, 25 Sep 2015 14:23:50 +1000
Message-ID: <87h9mjunxl.fsf@notabene.neil.brown.name>
References: <wrfjoagucvyq.fsf@redhat.com> <87k2rhyiqe.fsf@notabene.neil.brown.name> <wrfjvbb12xl8.fsf@redhat.com> <87io70wmst.fsf@notabene.neil.brown.name> <wrfjwpvgvupf.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <wrfjwpvgvupf.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid <linux-raid@vger.kernel.org>, yizhan@redhat.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Jes Sorensen <Jes.Sorensen@redhat.com> writes:

> Neil Brown <neilb@suse.de> writes:
>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>
>>> Neil Brown <neilb@suse.de> writes:
>>>> Jes Sorensen <Jes.Sorensen@redhat.com> writes:
>>>>
>>>>> Hi Neil,
>>>>>
>>>>> I think we have some bad side effects with this patch:
>>>>>
>>>>> commit 199dc6ed5179251fa6158a461499c24bdd99c836
>>>>> Author: NeilBrown <neilb@suse.com>
>>>>> Date:   Mon Aug 3 13:11:47 2015 +1000
>>>>>
>>>>>     md/raid0: update queue parameter in a safer location.
>>>>>=20=20=20=20=20
>>>>>     When a (e.g.) RAID5 array is reshaped to RAID0, the updating
>>>>>     of queue parameters (e.g. max number of sectors per bio) is
>>>>>     done in the wrong place.
>>>>>     It should be part of ->run, but it is actually part of ->takeover.
>>>>>     This means it happens before level_store() calls:
>>>>>=20=20=20=20=20
>>>>>         blk_set_stacking_limits(&mddev->queue->limits);
>>>>>=20=20=20=20=20
>>>>> Running the '03r0assem' test suite fills my kernel log with output li=
ke
>>>>> below. Yi Zhang also had issues where writes failed too.
>>>>>
>>>>> robably something we need to resolve for 4.2-final or revert the
>>>>> offending patch.
>>>>>
>>>>> Cheers,
>>>>> Jes
>>>>>
>>>>> md: bind<loop0>
>>>>> md: bind<loop1>
>>>>> md: bind<loop2>
>>>>> md/raid0:md2: md_size is 116736 sectors.
>>>>> md: RAID0 configuration for md2 - 1 zone
>>>>> md: zone0=3D[loop0/loop1/loop2]
>>>>>       zone-offset=3D         0KB, device-offset=3D         0KB, size=
=3D     58368KB
>>>>>
>>>>> md2: detected capacity change from 0 to 59768832
>>>>> bio too big device loop0 (296 > 255)
>>>>> bio too big device loop0 (272 > 255)
>>>>
>>>> 1/ Why do you blame that particular patch?
>>>>
>>>> 2/ Where is that error message coming from?  I cannot find "bio too bi=
g"
>>>>   in the kernel (except in a comment).
>>>>   Commit: 54efd50bfd87 ("block: make generic_make_request handle
>>>> arbitrarily sized bios")
>>>>   removed the only instance of the error message that I know of.
>>>>
>>>> Which kernel exactly are you testing?
>>>
>>> I blame it because of bisect - I revert that patch and the issue goes
>>> away.
>>>
>>> I checked out 199dc6ed5179251fa6158a461499c24bdd99c836 in Linus' tree,
>>> see the bio too large. I revert it and it goes away.
>>
>> Well that's pretty convincing - thanks.
>> And as you say - it is tagged for -stable so really needs to be fixed.
>>
>> Stares at the code again.  And again.
>>
>> Ahhh.  that patch moved the
>>   blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
>> to after
>>  disk_stack_limits(...);
>>
>> That is wrong.
>>
>> Could you confirm that this fixes your test?
>
> I refuse to do that! .... since Xiao beat me to it! Thanks!
>
> I was half way bisecting my way through it last night. For some reason
> the problem was reproducible in 4.2 if I applied the offending patch,
> but not in 4.3-rc2.
>
> Any chance you'll push these to your git tree in the near future?

Pushed.
Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWBMxWAAoJEDnsnt1WYoG5aXsP/2AlRFU4PHMdn2ALJDhwMmIf
CtHA1M1CmPz95Gucn4xN1yW58MdvUxkTa4Nb85FlUQmK6idS/l2jdMsQZIkGid/3
vOd7JKE+oEQWQj6H3K6Pf2UxY3NHptcVWAojj+X7a/mg+zVOz+UZQdFpNCEhgFd4
18I5GYUZxYImRSy+Llv8g3oFru2X6xOqLGaq1txUw4u7S1dQkcOYJ+SrH4mqSg6E
1T66UyDNuSD9ZNsx2SnNPUyJP3e8D7B7bCsJYN42zSxmPa+DoJ65eG50kR3AOFh+
Q/PFVBkZHq/AjbmWxDsUEtTss1A/Qn7WJNpyOiifkJMMjmJjV+B9OLzWVWUQ7/wu
bWsLXVimLdfZWBZK+Q2/rw8rZ/puxav9BEqBKyXXjlkTwnRlAApUm1Id8JI0LpnI
vgQQ35Mex/dbok9RhNlPWtL4DsUgj5GnzmhcREnqI1z6cYVSxxwAQBgp2sPkTJMb
01AWxLZFNd3lWECLq4gp1QJEAiqI7cZ6obT7d5A/1LFIDN8lPEzN8NG3C9XElfNJ
MzY/bZ85BuqvVsK6iJT22wTcfq17yFSs7EcXmVSA5Dwd+fK1pmVfbXDmQt8mukzI
5vWgoJPnl4nSh5eYXBGjf1sGExEgjKBycbvOGZhUsQ5X3JofIdtlKvhLvxxQH+QJ
WhWMAefg7KmG63+uhklK
=7ORw
-----END PGP SIGNATURE-----
--=-=-=--
