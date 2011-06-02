From: NeilBrown <neilb@suse.de>
Subject: Re: About monitor raid event using poll/select
Date: Thu, 2 Jun 2011 12:50:35 +1000
Message-ID: <20110602125035.21113078@notabene.brown>
References: <201106021034490930721@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201106021034490930721@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: majianpeng <majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, 2 Jun 2011 10:34:52 +0800 "majianpeng" <majianpeng@gmail.com> wrote:

> I recently did a project which monitor raids event in system.
> I used this way:
> while(1){
> 	open(/proc/mdstat);
> 	poll();
>     do-something
> 	close
> }

This is the wrong way to use 'poll' - no matter what sort of file descriptor
you have.

You need to open /proc/mdstat and keep it open.

You then read /proc/mdstat and possibly act upon the state that you find
there.
Then you call 'poll'.
When poll tells you that something has happened, you seek back to the start
of the file and read it again.  If something has changed, you can act on that
change.
Then you can call 'poll' again.

'poll' tells you if something has changed since the last time you read the
file.
When you open the file and use poll straight away it should tell you that the
file has data ready for you.. maybe it doesn't but it should.  Because there
is data there for you to read.

NeilBrown





> I wanted to monitor all events in times.Supposing events A--10s-->B---1hour---->C,do-somethings taks 30s.
> First I must fetch the event A.But I do do-somthing using 30s,so I did not monitor event B.
> But the interval of B and C is 1 hour,so  I only after 1 hours can detected the events B.
> 
> I can modified the do-something in order to reduce times.But in theory,I can omit event.
> so I think modified kernel function mdstat_poll:
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 39b27c4..aaecc03 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6539,8 +6539,10 @@ static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
>         /* always allow read */
>         mask = POLLIN | POLLRDNORM;
>  
> -   if (mi->event != atomic_read(&md_event_count))
> + if (mi->event != atomic_read(&md_event_count)){
> +              mi->event = atomic_read(&md_event_count);
>                 mask |= POLLERR | POLLPRI;
> + }
>         return mask;
>  }
>  user space function like this:
> opne(/proc/mdstat)
> while(1){
> 	poll
>     do-something
> }
> close
> 
> 2011-06-02 
> 
> 
> 
> majianpeng 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

