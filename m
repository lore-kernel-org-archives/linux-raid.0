From: Ross Boylan <ross@biostat.ucsf.edu>
Subject: Re: how to proceed with possible corruption
Date: Wed, 19 Dec 2012 15:16:22 -0800
Message-ID: <50D24AC6.2080105@biostat.ucsf.edu>
References: <1355951195.12402.33.camel@corn.betterworld.us> <20121219223009.GA12347@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20121219223009.GA12347@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/19/2012 2:30 PM, Robin Hill wrote:
> On Wed Dec 19, 2012 at 01:06:35PM -0800, Ross Boylan wrote:
>
>> Short version: I suspect some of my array components may be corrupt, and
>> wonder what the best way is to  check for it and fix it.
>>
>> I have a VM  configued similarly to my real machine for testing.
>> When I brought it up there were some complaints about the arrays and
>> needing to resync them.  While the sync appeared to complete
>> successfully, the VM was quite unstable afterwards, as it had not been
>> before.
>>
>> The VM was most likely shut down abruptly when the real machine had a
>> power failure.  Also, I had added a 3rd disk to my RAID-1 arrays since I
>> last booted the VM, but my mdadm.conf had -num-devices=2 (which we have
>> already established is a recipe for trouble).
>>
>> I installed a new kernel in the VM, and have not had problems since.  So
>> I wonder if some of the kernel files got corrupted, and more generally
>> if the virtual disks are trustworthy.
>>
>> Does this /proc/mdstat offer any clues about which disks might be a
>> problem?
>>
>> Personalities : [raid1]
>> md0 : active raid1 sda1[0] sdc1[2] sdb1[1]
>>        96256 blocks [3/3] [UUU]
>>
>> md1 : active raid1 sdb3[0] sdc3[2] sda3[1]
>>        8187712 blocks [3/3] [UUU]
>>
>> unused devices: <none>
>>
>> It seems odd the disks are out of order, that is not sda, sdb, sdc.
>>
>> I know I could fail some components and add them back to assure
>> consistency, but this wouldn't tell me if they were inconsistent before
>> that.  There's also the possibility they are  consisstent but corrupt.
>>
> The arrays are RAID1, so the order of the disks is irrelevant - they
> data should be identical on all disks.
>
> You can check whether the disks are all in sync by doing:
>      echo check > /sys/block/mdX/md/sync_action
>
> Once the check is complete (you can see the progress via /proc/mdstat)
> then /sys/block/mdX/md/mismatch_cnt will indicate whether or not there
> are any mismatches. If so, use "repair" instead of "check" in the above
> command to resync the drives.
Thank you for the tip.  This says there are no mismatches, and so I can 
count on the components being in sync.
> Otherwise, the issue could be filesystem corruption. A "fsck -f" on the
> array should detect that.
I think that's my next step.  My understanding is that this guarantees 
the integrity of the file system, but not necessarily the integrity of 
the contents of individual files.  I'm on ext3.
>
> HTH,
>      Robin

