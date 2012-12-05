From: Peter Maloney <peter.maloney@brockmann-consult.de>
Subject: Re: 3.7-rc4 hang with mdadm raid10 near layout, with 4 disks, and
 an internal bitmap
Date: Wed, 05 Dec 2012 23:24:45 +0100
Message-ID: <50BFC9AD.4060006@brockmann-consult.de>
References: <50A28D53.2080409@brockmann-consult.de> <20121127121914.77f6111e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121127121914.77f6111e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/27/2012 02:19 AM, NeilBrown wrote:
> On Tue, 13 Nov 2012 19:11:31 +0100 Peter Maloney
> <peter.maloney@brockmann-consult.de> wrote:
>
>> I am using kernel 3.7-rc4. I have 2 LV on a 4 disk raid10 near layout
>> mdadm device which I am trying to copy to another LV on the same VG
>> using dd. The mdadm device has an internal bitmap. When I copy the first
>> LV, it goes smoothly, but with the 2nd it hangs before it is done.
>> [...]
>> # uname -a
>> Linux peter 3.7.0-rc4-1-default #7 SMP Sun Nov 4 23:11:57 CET 2012
>> x86_64 x86_64 x86_64 GNU/Linux
>>
> ....
>
>
> Thanks for the report.
> Should be fixed by the following.
>
> NeilBrown
>
> Author: NeilBrown <neilb@suse.de>
> Date:   Tue Nov 27 12:14:40 2012 +1100
>
>     md/raid1{,0}: fix deadlock in bitmap_unplug.
>     
>     If the raid1 or raid10 unplug function gets called
>     from a make_request function (which is very possible) when
>     there are bios on the current->bio_list list, then it will not
>     be able to successfully call bitmap_unplug() and it could
>     need to submit more bios and wait for them to complete.
>     But they won't complete while current->bio_list is non-empty.
>     
>     So detect that case and handle the unplugging off to another thread
>     just like we already do when called from within the scheduler.
>     
>     RAID1 version of bug was introduced in 3.6, so that part of fix is
>     suitable for 3.6.y.  RAID10 part won't apply.
>     
>     Cc: stable@vger.kernel.org
>     Reported-by: Torsten Kaiser <just.for.lkml@googlemail.com>
>     Reported-by: Peter Maloney <peter.maloney@brockmann-consult.de>
>     Signed-off-by: NeilBrown <neilb@suse.de>
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 636bae0..a0f7309 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -963,7 +963,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
>  	struct r1conf *conf = mddev->private;
>  	struct bio *bio;
>  
> -	if (from_schedule) {
> +	if (from_schedule || current->bio_list) {
>  		spin_lock_irq(&conf->device_lock);
>  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>  		conf->pending_count += plug->pending_cnt;
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0d5d0ff..c9acbd7 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -1069,7 +1069,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
>  	struct r10conf *conf = mddev->private;
>  	struct bio *bio;
>  
> -	if (from_schedule) {
> +	if (from_schedule || current->bio_list) {
>  		spin_lock_irq(&conf->device_lock);
>  		bio_list_merge(&conf->pending_bio_list, &plug->pending);
>  		conf->pending_count += plug->pending_cnt;


It works; copying my LV no longer hangs. Thanks. :)

$ uname -a
Linux peter 3.7.0-rc7-1-default+ #3 SMP Wed Dec 5 22:20:58 CET 2012
x86_64 x86_64 x86_64 GNU/Linux


