From: David Brown <david.brown@hesbynett.no>
Subject: Re: Multi-layer raid status
Date: Fri, 02 Feb 2018 11:41:24 +0100
Message-ID: <5A744054.4060305@hesbynett.no>
References: <5A708F8E.2040604@hesbynett.no> <87372k2aix.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87372k2aix.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/02/18 07:03, NeilBrown wrote:
> On Tue, Jan 30 2018, David Brown wrote:
> 
>> Does anyone know the current state of multi-layer raid (in the Linux md
>> layer) for recovery?
>>
>> I am thinking of a setup like this (hypothetical example - it is not a
>> real setup):
>>
>> md0 = sda + sdb, raid1
>> md1 = sdc + sdd, raid1
>> md2 = sde + sdf, raid1
>> md3 = sdg + sdh, raid1
>>
>> md4 = md0 + md1 + md2 + md3, raid5
>>
>>
>> If you have an error reading a sector in sda, the raid1 pair finds the
>> mirror copy on sdb, re-writes the data to sda (which re-locates the bad
>> sector) and passes the good data on to the raid5 layer.  Everyone is
>> happy, and the error is corrected quickly.
>>
>> Rebuilds are fast as single disk copies.
>>
>>
>> However, if you have an error reading a sector in sda /and/ when reading
>> the mirror copy in sdb, then the raid1 pair has no data to give to the
>> raid5 layer.  The raid5 layer will then read the rest of the stripe and
>> calculate the missing data.  I presume it will then re-write the
>> calculated data to md0, which will in turn write it to sda and sdb, and
>> all will be well again.
> 
> If sda and sdb have bad-block-logs configured, this should work.  Not
> everyone trusts them though.
> 
>>
>>
>> But what about rebuilds?  A rebuild or recovery of the raid1 layer is
>> not triggered by a read from the raid5 level - it will be handled at the
>> raid1 level.  If sda is replaced, then the raid1 level will build it by
>> copying from sdb.  If a read error is encountered while copying, is
>> there any way for the recovery code to know that it can get the missing
>> data by asking the raid5 level?  Is it possible to mark the matching sda
>> sector as bad, so that a future raid5 read (such as from a scrub) will
>> see that md0 stripe as bad, and re-write it?
>>
> 
> "Is it possible to mark the matching sda sector as bad"
> 
> This is exactly what the bad-block-list functionality is meant to do.
> 
> NeilBrown
> 

Marvellous - thank you for the information.

Using bad block lists and then doing a higher level scrub should
certainly work, and is a good general solution as it means you don't
need direct interaction between the layers (just the normal top-down
processing of layered block devices).  The disadvantage is that there
may be quite a delay between the raid1 rebuild and the next full re-read
of the entire raid5 array - all you really need is a single read at the
higher level to trigger the fixup.

Is there any way to map from the block numbers on the lower raid level
here to block numbers at a higher level?  I suppose in general the lower
level does not know what is above it.  I guess a user mode tool could
look at /proc/mdstat and work through it to figure out the layers, then
look through bad block lists and calculate the required high-level reads.





