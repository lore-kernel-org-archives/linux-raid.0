From: Mark Knecht <markknecht@gmail.com>
Subject: Re: 3-drive RAID1 for my low use home server?
Date: Wed, 24 Mar 2010 07:59:30 -0700
Message-ID: <5bdc1c8b1003240759s97b4f1ex92b29c79d2aff39f@mail.gmail.com>
References: <5bdc1c8b1003231437q1cbeabex85833be0a59e3357@mail.gmail.com>
	 <hod8pf$imk$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hod8pf$imk$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Eric Shubert <ejs@shubes.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Mar 24, 2010 at 7:49 AM, Eric Shubert <ejs@shubes.net> wrote:
> Mark Knecht wrote:
>>
>> Hi,
>> =C2=A0 Just triple checking what I think I've learned here before I =
start
>> loading Gentoo. Parts are arriving and I'm staring to put them
>> together to build a combo low-use server (backups and MythTV) as wel=
l
>> as desktop for my wife. I can do anything up to 6 drives but want th=
e
>> RAID to survive in the face of possibly two drive failure. This is a=
ll
>> low bandwidth stuff.
>>
>> =C2=A0 I'm fairly focused at this point on doing RAID1 using 3 drive=
s.
>> Unless I hear differently I believe a 3-drive RAID1 could survive 2
>> drive failures, and as well any single drive could be taken to anoth=
er
>> machine or even placed in an external USB/eSATA drive container in t=
he
>> event of some major motherboard failure. Is any of that incorrect?
>
> All sounds right to me. Just be sure that the array is defined with 3=
 drives
> and no spares.
>
>> =C2=A0 Also, along the way folks have mentioned hot spares but I'm n=
ot
>> seeing that a hot spare does much for RAID1. Am I incorrect about
>> that?
>
> Right. The only thing it would buy you is a little write performance,=
 but
> you'd lose a little read performance, and take a performance hit if/w=
hen one
> drive goes off.
>
>> Granted, I guess the rebuild starts automatically and maybe
>> that's worth it, but I'm thinking that mdadm can probably let me kno=
w
>> fairly quickly that I need to do some work. I've purchased 6 drives =
so
>> I'll have 2 or 3 spares around and I can do a hot spare but I don't
>> see the value in spinning the drive for a year burning power and
>> wearing the drive out vs. just putting it on the shelf and keeping i=
t
>> in reserve for a rainy day.
>
> Just one thought here. There is a certain "infant mortality syndrome"=
 that
> drives experience (according to google study). I would rotate drives =
from
> the shelf into service after a year or so, while they're still under
> warranty (assuming 3yr warranty). If the warranty period is less than=
 2yr,
> rotate them sooner.
>
> NJoy!
>
> --
> -Eric 'shubes'

Thanks Eric. I'll keep this in mind.

Other than the work involved in fixing things this is a home setup so
if it was down for a day or two it's not like a mission critical or
anything.

Also, the really critical coming from another machine that has two RAID=
's in it:

1) Main RAID is RAID0 using RAID class drives. (Lower reliability but
speed where I need it.)

2) Backup RAID in first machine is a 3 drive RAID 1.

3) This 2nd machine which also has RAID1 as we've been speaking aobut.

So, machine 1 runs RAID0 for work and then automatically backs up data
every few hours to a RAID1 internal to the same box. Once a day I will
then back up the machine 1 RAID1 to machine 2's RAID1 so I'm covered
twice. If one RAID1 does down then I can basically just fix it will
the other RAID1 keeps me safe.

Certainly, every so often I go offsite for even more protection.

Cheers,
Mark

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
