From: Steve Cousins <steve.cousins@maine.edu>
Subject: Re: raidhotadd works, mdadm --add doesn't
Date: Mon, 11 Sep 2006 13:37:28 -0400
Message-ID: <45059ED8.9030206@maine.edu>
References: <7.0.1.0.0.20060910150522.0360c060@eatworms.swmed.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7.0.1.0.0.20060910150522.0360c060@eatworms.swmed.edu>
Sender: linux-raid-owner@vger.kernel.org
To: Leon Avery <leon@eatworms.swmed.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Leon Avery wrote:

> I've been using RAID for a long time, but have been using the old 
> raidtools.  Having just discovered mdadm, I want to switch, but I'm 
> having trouble.  I'm trying to figure out how to use mdadm to replace a 
> failed disk.  Here is my /proc/mdstat:
> 
>     Personalities : [linear] [raid1]
>     read_ahead 1024 sectors
>     md5 : active linear md3[1] md4[0]
>           1024504832 blocks 64k rounding
> 
>     md4 : active raid1 hdf5[0] hdh5[1]
>           731808832 blocks [2/2] [UU]
> 
>     md3 : active raid1 hde5[0] hdg5[1]
>           292696128 blocks [2/2] [UU]
> 
>     md2 : active raid1 hda5[0] hdc5[1]
>           48339456 blocks [2/2] [UU]
> 
>     md0 : active raid1 hda3[0] hdc3[1]
>           9765376 blocks [2/2] [UU]
> 
>     unused devices: <none>
> 
> The relevant parts are md0 and md2.  Physical disk hda failed, which 
> left md0 and md2 running in degraded mode.  Having an old spare used 
> disk sitting on the shelf, I plugged it in, repartitioned it, and said
> 
>     mdadm --add /dev/md0 /dev/hda3


I think the thing to do is to list the md device before the --add :

	mdadm /dev/md0 --add /dev/hda3

I use the -a form and do:

	mdadm /dev/md0 -a /dev/hda3


Steve



