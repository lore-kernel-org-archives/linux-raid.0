From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: [PATCH] md: Protecting mddev with barriers to avoid races
Date: Fri, 22 May 2009 15:16:20 +0530
Message-ID: <37d33d830905220246q45567d24p9619f1a02159632a@mail.gmail.com>
References: <37d33d830905220118o1c5d6518l49b3dd1177d0a25e@mail.gmail.com>
	 <20090522083641.GQ11504@skl-net.de>
	 <21131647e50f4a99c4a3b4261d1227be.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21131647e50f4a99c4a3b4261d1227be.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,


On Fri, May 22, 2009 at 2:28 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, May 22, 2009 6:36 pm, Andre Noll wrote:
>> On 13:48, SandeepKsinha wrote:
>>> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
>>> Date: =A0 Fri May 22 13:46:56 2009 +0530
>>>
>>> =A0 =A0 Protecting mddev with barriers to avoid races.
>>>
>>> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
>>> index 9ad6ec4..e2dbda8 100644
>>> --- a/drivers/md/linear.c
>>> +++ b/drivers/md/linear.c
>>> @@ -28,10 +28,12 @@
>>> =A0static inline dev_info_t *which_dev(mddev_t *mddev, sector_t sec=
tor)
>>> =A0{
>>> =A0 =A0 =A0 =A0 int lo, mid, hi;
>>> - =A0 =A0 =A0 linear_conf_t *conf =3D mddev_to_conf(mddev);
>>> + =A0 =A0 =A0 linear_conf_t *conf;
>>>
>>> =A0 =A0 =A0 =A0 lo =3D 0;
>>> =A0 =A0 =A0 =A0 hi =3D mddev->raid_disks - 1;
>>> + =A0 =A0 =A0 barrier();
>>> + =A0 =A0 =A0 conf =3D mddev_to_conf(mddev);
>>
>> Are you sure that a compiler barrier is sufficient here? Maybe we
>> need smp_mb(), but I'm not familar with all the different memory
>> barrier types that exist in the kernel.
>
> I think we just want a read barrier here:
> =A0 =A0smb_rmb();
> because it is a barrier between reading mddev->raid_disk and
> reading mddev->private.
>
> In linear_add, we want a write barrier
> =A0 =A0smb_wmb();
> before setting mdev->raid_disks, and I think we also want one
> before setting mddev->private to make sure that all the assignments
> to newconf->whatever are stable.

Do we really need one before setting mddev->private? Will newconf be
used by anyone before its assigned to mddev->private?
No. Then what makes you put a write barrier before it?

> NeilBrown
>
>
>



--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
