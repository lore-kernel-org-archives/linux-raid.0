From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Raid 5 to 6 is it do-able/safe?
Date: Tue, 29 Dec 2009 13:38:33 +0000
Message-ID: <73e903670912290538k5242bf07ob15a15fe508d1b66@mail.gmail.com>
References: <305721.15040.qm@web51302.mail.re2.yahoo.com> <alpine.DEB.1.10.0912291308010.27231@uplift.swm.pp.se>
	<4B3A04C3.5070804@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B3A04C3.5070804@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Dec 29, 2009 at 1:31 PM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
>
> On 29/12/2009 12:08, Mikael Abrahamsson wrote:
>>
>> On Tue, 29 Dec 2009, Jon Hardcastle wrote:
>>
>>> I run gentoo with kernel 2.6.22-gentoo-r8
>>>
>>> to convert my 6 drive +1 spare raid 5 to a 7 drive raid 6?
>>
>> No, you need at least kernel 2.6.32 to migrate from raid5 to raid6.
>
> But if you don't want to run 2.6.32 permanently/on your live system, iirc you can just run it to do the migration, and once the migration and reshape have completed, you can go back to your production kernel.
>

Besides the kernel version issues, this type of migration is
definitely possible and should be safe. I just did one of these before
christmas - grew a 3 or 4-disk RAID-5 into a 6-disk RAID-6, all on
1.5TB drives. Lots of fun nail-biting moments watching /proc/mdstat!
As it turned out, the thing just started, went about its business, and
finished in a quiet and refined manner. Now my arrays are vast and
comfortably redundant ...

Just give yourself a set of big, physical reminders to update your
mdadm.conf when the reshape / relevel is done.

And you really, preferably ought to back your data up before you do
this. Even though the rearrangement will probably work just fine.

Merry everything!

-- Kristleifur
