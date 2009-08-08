From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Sat, 08 Aug 2009 10:09:30 -0400
Message-ID: <4A7D871A.7010001@tmr.com>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop>    <4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop>    <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>    <4A7B708F.4050406@uga.edu>    <20090807035303.GA31754@musti.tarvainen.info>    <87vdkzp0rk.fsf@frosties.localdomain> <24aa235266d4cb2161954c4d49ed8ebe.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24aa235266d4cb2161954c4d49ed8ebe.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Tapani Tarvainen <raid@tapanitarvainen.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

NeilBrown wrote:
> On Sat, August 8, 2009 11:11 am, Goswin von Brederlow wrote:
>   
>> Tapani Tarvainen <raid@tapanitarvainen.fi> writes:
>>
>>     
>>> On Thu, Aug 06, 2009 at 08:08:47PM -0400, Harold Pritchett
>>> (harold@uga.edu) wrote:
>>>
>>>       
>>>> Mirrored Linux Mini How-to
>>>>         
>>> A few quick observations:
>>>
>>>       
>>>> Install linux on two identical disk drives in such a way that the
>>>> failure
>>>> of either of the drives will allow the system to be recovered without
>>>> any
>>>> loss of data
>>>>
>>>> Both of the drives are partitioned exactly the same:
>>>>      1.  3 primary partitions
>>>>      2.  Partition 1 - size - 1GB format as Linux Raid (fd)
>>>>      3.  Partition 2 - size = real memory size, format as linux swap
>>>> (82)
>>>>      4.  Partition 3 = size = remainder of disk, format as linux raid
>>>> (fd)
>>>>         
>>> If I read correctly, you are not only leaving swap out of lvm,
>>> you are not mirroring it at all - which would make the system
>>> crash if the swap disk breaks.
>>> Putting swap on lvm would also allow growing it easily as needed.
>>>       
>> On the other hand don't forget that raid1 is buggy with swap and the
>> page contents might change between writes to the first and second
>> disk. Or has that been fixed?
>>     
>
> There is no bug here.  The behaviour is a little unexpected
> but it is perfectly "correct" in that there is never any risk to
> data.
>
>
>   
The reason people use RAID is to protect their data, and with hardware 
raid there is no problem, the data is cached in the controller and sent 
to multiple devices, and only transferred over the bus once. Software 
raid can't avoid multiple bus transfers, but it could prevent the case 
where data "mirrored" is actually inconsistent on at least one copy.

There are two ways to prevent this, one would be to always copy data to 
a buffer rather than write from user memory (this sounds like a lot of 
overhead), or marking the page copy on write, which sounds far more 
efficient, but is probably more complex, particularly for a threaded 
application. Perhaps an option on a per-array basis would be useful, 
people who worry about this could set the option and have every write 
copied to a buffer, and people who don't worry about it can leave things 
as they are now.


>>> Another point is that sometimes it is useful to have multiple
>>> partitions separately mirrored and then combined with lvm:
>>> it allows things like changing the raid configuration from
>>> two-disk raid1 to three-disk raid5 without moving data
>>> via backup and yet avoiding windows of vulnerability
>>> to single-disk failure during the transition.
>>> (Perhaps not common enough to be worth mentioning here,
>>> but I've found it useful.)
>>>       
>> You can transform raid1 to raid5 without loss of redundncy so I don't
>> quite see what you mean here.
>>
>> MfG
>>         Goswin
>>     


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


