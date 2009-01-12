From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Strange array state
Date: Mon, 12 Jan 2009 18:51:23 -0500
Message-ID: <496BD77B.508@tmr.com>
References: <20090112120517.D4653832E425@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090112120517.D4653832E425@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Wolfgang Denk wrote:
> Hello, 
>
> I see somewhat strange reports for a RAID6 array of 6 disks:
>
> # cat /proc/mdstat 
> Personalities : [raid1] [raid6] [raid5] [raid4] 
> md2 : active raid6 sdc[0] sdh[6] sdg[4] sdf[3] sde[2] sdd[1]
>       1953545792 blocks super 1.0 level 6, 16k chunk, algorithm 2 [6/6] [UUUUUU]
> ...
>
> Oops? I see disks 0, 1, 2, 3, 4, and 6 - why 6 and not 5 ?
>
> If I check the devices, I see for example this:
>
> # mdadm -Q --examine /dev/sdc
> mdadm: metadata format 1.00 unknown, ignored.
> /dev/sdc:
>           Magic : a92b4efc
>         Version : 1.0
>     Feature Map : 0x0
>      Array UUID : ed815df1:a9df9e8e:a65e948f:17ef5557
>            Name : 1
>   Creation Time : Sat Apr 12 00:02:52 2008
>      Raid Level : raid6
>    Raid Devices : 6
>
>  Avail Dev Size : 976772896 (465.76 GiB 500.11 GB)
>      Array Size : 3907091584 (1863.05 GiB 2000.43 GB)
>    Super Offset : 976773152 sectors
>           State : clean
>     Device UUID : bc286549:0267dd3b:ce683a7c:66341111
>
>     Update Time : Mon Jan 12 13:02:52 2009
>        Checksum : 62b5e607 - correct
>          Events : 35060
>
>      Chunk Size : 16K
>
>     Array Slot : 0 (0, 1, 2, 3, 4, failed, 5)
>    Array State : Uuuuuu 1 failed
>
> What does the "metadata format 1.00 unknown, ignored." mean, and how
> can I fix it?  And why does it report "Array State ... 1 failed"?
>
>
> [This is on a standard Fedora 10 system.]
>
> Any help welcome - thanks in advance.
>   

I have seen similar on a system which has a drive fail and which rebuilt 
on a spare. Also, check you /etc/mdadm.conf file and be sure it uses 
PARTITIONS and UUID to build the array, and isn't looking for some 
missing device.

Report back, if none of that helps someone else will have ideas by 
then.  ;-)

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


