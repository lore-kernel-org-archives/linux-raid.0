From: Mark Knecht <markknecht@gmail.com>
Subject: Re: What RAID type and why?
Date: Sat, 6 Mar 2010 15:05:46 -0800
Message-ID: <5bdc1c8b1003061505g6b310f6ct6795b9180c2e6adf@mail.gmail.com>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
	 <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Freemyer <greg.freemyer@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sat, Mar 6, 2010 at 2:33 PM, Greg Freemyer <greg.freemyer@gmail.com>=
 wrote:
> On Sat, Mar 6, 2010 at 5:02 PM, Mark Knecht <markknecht@gmail.com> wr=
ote:
>> First post. I've never used RAID but am thinking about it and lookin=
g
>> for newbie-level info. Thanks in advance.
>>
>> I'm thinking about building a machine for long term number crunching
>> of stock market data. Highest end processor I can get, 16GB and at
>> least reasonably fast drives. I've not done RAID before and don't kn=
ow
>> how to choose one RAID type over another for this sort of workload.
>> All I know is I want the machine to run 24/7 computing 100% of the
>> time and be reliable at least in the sense of not losing data if 1
>> drive or possibly 2 go down.
>>
>> If a drive does go down I'm not overly worried about down time. I'll
>> stock a couple of spares when I build the machine and power the box
>> back up within an hour or two.
>>
>> What RAID type do I choose and why?
>>
>> Do I need a 5 physical drive RAID array to meet these requirements?
>> Assume 1TB+ drives all around.
>>
>> How critical is it going forward with Linux RAID solutions to be abl=
e
>> to get exactly the same drives in the future? 1TB today is 4TB a yea=
r
>> from now, etc.
>>
>> With an 8 core processor (high-end Intel Core i7 probably) do I need
>> to worry much about CPU usage doing RAID? I suspect not and I don't
>> really want to get into hardware RAID controllers unless critically
>> necessary which I suspect it isn't.
>>
>> Anyway, if there's a document around somewhere that helps a newbie
>> like me I'd sure appreciate finding out about it.
>>
>> Thanks,
>> Mark
>
> I'm not sure about a newbie doc, but here's some basics:
>
> You haven't said what kind of i/o rates you expect, nor how much
> storage you need.

Good points. I guess I was assuming I'd want 1TB storage and I'd buy
3/5/6 1TB drives to get it. Honestly I probably don't need anything
close to that. My weekly backups of stock data run about 1GB to 1TB
should hold me for quite awhile I think.

As for i/o rates I think it's pretty low. Real-time or historic stock
data arrives here over the net so that's not fast. Crunching numbers
*typically* amounts to loading a single data set from disk into memory
and then operating from there so I suspect that even in backtesting
it's pretty low but I'll see if I can get some data. None the less I'm
not sure there's much overlap between when the disk is heavily used
and when it gets CPU limited. Again, I'll have to give that some
thought.

>
> At a minimum I would build a 3-disk raid 6. =C2=A0raid 6 does a lot o=
f i/o
> which may be a problem.
>
> Raid-5 is out of favor for me due to issues people are seeing with
> discrete bad sectors with the remaining drives after you have a drive
> failure. =C2=A0raid-6 tolerates those much better. =C2=A0Even raid 10=
 is not as
> robust as raid 6 and with the current generation drives robustness in
> the raid solution is more important than ever.
>
> But raid 6 uses 2 parity drives, so you'll only get 1TB of useable
> space from a 3-disk raid 6 made from 1TB drives.

I've been looking at this page so far for the most basic info:

http://en.wikipedia.org/wiki/RAID#Organization

They show RAID 6 with 5 drives so I'll need to learn how to do this
with fewer drives. I think you're point about more than 1 drive having
problems around the same time is good input.

While money is always important buying 1 or 2 more drives (say $200)
isn't the biggest issue here. It's a new machine with a $500 processor
so if more drives make a big difference in terms of reliability then I
don't want to cut too many corners.

>
> mdraid just requires replacement disks be bigger than the old disk
> you're replacing.
>
> You might consider layering LVM on top of mdraid to help you manage
> the array as it grows.

Two subject I haven't even thought of!

Thanks for the info! Lots to study!

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
