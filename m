From: Neil Brown <neilb@suse.de>
Subject: Re: Growing raid 5 to 6; /proc/mdstat reports a strange value?
Date: Fri, 29 Jan 2010 23:23:34 +1100
Message-ID: <20100129232334.45a4103c@notabene>
References: <4877c76c1001241949p20089932saae123a1c2871ac0@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1001241949p20089932saae123a1c2871ac0@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 24 Jan 2010 19:49:31 -0800
Michael Evans <mjevans1983@gmail.com> wrote:

> mdX : active raid5 sdd1[8](S) sdb1[7](S) sdf8[0] sdl8[4] sdk2[5]
> sdc1[6] sdj6[3] sdi8[1]
>      Y blocks super 1.1 level 5, 128k chunk, algorithm 2 [6/6] [UUUUUU]
> 
> # mdadm --grow /dev/mdX --level=6 --raid-devices=8
> --backup-file=/root/mdX.backupfile
> 
> mdX : active raid6 sdd1[8] sdb1[7] sdf8[0] sdl8[4] sdk2[5] sdc1[6]
> sdj6[3] sdi8[1]
>      Y blocks super 1.1 level 6, 128k chunk, algorithm 18 [8/9] [UUUUUU_U]
>      [>....................]  reshape =  0.0% (33920/484971520)
> finish=952.6min speed=8480K/sec
> 
> !!! mdadm 3.1.1 I wanted an 8 device raid-6;  Why do you show 9?

That is weird isn't it.  It is showing that 8 devices are in the array, of
which 9 are working.  That cannot be right.
More worrying is that the second last device claim to not be present, which
doesn't seem right.


> 
> What is it showing me now???
> 
> blocks super 1.1 level 6, 128k chunk, algorithm 2 [8/10] [UUUUUUUU]
> 

So now of the 8 devices, 10 are working!!  At least all are present.


> ... Did it actually do what I want but just show me the wrong result
> with kernel 2.6.32-gentoo-r2

Some simple testing suggests it did do what you want, but reported something
silly in /proc/mdstat.

I'll see if I can work out what is happening.

Thanks for the report.

NeilBrown

