From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: Re: partitionable md partition size caps at 0.4TB
Date: Fri, 14 Nov 2008 10:23:22 +0200 (EET)
Message-ID: <alpine.DEB.2.00.0811140950550.23726@kurp.hut.fi>
References: <alpine.DEB.2.00.0811131350410.20263@kurp.hut.fi> <491C27C7.2040400@ziu.info>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <491C27C7.2040400@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Michal,

On Thu, 13 Nov 2008, Michal Soltys wrote:
>> is it possible to create md partitions larger than 0.4TB?
>> 
>> We have >=9TB RAID-0 systems, and I tried to create a partitionable 
>> two-partition md with mdadm --auto=mdp2 and partition it into for example 
>> 16MB and ~9TB. For partitioning /dev/md_d0 I have tried sfdisk, fdisk, 
>> cfdisk, parted, ... Regardless of the partitioning tool, the ~9TB partition 
>> always ends up as 455780.07MB i.e. 0.4TB.
>
> I'm assuming you tried standard MBR layout - you can't go above ~ 2TB limit 
> with it - you need either GPT, or use the device directly (as in md0 case). I 
> have one 1.5TB partition running happily on one of my systems (still within 
> limits of old MBR layout, but under GPT).

Aha, with GPT it works perfectly,

   parted /dev/md_d0 --script mklabel gpt
   parted /dev/md_d0 --script mkpart primary1 0 128M
   yes | parted /dev/md_d0 -- mkpart primary2 128M -1
   ... mkfs.* ...
   parted /dev/md_d0 --script print
   Number  Start   End     Size    File system  Name      Flags
    1      17.4kB  128MB   128MB   ext2         primary1
    2      128MB   9252GB  9252GB  xfs          primary2

and the final size of md_d0p2 is a correct 9252GB. The system does not 
boot from RAID, we just use the raid0 for >>4 Gbps data acquisition. Good 
to know about the newer superblock versions (mdadm -e option).

Thanks for your help!

  - Jan
