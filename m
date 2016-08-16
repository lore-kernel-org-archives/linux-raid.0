From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Can't mount Old RHEL 6 Raid with new install of CentOS 7, now
 can't mount with original RHEL 6
Date: Tue, 16 Aug 2016 11:58:47 -0600
Message-ID: <CAJCQCtSHffOMy7xvNyR2KshFfiwL3e4Jrt2BPY90CMrRY5nRyQ@mail.gmail.com>
References: <42cee2e2d85a5b0e39efc34117e597a2@celticblues.com>
 <CAJCQCtQfBjhKh2Fu+W76JyXODFJJ9Qxjbyn7KK0i3ALs1xREgQ@mail.gmail.com> <57d23adc6db12d6a365dd2c6f50d4bf5@celticblues.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <57d23adc6db12d6a365dd2c6f50d4bf5@celticblues.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Dawson <linux@celticblues.com>
Cc: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Aug 16, 2016 at 11:35 AM, John Dawson <linux@celticblues.com> wrote:

> ===============================================
> "sudo mdadm -D /dev/md127" results
> ===============================================
>
> /dev/md127:
>         Version : 1.2
>   Creation Time : Fri Aug  5 16:46:10 2016

Did you really create this array on 10 days ago with CentOS 6 and then
upgrade to CentOS 7 and it didn't work? Or did you happen to try to
fix the problem by doing mdadm --create ?





-- 
Chris Murphy
