From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Green drives and RAID arrays with partity
Date: Sun, 25 Sep 2011 09:54:28 -0500
Message-ID: <4E7F40A4.6040704@hardwarefreak.com>
References: <4E7F0A31.4070001@yazzy.org> <4E7F13E8.4080606@hardwarefreak.com> <4E7F3A80.7010308@yazzy.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7F3A80.7010308@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/25/2011 9:28 AM, Marcin M. Jessa wrote:
> On 9/25/11 1:43 PM, Stan Hoeppner wrote:
>
> [...]
>
>>
>> When you have a problem such as yours, and you ask for help on this, or
>> any other Linux kernel list, it's a really good idea to post all of the
>> relevant information up front. Why? Because most often when drives drop
>> out of arrays it is not because a disk failed or the disk has buggy
>> firmware. It's most often because of problems elsewhere in the storage
>> stack, either hardware or software.
>
> I wasn't sure which information I should attach and I did not want to
> spam the list. I was hoping someone would tell me if some of the
> relevant information was missing so I could send it when needed.
> Could you please tell me what kind of data was missing?
>
>> Crappy HBAs and/or drivers, loose or dislodged cable connectors, and
>> crappy active/passive backplanes are the primary movers when it comes to
>> good drives dropping out of arrays.
>
> In my case I don't use any HW Raid.
> My motherboard is a MSI 870A-G54 -
> http://www.msi.com/product/mb/870A-G54.html and I only use SATA and
> software RAID.
>
>> Again, I implore you to investigate all other portions of your storage
>> stack before blowing money on drives, which may not be the cause of your
>> problem.
>
> It's really hard to find the source of the failure.
> My first assumption was the drives, since I have 5 more (different) HDs
> connected to the board, two in RAID 1 (ATA drives) and they all work
> flawlessly.
> Reading feedbacks from all the people complaining about the same issue
> with the SEAGATE drives as I have I automatically assumed there is a
> problems with these particular disks.

Are the drives screwed into the case's internal drive cage?  Directly 
connected to the motherboard SATA ports with cables?  Or, do you have 
the drives mounted in any kind of SATA hot/cold swap cage?  The cheap 
ones of these are notorious for causing exactly the kind of drop outs 
you've experienced.  Post a link to your case and any drive related 
peripherals.

Did you suffer a power event?  I.e. a sag, brown out?  Is the system 
connected to a good quality working UPS?

Something else you should always mention:  How long did it all "just 
work" before having problems?  A few hours?  Days?  Weeks?  Months?  Had 
you made any hardware changes to the system recently before the failure 
event?  If so what?  Did you upgrade your kernel/drivers recently, or 
any software in the storage stack?  Is the PSU flaky?  How old is it?  A 
flaky PSU can drop drives out of arrays like hot potatoes when there is 
heavy access and thus heavy current draw.

-- 
Stan
