From: Robin Bowes <robin-lists@robinbowes.com>
Subject: Re: ATAn timeout errors
Date: Fri, 02 Dec 2005 14:18:08 +0000
Message-ID: <dmpl2s$6ul$1@sea.gmane.org>
References: <dhu42t$216$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <dhu42t$216$1@sea.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

My server is now unusable - I've rebuilt the array using a boot CD and 
it completed OK.

I rebooted from the internal drives and it came up OK, then crashed with 
  an "ata6: commain timeout" error.

I guess there must be a hardware issue somewhere, but I have no idea where.

Anyone got any ideas or suggestions?

R.

Robin Bowes said the following on 04/10/2005 15:37:
> I posted this on the linux-ide list but got no response so I thought I'd 
> try here.
> 
> My setup is as follows:
> 
> Epox EP-D3VA
> Dual PIII 1GHZ processors
> 1.5GB RAM
> Two of Promise SATA150 TX4 controllers
> Six of Maxtor 250GB SATA drives (7Y250M0) - three per controller
> 
> Running Fedora Core 4 with "stock" FC4 kernel 
> (kernel-smp-2.6.12-1.1456_FC4)
> 
> I have four md arrays as follows:
> 
> /dev/md0 RAID1 /dev/sd[ad]
> /dev/md1 RAID1 /dev/sd[be]1
> /dev/md2 RAID1 /dev/sd[cf]1
> /dev/md5 RAID5 /dev/sd[abcef]2 (/dev/sdd2 is a hot spare)
> 
> md[0-2] are 1.5 MB areas
> /dev/md0 is /
> /dev/md1 is swap
> /dev/md2 is currently not used
> 
> md5 is 929GB and I have used lvm to create:
> 
> /home home_lv audio_vg -wi-ao 914.38G
> /usr  usr_lv  audio_vg -wi-ao  10.00G
> /var  var_lv  audio_vg -wi-ao   5.00G
> 
> Ok, onto the problem...
> 
> After a couple of power outages I recently got myself a UPS but 
> (typically) didn't get round to installing it before another outage (doh!).
> 
> The server came back up OK with /dev/md5 dirty and needing to resync.
> 
> However, during the re-sync, one or more of the disks clunked and I saw 
> an "ATAn Timeout" message on the console and the system froze. (n 
> varied, e.g. ATA2, ATA1, ATA4, etc.)  This seemed to be triggered by 
> doing something that caused disk activity during the resync.
> 
> I've seen this before and done a hard-reset to start again - eventually 
> the resync has completed and everything's back to normal.
> 
> However, this time, I had to drop to single-user mode and reduce the 
> RAID sync speed (echo 5000 > /proc/sys/dev/raid/speed_limit_max) to get 
> the resync to complete.
> 
> The server then hung again - same error - so I used Maxtor's PowerMax 
> utility to perform a full test of all drives and all passed 
> successfully. I then rebooted and left it re-syncing in multi-user mode 
> (with fingers crossed) and this time it completed successfully.
> 
> Can anyone tell me if this is a bug somewhere or might it be a hardware 
> limitation, i.e. saturating the PCI bus when resyncing? Is there 
> anything I can do to prevent it from happening?
> 
> I'm not too bothered about RAID performance - I mainly use it to store 
> .flac audio files which don't need great throuhgput to stream off the disk.
> 
> Any suggestions (or fixes!) appreciated.
> 
> Thanks,
> 
> R.

