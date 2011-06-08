From: David Brown <david@westcontrol.com>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Wed, 08 Jun 2011 11:38:56 +0200
Message-ID: <isng0m$8c9$1@dough.gmane.org>
References: <4DEE6A11.1030205@xunil.at> <4DEE84F0.2030205@harddata.com> <4DEEBB66.7080802@nybeta.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEEBB66.7080802@nybeta.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/06/2011 01:59, Thomas Harold wrote:
> On 6/7/2011 4:07 PM, Maurice Hilarius wrote:
>> On 6/7/2011 12:12 PM, Stefan G. Weichinger wrote:
>>> Greetings, could you please advise me how to proceed?
>>>
>>> On a server I have 2 RAID1-arrays, each consisting of 2 TB-drives:
>>>
>>> ..
>>>
>>> Now I would like to move things to a more reliable RAID6 consisting of
>>> all the four TB-drives ...
>>>
>>> How to do that with minimum risk?
>>>
>>> ..
>>> Maybe I overlook a clever alternative?
>>
>> RAID 10 is as secure, and risk free, and much faster.
>> And will cause much less CPU load.
>>
>
> Well, with both a pair of RAID1 arrays and a pair of RAID-10 arrays, you
> can lose 2 disks without losing data, but only if the right 2 disks fail.
>
> With RAID6, any two of the four can fail without data loss.
>

It /sounds/ like RAID6 is more reliable here because it can always 
survive a second disk failure, while with RAID10 you have only a 66% 
chance of surviving a second disk failure.

However, how often does a disk fail?  What is the chance of a random 
disk failure in a given space of time?  And how long will it go between 
one disk failing, and it being replaced and the array rebuilt?  If you 
figure out these numbers, you'll have the probability of losing your 
RAID10 array due to the second critical disk failing.

To pick some rough numbers - say you've got low reliability, cheap disks 
with a 500,000 hour MTBF.  If it takes you 3 days to replace a disk 
(over the weekend), and 8 hours to rebuild, you have a risk period of 80 
hours.  That gives you a 0.016% chance of having the second disk 
failing.  Even if you consider that a rebuild is quite stressful on the 
critical disk, it's not a big risk.

Compare that to the chance of losing data through other causes (fire, 
theft, user-error, motherboard failure, power supply problems, etc., 
etc.) and in reality the "higher risk" of RAID10 compared to RAID6 is a 
drop in the ocean.  RAID10 is /far/ from being the weak point in a 
typical server.

And you can also take into account that the disk usage patterns on RAID6 
are a lot more intensive and stressful on the disk than RAID10 - I would 
expect the lifetime of a RAID10 member disk to be much higher than that 
of a RAID6 member disk.

I don't have the statistics to prove it, but I am certainly happy to use 
RAID10 rather than RAID6 for our company servers.

Of course, I also have two backup servers on two different sites...

> (I still prefer RAID-10 over RAID-6 unless space is at an absolute
> premium. But for a four-disk setup, net disk space is the same and it's
> just a question of whether you want the speed of RAID-10 or the
> reliability of RAID-6.)


