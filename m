From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: Checkarray doesn't seem to do anything
Date: Tue, 1 Mar 2016 23:25:08 +0100
Message-ID: <20160301222508.GA5495@lazy.lzy>
References: <20160301145721.0a91db92e0d9ae1e5e3fde0508678719.0a105d4628.wbe@email03.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20160301145721.0a91db92e0d9ae1e5e3fde0508678719.0a105d4628.wbe@email03.secureserver.net>
Sender: linux-raid-owner@vger.kernel.org
To: rodman@shellport.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 01, 2016 at 02:57:21PM -0700, rodman@shellport.com wrote:
> Thank you for that information. My kernel is 4.2.0.

I guess the problem is the same.

> 
> Is this it's intended behavior or is it simply a bug that has not been
> corrected?

Well, I think it is a bug.
I'm not sure if "dash" bug or kernel bug.
I suspect "dash", since "bash" works...

> 
> I only bring this up as nearly all mdadm config tutorials at some point
> mention the checkarray function.  They also point out that checkarray is
> also auto configured in the cron tab (cron.d) to run once a month.  But
> of course, if checkarray doesn't work then people may think it is
> running once a month when it really isn't.

Exactly!
I've some Ubuntu 14.04.x with old kernel, and one
with new kernel.
This one has a "weak" HDD in RAID (one / some blocks
waiting for relocation).
In my sytems the check occurs weekly, but it did not!
Tried from command line to no avail...
Debugging the script led to the previous result.

I'm not sure, maybe someone should file a bug, but I
have not to much faith in Ubuntu md/mdadm support.
In the past they were slow or no reacting, and "mdadm"
was always an obsolete version (like it is in 14.04.x).
Maybe Debian could be a better place, not sure.

bye,

pg

> 
> 
> Rodman Frowert  -------- Original Message --------
>  Subject: Re: Checkarray doesn't seem to do anything
>  From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
>  Date: Tue, March 01, 2016 3:33 pm
>  To: rodman@shellport.com
>  Cc: linux-raid@vger.kernel.org
>  
>  On Tue, Mar 01, 2016 at 02:09:44PM -0700, rodman@shellport.com wrote:
>  > 
>  > Hello,
>  > 
>  > I have a question as it pertains to the checkarray function of Mdadm.
> I
>  > can't actually get it to do anything. I'm running Ubuntu 14.04.4
> Server
>  > LTS with the latest mdadm installed. I have a single RAID 1 mirror
>  > configured and working properly near as I can tell. 
>  > 
>  > I can force a check if I issue "echo check >
>  > /sys/block/md0/md/sync_action" as root. I can then see the status of
>  > the check via /proc/mdstat or using the --detail switch on mdadm
> itself.
>  > 
>  > However, nothing happens if I type in:
>  > /usr/share/mdadm/checkarray -a
>  > or
>  > /usr/share/mdadm/checkarray -a /dev/mdX
>  > or
>  > /usr/share/mdadm/checkarray -as
>  > 
>  > I've tried the commands as root and using sudo. The array sits idle
>  > after all of the above commands. The only thing I can actually get
>  > checkarray to perform is to give me the help output if I pass it -h.
> I
>  > have attached, below, the current status of the mdadm managed array. 
>  > Doing some Googling I haven't been able to find anyone else that
> isn't
>  > able to use the checkarray function so I must be doing something
> wrong.
>  > 
>  > Any ideas?
>  
>  Well, yes, I've the same problem.
>  
>  Ubuntu 14.04.x with kernel 3.13, "checkarray" works.
>  Ubuntu 14.04.x with kernel 4.11 (I think), "checkarray"
>  does not work.
>  
>  The script runs with "dash" (not "bash") and it has
>  a "read cur_status < something_from_sysfs" in order to check
>  the array status.
>  With kernel 3.13, the "read" returns the proper value,
>  with kernel 4.11 (I think) the very same "read" exits
>  the script without any message or else.
>  
>  One option is to use "bash", that is change the top
>  of the script from: #!/bin/sh to #!/bin/bash
>  
>  Another is to change the "read", with a "cat", that is
>  something like: cur_status=$( cat something_from_sysfs )
>  
>  You can check yourself, there is only one "read" in
>  the script (if I recall correctly).
>  
>  Hope this helps,
>  
>  bye,
>  
>  pg
>  
>  > 
>  > Rodman Frowert
>  > 
>  
>  > 
>  > cat /proc/mdstat shows:
>  > ------------------
>  > rodman@nas:/usr/share/mdadm$ cat /proc/mdstat
>  > Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
>  > [raid4] [raid10]
>  > md0 : active raid1 sdc1[1] sdb1[0]
>  > 5860389696 blocks super 1.2 [2/2] [UU]
>  > -----------------
>  > 
>  > sudo mdadm --detail /dev/md0 shows:
>  > ------------------
>  > rodman@nas:/usr/share/mdadm$ sudo mdadm --detail /dev/md0
>  > /dev/md0:
>  > Version : 1.2
>  > Creation Time : Fri Feb 26 14:07:40 2016
>  > Raid Level : raid1
>  > Array Size : 5860389696 (5588.90 GiB 6001.04 GB)
>  > Used Dev Size : 5860389696 (5588.90 GiB 6001.04 GB)
>  > Raid Devices : 2
>  > Total Devices : 2
>  > Persistence : Superblock is persistent
>  > 
>  > Update Time : Tue Mar 1 07:40:19 2016
>  > State : clean
>  > Active Devices : 2
>  > Working Devices : 2
>  > Failed Devices : 0
>  > Spare Devices : 0
>  > 
>  > Name : nas:0 (local to host nas)
>  > UUID : 4765e7df:0e1a6ad2:1321765f:a2d9f2c9
>  > Events : 164
>  > 
>  > Number Major Minor RaidDevice State
>  > 0 8 17 0 active sync /dev/sdb1
>  > 1 8 33 1 active sync /dev/sdc1
>  > 
>  > -----------------
>  > --
>  > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
>  > the body of a message to majordomo@vger.kernel.org
>  > More majordomo info at http://vger.kernel.org/majordomo-info.html
>  
>  -- 
>  
>  piergiorgio
>  --
>  To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in
>  the body of a message to majordomo@vger.kernel.org
>  More majordomo info at http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 

piergiorgio
