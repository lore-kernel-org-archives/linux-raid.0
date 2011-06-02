From: "majianpeng" <majianpeng@gmail.com>
Subject: About monitor raid event using poll/select
Date: Thu, 2 Jun 2011 10:34:52 +0800
Message-ID: <201106021034490930721@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I recently did a project which monitor raids event in system.
I used this way:
while(1){
	open(/proc/mdstat);
	poll();
    do-something
	close
}
I wanted to monitor all events in times.Supposing events A--10s-->B---1hour---->C,do-somethings taks 30s.
First I must fetch the event A.But I do do-somthing using 30s,so I did not monitor event B.
But the interval of B and C is 1 hour,so  I only after 1 hours can detected the events B.

I can modified the do-something in order to reduce times.But in theory,I can omit event.
so I think modified kernel function mdstat_poll:
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 39b27c4..aaecc03 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -6539,8 +6539,10 @@ static unsigned int mdstat_poll(struct file *filp, poll_table *wait)
        /* always allow read */
        mask = POLLIN | POLLRDNORM;
 
-   if (mi->event != atomic_read(&md_event_count))
+ if (mi->event != atomic_read(&md_event_count)){
+              mi->event = atomic_read(&md_event_count);
                mask |= POLLERR | POLLPRI;
+ }
        return mask;
 }
 user space function like this:
opne(/proc/mdstat)
while(1){
	poll
    do-something
}
close

2011-06-02 



majianpeng 

