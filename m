From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Raid 5 Array
Date: Sat, 02 Apr 2011 21:09:48 +0100
Message-ID: <4D97828C.8050806@gmail.com>
References: <BANLkTim8620MUckc+EVCWo9FCTs=65_p8Q@mail.gmail.com>	<4D977279.30107@gmail.com> <BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimJfUhvkpkkAH=NLJOvLL-Jotrwqg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marcus <nexuslite@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

cc'd the list back in as I'm not an md guru.

I did a search for mdadm raid 50 and this looked the most appropriate.

http://books.google.co.uk/books?id=DkonSDG8jUMC&pg=PT116&lpg=PT116&dq=mdadm+raid+50&source=bl&ots=Ekw6NCiXqR&sig=edBYg9Gtd5RXyuUU0PeSpHvS7pM&hl=en&ei=9YGXTYyeBcGFhQe90ojpCA&sa=X&oi=book_result&ct=result&resnum=5&ved=0CEIQ6AEwBA#v=onepage&q=mdadm%20raid%2050&f=false

Simon

On 02/04/2011 20:38, Marcus wrote:
> Yes I used --zero-superblock this time. I think that was my problem
> last time it kept detecting the drives at random and creating odd
> arrays. This time I am not sure what my problem is. I got two drives
> back up so I have my data back but I tried getting the two raid0
> drives to become part of the raid5 twice so far and each time fdisk -l
> shows the wrong sizes for the raids when they are combine the first
> time it showed the small raid as 1TB which is the size of the big raid
> the second time it showed the big raid as 750GB which is the size of
> the small array. Some how the joining of the two raids is corrupting
> the headers and reporting wrong information.
>
> Is there a proper procedure for creating a raid0 to put into a raid5?
> last time I created my raid0 and added a partition to the raids and it
> automatically dropped the partition and just showed md0 and md1 in the
> array instead of md0p1 and md1p1 which was the partition i added to
> the array. I have tried adding the partition into the array and I also
> tried adding just array into the array. neither method seems to be
> working this time.
>
> On Sat, Apr 2, 2011 at 12:01 PM, Simon McNair<simonmcnair@gmail.com>  wrote:
>> Hi,
>> I'm sure you've tried this, but do you use --zero-superblock before moving
>> disks over ?
>>
>> Simon
>>
>> On 02/04/2011 19:51, Marcus wrote:
>>> I have a raid array this is the second time an upgrade seems to have
>>> corrupted the array.
>>>
>>> I get the following message from dmesg when trying to mount the array
>>> [  372.822199] RAID5 conf printout:
>>> [  372.822202]  --- rd:3 wd:3
>>> [  372.822208]  disk 0, o:1, dev:md0
>>> [  372.822212]  disk 1, o:1, dev:sdb1
>>> [  372.822216]  disk 2, o:1, dev:sdc1
>>> [  372.822305] md2: detected capacity change from 0 to 1000210300928
>>> [  372.823206]  md2: p1
>>> [  410.783871] EXT4-fs (md2): Couldn't mount because of unsupported
>>> optional features (3d1fc20)
>>> [  412.401534] EXT4-fs (md2): Couldn't mount because of unsupported
>>> optional features (3d1fc20)
>>>
>>> I originally had a raid0 md0 with two 160GB drives, a raid0 md1 with
>>> 250GB and md0, a raid 5 with a 1.0TB, 500GB, and md1
>>>
>>> I swapped out md1 with a new 1TB drive which worked. then i dropped
>>> the 500GB and combined it with the 250GB drive to make a 750GB drive
>>>
>>> The error seems to come when you reintroduce drives that were
>>> previously in a raid array into a new raid array. This is the second
>>> time I have ended up with the same problem.
>>>
>>> Any suggestions on how to recover from this or is my only option to
>>> reformat everything and start again?
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
