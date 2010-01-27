From: Matt Garman <matthew.garman@gmail.com>
Subject: Re: How can I tell what drive is sdb?
Date: Wed, 27 Jan 2010 08:29:50 -0600
Message-ID: <bdd6985b1001270629g38a371abtd513ec54d2feb77f@mail.gmail.com>
References: <1264601024.29409.19.camel@thor>
	 <bdd6985b1001270609m477799dpdcd625180efaed02@mail.gmail.com>
	 <4B604B2B.7070602@computer.org>
	 <18879E40-1CB7-47B0-90C5-1F4483729E3D@crc.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18879E40-1CB7-47B0-90C5-1F4483729E3D@crc.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Steven Haigh <netwiz@crc.id.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jan 27, 2010 at 8:21 AM, Steven Haigh <netwiz@crc.id.au> wrote:
>
> On 28/01/2010, at 1:18 AM, Jan Ceuleers wrote:
>
>> Matt Garman wrote:
>>>> Is there a way to identify what drive is what?
>>>
>>> Sometimes you can infer from dmesg. =A0E.g., type "dmesg | less" th=
en
>>> scroll until you see where sdb is initialized; it might show the mo=
del
>>> and serial number of the drive.
>>>
>>> Another approach is to use smartctl, i.e.: "sudo smartctl -a
>>> /dev/sdb". =A0This will definitely show you the model and serial nu=
mber.
>>> You can also use hdparm for the same effect: "sudo hdparm -I
>>> /dev/sdb".
>>>
>>> I'm sure there's more ways, but those are the first that come to mi=
nd.
>>
>> I'm guessing that the OP is looking for ways to identify disks witho=
ut disassembling them all.
>>
>> In the networking world, you can ask the system to tell you which ne=
twork interface is which, by blinking the network LEDs (using ethtool -=
p). Is there something similar for disks?
>
> I used a similar method. I have a SATA enclosure that takes 3 x 5.25"=
 bays and gives me 4 x hot swap SATA bays.
>
> As each bay has a power and an activity LED I can do something simple=
 like:
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dd if=3D/dev/sdb of=3D=
/dev/null
>
> The bay that has sdb will have a constantly on activity light.
>
> If you don't have enclosures, then this becomes somewhat difficult.

Depending on how the drives are mounted and their proximity to one
another, in the absence of LEDs, you might be able to listen to and/or
feel the drives will running dd, and possibly determine which is
which.

Another tedious approach: use smartctl or hdparm as suggested above to
get an initial mapping of /dev/sdX to serial number.  Then, disconnect
the SATA cable of all but one drive, and reboot.  Now look at what
/dev/sda's serial number is, and compare that to the initial mapping.
Eventually /dev/sda will correspond to /dev/sdb when all drives are
connected.

If the controller supports hotswap, you could do something similar
without so many reboots.

This scheme makes the assumption that it's easier to pull SATA cables
than just look at the drive's serial numbers.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
