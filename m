From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: 3 disk RAID1?
Date: Mon, 8 Mar 2010 22:18:52 +0000
Message-ID: <73e903671003081418g13861e21pa412f46995ad9781@mail.gmail.com>
References: <5bdc1c8b1003081239l32c5653fs8347179e23c0a287@mail.gmail.com>
	<20100308205803.GA31731@cthulhu.home.robinhill.me.uk> <5bdc1c8b1003081304n7a59e99ej1f66078090980f06@mail.gmail.com>
	<4877c76c1003081411p3c729c89q3d908d07f19b0857@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003081411p3c729c89q3d908d07f19b0857@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 8, 2010 at 10:11 PM, Michael Evans <mjevans1983@gmail.com> =
wrote:
> On Mon, Mar 8, 2010 at 1:04 PM, Mark Knecht <markknecht@gmail.com> wr=
ote:
>> On Mon, Mar 8, 2010 at 12:58 PM, Robin Hill <robin@robinhill.me.uk> =
wrote:
>>> On Mon Mar 08, 2010 at 12:39:26PM -0800, Mark Knecht wrote:
>>>
>>>> Hi all,
>>>> =A0 =A0I'm still very much on a steep learning curve about what I =
can do
>>>> with Linux software RAID. In another thread this weekend a couple =
of
>>>> responders discussed among themselves 3-disk RAID1 solutions that =
can
>>>> survive if 2 disks die. I don't understand what that means. Can
>>>> someone point me at a quick explanation? Is that really possible?
>>>>
>>>> =A0 =A0In general I'm using a few Wikipedia pages and gravitate to=
ward the
>>>> diagrams as much as anything.
>>>>
>>>> http://en.wikipedia.org/wiki/RAID
>>>> http://en.wikipedia.org/wiki/RAID1#RAID_1
>>>>
>>>> RAID0 - striping, speed not reliability (2 disk minimum)
>>>> RAID1 - duplicate data, no other protection (2 disk minimum)
>>>>
>>>> =A0 =A0How do I build RAID1 using three drives? Just duplicate the=
 data 3
>>>> times? If drives start going bad how do I determine which one or t=
wo
>>>> are failing? (fsck? SMART?) With 3 drives 1 fail seems relatively
>>>> straightforward to figure out, but 2?
>>>>
>>> A 3-disk RAID1 is just 3 duplicate copies, yes. =A0And RAID only pr=
otects
>>> against hardware failures, so you know which disk has failed becaus=
e it
>>> gets kicked out of the array as faulty. =A0This is the same regardl=
ess of
>>> how many mirrored copies you have (md will detect a write failure t=
o a
>>> drive and mark it as faulty - read errors will cause the failed blo=
ck to
>>> get rewritten).
>>>
>>> As for how to create it - it's just the same process as for a 2-dis=
k
>>> RAID1 but specifying 3 drives (assuming you're using Linux md softw=
are
>>> RAID - if not, please specify what you're intending to use). =A0The=
 manual
>>> page for mdadm should give you everything you need - do ask if ther=
e's
>>> anything you want clarifying though.
>>>
>>> Cheers,
>>> =A0 =A0Robin
>>
>> Thanks Robin. Maybe I am getting smarter about this if I'm figuring
>> out what others are talking about! ;-)
>>
>> Cheers,
>> Mark
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> When in doubt, read the manual two or three more times.
>
> This might also help you: http://wiki.tldp.org/LVM-on-RAID =A0I wrote
> some background comparison sections when I made that...

Good advice.

The contents of the manual didn't really stick for me until I'd
actually *done* the tasks I was trying to figure out. The beautiful
and classic Catch-22 of learning new things. So I somewhat
empathically suggest you obtain a virtual machine program and start up
a few disposable virtual machines. (VirtualBox is pretty good and also
free.) Try creating some RAID's on VM's and getting them to boot, try
failing a device and readding it, etc.

And keep the manual in a window next to the virtual machine's window :)

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
