From: Adam Goryachev <mailinglists@websitemanagers.com.au>
Subject: Re: clustered MD - beyond RAID1
Date: Tue, 22 Dec 2015 09:29:08 +1100
Message-ID: <56787D34.7020108@websitemanagers.com.au>
References: <56742652.5040304@nasa.gov>
 <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov>
 <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov>
 <8737uv4fz6.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8737uv4fz6.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, Tejas Rao <raot@bnl.gov>, Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
Cc: "Knister, Aaron S. (GSFC-606.2)[COMPUTER SCIENCE CORP]" <aaron.s.knister@nasa.gov>
List-Id: linux-raid.ids

On 22/12/15 09:03, NeilBrown wrote:
> On Tue, Dec 22 2015, Tejas Rao wrote:
>
>> On 12/21/2015 15:47, NeilBrown wrote:
>>> On Tue, Dec 22 2015, Tejas Rao wrote:
>>>
>>>> What if the application is doing the locking and making sure that only 1
>>>> node writes to a md device at a time? Will this work? How are rebuilds
>>>> handled? This would be helpful with distributed filesystems like
>>>> GPFS/lustre etc.
>>>>
>>> You would also need to make sure that the filesystem only wrote from a
>>> single node at a time (or access the block device directly).  I doubt
>>> GPFS/lustre make any promise like that, but I'm happy to be educated.
>>>
>>> rebuilds are handled by using a cluster-wide lock to block all writes to
>>> a range of addresses while those stripes are repaired.
>>>
>>> NeilBrown

My understanding of MD level cross host RAID was that it would not 
magically create cluster aware filesystems out of non-cluster aware 
filesystems. ie, you wouldn't be able to use the same multi-host RAID 
device on multiple hosts concurrently with ext3.

IMHO, if it was able to behave similar to DRBD, then that would be 
perfect (ie, enforce only a single node can write at a time (unless you 
specifically set it for multi-node write)). The benefit should be that 
you can lose a node without losing your data. After you lose that node, 
you can then "do something" to use the remaining node to access the data 
(eg, mount it, export with iscsi/nfs, etc).

Currently, this is what I use DRBD for, previously, I've used NBD + MD 
RAID1 to do the same thing. One question though is what advantage 
multi-host MD RAID might have over the existing in-kernel DRBD ? Are 
there plans which show why this is going to be better, have better 
performance, features, etc?

Regards,
Adam

-- 
Adam Goryachev Website Managers www.websitemanagers.com.au
