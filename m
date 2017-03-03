From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH V2 2/5] md: move bitmap_destroy before __md_stop
Date: Fri, 03 Mar 2017 16:20:11 +1100
Message-ID: <87efyflywk.fsf@notabene.neil.brown.name>
References: <1488357760-7893-1-git-send-email-gqjiang@suse.com> <1488357760-7893-3-git-send-email-gqjiang@suse.com> <20170302182825.fcinhanfai3qgzot@kernel.org> <87pohznx49.fsf@notabene.neil.brown.name> <58B8DE44.7040804@suse.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <58B8DE44.7040804@suse.com>
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <gqjiang@suse.com>, Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, shli@fb.com
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Fri, Mar 03 2017, Guoqing Jiang wrote:

> On 03/03/2017 06:15 AM, NeilBrown wrote:
>> On Thu, Mar 02 2017, Shaohua Li wrote:
>>
>>> On Wed, Mar 01, 2017 at 04:42:37PM +0800, Guoqing Jiang wrote:
>>>> Since we have switched to sync way to handle METADATA_UPDATED
>>>> msg for md-cluster, then process_metadata_update is depended
>>>> on mddev->thread->wqueue.
>>>>
>>>> With the new change, clustered raid could possible hang if
>>>> array received a METADATA_UPDATED msg after array unregistered
>>>> mddev->thread, so we need to stop clustered raid earlier
>>>> than before.
>>>>
>>>> And this change should be safe for non-clustered raid since
>>>> all writes are stopped before the destroy. Also in md_run,
>>>> we activate the personality (pers->run()) before activating
>>>> the bitmap (bitmap_create()). So it is pleasingly symmetric
>>>> to stop the bitmap (bitmap_destroy()) before stopping the
>>>> personality (__md_stop() calls pers->free()).
>>>>
>>>> Reviewed-by: NeilBrown <neilb@suse.com>
>>>> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
>>>> ---
>>>>   drivers/md/md.c | 30 +++++++++++++++++-------------
>>>>   1 file changed, 17 insertions(+), 13 deletions(-)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 44206bc6e3aa..e1d9116044ae 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -5574,8 +5574,8 @@ void md_stop(struct mddev *mddev)
>>>>   	/* stop the array and free an attached data structures.
>>>>   	 * This is called from dm-raid
>>>>   	 */
>>>> -	__md_stop(mddev);
>>>>   	bitmap_destroy(mddev);
>>>> +	__md_stop(mddev);
>>>>   	if (mddev->bio_set)
>>>>   		bioset_free(mddev->bio_set);
>>>>   }
>>> Applied other 4 patches. But this one I still have concerns.
>>>
>>> For raid1, if a bio is behind IO, we return the bio to upper layer but don't
>>> wait behind IO completion. So even there are no writes running, there might be
>>> behind IO running. mddev_detach will do the wait which checks bitmap. If we
>>> bitmap_destroy before __md_stop, mddev_detach doesn't do the wait.
>
> Got it, thanks for explanation!
>
>>>
>>> Probably we should move mddev_detach out of __md_stop and always do:
>>> mddev_detach()
>>> bitmap_destroy()
>>> __md_stop()
>>>
>>> This looks safer to me.
>> Thanks for catching that.  I agree - mddev_detach should come before
>> bitmap_destroy.
>> I might be best to change __md_stop() to start
>>
>> static void __md_stop(struct mddev *mddev)
>> {
>> 	struct md_personality *pers = mddev->pers;
>> 	mddev_detach(mddev);
>> +	bitmap_destroy(mddev);
>> 	/* Ensure ->event_work is done */
>> 	flush_workqueue(md_misc_wq);
>
> With this change, does it mean we destroy bitmap unconditionally even
> if the mode is 2? Thanks.

Yes, and we should destroy the bitmap.  In that case we need to return
the array to the start it was before RUN_ARRAY ioctl.

>
>> That would make the remainder of the patch (below) unnecessary.
>> I think it is wrong anyway.
>> We were correct to move the "bitmap_destroy() call up to the
>> "if (mddev->pers)" case, but we were not correct to move the
>> closing of bitmap_info.file.
>> If a file is added to an array but that array is not started
>> (so ->pers is not set), then stopping the array will not close the file
>> with the change below, and that isn't good.
>
> Hmm, thanks for reminder. Though I have some questions about above.
> I guess the file is pointed to bitmap file, from mdadm manpage, I see
>   "-b, --bitmap=" is used under create, build, grow and assemble mode.
> But  how to add a file to a array which is not started? Please correct me
> for my wrong understanding.

Call SET_BITMAP_FILE ioctl.
mdadm won't do this without then calling RUN_ARRAY (or similar).
But is it is possible and we should handle it.
o

>
>> So if we move bitmap_destroy() into  __md_stop() and remove it from
>> do_md_stop and md_stop(), that might be exactly what we need.
>
> How about the below changes? It may addresses both your concern and
> Shaohua's concern, but not sure ...


No, that is more complex than needed, and doesn't call bitmap_destroy()
always when required.

Thanks,
NeilBrown


>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 79a99a1..a0e79d6 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5555,7 +5555,6 @@ static void mddev_detach(struct mddev *mddev)
>   static void __md_stop(struct mddev *mddev)
>   {
>          struct md_personality *pers = mddev->pers;
> -       mddev_detach(mddev);
>          /* Ensure ->event_work is done */
>          flush_workqueue(md_misc_wq);
>          spin_lock(&mddev->lock);
> @@ -5574,8 +5573,9 @@ void md_stop(struct mddev *mddev)
>          /* stop the array and free an attached data structures.
>           * This is called from dm-raid
>           */
> -       __md_stop(mddev);
> +       mddev_detach(mddev);
>          bitmap_destroy(mddev);
> +       __md_stop(mddev);
>          if (mddev->bio_set)
>                  bioset_free(mddev->bio_set);
>   }
> @@ -5688,6 +5688,10 @@ static int do_md_stop(struct mddev *mddev, int mode,
>                          set_disk_ro(disk, 0);
>
>                  __md_stop_writes(mddev);
> +               mddev_detach(mddev);
> +               if (mode == 0)
> +                       bitmap_destroy(mddev);
> +
>                  __md_stop(mddev);
> mddev->queue->backing_dev_info->congested_fn = NULL;
>
> @@ -5713,7 +5717,8 @@ static int do_md_stop(struct mddev *mddev, int mode,
>          if (mode == 0) {
>                  pr_info("md: %s stopped.\n", mdname(mddev));
>
> -               bitmap_destroy(mddev);
> +               if (!mddev->pers)
> +                       bitmap_destroy(mddev);
>                  if (mddev->bitmap_info.file) {
>                          struct file *f = mddev->bitmap_info.file;
>                          spin_lock(&mddev->lock);
>
> Thanks,
> Guoqing

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAli4/QsACgkQOeye3VZi
gbmMFQ/+PXKY2ZpRdWJ7Zz610ZkA8KoIRUnvh/2ZEyyPF/VB/4Cj+JiUVhJg7gHi
PSkO4M7sezicCVc5A+hQmpBg3890jsfShmjC5npwbvm/2SdtL4Wv41hKLnV+d5OC
+lzVkxqKI1OJPjSUvVTSItFzRMrsKqNCruGHfDvRAsvZVXmERnqkDmketV4T+5de
GIoZfwkbzQjxSS9BlnHdwbBSxsOt4i7GYAMuDTybNu88x6hmBaUi99LRsnB5qj0Y
mXhb3iC0I4o/GctZcnxpcjwzY5ltfhgh61euP3IsHLwpwr62mbHymtCjKPVKN5Qy
pBQGD9pg2nxP42KSv6lG/9Lt/rTB0MM/C0jjCzeD4N0b39ADsTUiCcIrHz7jA4Of
oDVA0DBlSVET7weEnbP7jVloMdOO42gdi6rye5zQnBQeaViVb5ApFgATSWeytIZX
Yg0IGHvnP40k05eQro4CoXR36C5WR8T+1xu5syZj60sf+qJPgQq3y+vcBEcrMmVZ
gatdd6tONQC+jlKhJ0knabItfD3WjlDrT1LMLn1tCYNc8bdoa9tHSj/DhLhfYrZK
QxIxZJyd1vuxqpit9PDMFL5h6m3ssZ634mUN40MlFuLHZtum8Hrpn+Yci2xU1D+Q
1AYsSGMqyyCr02H3skvnz8scd9sfDXHCe2r53L7MigbCTMvahso=
=UgQa
-----END PGP SIGNATURE-----
--=-=-=--
