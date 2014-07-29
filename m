From: jiao hui <jiaohui@bwstor.com.cn>
Subject: Re: [PATCH] md/raid1: always set MD_RECOVERY_INTR flag in raid1 error
 handler to avoid potential data corruption
Date: Tue, 29 Jul 2014 14:50:04 +0800
Message-ID: <CAEuG+XJhbjGDWhFTdX0h+be-TNVUQUfgWPZVcaxwT4wvzoPbLA@mail.gmail.com>
References: <1406534973.21454.3.camel@fedws>
	<20140729124415.60ecdf3d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140729124415.60ecdf3d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: jiao hui <jiaohui@bwstor.com.cn>, linux-raid <linux-raid@vger.kernel.org>, guomingyang <guomingyang@nrchpc.ac.cn>, zhaomeng <zhaomeng@bwstor.com.cn>
List-Id: linux-raid.ids

Hi neil,

The patch works. I test it on Centos 7.0 for fifty rounds=EF=BC=8C no
consistency issue found=E3=80=82

Best Regards.
jiaohui

On Tue, Jul 29, 2014 at 10:44 AM, NeilBrown <neilb@suse.de> wrote:
> On Mon, 28 Jul 2014 16:09:33 +0800 jiao hui <jiaohui@bwstor.com.cn> w=
rote:
>
>> >From 1fdbfb8552c00af55d11d7a63cdafbdf1749ff63 Mon Sep 17 00:00:00 2=
001
>> From: Jiao Hui <simonjiaoh@gmail.com>
>> Date: Mon, 28 Jul 2014 11:57:20 +0800
>> Subject: [PATCH] md/raid1: always set MD_RECOVERY_INTR flag in raid1=
 error handler to avoid potential data corruption
>>
>>     In the recovery of raid1 with bitmap, if a bitmap bit has a NEED=
ED or RESYNC flag,
>>     actual resync io will happen. The sync_thread check each rdev, i=
f any rdev is missing
>>     or has a FAULTY flag, the array is still_degraded, then the bitm=
ap bit NEEDED flag
>>     not cleared. Otherwise, we cleared NEEDED flag and set RESYNC fl=
ag. The RESYNC flag cleared
>>     in bitmap_cond_end_sync or bitmap_close_sync.
>>
>>     If the only disk which is being recovered fails again when raid1=
 recovery is in progress.
>>     The resync_thread can't find a non-In_sync disk to write, then t=
he remaining recovery skipped.
>>     RAID1 error handler only set MD_RECOVERY_INTR flag when a In_syn=
c disk fails. But the disk
>>     being reocvered is non-In_sync, then md_do_sync can't got the IN=
TR singal to break, and the
>>     mddev->curr_resync is uptodated to max_sectors (mddev->dev_secto=
rs). When raid1 personality
>>     tries to finish resync process, no bitmap bit with RESYNC flag c=
an set back to NEEDED flag,
>>     and bitmap_close_sync clear the RESYNC flag. When the disk is ad=
ded back, the area from
>>     the offset of last recovery to the end of bitmap-chunk is skippe=
d by resync_thread forever.
>>
>>     Signed-off-by: JiaoHui <jiaohui@bwstor.com.cn>
>>
>> ---
>>  drivers/md/raid1.c | 8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index aacf6bf..51d06eb 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1391,16 +1391,16 @@ static void error(struct mddev *mddev, struc=
t md_rdev *rdev)
>>               return;
>>       }
>>       set_bit(Blocked, &rdev->flags);
>> +     /*
>> +      * if recovery is running, make sure it aborts.
>> +      */
>> +     set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>       if (test_and_clear_bit(In_sync, &rdev->flags)) {
>>               unsigned long flags;
>>               spin_lock_irqsave(&conf->device_lock, flags);
>>               mddev->degraded++;
>>               set_bit(Faulty, &rdev->flags);
>>               spin_unlock_irqrestore(&conf->device_lock, flags);
>> -             /*
>> -              * if recovery is running, make sure it aborts.
>> -              */
>> -             set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>       } else
>>               set_bit(Faulty, &rdev->flags);
>>       set_bit(MD_CHANGE_DEVS, &mddev->flags);
>
>
> Hi,
>  thanks for the report and the patch.
>
> If the recovery process gets a write error it will abort the current =
bitmap
> region by calling bitmap_end_sync() in end_sync_write().
> However you are talking about a different situation where a normal IO=
 write
> gets and error and fails a drive.  Then the recovery aborts without a=
borting
> the current bitmap region.
>
> I think I would rather fix the bug by calling end_sync_write() at the=
 place
> where the recovery decides to abort, as in the following patch.
> Would you be able to test it please and confirm that it works?
>
> A similar fix will probably be needed for raid10.
>
> Thanks,
> NeilBrown
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 56e24c072b62..4f007a410f4b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2668,9 +2668,11 @@ static sector_t sync_request(struct mddev *mdd=
ev, sector_t sector_nr, int *skipp
>
>         if (write_targets =3D=3D 0 || read_targets =3D=3D 0) {
>                 /* There is nowhere to write, so all non-sync
> -                * drives must be failed - so we are finished
> +                * drives must be failed - so we are finished.
> +                * But abort the current bitmap region though.
>                  */
>                 sector_t rv;
> +               bitmap_end_sync(mddev->bitmap, sector_nr, &sync_block=
s, 1);
>                 if (min_bad > 0)
>                         max_sector =3D sector_nr + min_bad;
>                 rv =3D max_sector - sector_nr;
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
