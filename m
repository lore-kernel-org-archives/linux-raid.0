From: "NeilBrown" <neilb@suse.de>
Subject: Re: [PATCH] md: raid0: Simplify raid0_run().
Date: Thu, 14 May 2009 22:06:40 +1000 (EST)
Message-ID: <5b77011896440aa0a5c0e1c89f0730a2.squirrel@neil.brown.name>
References: <1242297833-13908-1-git-send-email-maan@systemlinux.org>
    <1242297833-13908-7-git-send-email-maan@systemlinux.org>
    <37d33d830905140443y3e81ed8gf1dbb00843eb2864@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <37d33d830905140443y3e81ed8gf1dbb00843eb2864@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Andre Noll <maan@systemlinux.org>, raziebe@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, May 14, 2009 9:43 pm, SandeepKsinha wrote:
> Hi Andre,
>
> On Thu, May 14, 2009 at 4:13 PM, Andre Noll <maan@systemlinux.org> wr=
ote:
>> Get rid of the local variable "conf" and of an unnecessary cast.
>>
>> Signed-off-by: Andre Noll <maan@systemlinux.org>
>> ---
>> =A0drivers/md/raid0.c | =A0 20 +++++++-------------
>> =A01 files changed, 7 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index 5ff6290..36b747a 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -261,7 +261,6 @@ static sector_t raid0_size(mddev_t *mddev, secto=
r_t
>> sectors, int raid_disks)
>>
>> =A0static int raid0_run(mddev_t *mddev)
>> =A0{
>> - =A0 =A0 =A0 raid0_conf_t *conf;
>> =A0 =A0 =A0 =A0int ret;
>>
>> =A0 =A0 =A0 =A0if (mddev->chunk_size =3D=3D 0) {
>> @@ -276,14 +275,15 @@ static int raid0_run(mddev_t *mddev)
>> =A0 =A0 =A0 =A0blk_queue_segment_boundary(mddev->queue, (mddev->chun=
k_size>>1) -
>> 1);
>> =A0 =A0 =A0 =A0mddev->queue->queue_lock =3D &mddev->queue->__queue_l=
ock;
>>
>> - =A0 =A0 =A0 conf =3D kmalloc(sizeof (raid0_conf_t), GFP_KERNEL);
>> - =A0 =A0 =A0 if (!conf)
>> + =A0 =A0 =A0 mddev->private =3D kmalloc(sizeof(raid0_conf_t), GFP_K=
ERNEL);
>> + =A0 =A0 =A0 if (!mddev->private)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0return -ENOMEM;
>> - =A0 =A0 =A0 mddev->private =3D (void *)conf;
>> -
>> =A0 =A0 =A0 =A0ret =3D create_strip_zones(mddev);
>> - =A0 =A0 =A0 if (ret < 0)
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_conf;
>> + =A0 =A0 =A0 if (ret < 0) {
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 kfree(mddev->private);
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 mddev->private =3D NULL;
>> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return ret;
>> + =A0 =A0 =A0 }
>>
>
>
> I believe the use of goto statements keep the code more structured,
> especially for code cleanup in case of failures.
> Its better that you revert back to the goto's so that later if a new
> piece of code is added and there would be cases of failure to handle,
> you will have a common cleanup routine.
>
> I think Neil can comment better on this one.

I'm in two minds about this.
In general I prefer
   if (something went wrong)
         return error;
to
   if (something went wrong)_
         goto handle_error;
   ....

  handle_error:
    return error;

as it is easier to read.

However the point about maintainability is valid.  Having to put all
those gotos back in if you find that you need to free something for
unlock something in error prone (you might miss a return)
So having exactly one return for each function is a valuable
goal.

So in the general case there are good arguments in both directions.
Which means you have to make a decision based on the specifics of a
given case.
In this case, I think raid0_run is sufficiently small (now that all
the hash related code is gone) that the benefits of having gotos
are minimal.  So I would be inclined to leave it as it is.

Thanks for the suggestion.

NeilBrown




--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
