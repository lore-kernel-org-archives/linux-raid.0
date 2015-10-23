From: Nate Dailey <nate.dailey@stratus.com>
Subject: Re: [PATCH 0/2] raid1/10: Handle write errors correctly in
 narrow_write_error()
Date: Fri, 23 Oct 2015 10:30:13 -0400
Message-ID: <562A4475.1000904@stratus.com>
References: <1445357353-19906-1-git-send-email-Jes.Sorensen@redhat.com>
 <87pp092sid.fsf@notabene.neil.brown.name> <wrfjpp06lws6.fsf@redhat.com>
 <87r3kmziux.fsf@notabene.neil.brown.name> <56296510.4030702@stratus.com>
 <87d1w6zbrv.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87d1w6zbrv.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org, William.Kuzeja@stratus.com, xni@redhat.com
List-Id: linux-raid.ids

Thank you!

I confirmed that this patch prevents the bug.

Nate



On 10/22/2015 08:09 PM, Neil Brown wrote:
> Nate Dailey <nate.dailey@stratus.com> writes:
>
>> The problem is that we aren't getting true write (medium) errors.
>>
>> In this case we're testing device removals. The write errors happen because the
>> disk goes away. Narrow_write_error returns 1, the bitmap bit is cleared, and
>> then when the device is re-added the resync might not include the sectors in
>> that chunk (there's some luck involved; if other writes to that chunk happen
>> while the disk is removed, we're okay--bug is easier to hit with smaller bitmap
>> chunks because of this).
>>
>>
> OK, that makes sense.
>
> The device removal will be noticed when the bad block log is written
> out.
> When a bad-block is recorded we make sure to write that out promptly
> before bio_endio() gets called.  But not before close_write() has called
> bitmap_end_write().
>
> So I guess we need to delay the close_write() call until the
> bad-block-log has been written.
>
> I think this patch should do it.  Can you test?
>
> Thanks,
> NeilBrown
>
> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index c1ad0b075807..1a1c5160c930 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2269,8 +2269,6 @@ static void handle_write_finished(struct r1conf *conf, struct r1bio *r1_bio)
>   			rdev_dec_pending(conf->mirrors[m].rdev,
>   					 conf->mddev);
>   		}
> -	if (test_bit(R1BIO_WriteError, &r1_bio->state))
> -		close_write(r1_bio);
>   	if (fail) {
>   		spin_lock_irq(&conf->device_lock);
>   		list_add(&r1_bio->retry_list, &conf->bio_end_io_list);
> @@ -2396,6 +2394,9 @@ static void raid1d(struct md_thread *thread)
>   			r1_bio = list_first_entry(&tmp, struct r1bio,
>   						  retry_list);
>   			list_del(&r1_bio->retry_list);
> +			if (mddev->degraded)
> +				set_bit(R1BIO_Degraded, &r1_bio->state);
> +			close_write(r1_bio);
>   			raid_end_bio_io(r1_bio);
>   		}
>   	}

