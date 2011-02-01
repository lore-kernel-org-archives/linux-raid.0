From: David Brown <david.brown@hesbynett.no>
Subject: Re: What's the typical RAID10 setup?
Date: Tue, 01 Feb 2011 22:18:17 +0100
Message-ID: <ii9tap$8vu$1@dough.gmane.org>
References: <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <AANLkTi=kUGc8bjisn69BEEkZr6kcHUyfKnVZzNtgaJf3@mail.gmail.com> <20110131225235.GA11775@www2.open-std.org> <ii8lcv$3jg$1@dough.gmane.org> <20110201160245.GA25659@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110201160245.GA25659@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/02/11 17:02, Keld J=F8rn Simonsen wrote:
> On Tue, Feb 01, 2011 at 11:01:33AM +0100, David Brown wrote:
>> On 31/01/2011 23:52, Keld J=F8rn Simonsen wrote:
>>> raid1+0 and Linux MD raid10 are similar, but significantly differen=
t
>>> in a number of ways. Linux MD raid10 can run on only 2 drives.
>>> Linux raid10,f2 has almost RAID0 striping performance in sequential=
 read.
>>> You can have an odd number of drives in raid10.
>>> And you can have as many copies as you like in raid10,
>>>
>>
>> You can make raid10,f2 functionality from raid1+0 by using partition=
s.
>> For example, to get a raid10,f2 equivalent on two drives, partition =
them
>> into equal halves.  Then make md0 a raid1 mirror of sda1 and sdb2, a=
nd
>> md1 a raid1 mirror of sdb1 and sda2.  Finally, make md2 a raid0 stri=
pe
>> set of md0 and md1.
>
> I don't think you get the striping performance of raid10,f2 with this
> layout. And that is one of the main advantages of raid10,f2 layout.
> Have you tried it out?

No, I haven't tried it yet.  I've got four disks in this PC with an=20
empty partition on each specifically for testing such things, but I=20
haven't taken the time to try it properly.

But I believe you will get the striping performance - the two raid1=20
parts are striped together as raid0, and they can both be accessed in=20
parallel.

>
> As far as I can see the layout of blocks are not alternating between =
the
> disks. You have one raid1 of sda1 and sdb2, there a file is allocated=
 on
> blocks sequentially on sda1 and then mirrored on sdb2, where it is al=
so
> sequentially allocated. That gives no striping.
>

Suppose your data blocks are 0, 1, 2, 3, ... where each block is half a=
=20
raid0 stripe.  Then the arrangement of this data on raid10,f2 is:

sda: 0 2 4 6 .... 1 3 5 7 ....
sdb: 1 3 5 7 .... 0 2 4 6 ....

The arrangement inside my md2 is (striped but not mirrored) :

md0: 0 2 4 6 ....
md1: 1 3 5 7 ....

Inside md0 (mirrored) is then:
sda1: 0 2 4 6 ....
sdb2: 0 2 4 6 ....

Inside md1 (mirrored) it is:
sdb1: 1 3 5 7 ....
sda2: 1 3 5 7 ....

Thus inside the disks themselves you have
sda: 0 2 4 6 .... 1 3 5 7 ....
sdb: 1 3 5 7 .... 0 2 5 7 ....


>> I don't think there is any way you can get the equivalent of raid10,=
o2
>> in this way.  But then, I am not sure how much use raid10,o2 actuall=
y is
>> - are there any usage patterns for which it is faster than raid10,n2=
 or
>> raid10,f2?
>
> In theory raid10,o2 should have better performance on SSD's because o=
f
> the low latency, and raid10,o2 doing multireading from each drive, wh=
ich
> raid0,n2 does not.
>

I think it should beat raid10,n2 for some things - because of=20
multireading.  But I don't see it being faster than raid10,f2, which=20
multi-reads even better.  In particular with SSD's, the disadvantage of=
=20
raid10,f2 - the large head movements on writes - disappears.

> We lack some evidence from benchmarks, tho.
>

Indeed.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
