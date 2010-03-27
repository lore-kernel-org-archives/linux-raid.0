From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Use of WD20EARS with MDADM
Date: Sat, 27 Mar 2010 16:31:42 -0700
Message-ID: <5bdc1c8b1003271631w1446515egbf5a44dc69e514c7@mail.gmail.com>
References: <4BAB8D41.4010801@gmail.com> <4BAD18A5.1080905@kieser.ca>
	 <5bdc1c8b1003261359i2f6f1bdai3261aec30bb663bf@mail.gmail.com>
	 <4BAD20A2.20606@kieser.ca>
	 <5bdc1c8b1003261406m2ae66154u55a70aada56a91c1@mail.gmail.com>
	 <5bdc1c8b1003261416xdc883a4qdba1cdf049cca437@mail.gmail.com>
	 <4BAD24EB.4020606@sauce.co.nz>
	 <5bdc1c8b1003261538y751a3089p284bee0ee1b28b63@mail.gmail.com>
	 <72dbd3151003261601w55bbc103w431e9582f1f13cae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <72dbd3151003261601w55bbc103w431e9582f1f13cae@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Rees <drees76@gmail.com>
Cc: Richard Scobie <richard@sauce.co.nz>, Peter Kieser <peter@kieser.ca>, Andrew Dunn <andrew.g.dunn@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Mar 26, 2010 at 4:01 PM, David Rees <drees76@gmail.com> wrote:
> On Fri, Mar 26, 2010 at 3:38 PM, Mark Knecht <markknecht@gmail.com> w=
rote:
>> On Fri, Mar 26, 2010 at 2:19 PM, Richard Scobie <richard@sauce.co.nz=
> wrote:
>>> No, its item 193 Load_Cycle_Count (LCC) and it's at 27557.
>>
>> Thanks. I don't know if that's high or low. To me it's just a number=
=2E
>>
>> Following along from Matt Garman's reply I went back and looked at
>> when I built this machine for my dad. (How many here have 85 year ol=
d
>> fathers who have run Linux for 7 years instead of windows? Give him =
a
>> cheer!) ;-) I agree with Matt about trying to save power.
>>
>> This machine is 40 days old today, at least counting since he first
>> booted it at home. It's been up and running since then.
>>
>> 40 Days is 3,456,000 seconds.
>>
>> 3,456,000 / 27557 is 125 seconds/count increase on average. So about=
 2 minutes.
>>
>> I wonder if I'm seeing something like Matt is seeing with the drive
>> continually being woken up. I know most of the time it just sits idl=
e
>> from a user's perspective, but I've done nothing to stop daemons or
>> anything like that. It runs screen savers, gets used every day for a=
n
>> hour or two, but is always powered up so that I can administer it fr=
om
>> 350 miles away.
>
> Why leave the thing on 24 hours a day if it's only used 1-2 of them?
> Save wear on your drive and the rest of the machine, save your dad a
> few bucks on his electricity bill and shut the thing down when it's
> not used. =C2=A0Then use WoL to wake it up if you need to admin it, o=
r
> heck, just use the BIOS/ACPI wakeup feature and put the thing to slee=
p
> at night and wake up automatically in the morning - at least then
> you'll cut it's run-time in half.
>
> -Dave
>

That's really up to him. He doesn't hear well and doesn't seem to care
about his utility bill so it's easy for me, or has been in the past.
His last machine ran 5 1/2 years powered up all the time. I think the
alternate view is that keeping the drive at a relatively constant
temperature is a good thing also. Who knows?

As for WoL I don't know much about it but his machine is main target
logging in through his router and script kiddies are for every trying
to log in with name after name after name. If it could be make to
respond to my IP only that would be great but my IP moves around now
and then so how do I make that work?
(NOT a topic for this list...)

Cheers,
Mark
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
