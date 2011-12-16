From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Split-Brain Protection for MD arrays
Date: Fri, 16 Dec 2011 11:46:50 -0200
Message-ID: <CABYL=TrZ9hFTWa9Op8xaoN7qXYYRmdyrZU7AMvAnZWTeJVT=rg@mail.gmail.com>
References: <CAGRgLy6=-naSGJw_tgiD5=ab7gWxyeQ2ysu-yCKa064Jih+cfA@mail.gmail.com>
	<20111215140252.2f9bb986@notabene.brown>
	<CAGRgLy7oCm87HRTK_FS6g80g5MQzSvto10T0PH0vE022XMsn-w@mail.gmail.com>
	<20111216064003.18a7ab4f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111216064003.18a7ab4f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Alexander Lyakas <alex.bolshoy@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

just some points that we shouldn=B4t forget... thinking like a end user
of mdadm, not as a developer...
a disk fail occur about 1 time after 2 years of heavy use in a desktop =
sata disk
a complex structure just for 1 minute of mdadm --remove, mdadm --add
should be accepted by end users... it=B4s just 1 minute of 2 years...
2 years=3D730 days=3D17520 hours=3D1051200 minutes, in other works 1 mi=
nute
~=3D 1/1.000.000=3D0.0001% of stop time, 99.9999% of online time, if we
consider turn server off add a new disk and remove older, let we
consider 10minutes? 0.001% =3D 99.999% of online time
it=B4s well accepted for desktop and servers...

for raid1 and linear- i don=B4t see a real complex logic telling what
block isn=B4t ok, just a counter telling what disk have more recent dat=
a
is wellcome
for raid10, raid5 and raid6- ok we can allow a block specific ,since
we could consider a bad disk like many bad blocks and many good blocks
(in the good disk)


2011/12/15 NeilBrown <neilb@suse.de>:
> On Thu, 15 Dec 2011 16:29:12 +0200 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Neil,
>> thanks for the review, and for detailed answers to my questions.
>>
>> > When we mark a device 'failed' it should stay marked as 'failed'. =
=A0When the
>> > array is optimal again it is safe to convert all 'failed' slots to
>> > 'spare/missing' but not before.
>> I did not understand all that reasoning. When you say "slot", you me=
an
>> index in the dev_roles[] array, correct? If yes, I don't see what
>> importance the index has, compared to the value of the entry itself
>> (which is "role" in your terminology).
>> Currently, 0xFFFE means both "failed" and "missing", and that makes
>> perfect sense to me. Basically this means that this entry of
>> dev_roles[] is unused. When a device fails, it is kicked out of the
>> array, so its entry in dev_roles[] becomes available.
>> (You once mentioned that for older arrays, their dev_roles[] index w=
as
>> also their role, perhaps you are concerned about those too).
>> In any case, I will be watching for changes in this area, if you
>> decide to make them (although I think this might break backwards
>> compatibility, unless a new version of superblock will be used).
>
> Maybe... =A0as I said, "confusing" is a relevant word in this area.
>
>>
>> > If you have a working array and you initiate a write of a data blo=
ck and the
>> > parity block, and if one of those writes fails, then you no longer=
 have a
>> > working array. =A0Some data blocks in that stripe cannot be recove=
red.
>> > So we need to make sure that admin knows the array is dead and doe=
sn't just
>> > re-assemble and think everything is OK.
>> I see your point. I don't know what's better: to know the "last know=
n
>> good" configuration, or to know that the array has failed. I guess, =
I
>> am just used to the former.
>
> Possibly an 'array-has-failed' flag in the metadata would allow us to=
 keep
> the last known-good config. =A0But as it isn't any good any more I do=
n't really
> see the point.
>
>
>>
>> > I think to resolve this issue we need 2 thing.
>> >
>> > 1/ when assembling an array if any device thinks that the 'chosen'=
 device has
>> > =A0 failed, then don't trust that devices.
>> I think that if any device thinks that "chosen" has failed, then
>> either it has a more recent superblock, and then this device should =
be
>> "chosen" and not the other. Or, the "chosen" device's superblock is
>> the one that counts, then it doesn't matter what current device
>> thinks, because array will be assembled according to the "chosen"
>> superblock.
>
> This is exactly what the current code does and it allows you to assem=
ble an
> array after a split-brain experience. =A0This is bad. =A0Checking wha=
t other
> devices think of the chosen device lets you detect the effect of a
> split-brain.
>
>
>>
>> > 2/ Don't erase 'failed' status from dev_roles[] until the array is
>> > optimal.
>>
>> Neil, I think both these points don't resolve the following simple
>> scenario: RAID1 with drive A and B. Drive A fails, array continues t=
o
>> operate on drive B. After reboot, only drive A is accessible. If we =
go
>> ahead with assemble, we will see stale data. If after reboot, we,
>> however, see only drive A, then (since B is "faulty" in A's
>> superblock), we can go ahead and assemble. The change I suggested wi=
ll
>> abort in the first case, but will assemble in the second case.
>
> Using --no-degraded will do what you want in both cases. =A0So no cod=
e change
> is needed!
>
>>
>> But obviously, you know better what MD users expect and want.
>
> Don't bet on it.
> So far I have one vote - from you - that --no-degraded should be he d=
efault
> (I think that is what you are saying). =A0If others agree I'll certai=
nly
> consider it more.
>
> Note that "--no-degraded" doesn't exactly mean "not assemble a degrad=
ed
> array". =A0It means "don't assemble an array more degraded that it wa=
s last
> time it was working". =A0i.e. require that all devices that are worki=
ng
> according to the metadata are actually available.
>
> NeilBrown
>
>
>
>> Thanks again for taking time and reviewing the proposal! And yes, ne=
xt
>> time, I will put everything in the email.
>>
>> Alex.
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
