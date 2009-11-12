From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: [ANNOUNCE] mdadm-3.1 has been withdrawn
Date: Thu, 12 Nov 2009 17:25:49 -0500
Message-ID: <4AFC8B6D.7080603@tmr.com>
References: <19187.50708.551325.297625@notabene.brown> <4AF829B2.5090001@redhat.com>  <4AF836F8.5040903@panix.com> <cccedfc60911090742x5ac85a5axcf93d5cb9f6f6539@mail.gmail.com> <alpine.DEB.1.10.0911091749320.22728@uplift.swm.pp.se> <4AF8847D.8030303@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF8847D.8030303@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, Jon Nelson <jnelson-linux-raid@jamponi.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Doug Ledford wrote:
> On 11/09/2009 11:51 AM, Mikael Abrahamsson wrote:
>   
>> On Mon, 9 Nov 2009, Jon Nelson wrote:
>>
>>     
>>> I've been using 1.1 for everything.  What's the current wisdom
>>> regarding 1.0 vs 1.1 or 1.2?
>>> I used 1.1 because that's also where filesystem metadata usually goes
>>> and therefore one might hope that the presence of the md metadata
>>> would prevent accidental identification of a raid volume as containing
>>> a filesystem.
>>>       
>> I like 1.2 because if you happen to write an MBR or something to the
>> drive, you don't lose the superblock.
>>     
>
> Of course, I recently had a bug report that I ended closing out as
> NOTABUG because of this very ability.  The person had arrays with 1.2
> superblocks, and they went to add a new disk, and all the existing disks
> had a specific partition layout, so he copied that to the new disk, then
> tried to add the partition to the raid array.  It kept returning "device
> too small for array".  Then, upon inspection, we come to see he has a
> 1.2 superblock on the *entire* drive, which left the partition table
> intact, but the partition table is *pointless* because the array is on
> the whole disk devices.  This sort of confusion is bad.  So, while I
> could see making it 1.2 for partitions (so that boot sectors won't
> overwrite the superblock), I wouldn't make it 1.2 for whole disk
> devices, and in fact it might be wise to refuse to create 1.2
> superblocks on whole disk devices.  Just a thought.
>
>   

I'm trying to wrap my head around this recommendation, and not doing 
well. The end of the allocation area (partition, disk, array, whatever) 
seems to be what users hit when they do a dd or some similar operation 
without understanding it. And the from end is what they hit when they 
"fix" the MBR or add a partition table because something said it was 
missing. As for your friend, nothing is foolproof, and unless he tried 
very hard he probably failed to damage anything in a way which couldn't 
be readily fixed.

I like 1.2, I feel it's least likely to suffer collateral damage, and 
the problems it causes seem to result in the type of behavior you 
mention aboue, the system says "Can't, won't, you don't know what you're 
doing."

-- 
Bill Davidsen <davidsen@tmr.com>
  "We can't solve today's problems by using the same thinking we
   used in creating them." - Einstein

