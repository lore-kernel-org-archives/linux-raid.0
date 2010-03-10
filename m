From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: What RAID type and why?
Date: Wed, 10 Mar 2010 18:47:36 +0100
Message-ID: <87pr3cnk5j.fsf@frosties.localdomain>
References: <5bdc1c8b1003061402n1281b64es9fa597b8bc714bd5@mail.gmail.com>
	<87f94c371003061433x404a8c2fgcb61f817af6ecb1@mail.gmail.com>
	<9089562724D84B3C858E337F202FF550@m5>
	<20100307132113.7e2c95b6@notabene.brown>
	<877hpoqoob.fsf@frosties.localdomain>
	<4877c76c1003071240t6814248eqd63f391bc278aee8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003071240t6814248eqd63f391bc278aee8@mail.gmail.com>
	(Michael Evans's message of "Sun, 7 Mar 2010 12:40:24 -0800")
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Neil Brown <neilb@suse.de>, Guy Watkins <linux-raid@watkins-home.com>, Greg Freemyer <greg.freemyer@gmail.com>, Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Michael Evans <mjevans1983@gmail.com> writes:

> On Sun, Mar 7, 2010 at 4:52 AM, Goswin von Brederlow <goswin-v-b@web.=
de> wrote:
>> Neil Brown <neilb@suse.de> writes:
>>
>>> On Sat, 06 Mar 2010 18:17:44 -0500
>>> "Guy Watkins" <linux-raid@watkins-home.com> wrote:
>>>
>>>> }
>>>> } At a minimum I would build a 3-disk raid 6. =A0raid 6 does a lot=
 of i/o
>>>> } which may be a problem.
>>>>
>>>> If he only needs 3 drives I would recommend RAID1. =A0Can still lo=
ose 2 drives
>>>> and you don't have the RAID6 I/O overhead.
>>>>
>>>
>>> and as md/raid6 requires at least 4 drives, RAID1 is not just the b=
est
>>> solution to survive two failures on a 3-device array, it is the onl=
y solution.
>>>
>>> NeilBrown
>>
>> Except that there also is raid10 with 3 mirrors. :)
>>
>> MfG
>> =A0 =A0 =A0 =A0Goswin
>>
>> PS: Why doesn't raid6 still not allow 3 drives for the special case =
of
>> converting raid1 -> raid6?
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
> That should be obvious:
>
> Possible stripes:
>
> Start:
> 1, 1, 1;
> 2, 2, 2;

Start:
1, 1, 1;
2, 2, 2;
3, 3, 3;
=2E..

> 'raid6' overtake...
> 1, q, Q;
> 2, q, Q;

Middle:
1, P, Q;
P, Q, 2;
Q, 3, P;
=2E..

End:
1, 2, P, Q;
4, P, Q, 3;
P, Q, 5, 6;
=2E..

> 'raid6' overtake with missing;
> 1, (missing 2), q, Q;
> 3, (missing 4), q, Q;
>
> In the first overtake case you have the requirement of generating 200=
%
> parity, which probably won't work for the algorithm and is a silly
> idea in general since it's computationally far less expensive to stor=
e
> another copy of either form of data instead.

The sick 3 disk raid6 case should have both the P and Q identical to th=
e
data block. It is indeed computational a waste to go through the
expensive P/Q parity algorithm for the same result as mirroring but thi=
s
is only ment as a transitional state.

> In the second you're gaining the space of a second disk at the cost o=
f
> being already degraded; why not just go for raid 5 instead?
>
> You can overtake raid5 later with raid6 if you add more devices.

Because then you are going from 2 mirror disks to 1 parity disk even if
only temporary. You are reducing the number of disks failures you can
survive from 2 to 1 and the high load during a reshape makes a failure
more likely than normal operations.

Or can you go from 3 way raid1 to 4 disk raid6 in a single step?

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
