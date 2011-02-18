From: Phil Turmel <philip@turmel.org>
Subject: Re: Linux software RAID assistance
Date: Fri, 18 Feb 2011 08:16:19 -0500
Message-ID: <4D5E7123.5020103@turmel.org>
References: <4D540F6C.6050904@gmail.com>	<20110215155315.55d35b8e@notabene.brown>	<4D5A92F3.1090004@turmel.org>	<4D5BD678.2050200@gmail.com>	<4D5BE119.7000804@turmel.org>	<4D5C0E17.3060306@gmail.com>	<4D5C140F.9010301@turmel.org>	<4D5C1508.3040308@gmail.com>	<4D5C15D3.1070608@turmel.org>	<4D5C167C.7000101@turmel.org>	<4D5C1CF8.1020507@gmail.com>	<4D5C1E0B.9060300@turmel.org>	<4D5C2061.4060106@gmail.com>	<4D5C2143.3000907@turmel.org>	<4D5C2260.3020800@gmail.com>	<4D5C273E.7020609@turmel.org> <AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=420ttuWWG0vCWy00YLmZvGiM9JTF2n-oi2ebu@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Simon Mcnair <simonmcnair@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/18/2011 04:31 AM, Simon Mcnair wrote:
> time passes.  You are eaten by a Grue.  Sheesh this is taking a long time.
> 
> simon@proxmox:~$ top
> 
> top - 09:26:19 up 20:36, 11 users,  load average: 2.46, 2.49, 2.39
> Tasks: 334 total,   9 running, 325 sleeping,   0 stopped,   0 zombie
> Cpu(s): 52.8%us,  9.4%sy,  0.0%ni, 35.2%id,  2.5%wa,  0.0%hi,  0.2%si,  0.0%st
> Mem:  12299244k total, 12227584k used,    71660k free, 11042868k buffers
> Swap: 11534332k total,        0k used, 11534332k free,   208204k cached
> 
>   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
> 18896 root      20   0 12288 1072  460 S   63  0.0 431:16.55 ntfs-3g
> 18909 root      20   0 12288 1064  460 R   62  0.0 419:17.11 ntfs-3g
> 18920 root      20   0 12288 1100  492 R   62  0.0 428:17.33 ntfs-3g
>  9210 root      20   0  4068  520  328 S   54  0.0 661:59.92 gzip
>  9138 root      20   0  4068  524  328 R   53  0.0 647:29.07 gzip
>  9247 root      20   0  4068  524  328 S   53  0.0 651:28.36 gzip
> 25678 root      20   0  4068  524  328 R   52  0.0 439:49.20 gzip
> 24957 root      20   0  4068  524  328 R   51  0.0 437:44.01 gzip
> 25792 root      20   0  4068  524  328 S   48  0.0 433:28.14 gzip
> 
> This is hardly touching the CPU on the box (in my opinion), any advice
> on using renice ?  I've never used it before, but now seems like a
> good time ?

Probably wouldn't help.

You have a total usage of 65%.  I suspect that each of the processors running gzip are nearly pegged, and everything else is loafing along.  Hit '1' in top to show the CPU usage per-cpu.  Single-threaded gzip is holding you back.

If you had enough space for saving the partitions uncompressed, it would be much faster.  The PCIe x4 interface on the SuperMicro has a theoretical performance of 1GByte/s, which would be ~ 125MB/s per drive.  From what I've read, that card actually delivers ~ 75MB/s per drive when they're all busy.

Phil
