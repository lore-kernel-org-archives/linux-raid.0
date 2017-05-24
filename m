From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v4] super1: fix sb->max_dev when adding a new disk in linear array
Date: Wed, 24 May 2017 11:57:02 +1000
Message-ID: <87k257hv9t.fsf@notabene.neil.brown.name>
References: <20170522061612.29410-1-lzhong@suse.com> <87d1b1jgju.fsf@notabene.neil.brown.name> <20e71aa6-e9e0-312f-747a-d25b872d2af8@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20e71aa6-e9e0-312f-747a-d25b872d2af8@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, May 23 2017, Lidong Zhong wrote:

> On 05/22/2017 07:07 PM, NeilBrown wrote:
>> On Mon, May 22 2017, Lidong Zhong wrote:
>>
>>> The value of sb->max_dev will always be increased by 1 when adding
>>> a new disk in linear array. It causes an inconsistence between each
>>> disk in the array and the "Array State" value of "mdadm --examine DISK"
>>> is wrong. For example, when adding the first new disk into linear array
>>> it will be:
>>>
>>> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>>> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>>>
>>> Adding the second disk into linear array it will be
>>>
>>> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>>> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
>>>
>>> Signed-off-by: Lidong Zhong <lzhong@suse.com>
>>> ---
>>>  super1.c | 9 ++++++++-
>>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 2fcb814..03cea72 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -1267,8 +1267,10 @@ static int update_super1(struct supertype *st, s=
truct mdinfo *info,
>>>  				break;
>>>  		sb->dev_number =3D __cpu_to_le32(i);
>>>  		info->disk.number =3D i;
>>> -		if (max >=3D __le32_to_cpu(sb->max_dev))
>>> +		if (i >=3D max) {
>>> +			sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
>>
>
> Hi Neil,
>
>> Why do you assign to dev_roles[max]?
>
> I meant to assure there will always be a spare spot in dev_roles[],
> that is sb->max_dev at least is at lease 1 more than raid_disks.
> Now I see what you mean in your reply to my last version patch.
>
>> max must equal i here, and a few lines later:
>> 		sb->dev_roles[i] =3D __cpu_to_le16(info->disk.raid_disk);
>>
>> your assignment is over-written.  So it is pointless.
>> If i was greater than max (which should be impossible), you assignment
>> here would corrupt the dev_roles table.
>>
>> Please drop this assignment.
>
> Yes, just increase the max_dev value is enough.
>
>>
>>>  			sb->max_dev =3D __cpu_to_le32(max+1);
>>> +		}
>>>
>>>  		random_uuid(sb->device_uuid);
>>>
>>> @@ -1293,9 +1295,14 @@ static int update_super1(struct supertype *st, s=
truct mdinfo *info,
>>>  			}
>>>  		}
>>>  	} else if (strcmp(update, "linear-grow-update") =3D=3D 0) {
>>> +		unsigned int max =3D __le32_to_cpu(sb->max_dev);
>>>  		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
>>>  		sb->dev_roles[info->disk.number] =3D
>>>  			__cpu_to_le16(info->disk.raid_disk);
>>> +		if (info->array.raid_disks >=3D max) {
>>
>> if raid_disks =3D=3D max there is no need to change anything.
>> It is only when raid_disks > max that you need to increase max.
>>
>
> Yes, the max_dev should only be updated when raid_disks > max.
>
>>> +			sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
>>
>> When you increase max, you do need to assign MD_DISK_ROLE_SPARE to the
>> new element, but you need to do that *before* disk.raid_disk is
>> assigned, in case info->disk.number =3D=3D max (as it could be for the
>> recently added device).
>>
> I think it's also pointless to assign MD_DISK_ROLE_SPARE
> since there is no SPARE in dev_roles when we need to update
> sb->max_dev. The newly added device will not meet the condition
> as max_dev has already been updated, that's saying, we only
> need to update the max_dev value for original disks.
> The following code should work
>
> 1297     } else if (strcmp(update, "linear-grow-update") =3D=3D 0) {
> 1298         unsigned int max =3D __le32_to_cpu(sb->max_dev);
> 1299         sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
> 1300         sb->dev_roles[info->disk.number] =3D
> 1301             __cpu_to_le16(info->disk.raid_disk);
> 1302         if (info->array.raid_disks > max) {=20
>=20=20
>
> 1303             sb->max_dev =3D __cpu_to_le32(max+1);
> 1304         }

Increasing max_dev and not initializing will leave the last entry in
dev_roles[] uninitialised.  That isn't good.

MD_DISK_ROLE_SPARE doesn't mean there is a spare device in that slot.
It means that if there is a device in that slot, it must be spare.
If you leave it uninitialised, it will probably be zero, and then
you will get "?" in the mdadm output again.

NeilBrown


>
> Thank you for your patient review.
>
> Lidong
>
>> NeilBrown
>>
>>
>>> +			sb->max_dev =3D __cpu_to_le32(max+1);
>>> +		}
>>>  	} else if (strcmp(update, "resync") =3D=3D 0) {
>>>  		/* make sure resync happens */
>>>  		sb->resync_offset =3D 0ULL;
>>> --
>>> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkk6G4ACgkQOeye3VZi
gbnsWg/8D+Q1VsOACdx+9HLqLBcICfxXorSRUPDPL+nSkBA2GiyRHJq3tCkqFVsl
zlVcpGZMuadgLQ2mNMVtR3mLV2QHvt46q2h2j4/wcNDXXMQ3LVMKwG2v3WjdPJa/
NyCQWYdzdZwoCuPb8xdix5NuGSRdQrDTOeRiHSDCMcyQBBo82sxzSmlad+sApZw8
rmsOm/+4jdlkZZQeW2k3/0vxw4Q9NUu0GdY7lAB3N+rs+Y1dTYplVto+oXXSzhVi
77fDMaOrHeaNsWrsmonOkHBrzWAHGngo/ndY8LzcYDTpBJiB92supIQuGHkGL7Jh
zDhrWOHfDuK4Uf1sqSEczKm3bvyOlALsqSFd3+m71EtiVMxajz7JtgZKfg6TgKY8
6t5UaKru2XxS+gNVnt9yjfezeZeZEjFQsXoz4NJqktfYiaBSBt2acrKrV5XP/PjQ
PN9Ns0MwOvGZ92MXRQd5HEnyUYSoCSt2AemsJqdQmxMyRCrfbhEU8xIWTtkw5i9q
kVc8dFO+LkMyyjntU+w0Xy3DutK3tMce0dAa4TS7Ahl2Qv9Q5rUXIM3LH0Sqi+54
7v5LVp0MwOXpbeeOTk60ilbbjCmy+DaYc874ljH9n2ge1wv7yb+PH3YMR/qpO1M8
9GbKhSigCquLkPAxZvS5oXpXWGO2JJBh8ZN4RWKuiAD6okUR23o=
=+ZkQ
-----END PGP SIGNATURE-----
--=-=-=--
