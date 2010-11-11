From: Justin Maggard <jmaggard10@gmail.com>
Subject: Re: [PATCH] md: fix return value of rdev_size_change()
Date: Thu, 11 Nov 2010 13:01:14 -0800
Message-ID: <AANLkTiknj8qotyML2c=GwAtjNZewr8TNiZOX_i5E0J7F@mail.gmail.com>
References: <4cdc55d1.4800e70a.1ffa.6729@mx.google.com>
	<AANLkTikEgZVC=0spvkYsXN4KWoNgbK9VMZ8EnN_VWZnf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikEgZVC=0spvkYsXN4KWoNgbK9VMZ8EnN_VWZnf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Nov 11, 2010 at 12:51 PM, Mathias Bur=E9n <mathias.buren@gmail.=
com> wrote:
> On 11 November 2010 20:25, Justin Maggard <jmaggard10@gmail.com> wrot=
e:
>> When trying to grow an array by enlarging component devices, rdev_si=
ze_store()
>> expects the return value of rdev_size_change() to be in sectors, but=
 the actual
>> value is returned in KBs.
>>
>> Signed-off-by: Justin Maggard <jmaggard10@gmail.com>
>> ---
>> =A0drivers/md/md.c | =A0 =A04 ++--
>> =A01 files changed, 2 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>> index 4e957f3..a0615af 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -1337,7 +1337,7 @@ super_90_rdev_size_change(mdk_rdev_t *rdev, se=
ctor_t num_sectors)
>> =A0 =A0 =A0 =A0md_super_write(rdev->mddev, rdev, rdev->sb_start, rde=
v->sb_size,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdev->sb_page);
>> =A0 =A0 =A0 =A0md_super_wait(rdev->mddev);
>> - =A0 =A0 =A0 return num_sectors / 2; /* kB for sysfs */
>> + =A0 =A0 =A0 return num_sectors;
>> =A0}
>>
>>
>> @@ -1704,7 +1704,7 @@ super_1_rdev_size_change(mdk_rdev_t *rdev, sec=
tor_t num_sectors)
>> =A0 =A0 =A0 =A0md_super_write(rdev->mddev, rdev, rdev->sb_start, rde=
v->sb_size,
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 rdev->sb_page);
>> =A0 =A0 =A0 =A0md_super_wait(rdev->mddev);
>> - =A0 =A0 =A0 return num_sectors / 2; /* kB for sysfs */
>> + =A0 =A0 =A0 return num_sectors;
>> =A0}
>>
>> =A0static struct super_type super_types[] =3D {
>> --
>> 1.7.1
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> Hi,
>
> What is the effect of this bug?
>
> // Mathias
>

mdadm -G fails with enlarged component devices.

-Justin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
