From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Wed, 22 Jan 2014 14:32:14 -0800
Message-ID: <CAGRSmLtf6eRYSpdMqmCgMkSSX4xQwLPqRVc_dqX00Ymgky8GAA@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
	<20131120114833.695fc9d4@notabene.brown>
	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
	<20131120133016.7de2d400@notabene.brown>
	<528E710F.1050901@arcor.de>
	<CAGRSmLtfL+Pzcy0CdfvUpcX3Z90-wEVTg46Q2iFRbJsxuSeyBQ@mail.gmail.com>
	<5293C789.3020703@arcor.de>
	<CAGRSmLsHSwELK_jd=PEckDpSBVCfrt9cHBvG_cH9esMYtLu5Jg@mail.gmail.com>
	<529674CB.5040808@arcor.de>
	<CAGRSmLsOBr2GdSD5wa9K_2cKYqaE95SGMbfHJ-BsjDnEfk72cw@mail.gmail.com>
	<CAGRSmLvUrKT8zArpJsFrA=X9KZ7iMyqOWvyeaRBcQ3h0dcGU6Q@mail.gmail.com>
	<20131207141648.069eb003@notabene.brown>
	<CAGRSmLugnbB=_xTOPYnzTBvrOPZoHi8oSzs53-_cdBgttb7VXg@mail.gmail.com>
	<20140120153421.456f864f@notabene.brown>
	<CAGRSmLt+dcm7LrMgcfmbZq=L-=EfcMJt16WgKCz9umXrLVHpuA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLt+dcm7LrMgcfmbZq=L-=EfcMJt16WgKCz9umXrLVHpuA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

They said it's now showing up as it should.  Although they are going
to do some more tests later....

Thank You.


On Mon, Jan 20, 2014 at 3:54 PM, David F. <df7729@gmail.com> wrote:
> Ok, thanks - we have sent it on for them to check.
>
> On Sun, Jan 19, 2014 at 8:34 PM, NeilBrown <neilb@suse.de> wrote:
>> On Sat, 14 Dec 2013 13:01:50 -0800 "David F." <df7729@gmail.com> wrote:
>>
>>> Hi,
>>>
>>> Just wondering if this gave you guys everything you needed to figure
>>> out the issue?
>>
>> I had everything but time.  I've now made the time and have the fix (I hope).
>>
>> Please try the current HEAD of git://neil.brown.name/mdadm/
>> The important patch is below.
>>
>>>
>>> Also, any idea on when 3.4 may be out with the various fixes?
>>
>> I hope to release 3.3.1 some time in February.  Based on past experience it
>> should be out before Easter, but no promises.
>>
>> NeilBrown
>>
>> From f0e876ce03a63f150bb87b2734c139bc8bb285b2 Mon Sep 17 00:00:00 2001
>> From: NeilBrown <neilb@suse.de>
>> Date: Mon, 20 Jan 2014 15:27:29 +1100
>> Subject: [PATCH] DDF: fix detection of failed devices during assembly.
>>
>> When we call "getinfo_super", we report the working/failed status
>> of the particular device, and also (via the 'map') the working/failed
>> status of every other device that this metadata is aware of.
>>
>> It is important that the way we calculate "working or failed" is
>> consistent.
>> As it is, getinfo_super_ddf() will report a spare as "working", but
>> every other device will see it as "failed", which leads to failure to
>> assemble arrays with spares.
>>
>> For getinfo_super_ddf (i.e. for the container), a device is assumed
>> "working" unless flagged as DDF_Failed.
>> For getinfo_super_ddf_bvd (for a member array), a device is assumed
>> "failed" unless DDF_Online is set, and DDF_Failed is not set.
>>
>> Reported-by: "David F." <df7729@gmail.com>
>> Signed-off-by: NeilBrown <neilb@suse.de>
>>
>> diff --git a/super-ddf.c b/super-ddf.c
>> index d526d8ad3da9..4242af86fea9 100644
>> --- a/super-ddf.c
>> +++ b/super-ddf.c
>> @@ -1913,6 +1913,7 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
>>         info->disk.major = 0;
>>         info->disk.minor = 0;
>>         if (ddf->dlist) {
>> +               struct phys_disk_entry *pde = NULL;
>>                 info->disk.number = be32_to_cpu(ddf->dlist->disk.refnum);
>>                 info->disk.raid_disk = find_phys(ddf, ddf->dlist->disk.refnum);
>>
>> @@ -1920,12 +1921,19 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
>>                                                   entries[info->disk.raid_disk].
>>                                                   config_size);
>>                 info->component_size = ddf->dlist->size - info->data_offset;
>> +               if (info->disk.raid_disk >= 0)
>> +                       pde = ddf->phys->entries + info->disk.raid_disk;
>> +               if (pde &&
>> +                   !(be16_to_cpu(pde->state) & DDF_Failed))
>> +                       info->disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
>> +               else
>> +                       info->disk.state = 1 << MD_DISK_FAULTY;
>>         } else {
>>                 info->disk.number = -1;
>>                 info->disk.raid_disk = -1;
>>  //             info->disk.raid_disk = find refnum in the table and use index;
>> +               info->disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
>>         }
>> -       info->disk.state = (1 << MD_DISK_SYNC) | (1 << MD_DISK_ACTIVE);
>>
>>         info->recovery_start = MaxSector;
>>         info->reshape_active = 0;
>> @@ -1943,8 +1951,6 @@ static void getinfo_super_ddf(struct supertype *st, struct mdinfo *info, char *m
>>                 int i;
>>                 for (i = 0 ; i < map_disks; i++) {
>>                         if (i < info->array.raid_disks &&
>> -                           (be16_to_cpu(ddf->phys->entries[i].state)
>> -                            & DDF_Online) &&
>>                             !(be16_to_cpu(ddf->phys->entries[i].state)
>>                               & DDF_Failed))
>>                                 map[i] = 1;
>> @@ -2017,7 +2023,11 @@ static void getinfo_super_ddf_bvd(struct supertype *st, struct mdinfo *info, cha
>>                 info->disk.raid_disk = cd + conf->sec_elmnt_seq
>>                         * be16_to_cpu(conf->prim_elmnt_count);
>>                 info->disk.number = dl->pdnum;
>> -               info->disk.state = (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
>> +               info->disk.state = 0;
>> +               if (info->disk.number >= 0 &&
>> +                   (be16_to_cpu(ddf->phys->entries[info->disk.number].state) & DDF_Online) &&
>> +                   !(be16_to_cpu(ddf->phys->entries[info->disk.number].state) & DDF_Failed))
>> +                       info->disk.state = (1<<MD_DISK_SYNC)|(1<<MD_DISK_ACTIVE);
>>         }
>>
>>         info->container_member = ddf->currentconf->vcnum;
