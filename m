From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: mdadm: what if - crashed OS
Date: Fri, 05 Jan 2007 16:51:12 -0500
Message-ID: <459EC850.1050509@tmr.com>
References: <63442.70.104.60.127.1167978180.squirrel@spinellicreations.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <63442.70.104.60.127.1167978180.squirrel@spinellicreations.com>
Sender: linux-raid-owner@vger.kernel.org
To: Vince@SpinelliCreations.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Vince Spinelli wrote:
> Hello,
>
> My name is Vince Spinelli, from Buffalo, NY (US).  I am currently using
> 'mdadm' under Fedora Core 5 (32-bit) to run two Soft-RAID arrays.
>
> 1) RAID-1 (mirror) for mission critical data.  #drives = 2 ea. PATA ATA100
> 2) RAID-5 (striped+parity) for multimedia data.  #drives = 5 ea. SATA 3G
>
> My question is this...
>
> In case of catastropic machine failure, such as the operating system
> (which is on a separate PATA ATA100 drive) failing or even the OS hard
> drive being physically destroyed, how would I go about rebuilding my RAID
> arrays?
>   
May I say that if you don't want to lose your data, then the o/s is 
"critical data." I regard boot, root, and swap as critical, because if 
they fail you have a much more complex recovery issue. Also note that 
you still need backup, because some hardware failure modes will write 
bad data (maybe silently) without an actual "crash" you notice. Power 
supplies, controllers, and disk drives will help you test your backup 
procedures.
> Obviously, this would assume that the 7 disks which make up my arrays had
> survived and were not damaged.
>
> -I would obviously then build a new computer,
> -install Linux, make sure 'mdadm' was installed,
> -physically install all of my drives into the computer,
> -copy my old /etc/mdadm.conf file (which has been saved on cd-rom but is
> easily re-made) onto the new computer,
> - and then what?
>
> I have thought about this, and I can't understand how 'mdadm' decides the
> health of an array.
>
> For example, if I type at prompt:
>
> /sbin/mdadm --detail /dev/md1
>
> then I am given the current status of array 'md1'.  It may be clean,
> degraded, recovering, or whatever.  Therefore, on a fresh install of
> Linux, with a fresh copy of 'mdadm', I am led to believe that the result
> of the previous command would be something like...
>
> Active Devices = 0
> Working Devices = 4
> Failed Devices = 0
> Spare Devices = 4
>
> That, obviously would be no good.
>
> So, please, if anyone has rebuilt a Soft-RAID array from scratch WHILE
> STILL PRESERVING THE DATA ON THAT ARRAY with 'mdadm', please explain how
> this is accomplished, as I'm sitting on 1.5 TB of data that I truly do not
> want to lose.
You just set devices to PARTITIONS and use the -assemble command. Oh, 
you use a superblock with uuid so assemble can figure out what to do.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

