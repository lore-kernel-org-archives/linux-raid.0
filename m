From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Can't mount Old RHEL 6 Raid with new install of CentOS 7, now
 can't mount with original RHEL 6
Date: Tue, 16 Aug 2016 12:44:28 -0600
Message-ID: <CAJCQCtTAjg5bgboMjMyu0gMx57J0n6Po1uppsEoFvGAYCwV6xA@mail.gmail.com>
References: <42cee2e2d85a5b0e39efc34117e597a2@celticblues.com>
 <CAJCQCtQfBjhKh2Fu+W76JyXODFJJ9Qxjbyn7KK0i3ALs1xREgQ@mail.gmail.com>
 <57d23adc6db12d6a365dd2c6f50d4bf5@celticblues.com> <CAJCQCtSHffOMy7xvNyR2KshFfiwL3e4Jrt2BPY90CMrRY5nRyQ@mail.gmail.com>
 <fd2b2aab-a0c1-4e20-89e2-f859b488e4e9@Spark>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fd2b2aab-a0c1-4e20-89e2-f859b488e4e9@Spark>
Sender: linux-raid-owner@vger.kernel.org
To: John Dawson <linux@celticblues.com>
Cc: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 12:33 PM,  <linux@celticblues.com> wrote:
> The array was originally created well over a year ago, perhaps 2 or 3 years
> ago. It was working great. When the machine was updated to CentOS 7, the
> raid assembled manually fine and was mountable only once. After rebooting
> and trying to mount in /etc/fstab it could no longer be assembled and
> mounted...

How do you explain your mdadm -E and -D output, which shows the
creation time 10 days ago?


> ===============================================
> "sudo mdadm -D /dev/md127" results
> ===============================================
>
> /dev/md127:
> Version : 1.2
> Creation Time : Fri Aug 5 16:46:10 2016


Further the -E output shows Events: 0 which means the array you're
showing us has never been used. The only explanation I can think of is
you used mdadm --create, but something significant is missing from
your explanation because there is no possible way a normal mount or
assemble changes the Creation Time of the array, or the Event count.
But --create will do that.


-- 
Chris Murphy
