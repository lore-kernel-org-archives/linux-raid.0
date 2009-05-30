From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID5 reconstruction ?
Date: Sat, 30 May 2009 14:39:53 -0400
Message-ID: <4A217D79.9070006@tmr.com>
References: <37d33d830905292244w685499b3h391aa2ca7a5b1ad@mail.gmail.com>	 <4A213612.7080206@anonymous.org.uk> <1243699735.5740.103.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1243699735.5740.103.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: John Robinson <john.robinson@anonymous.org.uk>, SandeepKsinha <sandeepksinha@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Redeeman wrote:
> On Sat, 2009-05-30 at 14:35 +0100, John Robinson wrote:
>   
>> On 30/05/2009 06:44, SandeepKsinha wrote:
>>     
>>> Hi all,
>>>
>>> Say If I have a RAID 5 array of 50GB of five disks of 10GB each.
>>>
>>> I have data of 5GB. When a disk fails and replaced with a spare disk.
>>> Will the reconstruction happen only for the 5GB allocated disk blocks
>>> or it will happen for the whole disk size.
>>>       
>> The whole disc size, for now anyway; md does not currently note which 
>> blocks have been used by its client (the filesystem, LVM, whatever).
>>
>>     
>>> Is it possible to make  reconstruction intelligent enough to keep it optimized ?
>>>       
>> This has been discussed in combination with supporting SSD drives' TRIM 
>> function, and would mean md had to keep track of used chunks or possibly 
>> even sectors using a bitmap or something like that, but whether anyone's 
>> working on it I don't know.
>>     
>
> I would say it should be possible to 'query' the filesystem for that
> information. Obviously this will only work if you run a filesystem on it
> which supports it, but it would seem like a nicer solution than a bitmap
> for it.
>   

There is a program which does that, but i think it was for ext2. Read 
the inodes and saved the data. I believe 'dump' does something similar, 
but it's on a file system basis and I don't recall (or care much about) 
the details.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"You are disgraced professional losers. And by the way, give us our money back."
    - Representative Earl Pomeroy,  Democrat of North Dakota
on the A.I.G. executives who were paid bonuses  after a federal bailout.


