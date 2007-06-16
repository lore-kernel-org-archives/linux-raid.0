From: David Greaves <david@dgreaves.com>
Subject: Re: limits on raid
Date: Sat, 16 Jun 2007 14:33:14 +0100
Message-ID: <4673E69A.4020309@dgreaves.com>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>	<18034.479.256870.600360@notabene.brown>	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>	<18034.3676.477575.490448@notabene.brown>	<20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18035.23867.576212.859440@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Wakko Warner <wakko@animx.eu.org>, david@lang.hm, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Friday June 15, wakko@animx.eu.org wrote:
>  
>>                                                   As I understand the way
>> raid works, when you write a block to the array, it will have to read all
>> the other blocks in the stripe and recalculate the parity and write it out.
> 
> Your understanding is incomplete.

Does this help?
[for future reference so you can paste a url and save the typing for code :) ]

http://linux-raid.osdl.org/index.php/Initial_Array_Creation

David



Initial Creation

When mdadm asks the kernel to create a raid array the most noticeable activity 
is what's called the "initial resync".

The kernel takes one (or two for raid6) disks and marks them as 'spare'; it then 
creates the array in degraded mode. It then marks spare disks as 'rebuilding' 
and starts to read from the 'good' disks, calculate the parity and determines 
what should be on any spare disks and then writes it. Once all this is done the 
array is clean and all disks are active.

This can take quite a time and the array is not fully resilient whilst this is 
happening (it is however fully useable).

--assume-clean

Some people have noticed the --assume-clean option in mdadm and speculated that 
this can be used to skip the initial resync. Which it does. But this is a bad 
idea in some cases - and a *very* bad idea in others.

raid5

For raid5 especially it is NOT safe to skip the initial sync. The raid5 
implementation optimises use of the component disks and it is possible for all 
updates to be "read-modify-write" updates which assume the parity is correct. If 
it is wrong, it stays wrong. Then when you lose a drive, the parity blocks are 
wrong so the data you recover using them is wrong. In other words - you will get 
data corruption.

For raid5 on an array with more than 3 drive, if you attempt to write a single 
block, it will:

     * read the current value of the block, and the parity block.
     * "subtract" the old value of the block from the parity, and "add" the new 
value.
     * write out the new data and the new parity.

If the parity was wrong before, it will still be wrong. If you then lose a 
drive, you lose your data.

linear, raid0,1,10

These raid levels do not need an initial sync.

linear and raid0 have no redundancy.

raid1 always writes all data to all disks.

raid10 always writes all data to all relevant disks.


Other raid levels

Probably the most noticeable effect for the other raid levels is that if you 
don't sync first, then every check will find lots of errors. (Of course you 
could 'repair' instead of 'check'. Or do that once. Or something.)

For raid6 it is also safe to not sync first, though with the same caveat. Raid6 
always updates parity by reading all blocks in the stripe that aren't known and 
calculating P and Q. So the first write to a stripe will make P and Q correct 
for that stripe. This is current behaviour. There is no guarantee it will never 
changed (so theoretically one day you may upgrade your kernel and suffer data 
corruption on an old raid6 array).

Summary

In summary, it is safe to use --assume-clean on a raid1 or raid1o, though a 
"repair" is recommended before too long. For other raid levels it is best avoided.

Potential 'Solutions'

There have been 'solutions' suggested including the use of bitmaps to 
efficiently store 'not yet synced' information about the array. It would be 
possible to have a 'this is not initialised' flag on the array, and if that is 
not set, always do a reconstruct-write rather than a read-modify-write. But the 
first time you have an unclean shutdown you are going to resync all the parity 
anyway (unless you have a bitmap....) so you may as well resync at the start. So 
essentially, at the moment, there is no interest in implementing this since the 
added complexity is not justified.

What's the problem anyway?

First of all RAID is all about being safe with your data.

And why is it such a big deal anyway? The initial resync doesn't stop you from 
using the array. If you wanted to put an array into production instantly and 
couldn't afford any slowdown due to resync, then you might want to skip the 
initial resync.... but is that really likely?

So what is --assume-clean for then?

Disaster recovery. If you want to build an array from components that used to be 
in a raid then this stops the kernel from scribbling on them. As the man page says :

"Use this ony if you really know what you are doing."
