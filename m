From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: Redundancy check using "echo check > sync_action": error	reporting?
Date: Sat, 22 Mar 2008 11:03:06 +0100
Message-ID: <47E4D95A.9000505@rabbit.us>
References: <47DD2CD7.2090802@tuxes.nl> <20080316161451.0d17fd22@szpak> <47E26775.3000500@tuxes.nl> <20080320134747.GA28114@cthulhu.home.robinhill.me.uk> <47E2725C.1020206@tuxes.nl> <20080320163551.GG13719@mit.edu> <47E2EE64.5080101@rabbit.us> <47E3C504.3010700@tmr.com> <47E3CBAF.4090808@rabbit.us> <47E43E57.5010409@tmr.com> <20080321235557.GA11801@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080321235557.GA11801@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Robin Hill wrote:
> On Fri Mar 21, 2008 at 07:01:43PM -0400, Bill Davidsen wrote:
> 
>> Peter Rabbitson wrote:
>>> I was actually specifically advocating that md must _not_ do anything on 
>>> its own. Just provide the hooks to get information (what is the current 
>>> stripe state) and update information (the described repair extension). The 
>>> logic that you are describing can live only in an external app, it has no 
>>> place in-kernel.
>> So you advocate the current code being in the kernel, which absent a 
>> hardware error makes blind assumptions about which data is valid and which 
>> is not and in all cases hides the problem, instead of the code I proposed, 
>> which in some cases will be able to avoid action which is provably wrong 
>> and never be less likely to do the wrong thing than the current code?
>>
> I would certainly advocate that the current (entirely automatic) code
> belongs in the kernel whereas any code requiring user
> intervention/decision making belongs in a user process, yes.  That's not
> to say that the former should be preferred over the latter though, but
> there's really no reason to remove the in-kernel automated process until
> (or even after) a user-side repair process has been coded.

I am asserting that automatic repair is infeasible in most highly-redundant 
cases. Lets take the root raid1 of one of my busiest servers:

/dev/md0:
         Version : 00.90.03
   Creation Time : Tue Mar 20 21:58:54 2007
      Raid Level : raid1
      Array Size : 6000128 (5.72 GiB 6.14 GB)
   Used Dev Size : 6000128 (5.72 GiB 6.14 GB)
    Raid Devices : 4
   Total Devices : 4
Preferred Minor : 0
     Persistence : Superblock is persistent

     Update Time : Sat Mar 22 05:55:08 2008
           State : clean
  Active Devices : 4
Working Devices : 4
  Failed Devices : 0
   Spare Devices : 0

            UUID : b6a11a74:8b069a29:6e26228f:2ab99bd0 (local to host Arzamas)
          Events : 0.183270

As you can see it is pretty old, and does not have many events to speak of. 
Yet every month when the automatic check is issued I get between 512 and 2048 
in mismatch_cnt. I maintain md5sums of all files on this filesystem, and there 
were no deviations for the lifetime of the array (of course there are 
mismatches after upgrades, after log appends etc, but they are all expected). 
So all I can do with this array is issue a blind repair, without even having 
the chance to find what exactly is causing this. Yes, it is raid1 and I could 
do 1:1 comparison to find which is the offending block. How about raid10 -n 
f3? There is no way I can figure out _what_ is giving me a problem. I do not 
know if it is a hardware error (the md5 sums speak against it), some process 
with weird write patterns resulting in heavy DMA, or a bug in md itself.

By the way there is no swap file on this array. Just / and /var, with a 
moderately busy mail spool on top.

>> Currently the "repair" action (which *is* in the kernel now) takes no 
>> advantage of the additional information available in these cases I noted. 
>> By what logic do you conclude that the user meant "hide the error" when 
>> using the "repair" action? What I propose is never less likely to be 
>> correct than what the current code does, why would you not want to improve 
>> the chances of getting the repair correct?
>>
> That is, of course, a separate issue to whether it should be in-kernel.
> I would entirely agree that user-level processes should be able to
> access and manipulate the low-level RAID data/metadata (via the md
> layer) in order to facilitate more advanced repair functions, but this
> should be separate from, and in addition to, the "ignorant"
> parity-updating repair process currently in place.
> 

I am trying to convey the idea that a first step to a userland process would 
be full disclosure of what is going on. A non-zero mismatch_cnt on a 
multigigabyte array makes an admin very uneasy, without giving him a chance to 
assess the situation.

Peter
