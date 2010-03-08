From: Mark Knecht <markknecht@gmail.com>
Subject: Re: 3 disk RAID1?
Date: Mon, 8 Mar 2010 13:04:37 -0800
Message-ID: <5bdc1c8b1003081304n7a59e99ej1f66078090980f06@mail.gmail.com>
References: <5bdc1c8b1003081239l32c5653fs8347179e23c0a287@mail.gmail.com>
	 <20100308205803.GA31731@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100308205803.GA31731@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 8, 2010 at 12:58 PM, Robin Hill <robin@robinhill.me.uk> wro=
te:
> On Mon Mar 08, 2010 at 12:39:26PM -0800, Mark Knecht wrote:
>
>> Hi all,
>> =C2=A0 =C2=A0I'm still very much on a steep learning curve about wha=
t I can do
>> with Linux software RAID. In another thread this weekend a couple of
>> responders discussed among themselves 3-disk RAID1 solutions that ca=
n
>> survive if 2 disks die. I don't understand what that means. Can
>> someone point me at a quick explanation? Is that really possible?
>>
>> =C2=A0 =C2=A0In general I'm using a few Wikipedia pages and gravitat=
e toward the
>> diagrams as much as anything.
>>
>> http://en.wikipedia.org/wiki/RAID
>> http://en.wikipedia.org/wiki/RAID1#RAID_1
>>
>> RAID0 - striping, speed not reliability (2 disk minimum)
>> RAID1 - duplicate data, no other protection (2 disk minimum)
>>
>> =C2=A0 =C2=A0How do I build RAID1 using three drives? Just duplicate=
 the data 3
>> times? If drives start going bad how do I determine which one or two
>> are failing? (fsck? SMART?) With 3 drives 1 fail seems relatively
>> straightforward to figure out, but 2?
>>
> A 3-disk RAID1 is just 3 duplicate copies, yes. =C2=A0And RAID only p=
rotects
> against hardware failures, so you know which disk has failed because =
it
> gets kicked out of the array as faulty. =C2=A0This is the same regard=
less of
> how many mirrored copies you have (md will detect a write failure to =
a
> drive and mark it as faulty - read errors will cause the failed block=
 to
> get rewritten).
>
> As for how to create it - it's just the same process as for a 2-disk
> RAID1 but specifying 3 drives (assuming you're using Linux md softwar=
e
> RAID - if not, please specify what you're intending to use). =C2=A0Th=
e manual
> page for mdadm should give you everything you need - do ask if there'=
s
> anything you want clarifying though.
>
> Cheers,
> =C2=A0 =C2=A0Robin

Thanks Robin. Maybe I am getting smarter about this if I'm figuring
out what others are talking about! ;-)

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
