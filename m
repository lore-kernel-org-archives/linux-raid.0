From: Joe Landman <joe.landman@gmail.com>
Subject: Re: RAID10 performance with 20 drives
Date: Wed, 31 May 2017 08:36:55 -0400
Message-ID: <612d69da-78d0-e195-2f57-8e9c251c54f7@gmail.com>
References: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGqmV7p4_r+ca+Wq_UXcY4RDa7WwE2nWkgXF+Sn3ChwLEmkurQ@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On 05/31/2017 08:20 AM, CoolCold wrote:
> Hello!
> Got a new box, for image storage, playing around, created raid10 array
> with 20 1.8TB SATA drives, and found that we hit the cpu limit,
> details below.
>

[...]

> /proc/mdstat output:
> [root@spare-a17484327407661 rovchinnikov]# cat /proc/mdstat
> Personalities : [raid1] [raid10] [raid6] [raid5] [raid4]
> md1 : active raid10 sdx[19] sdw[18] sdv[17] sdu[16] sdt[15] sds[14]
> sdr[13] sdq[12] sdp[11] sdo[10] sdn[9] sdm[8] sdl[7] sdk[6] sdj[5]
> sdi[4] sdh[3] sdg[2] sdf[1] sde[0]
>        17580330880 blocks super 1.2 64K chunks 2 near-copies [20/20]
> [UUUUUUUUUUUUUUUUUUUU]
>        [=>...................]  resync =  6.4% (1133170368/17580330880)
> finish=192.6min speed=1423140K/sec

Note:  you are syncing the drives at 1.4 GB/s.

[...]

> [root@spare-a17484327407661 rovchinnikov]# cat /proc/version
> Linux version 3.10.0-327.el7.x86_64 (builder@kbuilder.dev.centos.org)
> (gcc version 4.8.3 20140911 (Red Hat 4.8.3-9) (GCC) ) #1 SMP Thu Nov
> 19 22:10:57 UTC 2015

And you have an ancient kernel.

>
> So, the question is - why cpu usage is so high and I suppose is a limit here?
>

Without seeing 'vmstat 1' or 'dstat' output, I think all that is 
possible is a guess.

If you have 20 drives, all connected over a single HBA going into an 
expander, it is possible that this is one of the rate limiting factors 
(and its around the same speed limit I've seen in other contexts for 
expander based systems).  Unfortunately, without more info, this is 
going to be pure speculation.

1.4GB/s / 20 drives -> 70 MB/s.  Without knowing what make/model drives 
you have there, it would be hard to speculate what fraction of the 
actual bandwidth you are getting.  Most modern (e.g. new) drives can do 
between 150-220 MB/s, so you could be anywhere from 33% to 50% of bandwidth.

Your HBA ... this matters tremendously to performance.  Not all HBAs are 
equivalent, and some are not very good at all.  Which make and model, 
how is it connected to the drives (direct or via expander), firmware 
revs, etc.   Since your kernel is ancient, chances are your HBA driver 
is as well, so ...

Closely related are how many context switches and interrupts per second 
you are seeing (hence the vmstat question).  Also quite related is how 
the irqs are being distributed for the HBA, or, as I've found many 
times, "if" they are being distributed.

Also, something I've found quite often has to do with how the PCIe 
devices actually negotiate their speeds.  This has bitten me more many 
times ... and I've written a tool to help answer that question:  
https://github.com/joelandman/pcilist

Then there are questions on the disk config, such as "is the write cache 
enabled", "is the read cache disabled".

     sdparm | grep WCE
     sdparm | grep RCD

And then the SD subsystem (read-ahead, ncq, etc.)

Basically you need to report far more information for anyone to give you 
anything more than pure speculation.


--
Joe Landman
e: joe.landman@gmail.com
t: @hpcjoe
w: https://scalability.org
g: https://github.com/joelandman


