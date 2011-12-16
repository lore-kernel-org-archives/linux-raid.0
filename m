From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: Split-Brain Protection for MD arrays
Date: Fri, 16 Dec 2011 16:30:58 +0200
Message-ID: <CAGRgLy7EhPS0PwyGxkEBBd7ijs7=Hpyt67aYukHbdH5AMSNX4A@mail.gmail.com>
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
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Neil,

I have re-run all my tests with the "no-degraded" option, and I
happily admit, that it provides perfect split-brain protection!
The (okcnt + rebuilding_cnt >=3D req_cnt) logic provides exactly that.

On the other hand, this option, exactly as you mentioned, doesn't
allow the array to come up "more degraded than it was last time it was
working". So there are cases, in which there is no split-brain danger,
but the array will not come up with this option. For example, a
3-drive RAID5, coming up with 2 drives after reboot. In those cases,
my tests failed with "no-degraded", as expected.

I agree that most of the users probably don't need this special
"protect-from-split-brain, but allow-to-come-up-degraded" semantics,
which my approach provides.

Thanks again for your insights!
Alex.



On Thu, Dec 15, 2011 at 9:40 PM, NeilBrown <neilb@suse.de> wrote:
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
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
