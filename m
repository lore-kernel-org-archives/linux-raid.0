From: David Brown <david.brown@hesbynett.no>
Subject: Re: "Missing" RAID devices
Date: Thu, 23 May 2013 10:22:27 +0200
Message-ID: <519DD1C3.8080704@hesbynett.no>
References: <CAGPLN=viGgdw0MM18tiNxwjNadg0cj8xjntW3ne1qMNkfgocaA@mail.gmail.com> <519B9351.4050708@turmel.org> <CAGPLN=uiUD3wnwt6DfELaLh+yqxkbrA=KetPiQHZrqq4FrS=HA@mail.gmail.com> <519C0B13.3040906@turmel.org> <519D4A15.7020107@hardwarefreak.com> <519D541B.1090508@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <519D541B.1090508@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 23/05/13 01:26, Phil Turmel wrote:
> On 05/22/2013 06:43 PM, Stan Hoeppner wrote:
>> Sorry for the dup Phil, hit the wrong reply button.
> 
> No worries.
> 
>> On 5/21/2013 7:02 PM, Phil Turmel wrote:
>> ...
>>> ...First is /dev/md1, a small (~500m) n-way
>>> ...as /boot.  The other, /dev/md2, uses
>>> ...raid10,far3 or raid6.
>>>
>>> I put LVM on top of /dev/md2, with LVs for swap, ... /tmp
>>
>> Swap and tmp atop an LV atop RAID6?  The former will always RMW on page
>> writes, the latter quite often will cause RMW.  As you stated your
>> performance requirements are modest.  However, for the archives, putting
>> swap on a parity array, let alone a double parity array, is not good
>> practice.
> 
> Ah, good point.  Hasn't hurt me yet, but it would if I pushed anything
> hard.  I'll have to revise my baseline to always have a small raid10,f3
> to go with the raid6.
> 

Always use raid1 (or raid10) for your swap - that is, assuming you want
it on raid at all.

Raid is all about uptime - look at what is likely to go wrong, what the
consequences of that problem are, and the cost of protecting against it.
 If your swap is seldom used (as is normally the case), and you can live
with the consequences of swap failing (i.e., any process using swap will
die - but everything else, including data on raid, will be fine), then
don't put swap on raid.  If it is cheaper to buy more ram than extra
spindles for swap on raid, then buy more ram and avoid swap.

But if you still feel you need swap on raid, then using raid1 styles.
Stan has given you all the details.


Also consider putting /tmp on tmpfs.  Then you don't need to worry about
raid here, and if it overflows to disk then the extra data goes out into
swap.


