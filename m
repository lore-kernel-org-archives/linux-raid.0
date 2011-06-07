From: Thomas Harold <thomas-lists@nybeta.com>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Tue, 07 Jun 2011 19:59:34 -0400
Message-ID: <4DEEBB66.7080802@nybeta.com>
References: <4DEE6A11.1030205@xunil.at> <4DEE84F0.2030205@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEE84F0.2030205@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: lists@xunil.at, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/7/2011 4:07 PM, Maurice Hilarius wrote:
> On 6/7/2011 12:12 PM, Stefan G. Weichinger wrote:
>> Greetings, could you please advise me how to proceed?
>>
>> On a server I have 2 RAID1-arrays, each consisting of 2 TB-drives:
>>
>> ..
>>
>> Now I would like to move things to a more reliable RAID6 consisting of
>> all the four TB-drives ...
>>
>> How to do that with minimum risk?
>>
>> ..
>> Maybe I overlook a clever alternative?
>
> RAID 10 is as secure, and risk free, and much faster.
> And will cause much less CPU load.
>

Well, with both a pair of RAID1 arrays and a pair of RAID-10 arrays, you 
can lose 2 disks without losing data, but only if the right 2 disks fail.

With RAID6, any two of the four can fail without data loss.

(I still prefer RAID-10 over RAID-6 unless space is at an absolute 
premium.  But for a four-disk setup, net disk space is the same and it's 
just a question of whether you want the speed of RAID-10 or the 
reliability of RAID-6.)
