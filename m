From: ravichandra <vmynidi@caviumnetworks.com>
Subject: Re: Problem regarding RAID10 on kernel 2.6.31
Date: Mon, 09 Aug 2010 13:09:56 +0530
Message-ID: <1281339596.18581.34.camel@venkata-pc.in.caveonetworks.com>
References: <1281087718.14259.5.camel@venkata-pc.in.caveonetworks.com>
	 <20100806201435.5a3cb1f9@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100806201435.5a3cb1f9@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,
   Thanks.The patch you have sent is working.There is no hanging up
after the patch is applied.can you elaborate on the problem which was
there earlier??

Thanks and Regards. 

On Fri, 2010-08-06 at 20:14 +1000, Neil Brown wrote:
> On Fri, 06 Aug 2010 15:11:58 +0530
> ravichandra <vmynidi@caviumnetworks.com> wrote:
> 
> > Hi everyone,
> >                  I  used 2 (1 TB disks) disks each with 3
> > partitions(sda[1-3] and sdb[1-3]).Using sda[1-2] and sdb[1-2] i have
> > created a RAID10 array say md2. Then  i was reading and writing to the
> > array and simultaneously removing a disk and adding it to the same
> > array. In the process i got a hang causing recovery process to halt. The
> > array was not operational after.These were done on kernel 2.6.31.
> > 
> >            I am working on the RAID10 for the first time. Can someone
> > help in this so that i can proceed further?? 
> > 
> > Thanks in advance.
> 
> Known problem.  I'll be submitting the fix upstream shortly.  I include it
> below.
> Thanks for the report
> NeilBrown
> 
> 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 42e64e4..d1d6891 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -825,11 +825,29 @@ static int make_request(mddev_t *mddev, struct bio * bio)
>  		 */
>  		bp = bio_split(bio,
>  			       chunk_sects - (bio->bi_sector & (chunk_sects - 1)) );
> +
> +		/* Each of these 'make_request' calls will call 'wait_barrier'.
> +		 * If the first succeeds but the second blocks due to the resync
> +		 * thread raising the barrier, we will deadlock because the
> +		 * IO to the underlying device will be queued in generic_make_request
> +		 * and will never complete, so will never reduce nr_pending.
> +		 * So increment nr_waiting here so no new raise_barriers will
> +		 * succeed, and so the second wait_barrier cannot block.
> +		 */
> +		spin_lock_irq(&conf->resync_lock);
> +		conf->nr_waiting++;
> +		spin_unlock_irq(&conf->resync_lock);
> +
>  		if (make_request(mddev, &bp->bio1))
>  			generic_make_request(&bp->bio1);
>  		if (make_request(mddev, &bp->bio2))
>  			generic_make_request(&bp->bio2);
>  
> +		spin_lock_irq(&conf->resync_lock);
> +		conf->nr_waiting--;
> +		wake_up(&conf->wait_barrier);
> +		spin_unlock_irq(&conf->resync_lock);
> +
>  		bio_pair_release(bp);
>  		return 0;
>  	bad_map:


