From: Vinnie <listacct1@lvwnet.com>
Subject: Re: HELP - need more documentation on using partitioned (mdp-type) md devices
Date: Tue, 05 Nov 2002 01:07:56 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3DC7603C.9040105@lvwnet.com>
References: <3DC7432B.304@lvwnet.com> <15815.18944.139723.503440@notabene.cse.unsw.edu.au> <3DC74C44.7090101@lvwnet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Linux Raid List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@cse.unsw.edu.au>
List-Id: linux-raid.ids

Hi Neil!

Thanks for your help.  That did the trick!

I did have to change the partitions= to partition=, I didn't know any 
better but LILO did! ;)

Also once I got a successful LILO install (I did a -t -v first), and 
booted up, I got an error from LILO stating "EBDA Too Big".

I looked up EBDA in the README's and it says it is a thing that happens
sometimes with MultiProcessor motherboards, and suggested building LILO
with the LARGE_EBDA option.  I thought I'd try out just using the
'compact' statement in lilo.conf first, and that was enough to do it, I
got booted up successfully!

My test case told the kernel that the root fs was on the original 
external RAID subsystem, so really all I was testing was that I could 
actually boot from the RAID1 pair of IDE disks created with the 
partitioned md device.  Should be able to proceed on now to copying all 
files over to the filesystems on the RAID1 pair, so I can pull this 
external RAID subsystem offline and reconfigure it.

Thanks again Neil!  Couldn't have done it without your help!  Well, not 
in the next week or so, probably... ;)

vince


Vinnie wrote:

> Neil Brown wrote:
> 
>> On Monday November 4, listacct1@lvwnet.com wrote:
>>
>>> If anybody (Neil?) can offer some advice on how to get LILO to write 
>>> a boot sector to the RAID1 array pair, it would be greatly 
>>> appreciated.  I am so close to getting this working!!!
>>>
>>>
>>
>> First, lilo thinks it knows what "/dev/md*" means, and gets all
>> confused when it turns out to be different.
>> So create device names that *don't* start /dev/md.
>> e.g.
>>    /dev/MDa == 60,0
>>    /dev/MDa1 == 60,1
>>    etc
>>
>> Second, you have to tell lilo about the geometry of /dev/MD*, because
>> it doesn't know:
>>
>>    boot=/dev/MDa
>>    disk=/dev/MDa
>>      bios=0x80
>>      sectors=63
>>      heads=255
>>      cylinders=1024
>>      partitions=/dev/MDa1
>>       start=63
>>
>> The "start" is very important.  check what the start sector of MDa1
>> is, and use that.
>>
>> Lilo should then work.
>>
>> NeilBrown
> 
> 
> 
> thanks Neil!  Getting ready to try this out.  This looks really 
> promising, makes a lot of sense.
> 
> Vince
> 
> 
> 
> 



