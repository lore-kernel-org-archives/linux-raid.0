From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Thu, 29 Sep 2011 11:28:36 -0700
Message-ID: <CAA9_cmfYPoZVZhm9f+5W5bbTA+1Utb5K=FnZv_=ni8x0=R=Wbg@mail.gmail.com>
References: <4E7EDE58.3000804@yazzy.org>
	<20110926074002.6399de56@notabene.brown>
	<4E7FA3E8.5010603@yazzy.org>
	<20110926081853.2819622b@notabene.brown>
	<4E804062.3020700@yazzy.org>
	<20110926193130.6377f5b9@notabene.brown>
	<4E82203A.60507@yazzy.org>
	<20110928091335.1df35f8e@notabene.brown>
	<4E828B92.40502@hardwarefreak.com>
	<4E82C862.8000705@yazzy.org>
	<4E834758.2090508@hardwarefreak.com>
	<20110929094910.2c44ff8a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110929094910.2c44ff8a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: stan@hardwarefreak.com, lists@yazzy.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Sep 28, 2011 at 4:49 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 28 Sep 2011 11:12:08 -0500 Stan Hoeppner <stan@hardwarefreak.=
com>
> wrote:
>
>> On 9/28/2011 2:10 AM, Marcin M. Jessa wrote:
>> > On 9/28/11 4:50 AM, Stan Hoeppner wrote:
>> >
>> >> Reading the thread, and the many like it over the past months/yea=
rs, may
>> >> yield a clue as to why you wish to move on to something other tha=
n Linux
>> >> RAID...
>> >
>> > :) I will give it another chance.
>> > In case of failure FreeBSD and ZFS would be another option.
>>
>> I was responding to Neil's exhaustion with mdadm. =A0I was speculati=
ng
>> that help threads such as yours may be a contributing factor,
>> requesting/requiring Neil to become Superman many times per month to=
 try
>> to save some OP's bacon.
>>
>
> No, I don't really think they are a factor - though thanks for thinki=
ng
> about it.
>
> Obviously not all "help threads" end with a good result but quite a f=
ew do
> and one has to take the rough with the smooth.
> And each help thread is a potential learning experience. =A0If I see =
patterns
> of failure recurring it will guide and motivate me to improve md or m=
dadm to
> make that failure mode less likely.
>
> I think it is simply that it isn't new any more. =A0I first started
> contributing to md early in 2000, and 11 years is a long time. =A0Not=
 as long
> as Mr Torvalds has works on Linux of course, but Linux is a lot bigge=
r than
> md so there is more room to be interested.
> There have been many highlights over that time, but the ones that sti=
ck in my
> memory is when others have contributed in significant ways. =A0I real=
ly value
> that, whether it is code, or review or documentation, or making a wik=
i or
> answering mailing lists questions before I do, or even putting extra =
time in
> to reproduce a bug so we can drill down to the cause.
>
> I figure that appearing competent capable and in control isn't going =
to
> attract new blood - new blood wants wide open frontiers with lots of
> opportunity (I started in md when it was essentially unmaintained - I=
 know
> the attraction). =A0So I just want to say that there is certainly roo=
m and
> opportunity over here.
>
> I'm not about to drop md, but I would love an apprentice or two (or 3=
 or 4)
> and would aim to provide the same mix of independence and oversight a=
s Linus
> does.
>

What if as a starting point we could get a Patchwork queue hosted
somewhere so you could at least start formally delegating incoming
patches for an apprentice to disposition?

The hardest part about maintenance is taste, and md has been thriving
on good-taste pragmatic decisions for a while now.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
