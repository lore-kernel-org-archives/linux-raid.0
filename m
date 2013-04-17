From: Ben Bucksch <linux.news@bucksch.org>
Subject: Re: Use RAID-6!
Date: Wed, 17 Apr 2013 13:51:49 +0200
Message-ID: <516E8CD5.4040301@bucksch.org>
References: <15345091.8.1366130671716.JavaMail.root@zimbra> <516DABF2.5050409@tigertech.com> <516DAF21.5040409@aei.mpg.de> <516DD433.50100@tigertech.com> <516DEAD4.7080305@bucksch.org> <516DFC4F.5000908@websitemanagers.com.au> <516E83D8.2070908@bucksch.org> <516E8848.1030702@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <516E8848.1030702@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Ben Bucksch <linux.news@bucksch.org>, Robert L Mathews <lists@tigertech.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Adam Goryachev wrote, On 17.04.2013 13:32:
> On 17/04/13 21:13, Ben Bucksch wrote:
>> Adam Goryachev wrote, On 17.04.2013 03:35:
>>> Obviously, if they suffered a two disk failure then they won't be here
>>> asking for help will they:)
>> Wrong, sadly. I suffered a 1 disk failure, and I am here asking for
>> help. And nobody can give it.
>>
>> Again: I have a RAID5, and 1 (one) disk failed, so I should be fine, but
>> I cannot read the data anymore, no way to get at it. That's because md
>> ejected a good (!) drive to start with,
> Actually, I think the real problem here is that you don't know why your
> so called good drive was ejected from the array.

I know it doesn't have a fatal hardware failure. See my quote above.

> obviously Linux and/or MD has a different opinion.

See my first post. You see that they have the almost same event count, 
yet I can't re-add it (considering the fact that another drive failed 
entirely).

>
>> and refuses to take it back (!).
> It probably would have taken it back, although requiring a resync.

It did. And that resync uncovered the failure of the other disk. The 
combination trashed my array. The problem is that the first drive should 
never have been ejected, so that the failing drive would not be fatal.

> Like I said, you need to be patient, and follow the expert advice
> provided from the list.

Well, I'm listening. All the info is in my thread:
md RAID5: Disk wrongly marked "spare", need to force re-add it

(And, FYI, being "patient" is difficult when you can't work until the 
array is back online.)

> This discussion is just a diversion from your
> problem, forget the diversion (at least until you get your problem fixed).

I am interested in both: My immediate problem fixed, and that this 
problem hever happens again: not for me, and not for anybody else who 
isn't aware of it yet.

>
>> The problem isn't double disk failure. The problem is bugs in md
>> implementation.
> Or users who expect things to work a certain way, without actually
> bothering to find out in advance. Hence their expectation is considered
> a bug when really it is just a lack of knowledge.

FWIW; I read a lot about RAID before using it, and I use it since 10 
years. RAID5 is supposed to protect against 1 total harddrive failure. 
It doesn't. That's a bug, no matter how you put the light on it.

>
>>> The Linux kernel advises Linux md that the block
>>> device is gone, so Linux md discards the block device and stops trying
>>> to use it. Personally, I don't see that Linux md has a lot of choice in
>>> the matter
>> True. But often, such errors are temporary. For example, a loose cable.
>> I must be able to re-add the device as a good device with data. But I
>> can't, md doesn't let me.
> It does actually. You can re-add it, with a resync, or if you ensure
> that no writes occurred since the drive was ejected, you can re-add it
> without a resync. In addition, even if some writes occurred, if you use
> a bitmap, only the newly written blocks need to by resynced.


>> My case was even more unbelievable: md ejected perfectly good drives
>> simply because I upgraded the OS. (This happened with 2 independent
>> arrays, so not coincidence.)
> Like I said, the drives were ejected for a reason. You just don't know
> what that reason is.
>
>> Also, a single sector being unreadable/unwritable doesn't count as "disk
>> failure" in my book, and shouldn't eject the whole disk. If I have 2
>> sectors on 2 different disks that are unreadable, md currently trashes
>> the whole array and doesn't let me read anything at all anymore. That's
>> obviously broken, but unfortunately the sad reality.
>> See http://neil.brown.name/blog/20110216044002#1
> This is all true, however, I would hope that when this is implemented,
> the distributions will properly alert the user that one or more drives
> are faulty. One failed write is very frequently indicative of more
> failed writes to come. Personally, I would want to replace that drive ASAP.
>
> In addition, the one thing that appeared missing from the blog was the
> ability for md to clear the bad blocks list when a drive is replaced,
> and rebuild the content of the "bad blocks" from the other members.
>
>> (And, BTW, RAID6 doesn't really help with this problem, because it's
>> quite possible that 3 disks have sectors unreadable/unwritable.)
> RAID6 simply improves your odds or chances. There is no RAID level that
> can provide a 100% uptime, at some point you have lost too many disks or
> too much data, etc. Use the appropriate level of RAID depending on your
> risk profile.
>
> Regards,
> Adam
>

