From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Replace drive in RAID5 without losing redundancy?
Date: Tue, 6 Mar 2007 13:02:46 +0100
Message-ID: <86703DF2-EAE4-4638-9608-8E3B5E5D8D7C@bj-ig.de>
References: <37643E71-0FD9-4F8A-AE68-A8565FEB0247@bj-ig.de> <17900.39356.684798.56121@notabene.brown> <Pine.LNX.4.64.0703052315250.27855@twinlark.arctic.org>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703052315250.27855@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: dean gaudet <dean@arctic.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Am 06.03.2007 um 08:37 schrieb dean gaudet:
>
> On Tue, 6 Mar 2007, Neil Brown wrote:
>
>> On Monday March 5, ralf@bj-ig.de wrote:
>>>
>>> Is it possible to mark a disk as "to be replaced by an existing  
>>> spare",
>>> then migrate to the spare disk and kick the old disk _after_  
>>> migration
>>> has been done? Or not even kick - but mark as new spare.
>>
>> No, this is not possible yet.
>> You can get nearly all the way there by:
>>
>>   - add an internal bitmap.
>>   - fail one drive
>>   - --build a raid1 with that drive (and the other missing)
>>   - re-add the raid1 into the raid5
>>   - add the new drive to the raid1
>>   - wait for resync
>
> i have an example at
> <http://arctic.org/~dean/proactive-raid5-disk-replacement.txt>... plus
> discussion as to why this isn't the best solution.

Oops - you are right. While in raid1-resync-state there is no redundancy
for the disk that should be replaced and therefore I lose a lot of  
redundancy
for the raid5 above it. When I replace a disk that is in a good state -
everything is fine. When I replace one with read problems - I simply  
lose.
Not as good as I thought first ...

A build in solution would be able to avoid such problems - right.

Ralf Mueller


-- 
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.


