From: Andreas Klauer <Andreas.Klauer@metamorpher.de>
Subject: Re: debian9/raid1 assembly/unexpected failure opening device
Date: Thu, 31 Aug 2017 15:22:26 +0200
Message-ID: <20170831132226.GA6058@metamorpher.de>
References: <CAGv-CE+UwWraQpVF8hG+OBxj1B7Gwbh7tUcMq7hKz0MQ0NWd-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAGv-CE+UwWraQpVF8hG+OBxj1B7Gwbh7tUcMq7hKz0MQ0NWd-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joel Walberg <joel.walberg@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Aug 31, 2017 at 06:06:42AM -0600, Joel Walberg wrote:
> ## root@jowahome:~# mdadm -A /dev/md2014 /dev/sdc1 /dev/sdb1
> ## mdadm: unexpected failure opening /dev/md2014
> ## root@jowahome:~# mdadm -A /dev/md/md2014 /dev/sdc1 /dev/sdb1
> ## mdadm: unexpected failure opening /dev/md2014

Could be related to the name. Try assembling it as /dev/md0.

If that works, change the name to something that isn't md<number>.

(--assemble --update=name --name=xyz I guess)

> ## SMART Extended Self-test Log Version: 1 (1 sectors)
> ## Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> ## # 1  Short offline       Completed without error       00%
> 21086         -

This is a personal preference... but you should run self tests 
more regularly (automated, smartd) to detect HDD errors in time.

> ##   5 Reallocated_Sector_Ct   PO--CK   097   097   010    -    3344

That's quite a lot of reallocated sectors already.
This is the kind of drive that will make your rebuilds fail.

I would consider replacing such a drive / putting it to some use 
where data loss is acceptable.

Regards
Andreas Klauer
