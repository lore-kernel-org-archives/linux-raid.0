From: Neil Brown <neilb@suse.de>
Subject: Re: using poll on /proc/mdstat
Date: Sun, 26 Dec 2010 22:44:34 +1100
Message-ID: <20101226224434.0c34f445@notabene.brown>
References: <201012251036232181820@gmail.com>
	<201012251048579216597@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201012251048579216597@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "kernel.majianpeng" <kernel.majianpeng@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, 25 Dec 2010 10:49:02 +0800 "kernel.majianpeng"
<kernel.majianpeng@gmail.com> wrote:

> 
> 
> According md.c:
>  * We have a system wide 'event count' that is incremented
>  * on any 'interesting' event, and readers of /proc/mdstat
>  * can use 'poll' or 'select' to find out when the event
>  * count increases.
> Events are:
>  *  start array, stop array, error, add device, remove device,
>  *  start build, activate spare
> I wanted to monitor RAID5 events,so I writed a c-function:
> int fd = open("/proc/mdstat",O_RDONLY);
> if(fd < 0){
> printf("open /proc/mdstat error:%s\n",strerror(errno));
> return -errno;
> }
> struct pollfd fds[1];
> int ret;
> fds[0].fd = fd;
> fds[0].events = POLLPRI;
> while(1){
> fds[0].fd = fd;
> fds[0].events = POLLPRI;
> ret = poll(fds,1,-1);
> if(ret < 0){
> printf("poll error:%s\n",strerror(errno));
> break;
> }else
> printf("ret value=%d\n",ret);
> }
> close(fd);
> But this function  did not run like my thought.
> After a raid event occured,the poll did not blocked,.The function only well at first.

poll will only block again after you read to the end of the file (and thus
observe any change), and then seek back to the start.

Any time that poll reports and event, you need to respond to that event (e.g.
by reading) or poll will continue to tell you that the event is pending.
This helps avoid some races.


> I wrote anthoer function:
> do{
> int fd = open("/proc/mdstat",O_RDONLY);
> if(fd < 0){
> printf("open /proc/mdstat error:%s\n",strerror(errno));
> return ;
> }
> struct pollfd fds;
> memset(&fds,0, sizeof(struct pollfd));
> fds.fd = fd;
> fds.events = POLLPRI|POLLERR;
> if(poll(&fds,1,-1) == -1){
> printf("poll error:%s\n",strerror(errno));
> break;
> }
> printf("return events:%d\n",fds.revents);
> close(fd);
> }while(1);
> this function work well, can return when raid_event occured.

After each poll, you close and re-open the file.  This is enough to 'tell'
poll that you have noticed the event.

If you have further questions, please ask.

NeilBrown



> I read the source found:
> static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
> {
> struct seq_file *m = filp->private_data;
> struct mdstat_info *mi = m->private;
> int mask;
> poll_wait(filp, &md_event_waiters, wait);
> /* always allow read */
> mask = POLLIN | POLLRDNORM;
> if (mi->event != atomic_read(&md_event_count)){
> mask |= POLLERR | POLLPRI;
> }
> return mask;
> }
> the mi->event assigned at function:md_seq_open.
> When open /proc/mdstat,the mi->event = md_event_count, so the first poll blocked.
> But after poll return,mi->event != md_event_count,so the rest poll must immediately return.
> In second function,every time I opend /proc/mdstat,so mi->event = md_event_count, when blocked
> 
> 2010-12-25 
> 
> 
> 
> kernel.majianpeng 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

