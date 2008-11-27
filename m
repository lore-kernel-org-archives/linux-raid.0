From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: [RFC patch 1/1] Track raid5/6 statistics.
Date: Thu, 27 Nov 2008 10:21:25 -0900 (AKST)
Message-ID: <alpine.LNX.2.00.0811271001300.11346@filesrv1.baby-dragons.com>
References: <20081126190452.775333692@sun.com> <20081126190854.813151413@sun.com> <20081127114748.GE14570@boogie.lpds.sztaki.hu> <20081127135248.GD29919@clouds> <20081127171535.GL14570@boogie.lpds.sztaki.hu> <20081127182912.GE29919@clouds>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081127182912.GE29919@clouds>
Sender: linux-raid-owner@vger.kernel.org
To: Jody McIntyre <scjody@sun.com>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Jody (& All) ,

On Thu, 27 Nov 2008, Jody McIntyre wrote:
> On Thu, Nov 27, 2008 at 06:15:35PM +0100, Gabor Gombas wrote:
>
>> /proc contains a lot of legacy junk but nowadays the trend is that you
>> should not add new files under /proc that are not process-related.
>
> Agreed.  I'm not proposing that at all.
>
>> Changing /proc/mdstat is IMHO out of question since it is part of the
>> user visible ABI and breaking that is a big no-no. So if you want all
>> info in a single file that pretty much leaves only debugfs.
>
> AFAICT it was last changed on 2005-09-09 (appearing in 2.6.14).  This
> suggests we can change it given a sufficiently good reason.
>
> debugfs isn't a good idea since ordinary systems won't (or shouldn't)
> have it mounted.  In case I wasn't clear: some of these statistics _are_
> useful to administrators with sufficient RAID knowledge.  For example,
> if "out of stripes" is large and you have lots of memory, increasing
> stripe_cache_size will likely be useful.
>
> Cheers,
> Jody
 	Seems as if changing /proc/mdstat might be problematic for all the 
present tools that monitor status ,  of an array & the disks ,  using it .
 	Tho somewhere I remember seeing "howto extemd a /proc/..." saying 
something about always "add to the end of a line any new data" & "never insert 
-before- present lines in those files" .

 	That said ,  /sys might actually be a convenient structure to place a 
single file for these statistics .  Try asking the /sys maintainer .

 	But ,  I'd like to further suggest that the creation criteria for this 
file be a boot: time option Or of course the ubiquitous module can be installed .
 	Thus the file is not created with every boot unless grub/lilo configs 
are modified ,  but just when the 'System Manager' needs to take a look .

 	Just $.02 ,  Twyl ,  JimL
-- 
+------------------------------------------------------------------+
| James   W.   Laferriere | System    Techniques | Give me VMS     |
| Network&System Engineer | 2133    McCullam Ave |  Give me Linux  |
| babydr@baby-dragons.com | Fairbanks, AK. 99701 |   only  on  AXP |
+------------------------------------------------------------------+
