From: scar <scar-47zfDnpWZoPQT0dZR+AlfA@public.gmane.org>
Subject: Re: moving spares into group and checking spares
Date: Wed, 14 Sep 2016 14:05:13 -0700
Message-ID: <nrce27$2km$1@blaine.gmane.org>
References: <nramjg$n07$1@blaine.gmane.org>
 <20160914092959.GA3584@metamorpher.de> <nrc2pm$2a9$1@blaine.gmane.org>
 <20160914232249.6e5fc568@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160914232249.6e5fc568@natsu>
Sender: linux-raid-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-raid-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-raid.ids

Roman Mamedov wrote on 09/14/2016 11:22 AM:
> But you think an 11-member RAID5, let alone four of them joined by LVM is
> safe? From a resiliency standpoint that setup is like insanity squared.

yeah it seems fine?  disks are healthy and regularly checked, just 
wondering how to check the spares.  use cron to schedule weekly smartctl 
long test?


> Considering that your expenses for redundancy are 8 disks at the moment, you
> could go with 3x15-disk RAID6 with 2 shared hotspares, making overall
> redundancy expense the same 8 disks -- but for a massively safer setup.

actually it would be 9 disks (3x15 +2 = 47 not 48) but i'm ok with that. 
  but rebuilding the array right now is not an option

> might just as well join them using mdadm RAID0 and
> at least gain the improved linear performance.

i did want to do that but debian-installer didn't seem to support it...


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
