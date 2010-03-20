From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Sysfs update frequency
Date: Sat, 20 Mar 2010 12:48:28 -0400
Message-ID: <4BA4FC5C.7060502@tmr.com>
References: <150c16851003161432gf38c0f5o1cc957435efd4c3e@mail.gmail.com> <20100317085256.6caee9bb@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100317085256.6caee9bb@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Maggard <jmaggard10@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Tue, 16 Mar 2010 14:32:55 -0700
> Justin Maggard <jmaggard10@gmail.com> wrote:
>
>   
>> I've noticed on recent kernels that /sys/block/md?/md/sync_completed
>> seems to rarely get updated.  What is the expected update interval?
>> For me, it seems to only update about once every 6% or so during the
>> resync.  Of course, /proc/mdstat has the actual current progress.
>>     
>
> The expected update time is every 6% - actually 1/16 which is 6.25%.
>
> sync_completed includes a guarantee that all blocks before this point really
> have been processed.  The number in /proc/mdstat is less precise.  The much
> of the array has been resynced, but due to the possibility of out-of-order
> completion of writes they may not be a contiguous series of blocks.
>
>   
Couldn't you just track the outstanding writes by LBA (or similar) and 
report that the completion is one less than the lowest write still 
outstanding? Since you would only do it when the user requests it, I 
don't think the overhead of a list scan or similar would be a show 
stopper. Or is that approach too simplistic?

> Providing the guarantee (which is needed for externally-managed metadata)
> requires briefly stalling the resync, so I didn't want to do it more often.
> I could possibly make it time-bases instead of size-based though.
>   

Is perfect accuracy needed, just as long as you don't promise to have 
synced more than you have? Are you using barriers to be sure the data is 
all the way to the platter, or is your stall just "to the device" 
anyway? Like any snapshot of a dynamic process, by the time you get the 
information it's out of date in any case, so I think a "at least this 
much has moved to the device" value would serve.

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

