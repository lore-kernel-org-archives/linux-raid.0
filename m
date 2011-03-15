From: CoolCold <coolthecold@gmail.com>
Subject: Re: Periodic RebuildStarted event
Date: Tue, 15 Mar 2011 07:21:09 +0300
Message-ID: <AANLkTi=ZY6bpdsJuGuCrQ8CgRT=a7JyLbfSX0V-YDT4E@mail.gmail.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com>
	<AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
	<20110207234411.GA93362@cons.org>
	<20110208112513.2b82111c@notabene.brown>
	<AANLkTi=xz=2RG2Ob_BsCffFDki_wYcUOohB5k4YQhZ-6@mail.gmail.com>
	<20110315144140.42f9c2c7@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110315144140.42f9c2c7@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Cracauer <cracauer@cons.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 15, 2011 at 6:41 AM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 15 Mar 2011 06:16:22 +0300 CoolCold <coolthecold@gmail.com> w=
rote:
>
>> Hello!
>>
>> On Tue, Feb 8, 2011 at 3:25 AM, NeilBrown <neilb@suse.de> wrote:
>> [snip]
>> > Then start either the
>> > 'next' array at the beginning, or the 'current' array at the curre=
nt point
>> > (write to sync_min).
>> I couldn't find documentation for sync_min/sync_max sysfs params at
>> least for repo cloned from
>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-2.6.37.y.=
git
>> coolcold@coolcold:~/gits/linux-2.6.37.y$ grep -qi sync_min
>> Documentation/md.txt || echo failed find docs
>> failed find docs
>
> Yes, sorry about that.
May be I can help and create patch for md.txt after this thread? If
yes, it would be nice to get some link for proper patch providing
instructions, never did patches for kernel ;)

>
>>
>> As I could understand from sources - resync_min & resync_max are
>> expressed in sectors (512bytes?) =A0and are set to 0 & total sectors=
 on
>> device accordingly. resync_max value should be divisible by array
>> chunk size (in sectors) . After setting this values, one can trugger
>> "check" / "repair" into sync_action.
>
> Yes - sectors (multiples of 512 bytes)
> Yes - 0 and a big number. =A0sync_max is actually set to MAX_LONG rat=
her than
> =A0 =A0 =A0the actual total number of sectors.
>
> Yes - one can trigger 'check' or 'repair' and it will obey these limi=
ts.
> When it reaches 'sync_max' it will pause rather than complete. =A0You=
 can
> use 'select' or 'poll' on "sync_completed" to wait for that number to
> reach sync_max. =A0Then you can either increase sync_max, or can writ=
e
> "idle" to "sync_action".
>
>>
>> My basic idea is to use this method to clear pending sectors from
>> SMART checks and looks like this gonna work, am i right?
>>
>
> I don't know exactly what "pending sectors" are, but if they are sect=
ors
> which return an error to READ and can be fixed by writing data to the=
m, then
> you are right, this should 'clear' any pending sectors.
Yes, i meant that kind.
>
> Of course you will need to be careful about mapping the sector number
> from smart to the second number given to 'sync_min'.
I guess you meant "sector" not "second" here?

> Not only must you
> adjust for any partition table, but also the 'data offset' of the
> md array must be allowed for.
So, for 0.9 metadata format offset is always gonna be 0, right?
And if the bad thing happens - bad block with read error is found on
metadata section, will mdadm with --update <something> will be enought
to do force write?

>
> NeilBrown
>
>
>
>> > Then wait for however long you want, abort the check (write 'idle'=
 to
>> > 'sync_action') and find out where it got up to (read sync_min) and=
 record
>> > that for next time.
>> >
>> > NeilBrown
>> >
>>
>>
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
