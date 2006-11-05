From: Pavel Machek <pavel@ucw.cz>
Subject: Re: [RFC][PATCH -mm][Experimental] suspend: Do not freeze md_threads
Date: Sun, 5 Nov 2006 12:58:04 +0100
Message-ID: <20061105115804.GG4965@elf.ucw.cz>
References: <200611022355.52856.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200611022355.52856.rjw@sisk.pl>
Sender: linux-raid-owner@vger.kernel.org
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

> If there's a swap file on a software RAID, it should be possible to use this
> file for saving the swsusp's suspend image.  Also, this file should be
> available to the memory management subsystem when memory is being freed before
> the suspend image is created.
> 
> For the above reasons it seems that md_threads should not be frozen during
> the suspend and the appended patch makes this happen, but then there is the
> question if they don't cause any data to be written to disks after the
> suspend image has been created, provided that all filesystems are frozen
> at that time.

Looks okay to me. It would be nice to have someone (Ingo? Neil?) try
to suspend to swap on md......
								Pavel

> Please advise.
> 
> Greetings,
> Rafael
> 
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/md/md.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> Index: linux-2.6.19-rc4-mm2/drivers/md/md.c
> ===================================================================
> --- linux-2.6.19-rc4-mm2.orig/drivers/md/md.c	2006-11-02 20:51:51.000000000 +0100
> +++ linux-2.6.19-rc4-mm2/drivers/md/md.c	2006-11-02 23:25:59.000000000 +0100
> @@ -4489,6 +4489,7 @@ static int md_thread(void * arg)
>  	 * many dirty RAID5 blocks.
>  	 */
>  
> +	current->flags |= PF_NOFREEZE;
>  	allow_signal(SIGKILL);
>  	while (!kthread_should_stop()) {
>  
> @@ -4505,7 +4506,6 @@ static int md_thread(void * arg)
>  			 test_bit(THREAD_WAKEUP, &thread->flags)
>  			 || kthread_should_stop(),
>  			 thread->timeout);
> -		try_to_freeze();
>  
>  		clear_bit(THREAD_WAKEUP, &thread->flags);
>  

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
