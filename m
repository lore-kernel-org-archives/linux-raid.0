From: Mark Knecht <markknecht@gmail.com>
Subject: Re: Array 'freezes' for some time after large writes?
Date: Tue, 30 Mar 2010 16:50:53 -0700
Message-ID: <5bdc1c8b1003301650g26d7317cwb6254b4bb64596@mail.gmail.com>
References: <dead81ad1003301007h4015ac57x99f36d232bb705b6@mail.gmail.com>
	 <5bdc1c8b1003301018j73f2d928x3e2624bac9c1ee94@mail.gmail.com>
	 <dead81ad1003301047t6be7b3b4r5bf70ad6317f9d1e@mail.gmail.com>
	 <5bdc1c8b1003301105o131b73aaj176c7679be20eada@mail.gmail.com>
	 <dead81ad1003301332k26f01a25t872106a9f93fd2f0@mail.gmail.com>
	 <5bdc1c8b1003301345p46efdaddv5d420c30e75b013f@mail.gmail.com>
	 <r2vdead81ad1003301359g73b5a6ady3a9bcc174d556579@mail.gmail.com>
	 <5bdc1c8b1003301521s33c9b227s3a1f7434f78c4bc9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc1c8b1003301521s33c9b227s3a1f7434f78c4bc9@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Duchek <jim.duchek@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 30, 2010 at 3:21 PM, Mark Knecht <markknecht@gmail.com> wro=
te:
> I just finished a long compile on my dad's i5-661/DH55HC machine whic=
h
> uses this same WD drive and I didn't spot any sign of this happening
> there. That's a very recent Intel chipset also and probably more or
> less the same SATA controller.
>
> I'm going to turn on the kernel message into dmesg thing for a while
> and see if anything pops up.
>
> I can set up some additional partitions on my local drive to test
> other file systems but since you're ext3 and I'm ext3 then it's not
> that unless the problem moved forward with code over time.
>
> I like the idea of using dd but I want to be careful about that sort
> of thing. I've not used dd before, but if I could tell it to write a
> gigabyte without messing up existing stuff then that could be helpful=
=2E
>
> Back later,
> Mark
>
> On Tue, Mar 30, 2010 at 1:59 PM, Jim Duchek <jim.duchek@gmail.com> wr=
ote:
>> I'm using ext4 on everything, but it's hard to judge which ext3 bugs
>> might affect ext4 as well. =C2=A0I really don't have the ability to
>> destructively test the array, I need all the data that's on it and I
>> don't have enough spare space elsewhere to back it all up. =C2=A0You=
 might
>> see if you can trigger it with dd, writing to the drive directly w/n=
o
>> filesystem?
>>
>> Jim
>>

<SNIP>

I know this isn't going to survive email very well but you might want
to look at interrupts. I'm seeing the count on CPU #5 rising much more
quickly than other CPU's, and in my case it's generally CPU #5 that
stalls out with this 100% wait problem.

I'm looking at another 4 processor machine that's been up for a few
days. Its interrupt counts are fairly balanced, except for TLB
Shootdowns, whatever that is.

Wouldn't know how to tell if it's related...

- Mark

Using keyboard-interactive authentication.
Password:
Last login: Tue Mar 30 15:59:22 PDT 2010 from 192.168.1.65 on pts/0
keeper ~ # cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
      CPU6       CPU7
  0:        232          0          0          1          0          0
         0          0   IO-APIC-edge      timer
  1:          0          0          0          2          0          0
         0          0   IO-APIC-edge      i8042
  3:          0          0          0          2          0          0
         0          0   IO-APIC-edge
  8:          0          0          0         91          0          0
         0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          4          0          0
         0          0   IO-APIC-edge      i8042
 14:          0          0          0          0          0          0
         0          0   IO-APIC-edge      ide0
 15:          0          0          0          0          0          0
         0          0   IO-APIC-edge      ide1
 16:          0          0          0          0         82          0
         0          0   IO-APIC-fasteoi   ahci, uhci_hcd:usb1, nvidia
 18:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   uhci_hcd:usb6, ehci_hcd:usb7
 19:          0          0          0          0          0       3137
         0          0   IO-APIC-fasteoi   ahci, firewire_ohci,
