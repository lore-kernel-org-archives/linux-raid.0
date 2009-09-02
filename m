From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Converting ext3 to RAID1 ...
Date: Wed, 02 Sep 2009 12:27:10 -0400
Message-ID: <4A9E9CDE.1040308@tmr.com>
References: <b7b14cbb0908241424i50bdcf59p35a63e4496b108ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b7b14cbb0908241424i50bdcf59p35a63e4496b108ca@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Clinton Lee Taylor <clintonlee.taylor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Clinton Lee Taylor wrote:
> Greetings ...
>
> I asked this question about two weeks ago
>
> http://www.issociate.de/board/post/498227/Ext3_convert_to_RAID1_....html
>
>   and have had not response, so I am going to try and re-phrase and
> hope that somebody can confirm my test case. Thanks.
>
> Wanting to convert an already created and populated ext3 filesystem.
>
> I unmounted the filesystem, ran e2fsck -f /dev/sdb1 to check that the
> current filesystem had no errors.
> Then ran mdadm --create /dev/md0 --level=1 -n 1 /dev/sdb1 --force to
> create the RAID1 device, answered yes to the question.
>   

Right here is where you invite problems. You want to create the array 
using the new device or partition, and put a new filesystem on it. Read 
and understand the man page for mke2fs in the stride= and stripe-width= 
parameters, it shouldn't matter for raid-1 but would if you use 
raid-[56]. Then mount the array, copy the data to the array, verify it, 
and then unmount the old partition and add it.
> Ran e2fsck -v /dev/md0 to check that the RAID1 device had no
> filesystem corruption on it, which it did not.
> Added a spared RAID device using mdadm --add /dev/md0 /dev/sdc1
> Then grew the RAID1 device to two compents with mdadm --grow /dev/md0
> --raid-disks=2 --backup-file=/root/raid1.backup.file
>   

I have an entry in my raid notes which says that's the wrong thing to 
do, the array should be created with the correct number of members and 
one left "missing" to be added later. My note says it should be done 
that way, but not why it's better, but it says "per Neil" so I bet there 
is a reason. It does seem to work that way, I just did an adventure in 
file moving to test it the hard way. I was doing a mix of raid-1, 
raid-10, and raid-5 arrays moving from little drives (750GB) to larger ones.

> Did another filesystem check once the RAID finished rebuilding and all
> seemed fine.
> Double checked that the data on the RAID was the same as the original
> data by diffing the two, again all was fine.
>
>  Now is this just lucky or would this be an acceptable way to convert
> an existing ext3 filesystem to RAID1?
>   

See above, given the resize you didn't mention it's okay, but forget the 
resize and you risk your data.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"Now we have another quarterback besides Kurt Warner telling us during postgame
interviews that he owes every great thing that happens to him on a football
field to his faith in Jesus. I knew there had to be a reason why the Almighty
included a mute button on my remote."
			-- Arthur Troyer on Tim Tebow (Sports Illustrated)

