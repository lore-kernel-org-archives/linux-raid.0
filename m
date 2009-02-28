From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: System hangs on raid md recovery/resync - revisit
Date: Sat, 28 Feb 2009 07:04:17 -0500 (EST)
Message-ID: <alpine.DEB.2.00.0902280654110.29132@p34.internal.lan>
References: <da290bd50902271732m54a32ad6r5797f618f5af7d7@mail.gmail.com>  <alpine.DEB.2.00.0902280407520.17966@p34.internal.lan> <da290bd50902280241y4102d5c3p73ce506b4195e5e9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463747160-1891810766-1235822657=:29132"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <da290bd50902280241y4102d5c3p73ce506b4195e5e9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad <brad46526@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463747160-1891810766-1235822657=:29132
Content-Type: TEXT/PLAIN; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Sat, 28 Feb 2009, Brad wrote:

> On Sat, Feb 28, 2009 at 7:08 PM, Justin Piszcz <jpiszcz@lucidpixels.com> =
wrote:
>>
>> On Sat, 28 Feb 2009, Brad wrote:
>>
>>> Hi. =A0I'd like to revisit a problem I put to the mailing list on the
>>> 27th July 2008.
>>>
>>> My linux system hangs if I have a lengthy recovery of a raid-1
>>> device going on at the same time as any significant network
>>> traffic.
>>> ...
>>
>> I have the same mobo:
>>
>> Handle 0x0001, DMI type 1, 27 bytes
>> System Information
>> =A0 =A0 =A0 =A0Manufacturer: Gigabyte Technology Co., Ltd.
>> =A0 =A0 =A0 =A0Product Name: P35-DS4
>
> How did you get that information, please?  Another linux command
> for me to learn?!  :-)
dmidecode | more

>
>> Have a RAID1 and RAID5, I do not use the jmicron SATA ports, only the in=
tel
>> ones and add-on pci-e cards, never had any problems with the raid volume=
s.
>> =A0The NIC is sort of flaky though [in linux], I recommend using an inte=
l
>> pci-e 1gbps card.
>
> I've had another problem with the Realtek network driver ... under networ=
k
> load it seemed to miss interrupts and/or pass them to the IDE driver, whi=
ch
> would print out errors about unexpected/unknown interrupts.  I had to tak=
e
> IDE out of my kernel.
Correct, buy an Intel 1GBPS PCI-e card, I do for all of my main machines
that do not have Intel NICs, solves the problem.  They are $30-40 and then
all of your network issues will be solved.

>
> I *think* my current hanging problem was even worse when the pata_jmicron
> driver module - which I need to use the ATA DVD drive connected to one of=
 the
> JMicron's IDE ports - shared the same interrupt as the Realtek driver.
Hm, no, I also use this jmicron driver and have no problems, but I no longe=
r
use the realtek nic.

I will offer a piece of advice though, the timings on Gigabyte boards in
general for the RAM, etc, have to be set just right otherwise, weird things
happen, I have seen the motherboard freeze/lockup do weird things before,
mainly before I had the memory settings set correctly.  Run memtest86 and
let it run for at least 1-2 passes, ENSURE you have no errors, if you have
errors, then the memory timings/parameters are set incorrectly.  This can
cause system instability, even though the memory is not bad, you will still
get errors because of the timing/multipliers etc!  (I tested the RAM in
another machine, no errors, move to gigabyte board with default settings,
memory errors, and hence, system instability!)


> I couldn't find a way to change interrupts (can one do that at will with =
the
> Linux kernel?) so my backup script unloads the pata_jmicron module
> before it attaches the third backup disk to the md1 array.
I do not use modules hardly ever, I do not understand why people do, at lea=
st
for their main os/system drivers.  For cameras, usb devices, etc, I can see
how that would be useful, but for me, I compile everything in when possible=
,
and only what is necessary.

>
> But it still hangs if there's any significant network traffic.  Maybe,
> even though I've gotten rid of anything using the same IRQ as the
> Realtek - IDE or pata_jmicron - the NIC driver is still flubbing interrup=
ts
> and that's confusing the kernel?
How often do you the CD/DVD drive?  There are SATA drives for $20-30 at new=
egg
if you think the IDE/jmicron is the culprit to most of your problems.

>
> Thanks for the advice Justin.  Maybe the solution is to abandon use
> of the Realtek NIC (a pity to 'waste' what's freely available on the
> motherboard, though, in a way).

No problem, suggestions:

1. Run memtest86, ensure no errors after 1-2 passes.
2. Buy intel pci-e nic, ~$30
3. Buy sata dvd+rw, ~$20

Justin.

---1463747160-1891810766-1235822657=:29132--
