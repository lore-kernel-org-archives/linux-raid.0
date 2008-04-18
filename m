From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID1 == two different ARRAY in scan, and Q on read error corrected
Date: Sat, 19 Apr 2008 10:02:15 +1200
Message-ID: <48091A67.1090906@sauce.co.nz>
References: <27567.1208547359@perkpartners.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <27567.1208547359@perkpartners.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Phil Lobbes wrote:
____________________________________________________________

> 
> Apr 15 11:07:14  kernel: raid1: sdc1: rescheduling sector 517365296
> Apr 15 11:07:54  kernel: raid1:md0: read error corrected (8 sectors at 517365296 on sdc1)
> Apr 15 11:07:54  kernel: raid1: sdc1: redirecting sector 517365296 to another mirror
> Apr 15 11:08:32  kernel: raid1: sdc1: rescheduling sector 517365472
> Apr 15 11:09:09  kernel: raid1:md0: read error corrected (8 sectors at 517365472 on sdc1)
> Apr 15 11:09:09  kernel: raid1: sdc1: redirecting sector 517365472 to another mirror

These entries,

> Apr 18 14:01:45  smartd[2104]: Device: /dev/sdc, 3 Currently unreadable (pending) sectors

and this, indicate that sdc is losing sectors, so you probably want a 
backup of the array.

Depending on how important the array is you could fail and remove sdc 
from the array, dd if=/dev/zero of=/dev/sdc bs=1M and re-add it back.

It may then be fine for some time, but if it continues to gather pending 
sectors in the short term, it is probably dying.

Otherwise just replace it with a new one.

Regards,

Richard
