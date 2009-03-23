From: Raz <raziebe@gmail.com>
Subject: Re: How to configure 36 disks ?
Date: Mon, 23 Mar 2009 18:52:51 +0200
Message-ID: <5d96567b0903230952h1929e208se550eff25eac864a@mail.gmail.com>
References: <49C7AC2C.9090307@tmr.com>
	 <174852.24274.qm@web51309.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <174852.24274.qm@web51309.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Mar 23, 2009 at 6:02 PM, Jon Hardcastle <jd_hardcastle@yahoo.co=
m> wrote:
>
> I'd like to understand how you even go attaching that many devices to=
 a system.. I am 'comparatively' new to this.. and have a 6 raid5 syste=
m.. not enterprise.. and i have slammed into case/power/sat slot issues=
 already. What sort of hardware must one use to grow to a 36 array syst=
em!
well, i am using a DAS in a JBOD mode. Cards are LSI logic Fiber channe=
l.

> -----------------------
> N: Jon Hardcastle
> E: Jon@eHardcastle.com
> '..Be fearful when others are greedy, and be greedy when others are f=
earful.'
> -----------------------
>
>
> --- On Mon, 23/3/09, Bill Davidsen <davidsen@tmr.com> wrote:
>
>> From: Bill Davidsen <davidsen@tmr.com>
>> Subject: Re: How to configure 36 disks ?
>> To: "Raz" <raziebe@gmail.com>
>> Cc: linux-fsdevel@vger.kernel.org, "Linux RAID Mailing List" <linux-=
raid@vger.kernel.org>, linux-xfs@oss.sgi.com, linux-aio@kvack.org, "lin=
ux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
>> Date: Monday, 23 March, 2009, 3:35 PM
>> Raz wrote:
>> > Hello
>> > I need to configure 3xDAS'es, each with 12 disks.
>> > All three DAS'es are connected to a single
>> machine.
>> > I have the following requirements (in this order of
>> importance)
>> > from the storage:
>> >
>> > 1. redundancy.
>> > =A0 =A0having two disks failing in one raid5 breaks the
>> entire raid. when
>> > you have 30TB storage
>> > =A0 =A0it is a disaster.
>> >
>> > 2. performance.
>> > =A0 =A0My code eliminates Linux raid5/6 write penalty. I
>> managed to do by
>> > =A0 =A0manipulating xfs and patching linux raid5 a bit.
>> >
>> > 3. modularity ( a "grow" and it will be nice
>> to have "shrink" )
>> > =A0 =A0file system and volume must be able to grow.
>> shrinking is possible
>> > by unifying multiple file systems
>> > =A0 =A0under unionfs or aufs.
>> >
>> > 4. Utilize storage size.
>> >
>> > I assume each disk is 1TB.
>> >
>> >
>> ___ snip ___
>>
>> > Any other ideas ?
>>
>> Yes, you have the whole solution rotated 90 degrees.
>> Consider your original solution #2 below... You have no
>> redundancy if one whole DAS box fails, which is certainly a
>> possible failure mode. If you put the RAID0 horizontally,
>> two arrays size six in each DAS, then RAID6 vertically, if
>> one DAS fails completely you still have a functioning
>> system, and the failure results for individual drives
>> remains about the same, while the rebuild time will be
>> longer.
>>
>> Solution #2
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0raid0
>> DAS1: raid6: D,D,D,D,D,D =A0 =A0 |
>> =A0 =A0 =A0 raid6: D,D,D,D,D,D =A0 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 |
>> DAS2: raid6: D,D,D,D,D,D =A0 =A0 | xfs.
>> =A0 =A0 =A0 raid6: D,D,D,D,D,D =A0 =A0 |
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0|
>> DAS3: raid6: D,D,D,D,D,D =A0 =A0 |
>> =A0 =A0 =A0 raid6: D,D,D,D,D,D =A0 =A0 |
>>
>>
>> In addition, you can expand this configuration by adding
>> more DAS units. This addresses several of your goals.
>>
>> In practice, just to get faster rebuild as the array gets
>> larger, I suspect you would find it was worth making the
>> horizontal arrays RAID5 instead of RAID0, just to minimize
>> time to full performance.
>>
>> -- bill davidsen <davidsen@tmr.com>
>> =A0CTO TMR Associates, Inc
>>
>> "You are disgraced professional losers. And by the
>> way, give us our money back."
>> =A0 =A0- Representative Earl Pomeroy, =A0Democrat of North Dakota
>> on the A.I.G. executives who were paid bonuses =A0after a
>> federal bailout.
>>
>>
>> --
>> To unsubscribe from this list: send the line
>> "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at
>> http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
