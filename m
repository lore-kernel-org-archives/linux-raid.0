From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: 3 disk RAID1?
Date: Mon, 8 Mar 2010 14:11:10 -0800
Message-ID: <4877c76c1003081411p3c729c89q3d908d07f19b0857@mail.gmail.com>
References: <5bdc1c8b1003081239l32c5653fs8347179e23c0a287@mail.gmail.com>
	 <20100308205803.GA31731@cthulhu.home.robinhill.me.uk>
	 <5bdc1c8b1003081304n7a59e99ej1f66078090980f06@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003081304n7a59e99ej1f66078090980f06@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 8, 2010 at 1:04 PM, Mark Knecht <markknecht@gmail.com> wrot=
e:
> On Mon, Mar 8, 2010 at 12:58 PM, Robin Hill <robin@robinhill.me.uk> w=
rote:
>> On Mon Mar 08, 2010 at 12:39:26PM -0800, Mark Knecht wrote:
>>
>>> Hi all,
>>> =A0 =A0I'm still very much on a steep learning curve about what I c=
an do
>>> with Linux software RAID. In another thread this weekend a couple o=
f
>>> responders discussed among themselves 3-disk RAID1 solutions that c=
an
>>> survive if 2 disks die. I don't understand what that means. Can
>>> someone point me at a quick explanation? Is that really possible?
>>>
>>> =A0 =A0In general I'm using a few Wikipedia pages and gravitate tow=
ard the
>>> diagrams as much as anything.
>>>
>>> http://en.wikipedia.org/wiki/RAID
>>> http://en.wikipedia.org/wiki/RAID1#RAID_1
>>>
>>> RAID0 - striping, speed not reliability (2 disk minimum)
>>> RAID1 - duplicate data, no other protection (2 disk minimum)
>>>
>>> =A0 =A0How do I build RAID1 using three drives? Just duplicate the =
data 3
>>> times? If drives start going bad how do I determine which one or tw=
o
>>> are failing? (fsck? SMART?) With 3 drives 1 fail seems relatively
>>> straightforward to figure out, but 2?
>>>
>> A 3-disk RAID1 is just 3 duplicate copies, yes. =A0And RAID only pro=
tects
>> against hardware failures, so you know which disk has failed because=
 it
>> gets kicked out of the array as faulty. =A0This is the same regardle=
ss of
>> how many mirrored copies you have (md will detect a write failure to=
 a
>> drive and mark it as faulty - read errors will cause the failed bloc=
k to
>> get rewritten).
>>
>> As for how to create it - it's just the same process as for a 2-disk
>> RAID1 but specifying 3 drives (assuming you're using Linux md softwa=
re
>> RAID - if not, please specify what you're intending to use). =A0The =
manual
>> page for mdadm should give you everything you need - do ask if there=
's
>> anything you want clarifying though.
>>
>> Cheers,
>> =A0 =A0Robin
>
> Thanks Robin. Maybe I am getting smarter about this if I'm figuring
> out what others are talking about! ;-)
>
> Cheers,
> Mark
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

When in doubt, read the manual two or three more times.

This might also help you: http://wiki.tldp.org/LVM-on-RAID  I wrote
some background comparison sections when I made that...
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
