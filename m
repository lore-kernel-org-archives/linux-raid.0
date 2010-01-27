From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: How can I tell what drive is sdb?
Date: Wed, 27 Jan 2010 16:12:07 +0100
Message-ID: <87sk9r37lk.fsf@frosties.localdomain>
References: <1264601024.29409.19.camel@thor>
	<bdd6985b1001270609m477799dpdcd625180efaed02@mail.gmail.com>
	<4B604B2B.7070602@computer.org>
	<18879E40-1CB7-47B0-90C5-1F4483729E3D@crc.id.au>
	<bdd6985b1001270629g38a371abtd513ec54d2feb77f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bdd6985b1001270629g38a371abtd513ec54d2feb77f@mail.gmail.com>
	(Matt Garman's message of "Wed, 27 Jan 2010 08:29:50 -0600")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Garman <matthew.garman@gmail.com> writes:

> On Wed, Jan 27, 2010 at 8:21 AM, Steven Haigh <netwiz@crc.id.au> wrot=
e:
>>
>> On 28/01/2010, at 1:18 AM, Jan Ceuleers wrote:
>>
>>> Matt Garman wrote:
>>>>> Is there a way to identify what drive is what?
>>>>
>>>> Sometimes you can infer from dmesg. =A0E.g., type "dmesg | less" t=
hen
>>>> scroll until you see where sdb is initialized; it might show the m=
odel
>>>> and serial number of the drive.
>>>>
>>>> Another approach is to use smartctl, i.e.: "sudo smartctl -a
>>>> /dev/sdb". =A0This will definitely show you the model and serial n=
umber.
>>>> You can also use hdparm for the same effect: "sudo hdparm -I
>>>> /dev/sdb".
>>>>
>>>> I'm sure there's more ways, but those are the first that come to m=
ind.
>>>
>>> I'm guessing that the OP is looking for ways to identify disks with=
out disassembling them all.
>>>
>>> In the networking world, you can ask the system to tell you which n=
etwork interface is which, by blinking the network LEDs (using ethtool =
-p). Is there something similar for disks?
>>
>> I used a similar method. I have a SATA enclosure that takes 3 x 5.25=
" bays and gives me 4 x hot swap SATA bays.
>>
>> As each bay has a power and an activity LED I can do something simpl=
e like:
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dd if=3D/dev/sdb of=3D=
/dev/null
>>
>> The bay that has sdb will have a constantly on activity light.
>>
>> If you don't have enclosures, then this becomes somewhat difficult.
>
> Depending on how the drives are mounted and their proximity to one
> another, in the absence of LEDs, you might be able to listen to and/o=
r
> feel the drives will running dd, and possibly determine which is
> which.

Shut down the raid arry (or just don't access it), set the spin down
time to 10s with hdparm and run dd if=3D/dev/sdb of=3D/dev/null. All bu=
t sdb
should spin down and then you should be able to hear/feel the activity.

Some drives also have a small led onboard which you see if you run the
system opened.

MfG
        Goswin

PS: If you have to take the system offline and disassemble the drives t=
o
find the right one then write down the serial number for each drive and
stick is some place visible when reassembled. If you lack space a color
coded dot or a number combined with a lookup table for color/numer ->
serial is also helpfull.

MfG
        Goswin
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
