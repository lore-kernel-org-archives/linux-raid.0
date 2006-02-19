From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: block level vs. file level
Date: Sat, 18 Feb 2006 19:38:00 -0500
Message-ID: <43F7BDE8.70309@tmr.com>
References: <43EF8CFB.5080403@kfa.org> <20060212213157.GX32687@strugglers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060212213157.GX32687@strugglers.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@lug.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Andy Smith wrote:

>On Sun, Feb 12, 2006 at 11:31:07AM -0800, it wrote:
>  
>
>>The hardware raid does the mirroring on the block level, so it's 
>>actually /dev/sda mirroring /dev/sdb - the whole drive, and not 
>>partitions. There is a way to set this up on software raid. It takes 
>>more configuration tweaking, but the mirroring then includes the 
>>partition table as well. This way, if a drive fails, one can replace it 
>>without pre-partitioning it.
>>    
>>
>
>That can be less flexible though.  If I have say 4 drives then I
>quite often want small /boot, / and swap under RAID-1 then the rest
>as a single large partition in RAID-5, -6 or -10 as an LVM PV.
>
>  
>
>>This also raises another point, which is relevant for both cases - same 
>>exact models of hard disks have different number of cylinders, so if a 
>>RAID partition is created on a larger drive it cannot be mirrored to a 
>>smaller drive.
>>    
>>
>
>Same exact models don't usually have different block counts, but
>certainly if you replace a dead drive with a different one of the
>same advertised capacity you can end up getting one slightly
>smaller.
>
>  
>
>>Does anyone have any experience with this?
>>    
>>
>
>Yes, and it's a pain, but if you have to deal with it I think the
>wealth of options in md leaves you better able to handle it than
>with hardware RAID.  Here's something that happened to me:
>
>http://strugglers.net/wiki/becks.strugglers.net
>
>  
>
I don't quite understand your problem with fdisk, you can specify 
starting sector and then either ending sector or size, and call it any 
partition number you want. So I don't see why any other tool is required 
and what "at the end" meant in you tale.

Glad you got it working, but you may have used more solution than you 
have problem.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

