From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Wed, 7 Feb 2018 08:51:15 +1100
Message-ID: <d764a824-fe3e-583a-10ef-040bc32dc78e@websitemanagers.com.au>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180206181416.amo6geclrvc6ylrf@merlins.org>
Content-Language: en-CA
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/02/18 05:14, Marc MERLIN wrote:
> So, I have 2 drives on a 5x6TB array that have respectively 1 and 8
> pending sectors in smart.
>
> Currently, I have a check running, but it will take a while...
>
> echo check > /sys/block/md7/md/sync_action
> md7 : active raid5 sdf1[0] sdg1[5] sdd1[3] sdh1[2] sde1[1]
>        23441561600 blocks super 1.2 level 5, 512k chunk, algorithm 2 [5/5] [UUUUU]
>        [==>..................]  check = 10.5% (615972996/5860390400) finish=4822.1min speed=18125K/sec
>        bitmap: 3/44 pages [12KB], 65536KB chunk
>
> My understanding is that eventually it will find the bad sectors that can't be read
> and rewrite new ones (block remapping) after reading the remaining 4 drives.
>
> But that may take up to 3 days, just due to how long the check will take and size of the drives
> (they are on a SATA port multiplier, so I don't get a lot of speed).
>
> Now, I was trying to see if I could just manually remap the block if I can read it at
> least once.
> Smart shows:
> # 3  Extended offline    Completed: read failure       90%       289         1287409520
> 197 Current_Pending_Sector  0x0032   200   200   000    Old_age   Always       -       1
>
> So, trying to read the block until it reads ok and gets remapped, would be great
> but that didn't work:
>
> Does that sound like a good plan, or is there another better way to fix my issue?

I think instead of reading the sector from the drive and relying on the 
drive to determine the correct data (it's already telling you it can't). 
What you need to do is find out where on md7 drive x sector y maps to 
and read that sector from md7, which will get md to (possibly) notice 
the read error, and then read the data from the other drives, and then 
re-write the faulty sector with correct calculated data (or do the 
resync on that area of md7 only).

You could probably take a rough guess as follows (note, my math is 
probably totally bogus as I don't really know the physical / logical 
mapping for raid5, but I'm guessing)
You have 5 drives in raid5, and we know one drive (capacity) is used for 
checksum, so four drives of data. So sector 1287409520 of one drive 
would be approx 4 x sector 1287409520 of the md array.

So try setting something like 1287000000 * 4 as the start of the resync 
up to 1288000000 * 4 and see if that finds and fixes it for you.

If nothing else, it should finish fairly quickly. You might need to 
start earlier, but you could just keep reducing the "window" until you 
find the right spot. Or, someone who knows a lot more about this mapping 
might jump in and answer the question, though they might need to see the 
raid details to see the actual physical layout/order of drives/etc.

Hope that helps anyway....

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
-- 
The information in this e-mail is confidential and may be legally privileged.
It is intended solely for the addressee. Access to this e-mail by anyone else
is unauthorised. If you are not the intended recipient, any disclosure,
copying, distribution or any action taken or omitted to be taken in reliance
on it, is prohibited and may be unlawful. If you have received this message
in error, please notify us immediately. Please also destroy and delete the
message from your computer. Viruses - Any loss/damage incurred by receiving
this email is not the sender's responsibility.
