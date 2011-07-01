From: David Brown <david@westcontrol.com>
Subject: Re: misunderstanding of spare and raid devices? - and one question
 more
Date: Fri, 01 Jul 2011 12:18:22 +0200
Message-ID: <iuk70t$emh$1@dough.gmane.org>
References: <4E0C5539.4030000@gmx.de> <4E0C5E47.5090604@anonymous.org.uk> <4E0C6CC4.3030506@turmel.org> <4E0C7196.1070307@gmx.de> <4E0C7B4B.7090404@turmel.org> <4E0C8685.3020806@gmx.de> <20110701072855.69ee763b@notabene.brown> <iujspj$jgg$1@dough.gmane.org> <20110701085044.GA22611@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110701085044.GA22611@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 01/07/2011 10:50, Robin Hill wrote:
> On Fri Jul 01, 2011 at 09:23:43 +0200, David Brown wrote:
>
>> On 30/06/2011 23:28, NeilBrown wrote:
>>> On Thu, 30 Jun 2011 16:21:57 +0200 Karsten R=F6mke<k.roemke@gmx.de>=
   wrote:
>>>
>>>> Hi Phil
>>>>>
>>>>> If your CPU has free cycles, I suggest you run raid6 instead of r=
aid5+spare.
>>>>>
>>>>> Phil
>>>>>
>>>> I started the raid 6 array and get:
>>>>
>>>> Personalities : [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
>>>> md0 : active raid6 sde5[4] sdd5[3] sdc5[2] sdb2[1] sda3[0]
>>>>          13759296 blocks level 6, 64k chunk, algorithm 2 [5/5] [UU=
UUU]
>>>>          [=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D>...]=
  resync =3D 87.4% (4013184/4586432) finish=3D0.4min speed=3D20180K/sec
>>>                                     ^^^^^^
>>> Note: resync
>>>
>>>>
>>>> when I started the raid 5 array I get
>>>>
>>>> md0 : active raid5 sdd5[4] sde5[5](S) sdc5[2] sdb2[1] sda3[0]
>>>>          13759296 blocks level 5, 64k chunk, algorithm 2 [4/3] [UU=
U_]
>>>>          [=3D>...................]  recovery =3D  6.2% (286656/458=
6432) finish=3D0.9min speed=3D71664K/sec
>>>                                     ^^^^^^^^
>>> Note: recovery.
>>>
>>>>
>>>> so I have to expect a three times less write speed - or is this ca=
lculation
>>>> to simple ?
>>>>
>>>
>>> You are comparing two different things, neither of which is write s=
peed.
>>> If you want to measure write speed, you should try writing and meas=
ure that.
>>>
>>> When you create a RAID5 mdadm deliberately triggers recovery rather=
 than
>>> resync as it is likely to be faster.  This is why you see a missed =
device and
>>> an extra spare.  I don't remember why it doesn't with RAID6.
>>>
>>
>> What's the difference between a "resync" and a "recovery"?  Is it th=
at a
>> "resync" will read the whole stripe, check if it is valid, and if it=
 is
>> not it then generates the parity, while a "recovery" will always
>> generate the parity?
>>
>  From the names, recovery would mean that it's reading from N-1 disks=
,
> and recreating data/parity to rebuild the final disk (as when it
> recovers from a drive failure), whereas resync will be reading from a=
ll
> N disks and checking/recreating the parity (as when you're running a
> repair on the array).
>
> The main reason I can see for doing a resync on RAID6 rather than a
> recovery is if the data reconstruction from the Q parity is far slowe=
r
> that the construction of the Q parity itself (I've no idea how the
> mathematics works out for this).
>

Well, data reconstruction from Q parity /is/ more demanding than=20
constructing the Q parity in the first place (the mathematics is the=20
part that I know about).  That's why a two-disk degraded raid6 array is=
=20
significantly slower (or, more accurately, significantly more=20
cpu-intensive) than a one-disk degraded raid6 array.

But that doesn't make a difference here - you are rebuilding one or two=
=20
disks, so you have to use the data you've got whether you are doing a=20
resync or a recovery.


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
