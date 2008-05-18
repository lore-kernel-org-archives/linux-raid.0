From: "David Lethe" <david@santools.com>
Subject: Re: questions about softraid limitations
Date: Sun, 18 May 2008 18:18:00 -0500
Message-ID: <203b01c8b93d$78e2c538$e90df40a@exchange.rackspace.com>
Reply-To: <David@santools.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>, David Greaves <david@dgreaves.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



-----Original Message-----

From:  "Janos Haar" <janos.haar@netcenter.hu>
Subj:  Re: questions about softraid limitations
Date:  Sun May 18, 2008 5:38 pm
Size:  2K
To:  "David Lethe" <david@santools.com>; "David Greaves" <david@dgreaves.com>
cc:  "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>

 
----- Original Message -----  
From: "David Greaves" <david@dgreaves.com> 
To: "David Lethe" <david@santools.com> 
Cc: "Janos Haar" <janos.haar@netcenter.hu>; <linux-raid@vger.kernel.org> 
Sent: Monday, May 19, 2008 12:23 AM 
Subject: Re: questions about softraid limitations 
 
 
> David Lethe wrote: 
> > Hmm - I wonder if things like ddrescue could work with the md bitmaps to 
>> improve 
>> this situation? 
>> Is this related to David Lethe's recent request? 
>> 
>> ----------- 
>> No, we are trying two different approaches. 
>> In my situation, I already know that the data is munged on a particular 
>> block, so the solution is to calculate the correct data from surviving 
>> parity, and just write the new value.  There is no reason to worry about 
>> md bitmaps, or even whether or not there are 0x00 holes. 
> 
> I think we (or I) may be talking about the same thing? 
> 
> Consider an array sd[abcde] and a badblock (42) on sdb followed by a  
> badblock 
> elsewhere (142) on sdc. 
> I would like to ddrescue sdb to sdb' and sdc to sdc' (leaving holes) 
> block 42 should be recovered from sd[acde] to sdb' 
> block 142 should be recovered from sd[abde] to sdc' 
 
If i read this correct, David Lethe wants an on the fly solution, to keep  
the integrity of the big online array, before some app reads the bad block,  
and need to resync... 
 
(David, think twice before buy disks! ;-) 


close .. I am proposing a mechanism to INSURE data integrity by rebuilding stripes while enough data is there to repair the data.   Otherwise, if you lose any disks (other than the one with the read error) then you lose contents of the entire stripe, unless you have  corner case of the bad block contains only the XOR parity, and you have ability to determine that from the RAID topology.

Effectively, I can do a pointed rebuild,  rather than brute force verify/rebuild ... Limited, of course, to discovered bad blocks that md hasn't encountered on its own.

Remember, certain kernels won't automatically repair even RAID1 sets if one of the disks has ECC errors on the mirror due to load balancing/performance enhancements.  (not to imply that is necessarily a  bad thing, just to point out how changes in the name of enhancements can have severe effect on delicate balance between speed and data integrity when a disk or block fails.   Some kernels repair data as it encounters it ... Others only repair if the load balancing directed the IO to a disk with a bad block.
> 
> The idea was to possibly tristate the bitmap clean/dirty/corrupt. 
> If md gets a read/write error then it marks the block corrupt;  
> alternatively we 
> could use the output from ddrescue to identify corrupt blocks that md may  
> not 
> have seen. 
 
I am not sure, but i have right, the bitmap cannot be tristate! 
But in my case, enough the dirty flag, because i only need a readonly array  
to read the data, and no need to rewrite the bad block by the kernel. 
 
 
> 
> I wondered whether each block actually needed to record the event it was  
> last 
> updated with. I haven't thought through the various failure cases but... 
> 
>> I am not trying to fix a problem such as a rebuild gone bad or an 
>> intermittent disk failure that put the md array in a partially synced, 
>> and totally confused state. 
> No, me neither... 
> 
>> My desire is to limit damage before a full disk recovery needs to be 
>> performed, by insuring that there are no double-errors that will make 
>> stripe-level recovery impossible (assuming they aren't using RAID6). 
>> For that I need a mechanism to repair a stripe given a physical disk and 
>> offset. There is no completely failed disk to contend with, merely a 
>> block of bad data that will repair itself once I issue a simple write 
>> command. (trick, of course, is to figure out exactly what & where to 
>> right it and deal with potential locking issues relating to file 
>> system). 
> I think I'm describing that too. 
> If you simplify my case to a single badblock do we meet? 
> 
> David  
 
 


