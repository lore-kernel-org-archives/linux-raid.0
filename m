From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: 3 disk RAID1?
Date: Mon, 8 Mar 2010 19:17:16 -0800
Message-ID: <4877c76c1003081917q5e6e9973vd4cc4124c511c57f@mail.gmail.com>
References: <5bdc1c8b1003081719h37f02cb9rbdc4bb6064e4c3d7@mail.gmail.com>
	 <BB.BD.21054.3B3A59B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BB.BD.21054.3B3A59B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: Mark Knecht <markknecht@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Quite odd, my AMD64 asus mobos work just fine.  Of course I have been
avoiding all NForce chipsets for years.

Maybe you should set the BIOS so that the discs are presented as AHCI d=
evices?

On Mon, Mar 8, 2010 at 5:26 PM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
>
>
>> -----Original Message-----
>> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
>> owner@vger.kernel.org] On Behalf Of Mark Knecht
>> Sent: Monday, March 08, 2010 7:19 PM
>> To: Kristleifur Da=C5=A1ason
>> Cc: Linux-RAID
>> Subject: Re: 3 disk RAID1?
>>
>> On Mon, Mar 8, 2010 at 2:18 PM, Kristleifur Da=C5=A1ason
>> <kristleifur@gmail.com> wrote:
>> <SNIP>
>> >>
>> >> When in doubt, read the manual two or three more times.
>> >>
>> >> This might also help you: http://wiki.tldp.org/LVM-on-RAID =C2=A0=
I wrote
>> >> some background comparison sections when I made that...
>> >
>> > Good advice.
>> >
>> > The contents of the manual didn't really stick for me until I'd
>> > actually *done* the tasks I was trying to figure out. The beautifu=
l
>> > and classic Catch-22 of learning new things. So I somewhat
>> > empathically suggest you obtain a virtual machine program and star=
t up
>> > a few disposable virtual machines. (VirtualBox is pretty good and =
also
>> > free.) Try creating some RAID's on VM's and getting them to boot, =
try
>> > failing a device and readding it, etc.
>> >
>> > And keep the manual in a window next to the virtual machine's wind=
ow :)
>> >
>> > -- Kristleifur
>> >
>>
>> Exactly what I'm working on this afternoon. I've not created many VM=
's
>> from scratch so there's a learning curve there, but potentially maki=
ng
>> the hard drives virtual in the new VM setup and then applying RAID t=
o
>> them seems like a good way to practice.
>>
>> Additionally I'm going to purchase maybe 3 or 4 drives and then see
>> about using the other SATA ports on my desktop motherboard to create
>> additional storage that I can get some real performance numbers on.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Your mileage may definitely vary, but neit=
her of the servers on
> which I run mdadm have motherboards which allow mdadm to recognize th=
e
> drives. =C2=A0For both of them, only drives 0 and 1 are properly reco=
gnized by
> Linux. =C2=A0I had to purchase SATA controllers for both. =C2=A0Both =
are Asus AMD-64
> motherboards.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
