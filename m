From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v2] md: add mddev->pers to avoid potential NULL pointer
 dereference
Date: Tue, 2 Apr 2019 22:41:00 +0000
Message-ID: <6D99E4B5-ADCC-4BF2-A447-4EE52FE775FE@fb.com>
References: <20190402062214.136669-1-yuyufen@huawei.com>
 <87lg0s159q.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <87lg0s159q.fsf@notabene.neil.brown.name>
Content-Language: en-US
Content-ID: <CD851FA50E78B84D805CCAD00EC2E860@namprd15.prod.outlook.com>
Sender: stable-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Yufen Yu <yuyufen@huawei.com>, "axboe@kernel.dk" <axboe@kernel.dk>, "xni@redhat.com" <xni@redhat.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-raid.ids



> On Apr 2, 2019, at 2:11 PM, NeilBrown <neilb@suse.com> wrote:
>=20
> On Tue, Apr 02 2019, Yufen Yu wrote:
>=20
>> When doing re-add, we need to ensure rdev->mddev->pers is not NULL,
>> which can avoid potential NULL pointer derefence in fallowing
>> add_bound_rdev().
>>=20
>> Fixes: a6da4ef85cef ("md: re-add a failed disk")
>> Cc: Xiao Ni <xni@redhat.com>
>> Cc: NeilBrown <neilb@suse.com>
>> Cc: <stable@vger.kernel.org>
>> Signed-off-by: Yufen Yu <yuyufen@huawei.com>
>=20
> Reviewed-by: NeilBrown <neilb@suse.com>
>=20
> Thanks,
> NeilBrown

Thanks Yufen and Neil.=20

I applied it to the md-next branch:

https://github.com/liu-song-6/linux/tree/md-next

Song

>=20
>> ---
>> drivers/md/md.c | 6 ++++--
>> 1 file changed, 4 insertions(+), 2 deletions(-)
>>=20
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 875b29ba5926..66b6bdf9f364 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -2859,8 +2859,10 @@ state_store(struct md_rdev *rdev, const char *buf=
, size_t len)
>> 			err =3D 0;
>> 		}
>> 	} else if (cmd_match(buf, "re-add")) {
>> -		if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk =3D=3D -1) &&
>> -			rdev->saved_raid_disk >=3D 0) {
>> +		if (!rdev->mddev->pers)
>> +			err =3D -EINVAL;
>> +		else if (test_bit(Faulty, &rdev->flags) && (rdev->raid_disk =3D=3D -1=
) &&
>> +				rdev->saved_raid_disk >=3D 0) {
>> 			/* clear_bit is performed _after_ all the devices
>> 			 * have their local Faulty bit cleared. If any writes
>> 			 * happen in the meantime in the local node, they
>> --=20
>> 2.16.2.dirty
