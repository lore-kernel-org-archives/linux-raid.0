From: Tyler <pml@dtbb.net>
Subject: Re: Rebuilt Array Issue
Date: Thu, 11 Aug 2005 04:31:27 -0700
Message-ID: <42FB370F.6000800@dtbb.net>
References: <003701c59e5d$fbbc5ca0$c700a8c0@NCNF5131FTH>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <003701c59e5d$fbbc5ca0$c700a8c0@NCNF5131FTH>
Sender: linux-raid-owner@vger.kernel.org
To: "David M. Strang" <dstrang@shellpower.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David M. Strang wrote:
<snip...>

>      24      65      128       24      active sync 
> /dev/scsi/host2/bus0/target24/lun0/disc
>      25      65      144       25      active sync 
> /dev/scsi/host2/bus0/target25/lun0/disc
>      26       0        0        -      removed
>      27      65      176       27      active sync 
> /dev/scsi/host2/bus0/target27/lun0/disc
>
>      28      65      160       26      active sync 
> /dev/scsi/host2/bus0/target26/lun0/disc
>
>
> Is it supposed to stay with number 26 as removed forever? Does number 
> 28 ever jump back up to that spot? I shouldn't have to hotadd and 
> allow it to resync everytime I re-assemble the raid should I?
>
No, you shouldn't have to hotadd and resync each time, after hot-adding 
a "new" device and the initial rebuild finishes, unless there's another 
failure after that, or an unclean shutdown.

Tyler.
