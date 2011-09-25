From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Sun, 25 Sep 2011 12:07:02 +0200
Message-ID: <4E7EFD46.6050605@yazzy.org>
References: <4E7EDE58.3000804@yazzy.org> <4E7EE8BD.2090301@hardwarefreak.com>
Reply-To: lists@yazzy.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7EE8BD.2090301@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/11 10:39 AM, Stan Hoeppner wrote:
> On 9/25/2011 2:55 AM, Marcin M. Jessa wrote:
>> Hi guys.
>>
>>
>> I have a RAID 6 setup with 5 2TB drives on Debian Wheezy [1] & [2].
>> Yesterday 3 of the drives failed working leaving the RAID setup broken.
>
> What was the hardware event that caused this situation? Did you lose
> power to, or kick the data cable out of a 3-bay eSATA enclosure? Do you
> have a bad 3 in 1 hot swap cage? A flaky HBA/driver?
>
> You need to identify the cause and fix it permanently or this will
> likely happen again and again.
>

The problem is the Seagate drives. Searching for issues with my
drives I found many people are complaining about the same problems as I 
have - drives failing randomly - [1-4].
I just ordered WD drives to replace the Seagate ones one by one in the 
array. I will return the Seagate HDs to the shop.
Right now my main concern is to get the data back from the LVM 
partitions and back it up...
The worst thing is the 3 drives failed so unexpectedly and fast I didn't 
even have a chance to set up a backup solution.
Any help would be greatly appreciated.



[1]: http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=625922
[2]: 
http://forums.seagate.com/t5/Barracuda-XT-Barracuda-Barracuda/ST2000DL003-Barracuda-Green-not-detected-at-BIOS/td-p/87154/page/7
[3]: http://www.readynas.com/forum/viewtopic.php?f=65&t=51496&p=306494
[4]: http://forum.qnap.com/viewtopic.php?f=182&t=39893&start=30



-- 

Marcin M. Jessa
