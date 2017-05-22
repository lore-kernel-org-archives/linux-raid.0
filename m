From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH v3] super1: fix sb->max_dev when adding a new disk in linear array
Date: Mon, 22 May 2017 14:35:33 +1000
Message-ID: <87fufxjyp6.fsf@notabene.neil.brown.name>
References: <20170519060638.4470-1-lzhong@suse.com> <87lgppkcrn.fsf@notabene.neil.brown.name> <86430c3a-73ed-4c9b-3386-c76b0ee82e82@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <86430c3a-73ed-4c9b-3386-c76b0ee82e82@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Lidong Zhong <lzhong@suse.com>, linux-raid@vger.kernel.org
Cc: colyli@suse.com, Jes.Sorensen@gmail.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Mon, May 22 2017, Lidong Zhong wrote:

> On 05/22/2017 07:31 AM, NeilBrown wrote:
>> On Fri, May 19 2017, Lidong Zhong wrote:
>>
>>> The value of sb->max_dev will always be increased by 1 when adding
>>> a new disk in linear array. It causes an inconsistence between each
>>> disk in the array and the "Array State" value of "mdadm --examine DISK"
>>> is wrong. For example, when adding the first new disk into linear array
>>> it will be:
>>>
>>> Array State : RAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>>> ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> Adding the second disk into linear array it will be
>>>
>>> Array State : .AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
>>> ('A' == active, '.' == missing, 'R' == replacing)
>>>
>>> Signed-off-by: Lidong Zhong <lzhong@suse.com>
>>> ---
>>>  super1.c | 13 +++++++++++--
>>>  1 file changed, 11 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/super1.c b/super1.c
>>> index 2fcb814..811923f 100644
>>> --- a/super1.c
>>> +++ b/super1.c
>>> @@ -1267,8 +1267,13 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>>  				break;
>>>  		sb->dev_number = __cpu_to_le32(i);
>>>  		info->disk.number = i;
>>> -		if (max >= __le32_to_cpu(sb->max_dev))
>>> -			sb->max_dev = __cpu_to_le32(max+1);
>>> +		if (i >= max) {
>>> +			while (max <= i) {
>>> +				sb->dev_roles[max] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>>> +				max += 1;
>>> +			}
>>> +			sb->max_dev = __cpu_to_le32(max);
>>> +		}
>>
>> This part of the patch is OK....
>>
>>>
>>>  		random_uuid(sb->device_uuid);
>>>
>>> @@ -1296,6 +1301,10 @@ static int update_super1(struct supertype *st, struct mdinfo *info,
>>>  		sb->raid_disks = __cpu_to_le32(info->array.raid_disks);
>>>  		sb->dev_roles[info->disk.number] =
>>>  			__cpu_to_le16(info->disk.raid_disk);
>>> +		if (sb->raid_disks+1 >= __le32_to_cpu(sb->max_dev)) {
>>
>> sb->raid_disks is an le32 number, not a cpu number.  So adding 1 to
>> it is clearly wrong.
>>
>
> Really sorry for the careless...I mean info->array.raid_disks here.
>
>> Why do you think you need a change here at all?
>>
>
> The first part of this patch is dealing with the newly added disk
> when the disk number is greater than sb->max_dev.
> While updating the superblock on the original disks of the linear
> array, shouldn't I also check if the disk numbers is greater
> than sb->max_dev?

OK, I can see that you might need to update max_dev to make sure that it
is larger than the new disk.number (or equal to the new raid_disks).
I don't see why you need to make it bigger than raid_disks, or why you
need to change ->dev_roles[] any more than it is already being changed.

i.e. the *only* bug here is with the way max_dev is being updated.
Just change that (in two places).

I don't think the "while (max <= i)" is really needed.  I know I wrote
it, and it isn't wrong.  But it will always do nothing (except increment
'max' once).  So there really isn't any point.

NeilBrown



>
>
>   254         info.array.raid_disks = nd+1;
>   255         info.array.nr_disks = nd+1;
>   256         info.array.active_disks = nd+1;
>   257         info.array.working_disks = nd+1;
>   258
>   259         st->ss->update_super(st, &info, "linear-grow-update", dv,
>   260                      0, 0, NULL);
>   261
>   262         if (st->ss->store_super(st, fd2)) {
>   263             pr_err("Cannot store new superblock on %s\n", dv);
>   264             close(fd2);
>   265             return 1;
>   266         }
>


>>
>>
>>> +			sb->dev_roles[sb->raid_disks] = __cpu_to_le16(MD_DISK_ROLE_SPARE);
>>> +			sb->max_dev = __cpu_to_le32(sb->raid_disks+1);
>>> +		}
>>>  	} else if (strcmp(update, "resync") == 0) {
>>>  		/* make sure resync happens */
>>>  		sb->resync_offset = 0ULL;
>>> --
>>> 2.12.0

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlkiapUACgkQOeye3VZi
gbmoCQ/+Osm0IhyC+KfZ0n/2RekQwXiP2DoM/uY9OjRM3mlHq3f0AJOTR14eSIho
zxh1ITUPejN7k+WuKXO0bNKvQSadV/UWta2gI57jqmnOxbJWWvxkxluVt65L03tp
z6JYOwHRoDNC23QVspP7VeY+NLq+8fyJ9PXLTyEUha4FcANSs2Ksh///BnF6llzA
K4RCFPio+gYkxjZMEDeD4SAzJlvbiu8ZAHss3CxLM/JQC94EmrCHW65rGUeESgFT
165jXoc//SWmWcG2iwtV1ySOyav5sXOhm97dtspGEP7UE6hL/5LHMOpYT37Fxty1
ZXZ6odpZ4kBrCCH25ej3Zz0NWIbsIafMhJYDxFa6AMeetSbHmvVlBBcOZnCvJoaa
2qhk/0cQ9Le6mC2WrU9ewz3FvaDOZo/PsTJpIJkYa8g2qgqUJnO50uc5F/4mX069
ame4sUyFtgiihGJDWzp2RJtbc/PZW24yvKzx7ZlXxJBkKbzyIF+mR4EF6UnzUFIV
U/ocl/8oFV/h/d90ADJJB90Z63oMOSe8DtgH7GHtxgfDFeNez2vaT0L7OQEedHCT
AJVZ5Q+DYiu083OfHGs9FgDm055TSuRuxrnZicMaCt8rux0DHIvi0LxLOGfXZtt9
WMn0kGgGF+ucWfpGc7footBGsKRjKC/ulX4i6lLh4kfFiXJM8SI=
=fjeD
-----END PGP SIGNATURE-----
--=-=-=--
