From: Clive Messer <clive@vacuumtube.org.uk>
Subject: Re: [PATCH] md: raid10: wake up frozen array
Date: Sat, 30 Aug 2008 22:30:52 +0100
Message-ID: <1220131852.19005.77.camel@pc343.objectsoft-systems.ltd.uk>
References: <20080725190338.GA27484@ajones-laptop.nbttech.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080725190338.GA27484@ajones-laptop.nbttech.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Fri, 2008-07-25 at 12:03 -0700, Arthur Jones wrote:
> When rescheduling a bio in raid10, we wake up
> the md thread, but if the array is frozen, this
> will have no effect.  This causes the array to
> remain frozen for eternity.  We add a wake_up
> to allow the array to de-freeze.  This code is
> nearly identical to the raid1 code, which has
> this fix already.

Can someone explain this to me in simple terms? 
What will cause a rescheduling of bio?
Frozen for eternity - what will be the effect assuming my root file
system is on raid10?

I have a Fedora Core 9 box using a 4 disk f2 raid10 array. This is the
main partition and root file system. Every couple of days the machine
would hard lock. Sometimes I could ssh in. Most of the time not. I never
managed to catch anything to the logs with SysRq. With the benefit of
hindsight - if the kernel was 'jammed' writing to logfiles on a frozen
raid10 array that could explain it. I assumed faulty hardware. I have
actually replaced one at a time, (and at considerable expense), the
power supply, motherboard, processor, all 4 disks in the array. Still
the machine would lock-up. What is interesting is that I have managed 5
days uptime since I added this one line patch to
2.6.25.14-108.fc9.x86_64. Could someone confirm for me that it is more
than likely that the hard locks I experienced on this machine could be
resolved by this one line patch? Has this patch now made it into an
official kernel release?


> Signed-off-by: Arthur Jones <ajones@riverbed.com>
> ---
>  drivers/md/raid10.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 159535d..d41bebb 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -215,6 +215,9 @@ static void reschedule_retry(r10bio_t *r10_bio)
>  	conf->nr_queued ++;
>  	spin_unlock_irqrestore(&conf->device_lock, flags);
>  
> +	/* wake up frozen array... */
> +	wake_up(&conf->wait_barrier);
> +
>  	md_wakeup_thread(mddev->thread);
>  }
>  

Regards

Clive
- 
Clive Messer <clive@vacuumtube.org.uk>




