From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 1/3] mdadm/Grow: fix the broken raid level conversion
Date: Wed, 11 Oct 2017 07:31:50 +1100
Message-ID: <878tgiycax.fsf@notabene.neil.brown.name>
References: <1507537274-29350-1-git-send-email-zlliu@suse.com> <1507537274-29350-2-git-send-email-zlliu@suse.com> <87shesy4sy.fsf@notabene.neil.brown.name> <7fe518ce-d68b-687b-f1f2-cd16616dbba9@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7fe518ce-d68b-687b-f1f2-cd16616dbba9@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Zhilong Liu <zlliu@suse.com>, Jes.Sorensen@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10 2017, Zhilong Liu wrote:

> On 10/09/2017 06:49 PM, NeilBrown wrote:
>> On Mon, Oct 09 2017, Zhilong Liu wrote:
>>
>>> To fix the commit: 4b74a905a67e
>>> (mdadm/grow: Component size must be larger than chunk size)
>>> Since cannot change component size at the same time as other
>>> changes, ensure the 'level' is UnSet when changing component
>>> size, and also not affect the raid level conversion.
>>>
>>> Signed-off-by: Zhilong Liu <zlliu@suse.com>
>>> ---
>>>   Grow.c | 3 ++-
>>>   1 file changed, 2 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Grow.c b/Grow.c
>>> index 1149753..180fd78 100644
>>> --- a/Grow.c
>>> +++ b/Grow.c
>>> @@ -1814,7 +1814,8 @@ int Grow_reshape(char *devname, int fd,
>>>   	}
>>>=20=20=20
>>>   	if (array.level > 1 &&
>>> -	   (array.chunk_size / 1024) > (int)s->size) {
>>> +	   (array.chunk_size / 1024) > (int)s->size &&
>>> +	    s->level =3D=3D UnSet) {
>>>   		pr_err("component size must be larger than chunk size.\n");
>>>   		return 1;
>>>   	}
>> This patch doesn't make any sense to me.
>
> Hi, Neil;
>    Sorry for the later reply due to meetings.
>
> I do agree your suggestion that adding test "s->size > 0" is more=20
> comfortable than
> adding "s->level =3D=3D UnSet".
>
> This patch mainly wanna ensure that changing new component size must be=20
> ">=3D" current
> chunk size, otherwise the mddev->pers->resize would set the=20
> mddev->dev_sectors as '0'.
>
> array.level > 1       ---> only against the raids which the chunk size=20
> is meaningful.
> (array.chunk_size / 1024) > (int)s->size     ----> ensure the=20
> explanation above.
> s->size > 0    ----> to ensure that valid re-size has required.
>
>> If the chunk_size is meaningful, then is must be less than the new
>> s->size.
>
> Yes here.
>> This is true whether the level is being changed or not.
>>
>> Why do you think that the component size cannot be changed at the same
>> time as other changes?
>
> Both user space and kernel space have codes to verify only one change=20
> happens.
>
> in mdadm/Grow.c:   Grow_reshape()
> ...
> 1801         if (s->size > 0 &&
> 1802             (s->chunk || s->level!=3D UnSet || s->layout_str ||=20
> s->raiddisks)) {
> 1803                 pr_err("cannot change component size at the same=20
> time as other changes.\n"
> 1804                         "   Change size first, then check data is=20
> intact before making other changes.\n");
> 1805                 return 1;
> 1806         }
> ...

Ahhh, yes.  I had forgotten about that.  There was probably a good
reason.
Thanks.

>
> in md.c:  update_array_info()
> ...
> 6833         /* Check there is only one change */

This isn't directly relevant.  mdadm could send multiple change
commands, one after the other.


> 6834         if (info->size >=3D 0 && mddev->dev_sectors / 2 !=3D info->s=
ize)
> 6835                 cnt++;
> 6836         if (mddev->raid_disks !=3D info->raid_disks)
> 6837                 cnt++;
> 6838         if (mddev->layout !=3D info->layout)
> 6839                 cnt++;
> 6840         if ((state ^ info->state) & (1<<MD_SB_BITMAP_PRESENT))
> 6841                 cnt++;
> 6842         if (cnt =3D=3D 0)
> 6843                 return 0;
> 6844         if (cnt > 1)
> 6845                 return -EINVAL;
> ...
>
> Here I give a test to explain more details.
>
> Steps:
> 1. create a raid5 array.
> ./mdadm -CR /dev/md0 -l5 -b internal -n2 -x1 /dev/loop10 /dev/loop11=20
> /dev/loop12
> 2. changing component size:
> ./mdadm -G /dev/md0 --size 511
>
> Currently, the /sys/block/md0/md/chunk_size is default by 512*1024, and=20
> we required to
> set new component size as 511K.
>
> in mdadm:
> it goes Grow_reshape() and sent a ioctl command of SET_ARRAY_INFO.
>
> in md:
> ioctl parses the command and goes to update_array_info  --> update_size=20
> --> mddev->pers->resize;
> in raid5.c:
> cut piece of code from raid5_resize().
> ...
> 7719         sectors &=3D ~((sector_t)conf->chunk_sectors - 1);
> 7720         newsize =3D raid5_size(mddev, sectors, mddev->raid_disks);
> ...
>
> the line 7719 shows the valid sectors should be the integer times of=20
> conf->chunk_sectors,
> but sectors would be '0' when sectors <=3D conf->chunk_sectors.
> At this time, the raid5 array is still on-line, but it's not meaningful=20
> any more due to the new
> component size has set as '0'.
>
> Thus, firstly I expose this patch to user space and require some ideas,=20
> would you suggest
> that add something in kernel space? such as ensure "sectors >=20
> conf->chunk_sectors"?

I would suggest
   if (sectors =3D=3D 0)
       return -EINVAL;

between lines 7719 abd 7720.

raid10.c needs a similar change.  Probably raid1.c too.

Thanks,
NeilBrown

>
> Thanks for your patience to correct me if any wrong here.
>
> Best regards,
> -Zhilong
>
>> NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlndLjcACgkQOeye3VZi
gbmLsQ/+LPFz+CH/JSoxoxqXyRatEQaMBWLJmPMoMpOpSVCGQ0pJtwrAekBxGeQ+
uZsQy6wscRgm5OsY5gCYubZA8t93Svmr5Asxi2HZSirr8Anx2n8oJxDbEOQ9TWLT
5E9kwtW32rhuanwwbbaVI/bJKbGVMkXdXJaetpW5beupptrgN4s13Eaw1GRTujqu
oUEk1KE1iJ//wFSpzXRoQ+4syCZ4wITbBNa3HJAy1rKbe2oDnFQnTJTvhXwAXxI8
u7M5FdXpngnNTYz/Mjwmc4icm0cn+D6NdGwy0RB/40N91SGTXgV3VEs8wQhnUb1q
so+H+R12C9RLwKu9B0W5g+ihZP4MVsOpHq6LD9GticolrXkOWmO8u3APuYkHF5J2
4MujclibjK5/2h9ulLOc9xAUaeyIXga/3+VDF9aSxtmfgudYkeojDNlG7gTBdRoz
61jT36ChElDjK4GyYmeXVFcpsQNwn+9aqDgqllE7MNBvnwNtANe1eM9N5gW2rWox
ZkK6UJuP0KXi21YsJs7yZzQq/K1jZNLS189giXvb9DtNOt8s32Gr7oIa9DfdTMNk
pd8bfD00nfG8m3U/S3sK4cSccCd8uBVvPUIyZGigNK6NqRA7oRSs2MubnGSVoo4B
KuC85dC3dFn+VBNAndhs9eqePFTZkVquYXhu7ekc0CWPyykhphs=
=ZgBK
-----END PGP SIGNATURE-----
--=-=-=--
