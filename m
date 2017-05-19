From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH] super1: fix sb->max_dev when adding a new disk in linear array
Date: Fri, 19 May 2017 15:37:15 +1000
Message-ID: <87bmqpl850.fsf@notabene.neil.brown.name>
References: <20170516045129.21815-1-lzhong@suse.com> <87pof5laxm.fsf@notabene.neil.brown.name> <4b01d20c-be52-eaa1-6809-909fb375b274@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4b01d20c-be52-eaa1-6809-909fb375b274@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, May 19 2017, Lidong Zhong wrote:

> On 05/19/2017 12:36 PM, NeilBrown wrote:
>> On Tue, May 16 2017, Lidong Zhong wrote:
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
>>>  super1.c | 8 +++++++-
>>>  1 file changed, 7 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 87a74cb..3d49bee 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -1184,8 +1184,10 @@ static int update_super1(struct supertype *st, s=
truct mdinfo *info,
>>>  				break;
>>>  		sb->dev_number =3D __cpu_to_le32(i);
>>>  		info->disk.number =3D i;
>>> -		if (max >=3D __le32_to_cpu(sb->max_dev))
>>> +		if (i >=3D __le32_to_cpu(sb->max_dev)) {
>>
>> This change is correct - thanks.  Though
>>     if (i >=3D max) {
>>
>> might be clearer and simpler.
>>
>>
>>>  			sb->max_dev =3D __cpu_to_le32(max+1);
>>> +			sb->dev_roles[sb->max_dev] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
>>
>> This change is wrong.
>> At the very least, the dev_roles[] array needs to be indexed by a
>> host-order number, not a little-endian number.
>> But the change is not needed because dev_roles[max_dev] is never used.
>> See role_from_sb().
>> dev_rols[max_dev - 1] does need to be set, but the line
>>
>> 		sb->dev_roles[i] =3D __cpu_to_le16(info->disk.raid_disk);
>>
>> almost certainly does that.
> Hi Neil,
>
> The reason I set all the dev_roles[0~max_dev-1] is because
> the following code
>
>   552     printf("   Array State : ");
>   553     for (d =3D 0; d < __le32_to_cpu(sb->raid_disks) + delta_extra;=
=20
> d++) {
>   554         int cnt =3D 0;
>   555         unsigned int i;
>   556         for (i =3D 0; i < __le32_to_cpu(sb->max_dev); i++) {
>   557             unsigned int role =3D __le16_to_cpu(sb->dev_roles[i]);=
=20
>
>   558             if (role =3D=3D d)=20
>
>   559                 cnt++;=20
>
>   560         }

This code does not access dev_roles[max_dev], only up to
dev_roles[max_dev-1].
You changed dev_roles[max_dev], which will never be accessed.

>
>
>> It might be better to do
>>   if (i >=3D max) {
>>      while (max <=3D i) {
>>         sb->dev_roles[max] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
>>         max +=3D 1;
>>      }
>>      sb->max_dev =3D __cpu_to_le32(max);
>>   }
>>
>
>
> Thanks for the advice.
>
>>> +		}
>>>
>>>  		random_uuid(sb->device_uuid);
>>>
>>> @@ -1214,6 +1216,10 @@ static int update_super1(struct supertype *st, s=
truct mdinfo *info,
>>>  		sb->raid_disks =3D __cpu_to_le32(info->array.raid_disks);
>>>  		sb->dev_roles[info->disk.number] =3D
>>>  			__cpu_to_le16(info->disk.raid_disk);
>>> +		if (sb->raid_disks+1 >=3D __le32_to_cpu(sb->max_dev)) {
>>> +			sb->max_dev =3D __cpu_to_le32(sb->raid_disks+1);
>>> +			sb->dev_roles[sb->max_dev] =3D __cpu_to_le16(MD_DISK_ROLE_SPARE);
>>
>> Again, max_dev is little-endian, so cannot be used as an index.
>> And I think you are updating the wrong element in the dev_roles array.
>
> Yes, I didn't realized the valude is conversed to little-endian and the
> index is wrong too. Thank you for pointing this out. I will submit
> another version patch.

I look forward to it,
Thanks,
NeilBrown

>
> Thanks,
> Lidong
>>
>> Thanks,
>> NeilBrown
>>
>>
>>> +		}
>>>  	} else if (strcmp(update, "resync") =3D=3D 0) {
>>>  		/* make sure resync happens */
>>>  		sb->resync_offset =3D 0ULL;
>>> --
>>> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkehIsACgkQOeye3VZi
gblznxAAwkvAyERy0VAlwjXmy6GflgiQVuNnPn1yXFcDn5jjMlZ1eAYiB1wtQBEq
VE3zlo0ADPuOWD7pQVHlbnKiY4fQVNMJBmkw8Ruhb8fK+fp7bn1dPOlt1uNwIsGB
goel8f8FVM5y78cP2Oxo9Y3xmgjwXUTS/TGzdjlot98ymKwH/F30XTfr+U2Y/8+a
P12omElPjy0dmC/Tz5gU8s7hplVUihLxfmyOe0TlHuYpAfyM3fE4Qvz7cmjEkzMA
rvTODQliNifB7s1QRVHUgeOCmCfx5mxsQR4TY5WckgSMCpNjS1LE9XJo2JMO/hhZ
akIx2Myjbzrhw+y0vS7IiW/xrEitvGO9OYh/TL3X12nIZwITPJXN/1Ng0Uuw/aJV
BaW2ttPX14ixw3LQYb7RTGfEjQEbMafy1+qvamkQP5KwNw1xZYkQ3DgoA9OzgcXK
gv2Scp7g2L6DEJzGaKEc1G5Tha817Ch005Y0LgynuS/UJtZR9pvn+ISXC1L1zzo0
no9JV0CLtdukZtvqaQDJwVvCScKfjL9IOzySi1Ztt6+GRAWthczzQhTEVnJnNN4u
O5EWYUx3IkoxMdLlJRJr/jral7FreHDK+HL5+PiP1ms+mXNa7BsXtui8+bsP9hdC
O1PTtegA7+i4J77hUCpGHsdnHP/FEVCVkRFrkcaebd0/gf0v0Ic=
=Z5f3
-----END PGP SIGNATURE-----
--=-=-=--
