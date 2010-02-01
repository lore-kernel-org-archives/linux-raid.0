From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Zeroing multiple superblocks
Date: Mon, 01 Feb 2010 16:22:25 -0500
Message-ID: <4B674611.2030402@tmr.com>
References: <20100122200924.GA29183@psychosis.jim.sh>	<20100125095221.GV21495@skl-net.de> <20100129233111.5c9cc1d0@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100129233111.5c9cc1d0@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Andre Noll <maan@systemlinux.org>, Jim Paris <jim@jtan.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Mon, 25 Jan 2010 10:52:21 +0100
> Andre Noll <maan@systemlinux.org> wrote:
>
>   
>> On 15:09, Jim Paris wrote:
>>
>>     
>>> I guess the only way to be fully safe with the current approach is to
>>> do a zero-superblock over and over until it complains.
>>>       
>> mdadm --zero-superblock tries to guess the location of the superblock.
>> If more than one superblock is found, the one with the latest creation
>> time is being zeroed. So yes, the method you describe works and I think
>> it is the most reliable way to remove all superblocks of a device.
>>
>> Maybe we could teach mdadm --zero-superblock to honor the --metadata=x
>> option which would zero-out the region of the device where the
>> version-x superblock is located.
>>     
>
> Latest mdadm has this feature.
> And if --metadata= isn't given, it repeatedly trying to find and zero a
> superblock until no more superblocks can be found.
>   

That would be potentially a bad thing, people do run things like RAID1+5 
and might want to clear on block and save the other, still possibly part 
of a running array, one. I'm not sure that's a safe default behavior.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

