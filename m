From: Ron Leach <ronleach@tesco.net>
Subject: Re: Recovery on new 2TB disk: finish=7248.4min (raid1)
Date: Fri, 28 Apr 2017 08:05:42 +0100
Message-ID: <5902E9C6.3090601@tesco.net>
References: <590117CD.1000009@tesco.net> <22785.65375.947842.648174@quad.stoffel.home> <e76a0a07-2306-e63a-a1f7-48d103eefd62@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e76a0a07-2306-e63a-a1f7-48d103eefd62@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/04/2017 15:43, Reindl Harald wrote:
> [root@rh:~]$ cat /proc/mdstat
> Personalities : [raid10] [raid1]
> md0 : active raid1 sda1[0] sdc1[1] sdb1[3] sdd1[2]
> 511988 blocks super 1.0 [4/4] [UUUU]
>
> md1 : active raid10 sda2[0] sdc2[1] sdd2[2] sdb2[3]
> 30716928 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
>
> md2 : active raid10 sda3[0] sdc3[1] sdd3[2] sdb3[3]
> 3875222528 blocks super 1.1 512K chunks 2 near-copies [4/4] [UUUU]
> [========>............] check = 44.4% (1721204032/3875222528)
> finish=470.9min speed=76232K/sec
>

Those were the sort of times that I used to see on this machine.

I've fixed it now, though.  There were some clues in syslog - gdm3 was 
alerting 2 or 3 times each second, continually.  This was because I'd 
taken this server offline and across to a workbench to change the 
disk.  I'd restarted the machine, partitioned it, etc, and issued 
those --add commands, without a screen or keyboard, just over ssh.  I 
hadn't realised that gdm3 would panic, causing a couple of acpid 
messages as well each time.

Someone on the Debian list pointed out that gdm3 was a service and 
could be stopped for this circumstance.  Doing that seemed to release 
mdadm to recovering at its normal rate; all the mds are fully 
replicated, now.

Thanks to folks for contributing their thoughts, some interesting 
insights came up as well which will be useful in the future.  This is 
quite an old server (still actively used), created before I realised 
the drawbacks of having so many partitions for each part of the 
filesystem; I don't do this on more-recent systems, which look more 
like the setup you show here.

Anyway, all seems ok now, and thanks again,

regards, Ron
