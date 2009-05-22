From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: Protecting mddev with barriers to avoid races
Date: Fri, 22 May 2009 21:33:53 +1000 (EST)
Message-ID: <5d25cad49125a635da88c08650cadb07.squirrel@neil.brown.name>
References: <37d33d830905220118o1c5d6518l49b3dd1177d0a25e@mail.gmail.com>
    <20090522083641.GQ11504@skl-net.de>
    <21131647e50f4a99c4a3b4261d1227be.squirrel@neil.brown.name>
    <37d33d830905220246q45567d24p9619f1a02159632a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905220246q45567d24p9619f1a02159632a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Andre Noll <maan@systemlinux.org>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, May 22, 2009 7:46 pm, SandeepKsinha wrote:
> Hi Neil,
>
>
> On Fri, May 22, 2009 at 2:28 PM, NeilBrown <neilb@suse.de> wrote:
>> On Fri, May 22, 2009 6:36 pm, Andre Noll wrote:
>>> On 13:48, SandeepKsinha wrote:
>>>> Signed-off-by: Sandeep K Sinha <sandeepksinha@gmail.com>
>>>> Date: =A0 Fri May 22 13:46:56 2009 +0530
>>>>
>>>> =A0 =A0 Protecting mddev with barriers to avoid races.
>>>>
>>>> diff --git a/drivers/md/linear.c b/drivers/md/linear.c
>>>> index 9ad6ec4..e2dbda8 100644
>>>> --- a/drivers/md/linear.c
>>>> +++ b/drivers/md/linear.c
>>>> @@ -28,10 +28,12 @@
>>>> =A0static inline dev_info_t *which_dev(mddev_t *mddev, sector_t se=
ctor)
>>>> =A0{
>>>> =A0 =A0 =A0 =A0 int lo, mid, hi;
>>>> - =A0 =A0 =A0 linear_conf_t *conf =3D mddev_to_conf(mddev);
>>>> + =A0 =A0 =A0 linear_conf_t *conf;
>>>>
>>>> =A0 =A0 =A0 =A0 lo =3D 0;
>>>> =A0 =A0 =A0 =A0 hi =3D mddev->raid_disks - 1;
>>>> + =A0 =A0 =A0 barrier();
>>>> + =A0 =A0 =A0 conf =3D mddev_to_conf(mddev);
>>>
>>> Are you sure that a compiler barrier is sufficient here? Maybe we
>>> need smp_mb(), but I'm not familar with all the different memory
>>> barrier types that exist in the kernel.
>>
>> I think we just want a read barrier here:
>> =A0 =A0smb_rmb();
>> because it is a barrier between reading mddev->raid_disk and
>> reading mddev->private.
>>
>> In linear_add, we want a write barrier
>> =A0 =A0smb_wmb();
>> before setting mdev->raid_disks, and I think we also want one
>> before setting mddev->private to make sure that all the assignments
>> to newconf->whatever are stable.
>
> Do we really need one before setting mddev->private? Will newconf be
> used by anyone before its assigned to mddev->private?
> No. Then what makes you put a write barrier before it?

I'm not 100% certain we do need it, but the logic goes like that:

One processor does
  newconf->disks[0].end_sector =3D X;
  mddev->private =3D newconf;

and another processor does
   conf =3D mddev->private;
   foo =3D conf->disk[0].end_sector;

Due to the lack of memory ordering guarantees, foo could end up
with the value of end_sector *before* X was assigned to it.

In fact, rcu_assign_pointer (in include/linux/rcupdate.h) has
exactly this purpose: place an smp_wmb before assigning the address
of a structure to a pointer, to ensure that the content of the
structure is globally visible before the address of the structure
become visible.
So I would probably do

   rcu_assign_pointer(mddev->private, newconf);
   smb_wmb();
   mddev->raid_disks ++;

An alternative (which actually might be an improvement, I'm not
sure) is to have a conf->raid_disks field and use that value in
which_dev.  Then it would be more like

   mddev->raid_disk++;
   newconf->raid_disk =3D mddev->raid_disks;
   rcu_assign_pointer(mddev->private, newconf);

and we only have one memory barrier.
The which_dev code then becomes:

   conf =3D rcu_dereference(mddev->private);
   hi =3D conf->raid_disks =3D 1;
   .....

and again we have only one memory barrier.  The significant benefit
of this is that instead of using the low level smp_[rw]mb() operations,
we use the higher level rcu_* interfaces which make it a lot more
obvious what we are doing.

It would then be a very small step use use rcu_dereference for
all mddev->private accesses in linear.c, wrap them in rcu_read_{,un}loc=
k,
and then use call_rcu to arrange for the old conf_t to be freed.

NeilBrown

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
