From: Song Liu <songliubraving@fb.com>
Subject: Re: Linux RAID with btrfs stuck and consume 100 % CPU
Date: Thu, 30 Jul 2020 06:45:04 +0000
Message-ID: <D8373CAD-7BB0-4DB9-AB6C-7BF0BE035286@fb.com>
References: <d3fced3f-6c2b-5ffa-fd24-b24ec6e7d4be@xmyslivec.cz>
 <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <a070c45a-0509-e900-e3f3-98d20267c8c9@cloud.ionos.com>
Content-Language: en-US
Content-ID: <27162D9B601CF24A983FDDD3B89FB8D7@namprd15.prod.outlook.com>
Sender: linux-btrfs-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Cc: Vojtech Myslivec <vojtech@xmyslivec.cz>, "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Michal Moravec <michal.moravec@logicworks.cz>
List-Id: linux-raid.ids



> On Jul 29, 2020, at 2:06 PM, Guoqing Jiang <guoqing.jiang@cloud.ionos.com=
> wrote:
>=20
> Hi,
>=20
> On 7/22/20 10:47 PM, Vojtech Myslivec wrote:
>> 1. What should be the cause of this problem?
>=20
> Just a quick glance based on the stacks which you attached, I guess it co=
uld be
> a deadlock issue of raid5 cache super write.
>=20
> Maybe the commit 8e018c21da3f ("raid5-cache: fix a deadlock in superblock
> write") didn't fix the problem completely.  Cc Song.
>=20
> And I am curious why md thread is not waked if mddev_trylock fails, you c=
an
> give it a try but I can't promise it helps ...
>=20
> --- a/drivers/md/raid5-cache.c
> +++ b/drivers/md/raid5-cache.c
> @@ -1337,8 +1337,10 @@ static void r5l_write_super_and_discard_space(stru=
ct r5l_log *log,
>          */
>         set_mask_bits(&mddev->sb_flags, 0,
>                 BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
> -       if (!mddev_trylock(mddev))
> +       if (!mddev_trylock(mddev)) {
> +               md_wakeup_thread(mddev->thread);
>                 return;
> +       }
>         md_update_sb(mddev, 1);
>         mddev_unlock(mddev);
>=20

Thanks Guoqing!

I am not sure whether we hit the mddev_trylock() failure. Looks like the=20
md1_raid6 thread is already running at 100%.=20

A few questions:=20

1. I see wbt_wait in the stack trace. Are we using write back throttling he=
re?
2. Could you please get the /proc/<pid>/stack for <pid> of md1_raid6? We ma=
y
   want to sample it multiple times.=20

Thanks,
Song
