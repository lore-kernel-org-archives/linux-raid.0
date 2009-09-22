From: "Majed B." <majedb@gmail.com>
Subject: Re: Full use of varying drive sizes?
Date: Tue, 22 Sep 2009 18:47:43 +0300
Message-ID: <70ed7c3e0909220847x6bddc9bdsc56deef31acb19f@mail.gmail.com>
References: <70ed7c3e0909220607y692e15a2s64aac9bd729422ef@mail.gmail.com>
	<580026.57085.qm@web51303.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <580026.57085.qm@web51303.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

md checks its part only, as far as I know. It makes sense since it
would be checking the integrity of the array's disks/partitions.

If you want the disks to undergo full check up, I'd suggest you run
smartd and run both short self tests and offline tests. Offline tests
take a very long time because they do thorough tests.

Make sure you setup smartd to email you on reports/problems so that
you can find bad sectors as soon as they happen and fix them asap.

On Tue, Sep 22, 2009 at 6:38 PM, Jon Hardcastle <jd_hardcastle@yahoo.co=
m> wrote:
> Some good suggestions here, thanks guys.
>
> Do I >DID< imagine some built in support for making use of this space=
?
>
> As a side note. when i do a repair or check on my array.. does it che=
ck the WHOLE DRIVE.. or just the part that is being used? I.e. in my ca=
se.. I have a 1TB drive but only an array multiple of 500GB.. i'd like =
to think it is checking the whole whack as it may have to take over som=
e day...
>
> -----------------------
> N: Jon Hardcastle
> E: Jon@eHardcastle.com
> 'Do not worry about tomorrow, for tomorrow will bring worries of its =
own.'
> -----------------------
>
>
> --- On Tue, 22/9/09, Majed B. <majedb@gmail.com> wrote:
>
>> From: Majed B. <majedb@gmail.com>
>> Subject: Re: Full use of varying drive sizes?
>> To: "Linux RAID" <linux-raid@vger.kernel.org>
>> Date: Tuesday, 22 September, 2009, 2:07 PM
>> When I first put up a storage box, it
>> was built out of 4x 500GB disks,
>> later on, I expanded to 1TB disks.
>>
>> What I did was partition the 1TB disks into 2x 500GB
>> partitions, then
>> create 2 RAID arrays: Each array out of partitions:
>> md0: sda1, sdb1, sdc1, ...etc.
>> md1: sda2, sdb2, sdc2, ...etc.
>>
>> All of those below LVM.
>>
>> This worked for a while, but when more 1TB disks started
>> making way
>> into the array, performance dropped because the disk had to
>> read from
>> 2 partitions on the same disk, and even worse: When a disk
>> fail, both
>> arrays were affected, and things only got nastier and worse
>> with time.
>>
>> I would not recommend that you create arrays of partitions
>> that rely
>> on each other.
>>
>> I do find the JBOD -> Mirror approach suggested earlier
>> to be convenient though.
>>
>> On Tue, Sep 22, 2009 at 3:58 PM, John Robinson
>> <john.robinson@anonymous.org.uk>
>> wrote:
>> > On 22/09/2009 12:52, Kristleifur Da=C4=91ason wrote:
>> >>
>> >> On Tue, Sep 22, 2009 at 11:24 AM, Jon Hardcastle
>> >> <jd_hardcastle@yahoo.com>
>> wrote:
>> >>>
>> >>> Hey guys,
>> >>>
>> >>> I have an array made of many drive sizes
>> ranging from 500GB to 1TB and I
>> >>> appreciate that the array can only be a
>> multiple of the smallest - I use the
>> >>> differing sizes as i just buy the best value
>> drive at the time and hope that
>> >>> as i phase out the old drives I can '--grow'
>> the array. That is all fine and
>> >>> dandy.
>> >>>
>> >>> But could someone tell me, did I dream that
>> there might one day be
>> >>> support to allow you to actually use that
>> unused space in the array? Because
>> >>> that would be awesome! (if a little hairy re:
>> spare drives - have to be the
>> >>> size of the largest drive in the array
>> atleast..?) I have 3x500GB 2x750GB
>> >>> 1x1TB so I have 1TB of completely unused
>> space!
>> >>
>> >> Here's a thought:
>> >> Imaginary case: Say you have a 500, a 1000 and a
>> 1500 GB drive. You
>> >> could JBOD the 500 and the 1000 together and
>> mirror that against the
>> >> 1500GB.
>> >>
>> >> Disclaimer:
>> >> I don't know if it makes any sense to do this. I
>> haven't seen this
>> >> method mentioned before, IIRC. It may be too
>> esoteric to get any
>> >> press, or it may be simply stupid.
>> >
>> > Sure you can do that. In Jon's case, a RAID-5 across
>> all 6 discs using the
>> > first 500GB, leaving 2 x 250GB and 1x 500GB free. The
>> 2 x 250GB could be
>> > JBOD'ed together and mirrored against the 500GB,
>> giving another 500GB of
>> > usable storage. The two md arrays can in turn be
>> JBOD'ed or perhaps better
>> > LVM'ed together.
>> >
>> > Another approach would be to have another RAID-5
>> across the 3 larger drives,
>> > again providing an additional 500GB of usable storage,
>> this time leaving 1 x
>> > 250GB wasted, but available if another 1TB drive was
>> added. I think this may
>> > be the approach Netgear's X-RAID 2 takes to using
>> mixed-size discs:
>> > http://www.readynas.com/?p=3D656
>> >
>> > Cheers,
>> >
>> > John.
>> > --
>> > To unsubscribe from this list: send the line
>> "unsubscribe linux-raid" in
>> > the body of a message to majordomo@vger.kernel.org
>> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info=
=2Ehtml
>> >
>>
>>
>>
>> --
>> =C2=A0 =C2=A0 =C2=A0=C2=A0=C2=A0Majed B.
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.h=
tml
>>
>
>
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
