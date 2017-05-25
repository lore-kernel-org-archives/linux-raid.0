From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v4] super1: fix sb->max_dev when adding a new disk in linear array
Date: Thu, 25 May 2017 10:32:24 +1000
Message-ID: <87efvdixnr.fsf@notabene.neil.brown.name>
References: <20170522061612.29410-1-lzhong@suse.com> <87d1b1jgju.fsf@notabene.neil.brown.name> <20e71aa6-e9e0-312f-747a-d25b872d2af8@suse.com> <87k257hv9t.fsf@notabene.neil.brown.name> <65768bfe-b94c-0382-4085-c46ff5aeb732@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <65768bfe-b94c-0382-4085-c46ff5aeb732@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Wed, May 24 2017, Lidong Zhong wrote:

> On 05/24/2017 09:57 AM, NeilBrown wrote:
>>>>
>>> I think it's also pointless to assign MD_DISK_ROLE_SPARE
>>> since there is no SPARE in dev_roles when we need to update
>>> sb->max_dev. The newly added device will not meet the condition
>>> as max_dev has already been updated, that's saying, we only
>>> need to update the max_dev value for original disks.
>>> The following code should work
>>>
>>> 1297     } else if (strcmp(update, "linear-grow-update") =3D=3D 0) {
>>> 1298         unsigned int max =3D __le32_to_cpu(sb->max_dev);
>>> 1299         sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
>>> 1300         sb->dev_roles[info->disk.number] =3D
>>> 1301             __cpu_to_le16(info->disk.raid_disk);
>>> 1302         if (info->array.raid_disks > max) {
>>>
>>>
>>> 1303             sb->max_dev =3D __cpu_to_le32(max+1);
>>> 1304         }
>>
>> Increasing max_dev and not initializing will leave the last entry in
>> dev_roles[] uninitialised.  That isn't good.
>>
> Hi Neil,
>
> As I can see, the dev_roles[] value has already been set by line 1300,
> because only one disk could be added to the linear array at one time.
> When info->array.raid_disks is large than max,
> info->disk.number should be equal to max now.
> If changing the source into
>
> 1297     } else if (strcmp(update, "linear-grow-update") =3D=3D 0) {
> 1298         unsigned int max =3D __le32_to_cpu(sb->max_dev);
> 1299         sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
> 1300         if (info->array.raid_disks > max) {
> 1301             sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
> 1302             sb->max_dev =3D __cpu_to_le32(max+1);
> 1303         }
> 1304         sb->dev_roles[info->disk.number] =3D=20
>=20=20
>
> 1305             __cpu_to_le16(info->disk.raid_disk);
>
> it still works, but I don't see it as necessary.

Yes, you are right, sorry.  My mistake.
No need to change dev_roles in linear-grow-update other than
info->disk.number.
Only changed needed there is to make sure max_dev is correct.

>> MD_DISK_ROLE_SPARE doesn't mean there is a spare device in that slot.
>> It means that if there is a device in that slot, it must be spare.
>> If you leave it uninitialised, it will probably be zero, and then
>> you will get "?" in the mdadm output again.
>>
>
> I did a test with growing a linear array to 129 devices

Thanks for doing that!!  Testing like this helps confirm our understanding.

Thanks,
NeilBrown

>
> /dev/dm-128:
>            Magic : a92b4efc
>          Version : 1.2
>      Feature Map : 0x0
>       Array UUID : 8bed7e5c:1acea7d9:9087c183:77f44fc0
>             Name : sles12sp2-clone1:0  (local to host sles12sp2-clone1)
>    Creation Time : Wed May 24 16:56:10 2017
>       Raid Level : linear
>     Raid Devices : 129
>
>   Avail Dev Size : 106400 (51.95 MiB 54.48 MB)
>    Used Dev Size : 0
>      Data Offset : 96 sectors
>     Super Offset : 8 sectors
>     Unused Space : before=3D8 sectors, after=3D0 sectors
>            State : clean
>      Device UUID : 47dec6cb:e84ddc52:35f7290b:7c47a1c6
>
>      Update Time : Wed May 24 16:56:10 2017
>    Bad Block Log : 512 entries available at offset 72 sectors
>         Checksum : 57c7a375 - correct
>           Events : 0
>
>         Rounding : 0K
>
>     Device Role : Active device 128
>     Array State :=20
> AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=
AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=20
> ('A' =3D=3D active, '.' =3D=3D missing, 'R' =3D=3D replacing)
> Debug Array State (raid_disks 129, delta_extra 0) :
> dev_roles[0]:0 dev_roles[1]:1 dev_roles[2]:2 dev_roles[3]:3=20
> dev_roles[4]:4 dev_roles[5]:5 dev_roles[6]:6 dev_roles[7]:7=20
> dev_roles[8]:8 dev_roles[9]:9 dev_roles[10]:a dev_roles[11]:b=20
> dev_roles[12]:c dev_roles[13]:d dev_roles[14]:e dev_roles[15]:f=20
> dev_roles[16]:10 dev_roles[17]:11 dev_roles[18]:12 dev_roles[19]:13=20
> dev_roles[20]:14 dev_roles[21]:15 dev_roles[22]:16 dev_roles[23]:17=20
> dev_roles[24]:18 dev_roles[25]:19 dev_roles[26]:1a dev_roles[27]:1b=20
> dev_roles[28]:1c dev_roles[29]:1d dev_roles[30]:1e dev_roles[31]:1f=20
> dev_roles[32]:20 dev_roles[33]:21 dev_roles[34]:22 dev_roles[35]:23=20
> dev_roles[36]:24 dev_roles[37]:25 dev_roles[38]:26 dev_roles[39]:27=20
> dev_roles[40]:28 dev_roles[41]:29 dev_roles[42]:2a dev_roles[43]:2b=20
> dev_roles[44]:2c dev_roles[45]:2d dev_roles[46]:2e dev_roles[47]:2f=20
> dev_roles[48]:30 dev_roles[49]:31 dev_roles[50]:32 dev_roles[51]:33=20
> dev_roles[52]:34 dev_roles[53]:35 dev_roles[54]:36 dev_roles[55]:37=20
> dev_roles[56]:38 dev_roles[57]:39 dev_roles[58]:3a dev_roles[59]:3b=20
> dev_roles[60]:3c dev_roles[61]:3d dev_roles[62]:3e dev_roles[63]:3f=20
> dev_roles[64]:40 dev_roles[65]:41 dev_roles[66]:42 dev_roles[67]:43=20
> dev_roles[68]:44 dev_roles[69]:45 dev_roles[70]:46 dev_roles[71]:47=20
> dev_roles[72]:48 dev_roles[73]:49 dev_roles[74]:4a dev_roles[75]:4b=20
> dev_roles[76]:4c dev_roles[77]:4d dev_roles[78]:4e dev_roles[79]:4f=20
> dev_roles[80]:50 dev_roles[81]:51 dev_roles[82]:52 dev_roles[83]:53=20
> dev_roles[84]:54 dev_roles[85]:55 dev_roles[86]:56 dev_roles[87]:57=20
> dev_roles[88]:58 dev_roles[89]:59 dev_roles[90]:5a dev_roles[91]:5b=20
> dev_roles[92]:5c dev_roles[93]:5d dev_roles[94]:5e dev_roles[95]:5f=20
> dev_roles[96]:60 dev_roles[97]:61 dev_roles[98]:62 dev_roles[99]:63=20
> dev_roles[100]:64 dev_roles[101]:65 dev_roles[102]:66 dev_roles[103]:67=20
> dev_roles[104]:68 dev_roles[105]:69 dev_roles[106]:6a dev_roles[107]:6b=20
> dev_roles[108]:6c dev_roles[109]:6d dev_roles[110]:6e dev_roles[111]:6f=20
> dev_roles[112]:70 dev_roles[113]:71 dev_roles[114]:72 dev_roles[115]:73=20
> dev_roles[116]:74 dev_roles[117]:75 dev_roles[118]:76 dev_roles[119]:77=20
> dev_roles[120]:78 dev_roles[121]:79 dev_roles[122]:7a dev_roles[123]:7b=20
> dev_roles[124]:7c dev_roles[125]:7d dev_roles[126]:7e dev_roles[127]:7f=20
> dev_roles[128]:80
>
> And there is no problem showing the status.
>
> Thanks,
> Lidong
>> NeilBrown
>>
>>
>>>
>>> Thank you for your patient review.
>>>
>>> Lidong
>>>
>>>> NeilBrown
>>>>
>>>>
>>>>> +			sb->max_dev =3D __cpu_to_le32(max+1);
>>>>> +		}
>>>>>  	} else if (strcmp(update, "resync") =3D=3D 0) {
>>>>>  		/* make sure resync happens */
>>>>>  		sb->resync_offset =3D 0ULL;
>>>>> --
>>>>> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkmJhgACgkQOeye3VZi
gbknhw//fOaW9O26Uhlvkd1f+d1ie0oI0s+7H6pp4ypAs6wiyhDzj/TwWQ+6llhA
sKZeQgCBNxx4K3NCUianITzw2QuxTMvmmSX3VN1v9ZbZucgCU8UI57zG84uK6q3C
HF42qbKeSJiMhaYDkSx17stMgy14W9wu3t+IEvNL7aKo9XGBac1q9/sF6vKGD2ax
sryykLsXXYNmKQwoS1v6uszg9Qv9GFcqMPX/rmx+pG2gaLA72ah1WI46/l1hIBqv
Xr02pgNKBTvprprnh2cjGdShUk/TMH5uuAtMe+2MuDgx2Tq8E1T3thcKTOwopZyf
LKHXOg5LrlHe+ky1HZRtLPEcGykAvXUAo2KkcicFdebiEUq5WtTzX6bgAF+YLz6y
s5kzGBZTa9UAlXeta2gSY1z53CnkD+6zEIwjzzlWev0lds2gcs5YPJXwM+2BJRT0
ZfegEE3OHOksPZ5OslfQhz/HD/6ll+hj1yv6/xzutP5lKJQyTIqNClddH6X0FHNQ
IzRdUJ4JJWruK7e6PhzE0t8WHw8kmdruFpYj3PezLhNmj3iuVva0Gulin7RPKICG
YFvMQkajBACLx6ov1BokjOb4W2pp7BPKom+LBDBsZU6EygEa5lwoJzPaHcDZfc0E
BPwWLp2T+ONU/QbxsTMjngSkTmsKB+JcgboYkmMX0scBRKGoR/4=
=Z24Y
-----END PGP SIGNATURE-----
--=-=-=--
