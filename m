From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Raid1 where Event Count off my 1 cannot assemble --force
Date: Sun, 08 Dec 2013 21:40:50 -0600
Message-ID: <52A53BC2.2060902@suddenlinkmail.com>
References: <52A44778.8040502@suddenlinkmail.com> <alpine.DEB.2.02.1312081157100.24602@uplift.swm.pp.se> <52A4B311.6040204@suddenlinkmail.com> <52A51122.3030604@suddenlinkmail.com> <52A51442.1000903@websitemanagers.com.au> <52A52D35.7060909@suddenlinkmail.com> <52A5350A.2020504@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52A5350A.2020504@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 12/08/2013 09:12 PM, Adam Goryachev wrote:
> Probably the best option is to follow Neil's advise to use mdadm from git....
> 
> The alternative as I mentioned is to backup the data, re-create the raid +
> filesystem, and then restore the data.
>>> BTW, the bitmap location looks.... strange...
>>    I thought so too, but checking the other arrays, /dev/md2 has a negative
>> number as well:
>>
>> nemtemp:/mnt # mdadm -E /dev/sda7
>> /dev/sda7:
>> <snip>
>> Internal Bitmap : -213 sectors from superblock
>>      Update Time : Mon Dec  9 02:14:18 2013
> It looks strange when I first saw it, but now that I think about it, it is
> probably right (correct) since 1.0 metadata is at the very end of the drive, so
> the bitmap is probably before the metadata, hence negative offset.
> 

I have an install cd with mdadm 3.3.2 on it, I'll give that a go and see what it
does with the array. The partition is only 20G, so I can just copy it to a new
drive to backup. It almost seems like I should be able to change the Events
number with a low level tool on one drive and see if that would fix the problem.

I suspect the problem is with the older mdadm. Searching, there were several
posts very similar to mine in the 2008/2009 time frame. The older mdadm probably
does not handle recovery very well.

If I do get the drive to assemble/run under mdadm 3.3.2, then is there anything
I need to do before shutting down the box to insure it will work again under 2.6
so I can at least boot it before updating mdadm? If it assembles under 3.3.2,
then I should be able to assemble/run it under 2.6.4 since the Event count would
match -- right?

-- 
David C. Rankin, J.D.,P.E.