uhci_hcd:usb3, uhci_hcd:usb5
 20:          0          0          0          0          0          0
       265          0   IO-APIC-fasteoi   eth0
 21:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 22:        154          0          0          0          0          0
         0          0   IO-APIC-fasteoi   hda_intel
 23:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   uhci_hcd:usb4, ehci_hcd:usb8
NMI:          0          0          0          0          0          0
         0          0   Non-maskable interrupts
LOC:       7048       6722       3577       3598       3491       8425
      3756       3569   Local timer interrupts
SPU:          0          0          0          0          0          0
         0          0   Spurious interrupts
PMI:          0          0          0          0          0          0
         0          0   Performance monitoring interrupts
PND:          0          0          0          0          0          0
         0          0   Performance pending work
RES:        335        332        353        259        176        173
       251         82   Rescheduling interrupts
CAL:        242        233        258        180        241        160
       260        260   Function call interrupts
TLB:        232        242        270        235        342        474
       537        497   TLB shootdowns
TRM:          0          0          0          0          0          0
         0          0   Thermal event interrupts
THR:          0          0          0          0          0          0
         0          0   Threshold APIC interrupts
MCE:          0          0          0          0          0          0
         0          0   Machine check exceptions
MCP:          2          2          2          2          2          2
         2          2   Machine check polls
ERR:          7
MIS:          0
keeper ~ # date
Tue Mar 30 16:45:13 PDT 2010
keeper ~ # cat /proc/interrupts
           CPU0       CPU1       CPU2       CPU3       CPU4       CPU5
      CPU6       CPU7
  0:        232          0          0          9          0          0
         0          0   IO-APIC-edge      timer
  1:          0          0          0          2          0          0
         0          0   IO-APIC-edge      i8042
  3:          0          0          0          2          0          0
         0          0   IO-APIC-edge
  8:          0          0          0         91          0          0
         0          0   IO-APIC-edge      rtc0
  9:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   acpi
 12:          0          0          0          4          0          0
         0          0   IO-APIC-edge      i8042
 14:          0          0          0          0          0          0
         0          0   IO-APIC-edge      ide0
 15:          0          0          0          0          0          0
         0          0   IO-APIC-edge      ide1
 16:          0          0          0          0       2660          0
         0          0   IO-APIC-fasteoi   ahci, uhci_hcd:usb1, nvidia
 18:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   uhci_hcd:usb6, ehci_hcd:usb7
 19:          0          0          0          0          0      20762
         0          0   IO-APIC-fasteoi   ahci, firewire_ohci,
uhci_hcd:usb3, uhci_hcd:usb5
 20:          0          0          0          0          0          0
      1903          0   IO-APIC-fasteoi   eth0
 21:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   uhci_hcd:usb2
 22:        154          0          0          0          0          0
         0          0   IO-APIC-fasteoi   hda_intel
 23:          0          0          0          0          0          0
         0          0   IO-APIC-fasteoi   uhci_hcd:usb4, ehci_hcd:usb8
NMI:          0          0          0          0          0          0
         0          0   Non-maskable interrupts
LOC:      10618      11998       8756       6940       6484      22076
      7456       6599   Local timer interrupts
SPU:          0          0          0          0          0          0
         0          0   Spurious interrupts
PMI:          0          0          0          0          0          0
         0          0   Performance monitoring interrupts
PND:          0          0          0          0          0          0
         0          0   Performance pending work
RES:        335        332        353        259        176        173
       251         82   Rescheduling interrupts
CAL:        242        233        258        180        241        160
       260        260   Function call interrupts
TLB:        232        243        270        236        343        475
       538        497   TLB shootdowns
TRM:          0          0          0          0          0          0
         0          0   Thermal event interrupts
THR:          0          0          0          0          0          0
         0          0   Threshold APIC interrupts
MCE:          0          0          0          0          0          0
         0          0   Machine check exceptions
MCP:         10         10         10         10         10         10
        10         10   Machine check polls
ERR:          7
MIS:          0
keeper ~ #
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
