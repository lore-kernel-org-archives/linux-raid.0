From: Juri Haberland <list-linux.raid@spoiled.org>
Subject: Re: mdadm never notify, grub cause fault
Date: Fri, 16 May 2003 17:45:02 +0000 (UTC)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <news2mail-ba382u$uop$1@cartman.spoiled.org>
References: <3EC4AD9A.6090104@bnap.hu>
Reply-To: Juri Haberland <juri@koschikode.com>
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Farkas Levente <lfarkas@bnap.hu> wrote:

> /etc/mdadm.conf:
> --------------------------
> DEVICE /dev/hd[ac]1
> ARRAY /dev/md0 UUID=a64f771d:9934a60a:39c1483d:2f4a9138
> MAILADDR root@bnap.hu
> --------------------------
> we assume if we run:
> /sbin/mdadm --monitor --scan --daemonise > /var/run/mdadm
> than we'll get a notification in this case. unfortunately we didn't get 
> any notice! even when I stop this monitor and start it again we still 
> didn't got any email. do mdadm periodicaly send the notification? or it 

I also ran into this problem. I found the reason when I started mdadm
without '--daemonize': It tries to use '/usr/lib/sendmail' whereas most
recent distributions have sendmail (or it's replacement) in /usr/sbin.
So just create a link from /usr/sbin/sendmail to /usr/lib/sendmail and it
should work.

> send only once and if it fails for some reason we never get notified?
> I'd like to get notification about it! even in every minutes. or is 
> there any other way to check the state in every hour?

Mdadm will sent only one mail per event. If you want to have a periodic
notification I think you will have to write your own script that checks
/proc/mdstat.

Concerning your problem with hdc, it might be a bad cabling. Have you
checked this?

Regards,
Juri

-- 
Juri Haberland  <juri@koschikode.com> 

