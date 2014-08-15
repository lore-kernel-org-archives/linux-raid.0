From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Unable to re-add a disk  after a reboot.
Date: Thu, 14 Aug 2014 20:33:45 -0500
Message-ID: <53ED6379.8030404@gmail.com>
References: <53ED416E.8010504@gmail.com> <20140815101924.1d09363d@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140815101924.1d09363d@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 08/14/2014 07:19 PM, NeilBrown wrote:
> On Thu, 14 Aug 2014 18:08:30 -0500 Ram Ramesh <rramesh2400@gmail.com> wrote:
>
>> Hi,
>>
>>     I just finished converting a 3-disk raid5 to 4-disk raid6. After a
>> reboot to start clean, I noticed that one of the disk (the new one I
>> just added) was missing in /proc/partitions. This was disk 4 in my
>> /dev/md0. Assuming some cable issue, I powered off, wiggled the cables
>> and restarted and the device was found by kernel. However, md0 shows
>> device missing and array degraded
>>
>>      lata [rramesh] 280 > cat /proc/mdstat
>>      Personalities : [raid6] [raid5] [raid4]
>>      md0 : active raid6 sdb1[0] sdd1[3] sdc1[1]
>>             3906763776 blocks super 1.2 level 6, 512k chunk, algorithm 2
>>      [4/3] [UUU_]
>>
>>      unused devices: <none>
>>
>> However my attempt to --re-add does not work.
>>
>>      lata [rramesh] 277 > sudo mdadm /dev/md0 --verbose --re-add /dev/sde1
>>      mdadm: --re-add for /dev/sde1 to /dev/md0 is not possible
> "re-add" only makes sense when you have a write-indent bitmap which you don't
> have.
> So you need to "--add" which marks the device as a spare and then starts a
> complete rebuild.
>
>
>> I checked the SMART and it shows a lot of reallocated_sector_ct errors
>> also. So, the disk is dying, but I am not able understand why mdadm
>> would not add.
> It will "add".  It just wont "re-add".
>
> NeilBrown
>
>
Thanks. Did not know that. I thought it will add without rebuild. This 
means if a cable accidentally came off or if I booted without one disk 
by mistake, my arrays are dead. This looks too restrictive. I must be 
wrong in my conclusion. Please help me see this. Is there a add with 
assume clean?

Anyway, there is no point in rebuilding (or adding) it after it failed 
this miserably (has 17K reallocated event count, whatever that means) . 
I will let the array be degraded until I find a replacement.

I thought write-intent bitmap was not a good idea. May be I did not 
research enough. This brings me to the next (probably more important) 
question. How do I replace a old drive that has not died without having 
to rebuild? If I did a dd image xfer will it accept
the replacement?

Ramesh

